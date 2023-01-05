#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        type Manager;

        #[swift_bridge(init)]
        fn new() -> Manager;

        async fn load(self: &Manager, url: String, file_path: String) -> String;
    }
}

pub struct Manager {}

impl Manager {
    fn new() -> Self {
        Self {}
    }

    async fn load(&self, url: String, file_path: String) -> String {
        let res = self.real_load(&url, &file_path).await;
        match res {
            Err(err) => err,
            Ok(()) => "no error".to_owned(),
        }
    }

    async fn real_load(&self, url: &str, file_path: &str) -> Result<(), String> {
        let https = hyper_tls::HttpsConnector::new();
        let client = hyper::Client::builder().build::<_, hyper::Body>(https);
        let parsed_url = url
            .parse()
            .map_err(|err| format!("unabel to parse url {:?}: {:?}", url, err))?;
        let total_size = quickload_loader::Loader::detect_size(&client, &parsed_url)
            .await
            .map_err(|err| {
                format!(
                    "unable to detect the data size at {:?} for {:?}: {:?}",
                    file_path, url, err
                )
            })?;
        let chunk_size = 4 * 1024 * 1024;
        let chunk_size = chunk_size.try_into().unwrap();
        let loader = quickload_loader::Loader::with_size(
            file_path, client, parsed_url, total_size, chunk_size,
        )
        .map_err(|err| {
            format!(
                "unable to initiate the loader at {:?} for {:?}: {:?}",
                file_path, url, err
            )
        })?;
        loader
            .run()
            .await
            .map_err(|err| format!("unable to load the remote file: {:?}", err))?;
        Ok(())
    }
}
