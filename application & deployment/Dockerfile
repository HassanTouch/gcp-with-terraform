 # Using official python runtime base image
FROM  python:3.9-slim
# i try with python:3.7
RUN apt-get update \
    && pip install --upgrade pip \
    && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/* 


WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/ 
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV ENVIRONMENT=DEV
ENV HOST=localhost
ENV PORT=8000
ENV REDIS_HOST=localhost
ENV REDIS_PORT=6379
ENV REDIS_DB=0
EXPOSE 8000


CMD ["python3", "hello.py"]

