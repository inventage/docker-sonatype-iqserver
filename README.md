# Sonatypes IQ Server for demo purposes

This docker file is just for demo purposes and is not tested/recommended for production.

## Building the docker image

    docker build -t iqs .

## Starting the docker container

    docker run -p 8070:8070 -t -i iqs

If you'd like to mount the working folder (including data and logs) in `/tmp/volume`:

    docker run -p 8070:8070 -v /tmp/volume:/sonatype-work -t -i iqs

The host folder `/tmp/volume` needs to contain the `config.yml` and must be read-/writeable to the uid `200`.

## Accessing the web interface

<http://localhost:8070/>

(User: `admin`, Password: `admin123`)

You'll first need to upload a license file.
