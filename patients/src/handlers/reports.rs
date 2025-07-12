use actix_multipart::Multipart;
use actix_web::{post, HttpResponse};
use futures_util::StreamExt;
use std::fs::File;
use std::io::Write;

#[post("/patients/{id}/report")]
pub async fn upload(mut payload: Multipart) -> HttpResponse {
    while let Some(item) = payload.next().await {
        let mut field = item.unwrap();
        let filename = "report.pdf";
        let mut f = File::create(format!("./uploads/{}", filename)).unwrap();

        while let Some(chunk) = field.next().await {
            let data = chunk.unwrap();
            f.write_all(&data).unwrap();
        }
    }

    HttpResponse::Ok().body("Report uploaded")
}