### Shortcut for rebuilding and relaunching

Before launching it, make sure you have `dataset` directory here populated with subject images.

The following Docker run command mounts the image's `/output` directory to the local one named `output`, so we can get the output of the training outside the container easily.

```
docker rm -f train-flux-kohya-sd-scripts && \
    docker build -t kopyl/train-flux-kohya-sd-scripts . && \
    docker run \
        --name train-flux-kohya-sd-scripts \
        -d \
        -v ./output:/output \
        -v ./dataset:/dataset \
        -v ./dataset-config.toml:/dataset-config.toml \
        -v ./sample_prompts.txt:/sample_prompts.txt \
        --gpus all \
        --shm-size 8G \
        kopyl/train-flux-kohya-sd-scripts && \
    docker ps && \
    docker logs train-flux-kohya-sd-scripts -f
```

```
docker exec -it train-flux-kohya-sd-scripts bash
```
