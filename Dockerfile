# Usar Ubuntu 24.04 como imagen base mínima
FROM ubuntu:24.04

# Definir variables de entorno
ENV DEBIAN_FRONTEND=noninteractive \
    CUDA_HOME=/usr/local/cuda \
    PATH=/usr/local/cuda/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/lib/x86_64-linux-gnu

# Instalar dependencias esenciales
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 ca-certificates wget file sudo \
    build-essential git cmake pkg-config ninja-build \
    python3 python3-pip python3-venv \
    libopencv-dev libtiff5-dev libpng-dev libjpeg-dev \
    libsqlite3-dev libcurl4-openssl-dev \
    qtbase5-dev qtchooser qt5-qmake \
    libmagic-dev libtclap-dev \
    libfreetype6-dev libpoppler-cpp-dev \
    libxrandr-dev libxinerama-dev libxcursor-dev \
    libgl1 libegl1 fonts-liberation && \
    rm -rf /var/lib/apt/lists/*

# Agregar el repositorio de NVIDIA y eliminar el archivo después
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    rm cuda-keyring_1.1-1_all.deb && \
    apt-get update

# Instalar CUDA y drivers NVIDIA
RUN apt-get install -y --no-install-recommends \
    cuda-toolkit-12-8 \
    cuda-drivers && \
    rm -rf /var/lib/apt/lists/*

# Asegurar que libcuda.so.1 esté accesible
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/libcuda.so.1 && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/cuda.conf && \
    ldconfig

# Instalar cuDNN y limpiar archivos temporales
RUN wget https://developer.download.nvidia.com/compute/cudnn/9.8.0/local_installers/cudnn-local-repo-ubuntu2404-9.8.0_1.0-1_amd64.deb && \
    dpkg -i cudnn-local-repo-ubuntu2404-9.8.0_1.0-1_amd64.deb && \
    cp /var/cudnn-local-repo-ubuntu2404-9.8.0/cudnn-*-keyring.gpg /usr/share/keyrings/ && \
    apt-get update && \
    apt-get install -y cudnn-cuda-12 && \
    rm -rf /var/lib/apt/lists/* cudnn-local-repo-ubuntu2404-9.8.0_1.0-1_amd64.deb

# Diagnóstico de CUDA y cuDNN
RUN nvcc --version && ldconfig -p | grep libcudnn && ldconfig -p | grep libcuda

# Clonar repositorios con profundidad mínima
RUN git clone https://github.com/hank-ai/darknet.git darknet && \
    git clone --depth=1 https://github.com/stephanecharette/DarkHelp.git DarkHelp && \
    git clone --depth=1 https://github.com/stephanecharette/DarkMark.git DarkMark

# Rename directories a lowercase
RUN mv DarkHelp darkhelp && mv DarkMark darkmark

# Build Darknet con soporte CUDA
RUN cd /darknet && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_CUDA_ARCHITECTURES="50;52;60;61;70;75;80;86;89;90" && \
    make -j$(nproc)

# Agregar Darknet al PATH
ENV PATH="/darknet/build:${PATH}" 

# Build DarkHelp y DarkMark
RUN cd /darkhelp && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc) && make package && \
    dpkg -i /darkhelp/build/darkhelp*.deb && \
    cd /darkmark && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc) package && \
    dpkg -i /darkmark/build/darkmark*.deb

# Copiar la carpeta "data" desde el host al contenedor
COPY data /darknet/data

# Mantener el contenedor activo
CMD ["sleep", "infinity"]
