FROM python:3.8-slim-buster
RUN apt-get update \
    && apt-get -y install libpq-dev gcc 
WORKDIR /app
COPY ./app/requirement.txt requirement.txt
RUN sudo yum install telnet -y
RUN pip3 install -r requirement.txt
COPY ./app /app
ENTRYPOINT [ "python3" ]
CMD [ "app.py" ]