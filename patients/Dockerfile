# ---------- Build Stage ----------
FROM rust:latest as builder

WORKDIR /app

# Pre-build step to cache dependencies
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release && rm -rf src

# Actual source copy
COPY . .

RUN cargo build --release

# ---------- Runtime Stage ----------
FROM debian:buster-slim

RUN useradd -m appuser

COPY --from=builder /app/target/release/patients /usr/local/bin/patients

USER appuser

EXPOSE 8080

CMD ["patients"]