ARG PYTHON_VERSION=3.10
ARG UBUNTU_VERSION=20.04

FROM ubuntu:${UBUNTU_VERSION}

ARG USER_ID
ARG PYTHON_VERSION
ARG UBUNTU_VERSION

ADD . /workspace
WORKDIR /workspace

# Install dependencies
RUN apt update && \
        apt upgrade -y && \
        apt install software-properties-common -y && \
        add-apt-repository ppa:deadsnakes/ppa && \
        apt update && \
        apt install python${PYTHON_VERSION} curl python${PYTHON_VERSION}-distutils -y && \
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
        python${PYTHON_VERSION} get-pip.py

# Install requirements
RUN python${PYTHON_VERSION} -m pip install wheel && \
        python${PYTHON_VERSION} -m pip install --upgrade https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-1.12.0-py3-none-any.whl && \
        pip install -r requirements.txt

RUN adduser --shell /bin/bash --disabled-password --gecos "" --uid $USER_ID game
RUN chown -R game /workspace
USER game

CMD ["python3.10", "app.py"]
