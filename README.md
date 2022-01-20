# minecraft-bedrock-docker

### Overview

Dockerized minecraft-bedrock server.

https://www.minecraft.net/en-us/download/server/bedrock

### Building

```
docker build --tag minecraft-bedrock:latest .
```

### Testing

```
docker run -it --rm --net=host \
  --env-file ./minecraft-bedrock.env \
  --name minecraft-bedrock \
  minecraft-bedrock:latest
```

### Running

```
docker-compose up -d
```

### Environment

* SERVER_PROPERTIES
...Default:
...Description: Pipe separated pairs variable=value for minecraft server.properties (lines starting with `variable=` will be replaced, otherwise will be appended)
...Example: `SERVER_PROPERTIES="server-name=Dedicated Server|gamemode=survival"`

* WHITELIST
..Default:
..Description: Pipe separated usernames for whitelist.
...Example: `WHITELIST="user1|user2"`
