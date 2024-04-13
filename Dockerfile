# Use a PyTorch base image with CUDA support
FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-runtime

ARG DEBIAN_FRONTEND=noninteractive

# Environment variables for CUDA and setuptools
ENV CUDA_HOME=/usr/local/cuda \
    TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX" \
    SETUPTOOLS_USE_DISTUTILS=stdlib

# Update conda
RUN conda update conda -y

# Install necessary packages
RUN apt-get -y update && apt-get install -y --no-install-recommends \
         wget \
         build-essential \
         git \
         python3-opencv \
         ca-certificates \
         python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Install JupyterLab
RUN pip install jupyterlab==3.3.0

# Make sure Jupyter knows about Python 3
RUN python -m ipykernel install --user

# Set the working directory
WORKDIR /workspace

# Command to keep the container running and start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--no-browser"]
