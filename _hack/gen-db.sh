#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 [all|mysql|mariadb|postgresql|mongodb|redis]"
	exit 1
fi

scriptDir="$(dirname "$0")"

TARGET_DIR="$scriptDir/../db/$1"

APP_NAME="$1-sample-app"

TEMPLATE_FILE="$1-template.yaml"
INSTANCE_FILE="$1-instance.yaml"

TEMPLATE_NAME="$1-template"
INSTANCE_NAME="$1-template-instance"

if [ "$1" == "all" ]; then
	/bin/bash "$0" mysql && \
	/bin/bash "$0" mariadb && \
	/bin/bash "$0" postgresql && \
	/bin/bash "$0" mongodb && \
	/bin/bash "$0" redis && \
	exit 0
# Param setting for each DB
elif [ "$1" == "mysql" ]; then
	DISPLAY_NAME="MySQL"
	IMAGE="centos/mysql-57-centos7:5.7"
	PORT=3306
	STORAGE="/var/lib/mysql/data"
	THUMBNAIL="https://upload.wikimedia.org/wikipedia/en/6/62/MySQL.svg"
	URL_DESCRIPTION="https://www.mysql.com/"
	declare -A env0=(
		[name]='MYSQL_USER'
		[displayName]='MysqlUser'
		[value]='root1'
	)
	declare -A env1=(
		[name]='MYSQL_PASSWORD'
		[displayName]='MysqlPassword'
		[value]='tmax@23'
	)
	declare -A env2=(
		[name]='MYSQL_DATABASE'
		[displayName]='MysqlDatabase'
		[value]='root1'
	)
	READINESS=("/bin/bash" "-c" "MYSQL_PWD=\"\$MYSQL_PASSWORD\" mysql -h 127.0.0.1 -u \$MYSQL_USER -D \$MYSQL_DATABASE -e 'SELECT 1'")
elif [ "$1" == "mariadb" ]; then
	DISPLAY_NAME="MariaDB"
	IMAGE="centos/mariadb-102-centos7:latest"
	PORT=3306
	STORAGE="/var/lib/mysql/data"
	THUMBNAIL="https://upload.wikimedia.org/wikipedia/commons/c/c9/MariaDB_Logo.png"
	URL_DESCRIPTION="https://mariadb.org/"
	declare -A env0=(
		[name]='MYSQL_USER'
		[displayName]='MysqlUser'
		[value]='root1'
	)
	declare -A env1=(
		[name]='MYSQL_PASSWORD'
		[displayName]='MysqlPassword'
		[value]='tmax@23'
	)
	declare -A env2=(
		[name]='MYSQL_DATABASE'
		[displayName]='MysqlDatabase'
		[value]='root1'
	)
	READINESS=("/bin/bash" "-c" "MYSQL_PWD=\"\$MYSQL_PASSWORD\" mysql -h 127.0.0.1 -u \$MYSQL_USER -D \$MYSQL_DATABASE -e 'SELECT 1'")
elif [ "$1" == "postgresql" ]; then
	DISPLAY_NAME="PostgreSQL"
	IMAGE="centos/postgresql-96-centos7:latest"
	PORT=5432
	STORAGE="/var/lib/pgsql/data"
	THUMBNAIL="https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg"
	URL_DESCRIPTION="https://www.postgresql.org/"
	declare -A env0=(
		[name]='POSTGRESQL_USER'
		[displayName]='PostgreSQLUser'
		[value]='root'
	)
	declare -A env1=(
		[name]='POSTGRESQL_PASSWORD'
		[displayName]='PostgreSQLPassword'
		[value]='tmax@23'
	)
	declare -A env2=(
		[name]='POSTGRESQL_DATABASE'
		[displayName]='PostgreSQLDatabase'
		[value]='root'
	)
	READINESS=("/usr/libexec/check-container")
elif [ "$1" == "mongodb" ]; then
	DISPLAY_NAME="MongoDB"
	IMAGE="centos/mongodb-26-centos7:latest"
	PORT=27017
	STORAGE="/var/lib/mongodb/data"
	THUMBNAIL="https://upload.wikimedia.org/wikipedia/en/4/45/MongoDB-Logo.svg"
	URL_DESCRIPTION="https://www.mongodb.com/"
	declare -A env0=(
		[name]='MONGODB_USER'
		[displayName]='MongoDBUser'
		[value]='root'
	)
	declare -A env1=(
		[name]='MONGODB_PASSWORD'
		[displayName]='MongoDBPassword'
		[value]='root'
	)
	declare -A env2=(
		[name]='MONGODB_DATABASE'
		[displayName]='MongoDBDatabase'
		[value]='root'
	)
	declare -A env3=(
		[name]='MONGODB_ADMIN_PASSWORD'
		[displayName]='MongoDBAdminPassword'
		[value]='root'
	)
	READINESS=("/bin/bash" "-c" "mongo 127.0.0.1:27017/\$MONGODB_DATABASE -u \$MONGODB_USER -p \$MONGODB_PASSWORD --eval=\"quit()\"")
