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
        --env OUTPUT_MODEL_NAME="finetuned-model" \
        --env SAVE_EVERY_N_EPOCHS=70 \
        --env MAX_TRAIN_EPOCHS=300 \
        --env SAMPLE_EVERY_N_EPOCHS=10 \
        --env LEARNING_RATE="1.1e-5" \
        kopyl/train-flux-kohya-sd-scripts && \
    docker logs train-flux-kohya-sd-scripts -f
```

```
docker exec -it train-flux-kohya-sd-scripts bash
```

The environment variables are just the defaults.
Unless not provided, the same values are going to be used

### The most common use case:

1. Clone the repo with (git must be installed):

```
git clone https://github.com/kopyl/flux-training-docker-kohya.git
```

2. cd into the repo with

```
cd flux-training-docker-kohya
```

3. Create directory with name `dataset` and put your images there;
4. Change `class_tokens` inside `dataset-config.toml` file to your subject token. E.g: if it's a man, change `'sks girl'` to `'sks man'`;
5. Change the class token in inside `sample_prompts.txt` file. E.g: if you change the class token, you need to change it in the prompts list as well;
   ([prompt formatting syntax](https://github.com/kohya-ss/sd-scripts?tab=readme-ov-file#sample-image-generation-during-training))
6. Launch the docker container to start the training with:

```
docker run \
    --name train-flux-kohya-sd-scripts \
    -d \
    -v ./output:/output \
    -v ./dataset:/dataset \
    -v ./dataset-config.toml:/dataset-config.toml \
    -v ./sample_prompts.txt:/sample_prompts.txt \
    --gpus all \
    --shm-size 8G \
    kopyl/train-flux-kohya-sd-scripts
```

7. Sit back and watch the logs with

```
docker logs train-flux-kohya-sd-scripts -f
```

Each 10 epochs there are going to be generated the images from your prompts inside `/output/sample` directory (which you mount to `./output/sample` on your host with the `docker run` command above).
When the training is finished, you get the model name `finetuned-model.safetensors` inside `/output` directory. For more info on how to generate images with the train models, read [But how am I supposed to use that training model in Diffusers?](https://github.com/kopyl/flux-training-docker-kohya/blob/main/README.md#but-how-am-i-supposed-to-use-that-training-model-in-diffusers) section.
