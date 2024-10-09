ARG PYTHON_VERSION=3.8-slim

FROM python:${PYTHON_VERSION}

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /code

WORKDIR /code

COPY requirements.txt /tmp/requirements.txt
RUN set -ex && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/
COPY . /code

# This is 😱 but this repo is just for testing so.... okay I guess???
ENV SECRET_KEY "pSuEJRgCjlg0MzpTJsF2KtGjJWa1ofpNwWGmQTv2gY3QN0a1q0"
RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn","--bind",":8000","--workers","2","mysite.wsgi"]
