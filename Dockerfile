# custom cinder-volume container - having python-3parclient
FROM registry.access.redhat.com/rhosp13/openstack-cinder-volume

MAINTAINER HPE

LABEL name="rhosp13/openstack-cinder-volume-hpe" \
      maintainer="sneha.rai@hpe.com" \
      vendor="HPE" \
      version="1.0" \
      release="13" \
      summary="Red Hat OpenStack Platform 13.0 cinder-volume HPE plugin" \
      description="Cinder plugin for HPE 3PAR"

# switch to root and install a custom RPM, etc.
USER root

# install python module python-3parclient(dependent module for HPE 3PAR Cinder driver)
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && python get-pip.py && pip install python-3parclient==4.2.8 && rm get-pip.py

# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)
COPY licenses /licenses

# switch the container back to the default user
USER cinder
