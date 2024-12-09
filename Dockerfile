FROM python:3.10.15-slim

ENV PYTHONUNBUFFERED=1
ENV TOKENIZERS_PARALLELISM=false

# models directory contains 4 Flux models:
    # flux1-dev.safetensors
    # clip_l.safetensors
    # t5xxl_enconly.safetensors
    # ae.safetensors
COPY models /models
# sd-scripts: https://github.com/kohya-ss/sd-scripts/tree/e425996a5953f0479384e70b6490e751c2d00b1f
COPY sd-scripts /sd-scripts

WORKDIR /sd-scripts

RUN pip install -r requirements.txt
RUN pip install opencv-python==4.10.0.84
RUN pip install torch torchvision --extra-index-url https://download.pytorch.org/whl/cu124

COPY sample-female-dataset sample-female-dataset
COPY dataset-config.toml .
COPY sample_prompts.txt .

COPY Dockerfile .
COPY README.md .

CMD ["sleep", "infinity"]

# docker build -t kopyl/train-flux-kohya-sd-scripts .