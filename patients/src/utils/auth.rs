use jsonwebtoken::{encode, decode, Header, EncodingKey, DecodingKey, Validation};
use serde::{Serialize, Deserialize};
use crate::models::user::User;
use std::env;
use chrono::{Utc, Duration};

#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    pub sub: String,
    pub role: String,
    pub exp: usize,
}

pub fn create_jwt(user: &User) -> Result<String, jsonwebtoken::errors::Error> {
    let expiration = Utc::now()
        .checked_add_signed(Duration::hours(24))
        .expect("valid timestamp")
        .timestamp() as usize;

    let role = user.role
        .iter()
        .filter_map(|r| r.clone()) // flatten Vec<Option<String>> to Vec<String>
        .collect();

    let claims = Claims {
        sub: user.email.clone(),
        role,
        exp: expiration,
    };

    encode(&Header::default(), &claims, &EncodingKey::from_secret("your-secret".as_ref()))
}

pub fn decode_jwt(token: &str) -> Result<Claims, jsonwebtoken::errors::Error> {
    let secret = env::var("JWT_SECRET").unwrap();
    decode::<Claims>(token, &DecodingKey::from_secret(secret.as_bytes()), &Validation::default())
        .map(|d| d.claims)
}