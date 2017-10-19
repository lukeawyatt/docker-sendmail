FROM ubuntu
MAINTAINER Luke Wyatt <luke@meat.space>
LABEL company="Meatspace Studios"
LABEL version="1.0.0"

# INSTALL PREREQUISITES
RUN apt-get update
RUN apt-get -y install sendmail

# CREATE APP DIRECTORY
RUN mkdir -p /usr/src/app
RUN mkdir -p /data
WORKDIR /usr/src/app
COPY docker-sendmail.sh /usr/src/app/

EXPOSE 25 587
ENTRYPOINT ["/usr/src/app/docker-sendmail.sh"]
CMD ["--help"]
