FROM python:3.10-alpine

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /usr/src/app

# Install system dependencies
RUN apk update && apk add --no-cache netcat-openbsd

# Install dependencies
COPY requirements.txt /usr/src/app/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy project
COPY . /usr/src/app/

# Make entrypoint.sh executable
RUN chmod +x /usr/src/app/entrypoint.sh

# Expose the port the app runs on
EXPOSE 5000

# Run the entrypoint script
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

# Default command to run the Flask app
CMD ["flask", "run", "--host=0.0.0.0"]
