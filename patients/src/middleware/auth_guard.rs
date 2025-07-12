use actix_web::{
    body::{EitherBody, MessageBody},
    dev::{ServiceRequest, ServiceResponse},
    Error, HttpMessage, HttpResponse,
};
use actix_web_lab::middleware::Next;
use jsonwebtoken::{decode, DecodingKey, Validation};
use crate::utils::auth::Claims;

pub async fn jwt_middleware<B>(
    mut req: ServiceRequest,
    next: Next<B>,
) -> Result<ServiceResponse<EitherBody<B>>, Error>
where
    B: MessageBody + 'static,
{
    let token = req
        .headers()
        .get("Authorization")
        .and_then(|h| h.to_str().ok())
        .and_then(|h| h.strip_prefix("Bearer "))
        .map(str::to_string);

    match token {
        Some(token) => {
            let secret = std::env::var("JWT_SECRET").unwrap_or_else(|_| "secret_key".into());

            let mut validation = Validation::default();
            validation.validate_exp = true;

            match decode::<Claims>(
                &token,
                &DecodingKey::from_secret(secret.as_ref()),
                &validation,
            ) {
                Ok(token_data) => {
                    req.extensions_mut().insert(token_data.claims);
                    let res = next.call(req).await?;
                    Ok(res.map_into_left_body())
                }
                Err(err) => {
                    eprintln!("[JWT] Token validation failed: {:?}", err);
                    let (req, _pl) = req.into_parts();
                    let res = HttpResponse::Unauthorized()
                        .body("Invalid token");
                    Ok(ServiceResponse::new(req, res).map_into_right_body())
                }
            }
        }
        None => {
            let (req, _pl) = req.into_parts();
            let res = HttpResponse::Unauthorized()
                .body("Missing token");
            Ok(ServiceResponse::new(req, res).map_into_right_body())
        }
    }
}