use diesel::prelude::*;
use diesel::r2d2::{self, ConnectionManager};
use std::env;

pub type DbPool = r2d2::Pool<ConnectionManager<PgConnection>>;

pub fn establish_connection() -> DbPool {
    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set in .env");
    let manager = ConnectionManager::<PgConnection>::new(database_url);
    r2d2::Pool::builder()
        .build(manager)
        .expect("Failed to create DB pool")
}