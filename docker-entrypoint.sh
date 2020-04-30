#!/usr/bin/env bash

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_SECRETNAME" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local secretNameVar="${var}_SECRETNAME"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!secretNameVar:-}" ]; then
		echo "Both $var and $secretNameVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!secretNameVar:-}" ]; then
		val="$(< "/run/secrets/${!secretNameVar}")"
	fi
	export "$var"="$val"
	unset "$secretNameVar"
}

file_env "DRONE_BITBUCKET_CLIENT_ID"
file_env "DRONE_BITBUCKET_CLIENT_SECRET"
file_env "DRONE_CONVERT_PLUGIN_SECRET"
file_env "DRONE_COOKIE_SECRET"
file_env "DRONE_DATABASE_SECRET"
file_env "DRONE_GIT_PASSWORD"
file_env "DRONE_GIT_USERNAME"
file_env "DRONE_GITEA_CLIENT_ID"
file_env "DRONE_GITEA_CLIENT_SECRET"
file_env "DRONE_GITHUB_CLIENT_ID"
file_env "DRONE_GITHUB_CLIENT_SECRET"
file_env "DRONE_GITLAB_CLIENT_ID"
file_env "DRONE_GITLAB_CLIENT_SECRET"
file_env "DRONE_RPC_SECRET"
file_env "DRONE_STASH_CONSUMER_KEY"
file_env "DRONE_STASH_PRIVATE_KEY"
file_env "DRONE_VALIDATE_PLUGIN_SECRET"
file_env "DRONE_WEBHOOK_SECRET"

exec /bin/drone-server "$@"
