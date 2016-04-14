FROM ubuntu:16.04
MAINTAINER Yves Jacolin <yves.jacolin@camptocamp.com>

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key 3FF5FFCAD71472C4 && \
    echo "deb     http://qgis.org/debian xenial main" > /etc/apt/sources.list.d/qgis.list

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get update &&  \
    apt-get install -qqy qgis-server apache2 libapache2-mod-fcgid
    
RUN a2enmod fcgid
RUN a2enmod cgid
RUN a2enmod rewrite

#TODO: ajouter conf Apache

RUN mkdir /projects/
WORKDIR /projects
VOLUME ["/projects"]

ADD qgis.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default
ENV PGSERVICEFILE /projects/pg_service.conf

EXPOSE 80
CMD ["apache2ctl", "-DFOREGROUND"]
