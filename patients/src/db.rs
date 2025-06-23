
use dotenvy::dotenv;
use crate::models::user::Employee;
use crate::schema::employees::dsl::*;
use diesel::prelude::*;
use diesel::pg::PgConnection;
use diesel::r2d2::{self, ConnectionManager};
use std::env;

type DbPool = r2d2::Pool<ConnectionManager<PgConnection>>;

fn establish_connection() -> PgConnection {
    let db_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    PgConnection::establish(&db_url).expect("Failed to connect to DB")
}

pub fn init() {
    dotenv().ok();
}


