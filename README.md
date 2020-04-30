# Drone for Docker Swarm

Reference to secrets from your environment variables is unfortunately not supported yet. In order to do just that, there is a workaround implemented in the official docker [MySQL](https://github.com/docker-library/mysql/blob/master/5.7/docker-entrypoint.sh) image.

Secrets are accessible from the containers that have access to them by using the file path /run/secrets/drone_rpc_secret. Add an environment variable to the compose file with a custom name appending `_SECRETNAME`.

A secret can be defined using the following command:

```bash
echo "mysupersecret" | docker secret create drone_rpc_secret -
```

And then append `_SECRETNAME` to the environment variable in the compose file.

```yaml
version: '3.7'

services:
  drone:
    image: juli3nk/drone:1
    environment:
      MYSQL_PASSWORD_SECRETNAME: drone_rpc_secret

secrets:
  drone_rpc_secret:
    external: true
```



