Levantarlo construyendo la imagen:
docker-compose up --build -d

Levantar el contenedor si la imagen ya esta creada:
docker-compose up -d


Ejecutar el contenedor:
docker exec -it darknet-container /bin/bash

darknet version                         #Ver la version obviamente.

    Ejecutar deteccion de una imagen
        darknet detector test cfg/coco.data cfg/yolov4.cfg yolov4.weights data/NombreImagenADetectar.jpg

    Ejecutar detección en tiempo real con una webcam
        Si estás en un entorno donde la cámara está accesible:
            darknet detector demo cfg/coco.data cfg/yolov4.cfg yolov4.weights
        (O con una ruta de video, si tienes uno cargado en /workspace):
            darknet detector demo cfg/coco.data cfg/yolov4.cfg yolov4.weights test.mp4

    Se Puede modificar el docker-compose para crear volumenes y acceder a imagenes, ahora mismo cualquier imagen que metamos en la carpeta videosImg estará disponible.

detener sin eliminar:
docker-compose down

detener eliminando todo:
docker-compose down --rmi all


comandos que si funcionan:

darknet_04_process_videos /workspace/darknet/cfg/yolov4.cfg /workspace/videosImg/test.mp4 /workspace/darknet/yolov4.weights
darknet_05_process_videos_multithreaded /workspace/darknet/cfg/yolov4.cfg /workspace/videosImg/test.mp4 /workspace/darknet/yolov4.weights


AÑADIR AL README:

GPU	Arquitectura        CUDA
GTX 10xx (Pascal)	    61
RTX 20xx (Turing)	    75
RTX 30xx (Ampere)	    86
RTX 40xx (Ada Lovelace)	89
Tesla V100 (Volta)	    70
Tesla A100 (Ampere)	    80
Tesla H100 (Hopper)	    90
