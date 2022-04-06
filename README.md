# Docker reverse proxy for local development

No more adding vhosts to the hosts file! Simply start this container and route `*.local` DNS to localhost.

[Traefik](https://github.com/traefik/traefik) binds to Docker and automatically routes traffic to Docker containers.
There's even a fancy monitoring portal bundled with the container.

## Setup

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

## HTTPS

There is an HTTPS branch in this repository. It generates and uses a
self-signed certificate that triggers danger warnings in all browsers.

It's still a work in progress!

TODO: How do I configure my system to trust self-signed certificates? I trust myself, so should my computer.

---

## Route `*.local` DNS to localhost on Windows 10

- Download and install `Acrylic DNS Proxy` from https://mayakron.altervista.org/support/acrylic/Home.htm
- There is a [known issue](https://github.com/microsoft/WSL/issues/4364) with WSL2 / Acrylic DNS Proxy.
  We need to tell Acrylic to only bind to the primary network adapter, and not all adapters (including the WSL adapter).
- Open Acrylic UI to edit configs:
    - File > Open Acrylic Configuration:
      Change `LocalIPv4BindingAddress` from `0.0.0.0` to `127.0.0.1`
    - File > Open Acrylic Hosts:
      Add this line at the end of the file to route all .local URLs to localhost.
      `127.0.0.1 *.local`
- Open "Network and Sharing Center":
    - Change adapter options.
    - Right click > Properties on primary network adapter (ignore any others).
    - Select "Internet Protocol Version 4 (TCP/IPv4)" and click Properties.
      Enter 127.0.0.1 as Preferred DNS server.
    - Repeat for Internet Protocol Version 6 (TCP/IPv6)

---