# Docker reverse proxy for local development

Provides routing to Docker containers.

[Traefik](https://github.com/traefik/traefik) binds to Docker and automatically routes traffic to Docker containers.
It provides SSL support at the router level, allowing me to ignore SSL configuration on all other Docker containers system wide.
There's even a fancy monitoring portal bundled with the container.

## Setup

- Generate self-signed SSL certificate
  ```
  ./makeCertificates.sh
  ```
- Start traefik container
  ```
  docker-compose up -d
  ```  
  Traefik will run in the background, and restart automatically. Set and forget.
- Start other containers, Traefik will discover them and create routing automatically.

**Multiple Docker Networks**

By default Docker Compose creates a distinct network for each docker-compose file.
In order for Traefik to route to a container it must be connected to the same network.

There are options for how to do this:

- **Use the same network name across multiple docker-compose files.**  
  This works great if we don't care that containers from different projects are able to communicate.
  I have Traefik configured to use a network named `local`.
- **Manually connect Traefik to networks.**  
  `docker network connect [network-name] traefik`  
  Traefik can be connected to multiple networks at once.

---

## Traefik Web UI

The Web UI is enabled by default.
To access it go to `https://localhost:8080`.

To disable it comment these lines:

```
# docker-compose.yaml

  my-service:
    command:
      # - --api.insecure=true # Enables the web UI
    ports:
      # - "8080:8080" # Web UI port
```

---

TODO: How do I configure my system to trust self-signed certificates?

Currently my browser shows me a security warning before proceeding to the destination.
This is an annoying inconvenience, there must be a way to trust my own certificates.

---
