# DarkNet AI en Docker

Este repositorio tiene como finalidad permitir desplegar de forma rápida y sencilla el entorno de DarkNet by HankAI.

> **⚠️ IMPORTANTE:**  
> Si usas Ubuntu en WSL, es necesario que instales [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

## Instrucciones de uso

### Construcción y ejecución del contenedor

1. **Construir la imagen de Docker:**
   ```bash
   docker-compose up --build -d
   ```

2. **Levantar el contenedor si la imagen ya está creada:**
   ```bash
   docker-compose up -d
   ```

3. **Ejecutar el contenedor:**
   ```bash
   docker exec -it darknet-container bash
   ```

4. **Ver la versión de DarkNet:**
   ```bash
   darknet version
   ```

### Uso de DarkNet

#### Detección de objetos en una imagen
```bash
darknet detector test cfg/coco.data cfg/yolov4.cfg yolov4.weights data/NombreImagenADetectar.jpg
```

#### Detección en tiempo real con una webcam
- Si la cámara está accesible:
  ```bash
  darknet detector demo cfg/coco.data cfg/yolov4.cfg yolov4.weights
  ```

- Si tienes un video cargado en `/workspace`:
  ```bash
  darknet detector demo cfg/coco.data cfg/yolov4.cfg yolov4.weights test.mp4
  ```

### Configuración adicional
Se puede modificar el `docker-compose.yml` para crear volúmenes y acceder a imágenes. Actualmente, cualquier imagen colocada en la carpeta `videosImg` estará disponible dentro del contenedor.

### Detener el contenedor

- **Detener sin eliminar la imagen:**
  ```bash
  docker-compose down
  ```

- **Detener y eliminar todo (contenedores e imágenes):**
  ```bash
  docker-compose down --rmi all
  ```

### Comandos adicionales

- **Procesar un video con detección de objetos:**
  ```bash
  darknet_04_process_videos /workspace/darknet/cfg/yolov4.cfg /workspace/videosImg/test.mp4 /workspace/darknet/yolov4.weights
  ```

- **Procesar un video con detección de objetos en múltiples hilos:**
  ```bash
  darknet_05_process_videos_multithreaded /workspace/darknet/cfg/yolov4.cfg /workspace/videosImg/test.mp4 /workspace/darknet/yolov4.weights
  
