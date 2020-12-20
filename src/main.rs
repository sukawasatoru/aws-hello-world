use lambda::{handler_fn, Context};
use log::info;

type BoxError = Box<dyn std::error::Error + Send + Sync + 'static>;

#[tokio::main]
async fn main() -> Result<(), BoxError> {
    env_logger::init();

    let func = handler_fn(handler);

    lambda::run(func).await?;
    Ok(())
}

async fn handler(event: serde_json::Value, _: Context) -> Result<serde_json::Value, BoxError> {
    info!("event: {}", event);

    Ok(serde_json::json!({
        "message": "Hello World2!"
    }))
}