elif [ "$1" == "redis" ]; then
	DISPLAY_NAME="Redis"
	IMAGE="centos/redis-32-centos7:latest"
	PORT=6379
	STORAGE="/var/lib/redis/data"
	THUMBNAIL="https://upload.wikimedia.org/wikipedia/en/6/6b/Redis_Logo.svg"
	URL_DESCRIPTION="https://redis.io/"
	declare -A env0=(
		[name]='DATABASE_SERVICE_NAME'
		[displayName]='DatabaseServiceName'
		[value]='redis'
	)
	declare -A env1=(
		[name]='REDIS_PASSWORD'
		[displayName]='RedisPassword'
		[value]='tmax@23'
	)
	READINESS=("/bin/bash" "-c" "redis-cli -h 127.0.0.1 -a \$REDIS_PASSWORD ping")
fi

mkdir -p "$TARGET_DIR"

# Deployments
# Template
yq w "$scriptDir/db_original/original-template.yaml" 'metadata.name' "$TEMPLATE_NAME" | \
yq w - 'shortDescription' "$DISPLAY_NAME Deployment" | \
yq w - 'longDescription' "$DISPLAY_NAME Deployment" | \
yq w - 'urlDescription' "$URL_DESCRIPTION" | \
yq w - 'imageUrl' "$THUMBNAIL" | \
yq w - 'tags[1]' "$1" | \
yq w - 'objects[0].spec.ports[0].port' "$PORT" | \
yq w - 'objects[0].spec.selector.tier' "$1" > "$TARGET_DIR/$TEMPLATE_FILE"
declare -n e
for e in ${!env@}; do
	yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "objects[2].stringData.${e[name]}" '${'"${e[name]}"'}'
done

yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'objects[3].metadata.name' '${APP_NAME}'"-$1"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'objects[3].spec.selector.matchLabels.tier' "$1"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'objects[3].spec.template.metadata.labels.tier' "$1"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'objects[3].spec.template.spec.containers[0].image' "$IMAGE"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'objects[3].spec.template.spec.containers[0].name' "$1"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'objects[3].spec.template.spec.containers[0].ports[0].name' "$1"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'objects[3].spec.template.spec.containers[0].ports[0].containerPort' "$PORT"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'objects[3].spec.template.spec.containers[0].volumeMounts[0].name' "$1-persistent-storage"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'objects[3].spec.template.spec.containers[0].volumeMounts[0].mountPath' "$STORAGE"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'objects[3].spec.template.spec.volumes[0].name' "$1-persistent-storage"
I=0
declare -n e
for e in ${!env@}; do
	yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "objects[3].spec.template.spec.containers[0].env[+].name" "${e[name]}"
	yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "objects[3].spec.template.spec.containers[0].env[$I].valueFrom.secretKeyRef.name" '${APP_NAME}-secret'
	yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "objects[3].spec.template.spec.containers[0].env[$I].valueFrom.secretKeyRef.key" "${e[name]}"
	I=$((I + 1))
done
if [ "$READINESS" != "" ]; then
	yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "objects[3].spec.template.spec.containers[0].readinessProbe.initialDelaySeconds" "5"
	yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "objects[3].spec.template.spec.containers[0].readinessProbe.periodSeconds" "10"
	IFS=""
    for command in "${READINESS[@]}"; do
        yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "objects[3].spec.template.spec.containers[0].readinessProbe.exec.command[+]" -- "$command"
	done
fi

I=3
declare -n e
for e in ${!env@}; do
	yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "parameters[+].name" "${e[name]}"
	yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "parameters[$I].displayName" "${e[displayName]}"
	yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "parameters[$I].description" "${e[displayName]}"
	yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "parameters[$I].required" true
	I=$((I + 1))
done

yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'plans[0].name' "$1-plan1"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'plans[0].description' "$1"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "plans[0].schemas.service_instance.create.parameters.APP_NAME" "$1-deploy"
declare -n e
for e in ${!env@}; do
	yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "plans[0].schemas.service_instance.create.parameters.${e[name]}" "${e[value]}"
done

yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'plans[1].name' "$1-plan2"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" 'plans[1].description' "$1"
yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "plans[1].schemas.service_instance.create.parameters.APP_NAME" "$1-deploy"
declare -n e
for e in ${!env@}; do
	yq w -i "$TARGET_DIR/$TEMPLATE_FILE" "plans[1].schemas.service_instance.create.parameters.${e[name]}" "${e[value]}"
done


# Instance
yq w "$scriptDir/db_original/original-instance.yaml" 'metadata.name' "$INSTANCE_NAME" | \
yq w - 'spec.clustertemplate.metadata.name' "$TEMPLATE_NAME" | \
yq w - 'spec.clustertemplate.parameters[0].value' "$APP_NAME" > "$TARGET_DIR/$INSTANCE_FILE"
I=3
declare -n e
for e in ${!env@}; do
	yq w -i "$TARGET_DIR/$INSTANCE_FILE" "spec.clustertemplate.parameters[+].name" "${e[name]}"
	yq w -i "$TARGET_DIR/$INSTANCE_FILE" "spec.clustertemplate.parameters[$I].value" "${e[value]}"
	I=$((I + 1))
done
