#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        type Loader;

        #[swift_bridge(init)]
        fn new() -> Loader;

        fn load(&self, url: &str) -> String;
    }
}

pub struct Loader {}

impl Loader {
    fn new() -> Self {
        Self {}
    }

    fn load(&self, _url: &str) -> String {
        format!("test")
    }
}
