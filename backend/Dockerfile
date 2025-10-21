# Use an official lightweight Python image
FROM python:3.10-slim

# Set working directory inside the container
WORKDIR /app

# Copy requirements first (for caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app code
COPY ./app /app

# Expose port 5000 (the FastAPI default in your app)
EXPOSE 5000

# Command to run the server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]
