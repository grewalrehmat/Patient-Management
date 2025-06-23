# ---------- Build Stage ----------
FROM rust:latest as builder

WORKDIR /app

# Cache dependencies
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release

# Copy actual source and build real app
COPY . .
RUN cargo build --release

# ---------- Runtime Stage ----------
FROM debian:bookworm-slim

# Install required runtime libs
RUN apt-get update && apt-get install -y \
    libssl3 \
    libpq5 \
    zlib1g \
    libgcc-s1 \
    libstdc++6 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m appuser

# Copy binary
COPY --from=builder /app/target/release/patients /usr/local/bin/patients
RUN chown appuser:appuser /usr/local/bin/patients

# Set permissions
RUN chown appuser:appuser /usr/local/bin/patients

USER appuser
WORKDIR /home/appuser

EXPOSE 8080

CMD ["patients"]
