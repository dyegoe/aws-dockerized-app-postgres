FROM python:2.7-alpine3.8

COPY . /app

RUN apk --update add --no-cache postgresql postgresql-dev && \
    apk --update add --no-cache --virtual build-dependencies \
        build-base python-dev libffi-dev musl-dev && \
    pip install --upgrade pip && \
    pip install -r /app/requirements.txt && \
    apk del build-dependencies && \
    python /app/tests.py

ENTRYPOINT ["python", "/app/runserver.py"]