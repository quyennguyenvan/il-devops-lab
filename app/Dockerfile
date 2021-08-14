FROM python:3.8-slim-buster
RUN apt-get update \
    && apt-get -y install libpq-dev gcc 
WORKDIR /app
COPY requirement.txt requirement.txt
RUN pip3 install -r requirement.txt
COPY . .
CMD ["python3", "main.py"]