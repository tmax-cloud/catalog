FROM python:alpine

COPY serve.sh /serve.sh

RUN mkdir -p /devpi-home
WORKDIR /devpi-home

RUN apk add --no-cache --virtual .build-deps gcc libffi-dev musl-dev supervisor && \
    pip install -q -U devpi-server && \
	rm -r /root/.cache && \
	chmod +x /serve.sh

ENTRYPOINT ["/serve.sh"]
