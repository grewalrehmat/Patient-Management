# ---------- Build Stage ----------
FROM rust:latest AS builder

# Set working directory
WORKDIR /app

# Pre-copy: cache dependencies
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release || true
RUN rm -r src

# Copy full source and build
COPY . .

RUN cargo build --release

# ---------- Runtime Stage ----------
FROM debian:buster-slim

# Create a non-root user
RUN useradd -m appuser

# Copy built binary from builder
COPY --from=builder /app/target/release/patients /usr/local/bin/patients

# Set user
USER appuser

# Expose port (match the one your Rust app listens on)
EXPOSE 8080

# Run the app
CMD ["patients"]