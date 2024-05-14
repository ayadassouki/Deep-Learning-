FROM python:3.8

# Install system dependencies
# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgl1-mesa-glx \
    git \
    libhdf5-dev && rm -rf /var/lib/apt/lists/*



# Set the working directory
WORKDIR /app

# Setup Python virtual environment
RUN python -m venv venv
ENV PATH="/app/venv/bin:$PATH"

# Install Python dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . /app

# Expose the port the app runs on
EXPOSE 8888

# # Use a non-root user to run the Jupyter notebook
# RUN useradd -ms /bin/bash user
# USER user

# # Start Jupyter Notebook
# CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
# Use a non-root user to run the Jupyter notebook
RUN useradd -ms /bin/bash user
USER user

# Activate the virtual environment and start Jupyter Notebook
CMD ["bash", "-c", "source /app/venv/bin/activate && jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser"]
