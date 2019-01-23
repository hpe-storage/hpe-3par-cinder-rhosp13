# custom cinder-volume container - having python-3parclient
FROM registry.access.redhat.com/rhosp13/openstack-cinder-volume

MAINTAINER HPE

LABEL name="rhosp13/openstack-cinder-volume-hpe" \
      vendor="HPE" \
      version="1.0" \
      release="13" \
      summary="Red Hat OpenStack Platform 13.0 cinder-volume HPE plugin"

# switch to root and install a custom RPM, etc.
USER root

# install python module python-3parclient(dependent module for HPE 3PAR Cinder driver)
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" --proxy ${http_proxy} && https_proxy=${https_proxy} python get-pip.py && https_proxy=${https_proxy} pip install python-3parclient==4.2.8 && rm get-pip.py

# switch the container back to the default user
USER cinder
