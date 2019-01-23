# custom cinder-volume container - having python-3parclient
FROM 10.50.9.100:8787/rhosp13/openstack-cinder-volume:latest

MAINTAINER HPE

LABEL name="rhosp13/openstack-cinder-volume-hpe"
LABEL vendor="HPE"
LABEL version="3"
LABEL release="13.0-63"

USER root

# install pre-requisite
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" --proxy ${http_proxy} && https_proxy=${https_proxy} python get-pip.py && https_proxy=${https_proxy} pip install python-3parclient && rm get-pip.py

USER cinder

