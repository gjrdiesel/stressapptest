FROM ubuntu

RUN apt update -y && apt install -y stressapptest dstat gcc

COPY files/ /

RUN gcc -o /memtest memtest.c

RUN gcc -o /memtest2 memtest2.c
