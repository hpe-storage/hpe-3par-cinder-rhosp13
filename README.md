## HPE 3PAR Cinder volume custom container for RHOSP13
Manual building of a container for HPE 3PAR cinder volume for RHOSP13

1.	Create Dockerfile

[Dockerfile](hpe-3par-cinder-rhosp13/Dockerfile)
      
2.	Build the docker image
```
docker build --build-arg http_proxy=http://16.85.88.10:8080 --build-arg https_proxy=http://16.85.88.10:8080 .
```

3.	Run docker images command to verify if the container got created successfully or not
```
docker images
REPOSITORY                                           TAG                 IMAGE ID                       CREATED             SIZE
<none>                                               <none>              b497daac7539        21 seconds ago      1.01 GB
```

4.	Add tag to the image created
```
docker tag <image id> 10.50.9.100:8787/rhosp13/openstack-cinder-volume-hpe:latest
```

5.	Run docker images command to verify the repository and tag is correctly updated to the docker image
```
docker images
REPOSITORY                                                                                                            TAG                                IMAGE ID               CREATED                    SIZE
10.50.9.100:8787/rhosp13/openstack-cinder-volume-hpe                      latest                             b497daac7539        2 minutes ago       1.01 GB
```

6.	Push the container to a local registry
```
docker push 10.50.9.100:8787/rhosp13/openstack-cinder-volume-hpe:latest
```

7.	Created new env file “custom_container_env.yml” under /home/stack/custom_container/ with only the custom container parameter and other backend details
```
parameter_defaults:
    DockerCinderVolumeImage: 10.50.9.100:8787/rhosp13/openstack-cinder-volume-hpe:latest
```

8.	Deploy overcloud
```
openstack overcloud deploy --templates -e /home/stack/templates/node-info.yaml -e /home/stack/templates/overcloud_images.yaml -e /home/stack/custom_container/custom_container_env.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/cinder-backup.yaml --ntp-server 10.38.11.1
```

9.	SSH to controller node from undercloud and check the docker process for cinder-volume
```
[root@overcloud-controller-0 log]# docker ps | grep cinder
c2bdda1c0927        10.50.9.100:8787/rhosp13/openstack-cinder-api:latest                  "kolla_start"            25 hours ago        Up 25 hours                                 cinder_api_cron
5988651e5bed        10.50.9.100:8787/rhosp13/openstack-cinder-volume-hpe:pcmklatest       "/bin/bash /usr/lo..."   25 hours ago        Up 25 hours                                 openstack-cinder-volume-docker-0
9538b16dc737        10.50.9.100:8787/rhosp13/openstack-cinder-backup:pcmklatest           "/bin/bash /usr/lo..."   25 hours ago        Up 25 hours                                 openstack-cinder-backup-docker-0
f48d1d53b99d        10.50.9.100:8787/rhosp13/openstack-cinder-scheduler:latest            "kolla_start"            25 hours ago        Up 25 hours (healthy)                       cinder_scheduler
daded4534677        10.50.9.100:8787/rhosp13/openstack-cinder-api:latest                  "kolla_start"            25 hours ago        Up 25 hours (healthy)                       cinder_api
```

10.	Verify the module installed is present in the cinder-volume-hpe container
```
[root@overcloud-controller-0 log]# docker exec -it 5988651e5bed bash
()[root@overcloud-controller-0 /]# pip list | grep 3par
python-3parclient                4.2.8
```
