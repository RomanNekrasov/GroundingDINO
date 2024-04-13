FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-runtime

ARG DEBIAN_FRONTEND=noninteractive

# Set environment variables
ENV CUDA_HOME=/usr/local/cuda \
    TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX" \
    SETUPTOOLS_USE_DISTUTILS=stdlib

# Update and install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    build-essential \
    git \
    python3-opencv \
    ca-certificates \
    libgl1-mesa-glx \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Install JupyterLab
RUN pip3 install jupyterlab

# Set the working directory
WORKDIR /opt/program

# Clone the necessary GitHub repository
RUN git clone https://github.com/IDEA-Research/GroundingDINO.git

# Download the pre-trained model weights
RUN mkdir weights && cd weights && wget -q https://github.com/IDEA-Research/GroundingDINO/releases/download/v0.1.0-alpha/groundingdino_swint_ogc.pth && cd ..

# Install Python packages from the cloned repository
RUN cd GroundingDINO/ && pip install .

# Copy any scripts if necessary
COPY docker_test.py docker_test.py

# Expose the Jupyter port
EXPOSE 8888

# Command to keep the container running
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
