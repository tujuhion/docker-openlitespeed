# Docker Centos7 with Openlitespeed

This Docker will run

- Centos 7
- Openlitespedd
- MariaDB10.2
- ProFTPD

you can access litespeed admin in http://yourhostname:7080, set password with command

```/usr/local/lsws/admin/misc/admpass.sh```

Document root in:
```
/home/defdomain/html/
```

MySQL password it not set, and can access with root without password, you must set yourself after docker run for security.

## Build docker image
```
git clone https://github.com/tujuhion/docker-centos-openlitespeed.git
cd docker-centos-openlitespeed
docker build --rm=true --no-cache=true -t docker-centos-openlitespeed .
```
Run docker image
```
docker run docker-centos-openlitespeed
```
## Hub Docker

Can found in https://hub.docker.com/r/7ion/docker-centos-openlitespeed/

or pull
```
docker pull 7ion/docker-centos-openlitespeed/
```
