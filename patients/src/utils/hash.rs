use argon2::{Argon2, PasswordHash, PasswordVerifier};

pub fn verify_password(plain: &str, hashed: &str) -> bool {
    match PasswordHash::new(hashed) {
        Ok(parsed_hash) => {
            let result = Argon2::default().verify_password(plain.as_bytes(), &parsed_hash);
            println!("🔍 Password verification result: {:?}", result);
            result.is_ok()
        }
        Err(e) => {
            println!("❌ Failed to parse hash: {:?}", e);
            false
        }
    }
}