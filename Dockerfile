#FROM python:3.9.2-slim-buster@sha256:721de1d0aea3331da282531b8b9e428d552b89bd6fd0d0c14e634deaddc241fc as build
#RUN groupadd auth0 && useradd -m developer -g auth0
#WORKDIR /home/developer/app
#USER developer
#COPY ./requirements.txt .
#RUN pip install --disable-pip-version-check -r requirements.txt --target /home/developer/packages
#COPY authz authz
#COPY common common
#COPY hello_world hello_world
#COPY messages_api messages_api
#COPY gunicorn.conf.py manage.py ./

#FROM gcr.io/distroless/python3@sha256:eb773dd9d39f0becdab47e2ef5f1b10e2988c93a40ac8d32ca593096b409d351
#COPY --from=build /home/developer/packages /packages
#COPY --from=build /home/developer/app /app
#WORKDIR /app
#USER 1000
#EXPOSE 6060
#ENV PYTHONPATH=/packages
#CMD ["/packages/gunicorn/app/wsgiapp.py","hello_world.wsgi:application"]

FROM python:3.9.2-slim-buster@sha256:721de1d0aea3331da282531b8b9e428d552b89bd6fd0d0c14e634deaddc241fc as build

LABEL eon_natgas = "natgas-natdev"

ENV PYTHONUNBUFFERED 1

# Install dependencies
COPY ./requirements.txt /requirements.txt
# RUN apk add --update --no-cache postgresql-client
# RUN apk add --update --no-cache --virtual .tmp-build-deps \
# gcc libc-dev linux-headers postgresql-dev
# RUN apk del .tmp-build-deps

RUN pip install -r /requirements.txt

EXPOSE 6060
# Setup directory structure
COPY authz authz
COPY common common
COPY hello_world hello_world
COPY messages_api messages_api
COPY gunicorn.conf.py manage.py ./

ENV PATH="/py/bin/$PATH"
