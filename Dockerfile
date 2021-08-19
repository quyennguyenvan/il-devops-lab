FROM python:3.8-slim-buster
RUN apt-get update \
    && apt-get -y install libpq-dev gcc 
ENV accessKey=AKIAXA45ESJF6Z5CNWCO
ENV secretKey=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
WORKDIR /app
COPY ./app/requirement.txt requirement.txt
RUN pip3 install -r requirement.txt
COPY ./app /app
ENTRYPOINT [ "python3" ]
CMD [ "app.py" ]

