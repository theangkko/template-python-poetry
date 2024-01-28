# Dockerfile

# FROM python:3
# WORKDIR /app
# COPY requirements.txt ./

# RUN apt-get update && apt-get install -y sudo
# RUN chmod +w /etc/sudoers
# RUN echo 'user ALL=(ALL) NOPASSWD:ALL' | tee -a /etc/sudoers
# RUN chmod -w /etc/sudoers
# RUN pip3 install -r requirements.txt
# COPY . .

# CMD [ "python3", "./main.py" ]

# EXPOSE 8550

FROM python:3.11

ARG YOUR_ENV

ENV YOUR_ENV=${YOUR_ENV} \
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=1.0.0

# System deps:
RUN pip install "poetry==$POETRY_VERSION"

# Copy only requirements to cache them in docker layer
WORKDIR /app
COPY poetry.lock pyproject.toml /app/


# Project initialization:
RUN poetry config virtualenvs.create false \
  && poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi


# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
# RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
# USER appuser


# Creating folders, and files for a project:
COPY /src/. /app
# COPY /. /app

CMD [ "python3", "./main.py" ]
