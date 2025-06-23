use actix_web::{post, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use reqwest::Client;

#[derive(Debug, Deserialize, Serialize)] // 👈 added Serialize here
pub struct LoginRequest {
    pub email: String,
    pub password: String,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct LoginResponse {
    pub token: String,
}

#[post("/login")]
pub async fn login(data: web::Json<LoginRequest>) -> impl Responder {
    let client = Client::new();

    let res = client
        .post("http://auth:3000/login")
        .json(&*data)
        .send()
        .await;

    match res {
        Ok(response) => {
            if response.status().is_success() {
                match response.json::<LoginResponse>().await {
                    Ok(token_data) => HttpResponse::Ok().json(token_data),
                    Err(_) => HttpResponse::InternalServerError().body("Token parse failed"),
                }
            } else {
                HttpResponse::Unauthorized().body("Invalid credentials")
            }
        }
        Err(_) => HttpResponse::InternalServerError().body("Login service unavailable"),
    }
}