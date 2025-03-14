# Imagen base con CUDA, cuDNN y soporte para Deep Learning
FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu24.04

# Configurar variables de entorno
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:/usr/lib/x86_64-linux-gnu/"

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libopencv-dev \
    wget \
    file \
    cmake && \
    rm -rf /var/lib/apt/lists/*

# Agregar las librerías de CUDA al sistema para evitar errores en la instalación
RUN echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/cuda.conf && \
    ldconfig

# Crear directorio de trabajo
WORKDIR /workspace

# Clonar y compilar Darknet
RUN git clone https://github.com/hank-ai/darknet.git && \
    cd darknet && mkdir -p build && cd build && cmake .. && \
    make -j$(nproc) && make install

# Mantener el contenedor abierto para ejecución
CMD ["/bin/bash"]