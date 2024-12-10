## Dockerized way to fine-tune [FLUX.1-dev model](https://huggingface.co/black-forest-labs/FLUX.1-dev) using Dreambooth metod with memory-efficient and configurable training,

Dockerhub: [kopyl/train-flux-kohya-sd-scripts](https://hub.docker.com/repository/docker/kopyl/train-flux-kohya-sd-scripts/general)
<br/>
[Simplified training run](https://github.com/kopyl/flux-training-docker-kohya/blob/main/docker-helper-commands.md#the-most-common-use-case) guide.

### Purpose of this project

Throughout my ML career i found that the best way to train diffusion models is with [kohya's sd-scripts repo](https://github.com/kohya-ss/sd-scripts/tree/sd3).

One of the coolest advantages I like:

- Way less bugs than [huggingface/diffusers](https://github.com/huggingface/diffusers) repo's training scipts have;
- Latest and gratest models to trainl
- Amazing speed optimization which i could not get [myself re-writing huggingface/diffusers' Flux training code](https://github.com/kopyl/diffusers/commit/561962d1c01a9ed0c7b7873f1bede24a5ee19139);
- Not very difficult to understand in terms of the architecture and the code readability

While being really nice to use, you have to spend a while setting up a simple Flux Dreambooth training environment, which is basically:

1. Install everything a repo requires you to. Sometimes even a newer version of Python. And I always had to install additional packages which are out of scope of the required ones by the sd-scripts repo like `torchvision` and `opencv`;
2. Copy all the models into your project environment (and find them on the internet if you not happen to casually store 30gb of data on your computer).

### With this project all you have to do to run that training:

1. Deploy a container (or run on your own machine);
2. `exec -it {name} bash` into a container;
3. Upload photos of your subject to `dataset` directory and change the subject's identifier if needed (like `sks woman`) in `dataset-config.toml`;
4. Run the training script like `bash run-training.sh`;
5. When the training is finished, you will find the trained Flux model (transformer type) in the `/output` directory of a container

### Things you might also want to change:

###### In training launching script (run-training.sh):

- Remove `--apply_t5_attn_mask` parameter. It slightly increases quality and slightly reduces training speed (in my measurements on a server with NVIDIA H100 2.53s/it with attention mask and 1.91s/it without). So far i guess it's worth the time sacrifice. VRAM usage is around the smae;
- Change `--save_every_n_epochs` parameter;
- Change `--max_train_epochs` parameter. But for the most optimal training process i recomment keeping it at 300;

- Change `--sample_every_n_epochs` parameter;
- Change `--learning_rate` paramet;
- Adjust contents of `sample_prompts.txt` file to fit the subject token. I.e: if class token is `sks man`, prompts start with `a photo of sks man...` and I'm training a model on a woman, then I'd need to change `sks man` part in all prompts to `sks woman`. Also change the class token in the `dataset-config.toml` file.
  ([prompt formatting syntax](https://github.com/kohya-ss/sd-scripts?tab=readme-ov-file#sample-image-generation-during-training))

### But how am I supposed to use that training model in Diffusers?

1. Make sure you have the latest version of diffusers from the [official repo](https://github.com/huggingface/diffusers);
2. Do a couple imports:

```
from diffusers import FluxTransformer2DModel, FluxPipeline
```

3. Load the transformer model you just trained:

```
transformer = FluxTransformer2DModel.from_single_file("finetuned-model.safetensors", torch_dtype=torch.bfloat16)
```

4. And finally load the default model from [black-forest-labs/FLUX.1-dev](https://huggingface.co/black-forest-labs/FLUX.1-dev) with swapping the main model component – the transformer with the code like this:

```
pipe = FluxPipeline.from_pretrained("models/flux-dev-model", transformer=transformer, torch_dtype=torch.bfloat16)
```
