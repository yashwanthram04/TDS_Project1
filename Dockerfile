# Use official lightweight Python base image
FROM python:3.11-slim

# Install system dependencies (optional: build-essential if you compile stuff)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Install Python dependencies first (leverage Docker layer cache)
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy your FastAPI app code
COPY . .

# Port Cloud Run expects
ENV PORT 8080

# Start with uvicorn -- use PORT env var
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
