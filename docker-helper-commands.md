### Shortcut for rebuilding and relaunching

The following Docker run command mounts the image's `/output` directory to the local one named `kohya-docker-output`, so we can get the output of the training outside the container easily.

```
docker rm -f train-flux-kohya-sd-scripts && \
    docker build -t kopyl/train-flux-kohya-sd-scripts . && \
    docker run \
        --name train-flux-kohya-sd-scripts \
        -d \
        -v ./kohya-docker-output:/output \
        --gpus all \
        --shm-size 8G \
        kopyl/train-flux-kohya-sd-scripts && \
    docker ps && \
    docker exec -it train-flux-kohya-sd-scripts bash
```
