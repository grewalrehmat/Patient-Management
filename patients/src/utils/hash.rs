use bcrypt::{verify, hash, DEFAULT_COST};

pub fn hash_password(pw: &str) -> String {
    hash(pw, DEFAULT_COST).unwrap()
}

pub fn verify_password(pw: &str, hashed: &str) -> bool {
    verify(pw, hashed).unwrap_or(false)
}