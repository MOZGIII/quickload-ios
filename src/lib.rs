use std::sync::Arc;

use tokio_util::sync::CancellationToken;

#[swift_bridge::bridge]
mod ffi {
    enum CancellationEffect {
        IssuedWithWriteQueue,
        IssuedWithDropQueue,
        NoEffect,
    }

    extern "Rust" {
        type Manager;

        #[swift_bridge(init)]
        fn new() -> Manager;

        async fn load(self: &Manager, url: String, file_path: String) -> String;
        fn cancel(self: &Manager) -> CancellationEffect;
    }
}

pub struct Manager {
    cancel_write_queued: CancellationToken,
    cancel_drop_queued: CancellationToken,
}

impl Manager {
    fn new() -> Self {
        Self {
            cancel_write_queued: CancellationToken::new(),
            cancel_drop_queued: CancellationToken::new(),
        }
    }

    async fn load(&self, url: String, file_path: String) -> String {
        let res = self.real_load(&url, &file_path).await;
        match res {
            Err(err) => err,
            Ok(()) => "no error".to_owned(),
        }
    }

    fn cancel(&self) -> ffi::CancellationEffect {
        if !self.cancel_write_queued.is_cancelled() {
            self.cancel_write_queued.cancel();
            return ffi::CancellationEffect::IssuedWithWriteQueue;
        }
        if !self.cancel_drop_queued.is_cancelled() {
            self.cancel_drop_queued.cancel();
            return ffi::CancellationEffect::IssuedWithWriteQueue;
        }
        ffi::CancellationEffect::NoEffect
    }

    async fn real_load(&self, url: &str, file_path: &str) -> Result<(), String> {
        let https = hyper_tls::HttpsConnector::new();
        let client = hyper::Client::builder().build::<_, hyper::Body>(https);
        let parsed_url = url
            .parse()
            .map_err(|err| format!("unabel to parse url {:?}: {:?}", url, err))?;
        let total_size = quickload_loader::detect_size(&client, &parsed_url)
            .await
            .map_err(|err| {
                format!(
                    "unable to detect the data size at {:?} for {:?}: {:?}",
                    file_path, url, err
                )
            })?;
        let writer = quickload_loader::init_file(file_path, total_size)
            .map_err(|err| format!("unable to initiate the file at {:?}: {:?}", file_path, err))?;

        let chunk_size = 4 * 1024 * 1024;
        let chunk_size = chunk_size.try_into().unwrap();
        let chunker = quickload_chunker::Chunker::<quickload_loader::ChunkerConfig> {
            total_size,
            chunk_size,
        };

        let loader = quickload_loader::Loader {
            client: Arc::new(client),
            uri: parsed_url,
            writer,
            chunker,
            cancel_write_queued: self.cancel_write_queued.clone(),
            cancel_drop_queued: self.cancel_drop_queued.clone(),
        };

        loader
            .run()
            .await
            .map_err(|err| format!("unable to load the remote file: {:?}", err))?;
        Ok(())
    }
}
