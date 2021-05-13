# CoreDNS+

---

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/RedSerenity/coredns-docker?label=Version&style=for-the-badge)
![GitHub Workflow Status (event)](https://img.shields.io/github/workflow/status/RedSerenity/coredns-docker/DockerBuildPush?event=push&label=Docker%20Build&style=for-the-badge)
![Docker Stars](https://img.shields.io/docker/stars/redserenity/coredns?style=for-the-badge)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/redserenity/coredns?sort=date&style=for-the-badge)

_Note: Versioning will follow the main CoreDNS releases._

This repo contains a Dockerfile to custom build CoreDNS with certain plugins, namely `pdsql, redis, redis_cache, netbox, alternate, mdns, dump` and using _Alpine Linux_ as the base container.

[Dockerhub Repository](https://hub.docker.com/r/redserenity/coredns)

<br/>

#### Command line

```shell
docker run -p 53:53 -p 53:53/udp -v "./coredns:/etc/coredns" --name CoreDns redserenity/coredns:latest
```
<br/>

#### docker-compose.yml
```yaml
version: '3.5'

services:
  CoreDns:
    container_name: CoreDns
    image: redserenity/coredns:latest
    restart: always
    ports:
      - 53:53
      - 53:53/udp
    volumes:
      - "./coredns:/etc/coredns"
```