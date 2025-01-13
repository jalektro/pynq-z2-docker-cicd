# syntax=docker/dockerfile:1

ARG PLATFORM=linux/arm/v7

# Build fase
FROM --platform=$PLATFORM docker.io/arm32v7/debian:stable AS build

SHELL ["/bin/bash", "-c"]

RUN apt-get update
RUN apt-get install -y \
    python3 \
    python3-pip \
    python3-venv

RUN --network=none groupadd -r builders && useradd --no-log-init -r -g builders builder
USER builder:builders

WORKDIR /build
ADD ./requirements.txt .
ADD ./app.py .

# Maak een virtuele omgeving en installeer Python dependencies
RUN --network=none python3 -m venv venv && \
    source venv/bin/activate && \
    pip install --no-cache-dir -r requirements.txt

# App fase
FROM --platform=$PLATFORM docker.io/arm32v7/debian:stable AS app

LABEL org.opencontainers.image.authors="Robert Jansen <jansenrobert4@gmail.com>"
LABEL org.opencontainers.image.documentation="https://github.com/jalektro/pynq-z2-docker-cicd"
LABEL org.opencontainers.image.source="https://github.com/jalektro/pynq-z2-docker-cicd"
LABEL org.opencontainers.image.version="0.0.0"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.ref.name="python-pynq-tryout"
LABEL org.opencontainers.image.title="Pynq Z2 container for Python"
LABEL org.opencontainers.image.description="\
  trying to put up a python container on the pynq-z2 \
"

WORKDIR /app

RUN --network=none groupadd -r runners && useradd --no-log-init -r -g runners app
USER app:runners

# Kopieer de virtuele omgeving en het script naar de app fase
COPY --from=build /build/venv /app/venv
COPY --from=build /build/led.py /app/led.py

# Zorg ervoor dat het script uitvoerbaar is
RUN chmod +x /app/led.py

# Stel de Python virtuele omgeving in en voer het script uit
ENV PATH="/app/venv/bin:$PATH"

ENTRYPOINT ["python3", "/app/led.py"]
