FROM public.ecr.aws/lambda/python:3.10-arm64

COPY ./requirements.txt /home/lambdas/

VOLUME /home/dist
VOLUME /home/lambdas

WORKDIR /home/lambdas
RUN ["pip", "install", "-r", "requirements.txt"]

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
