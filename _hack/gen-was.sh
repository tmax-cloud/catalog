#!/bin/bash 

if [ $# -ne 1 ]; then
	echo "Usage: $0 <WAS>"
	exit 1
fi

scriptDir="$(dirname "$0")"

TARGET_DIR="$scriptDir/../was/$1"

TEMPLATE_FILE="$1-template.yaml"
INSTANCE_FILE="$1-instance.yaml"

APP_NAME="$1-sample-app"

TEMPLATE_NAME="$1-cicd-template"
INSTANCE_NAME="$1-cicd-template-instance"

WAS_PORT=8080

if [ "$1" == "all" ]; then
	/bin/bash "$0" apache && \
	/bin/bash "$0" nodejs && \
	/bin/bash "$0" django && \
	/bin/bash "$0" wildfly && \
	/bin/bash "$0" tomcat && \
	exit 0
elif [ "$1" == "apache" ]; then
	DISPLAY_NAME="Apache"
	BUILDER_IMAGE="tmaxcloudck/s2i-apache:2.4"
	GIT_URL="https://github.com/microsoft/project-html-website"
	THUMBNAIL="https://upload.wikimedia.org/wikipedia/commons/4/45/Apache_HTTP_server_logo_%282016%29.png"
	URL_DESCRIPTION="https://httpd.apache.org/"
elif [ "$1" == "nodejs" ]; then
	DISPLAY_NAME="NodeJS"
	BUILDER_IMAGE="tmaxcloudck/s2i-nodejs:12"
	GIT_URL="https://github.com/sunghyunkim3/nodejs-rest-http"
	THUMBNAIL="https://upload.wikimedia.org/wikipedia/commons/d/d9/Node.js_logo.svg"
	URL_DESCRIPTION="https://nodejs.org/ko/"
elif [ "$1" == "django" ]; then
	DISPLAY_NAME="Django"
	BUILDER_IMAGE="tmaxcloudck/s2i-django:35"
	GIT_URL="https://github.com/sunghyunkim3/django-realworld-example-app"
	THUMBNAIL="https://upload.wikimedia.org/wikipedia/commons/7/75/Django_logo.svg"
	URL_DESCRIPTION="https://www.djangoproject.com/"
elif [ "$1" == "wildfly" ]; then
	DISPLAY_NAME="Wildfly"
	BUILDER_IMAGE="tmaxcloudck/s2i-wildfly:latest"
	GIT_URL="https://github.com/sunghyunkim3/TomcatMavenApp"
	THUMBNAIL="https://upload.wikimedia.org/wikipedia/commons/a/a3/Wildfly_logo.png"
	URL_DESCRIPTION="https://www.wildfly.org/"
elif [ "$1" == "tomcat" ]; then
	DISPLAY_NAME="Tomcat"
	BUILDER_IMAGE="tmaxcloudck/s2i-tomcat:latest"
	GIT_URL="https://github.com/sunghyunkim3/TomcatMavenApp"
	THUMBNAIL="https://upload.wikimedia.org/wikipedia/commons/7/7b/Tomcat-logo.svg"
	URL_DESCRIPTION="https://tomcat.apache.org/"
else
	echo "No known target $1"
	exit 1
fi

mkdir -p "$TARGET_DIR"

# Template
yq w "$scriptDir/was_original/original-template.yaml" 'metadata.name' "$TEMPLATE_NAME" | \
yq w - 'metadata.labels.cicd-template-was' "$1" | \
yq w - 'objects[2].spec.tasks[1].params[0].value' "$BUILDER_IMAGE" | \
yq w - 'imageUrl' "$THUMBNAIL" | \
yq w - 'shortDescription' "$DISPLAY_NAME CI/CD Template" | \
yq w - 'longDescription' "$DISPLAY_NAME CI/CD Template" | \
yq w - 'urlDescription' "$URL_DESCRIPTION" | \
yq w - 'tags[1]' "$1" | \
yq w - 'plans[0].description' "$1" | \
yq w - 'plans[0].name' "$1-plan1"> "$TARGET_DIR/$TEMPLATE_FILE"

# Instance
yq w "$scriptDir/was_original/original-instance.yaml" 'metadata.name' "$INSTANCE_NAME" | \
yq w - 'spec.clustertemplate.metadata.name' "$TEMPLATE_NAME" | \
yq w - 'metadata.labels.cicd-template-was' "$1" | \
yq w - 'spec.clustertemplate.parameters[0].value' "$APP_NAME" | \
yq w - 'spec.clustertemplate.parameters[2].value' "$GIT_URL" | \
yq w - 'spec.clustertemplate.parameters[6].value' "$WAS_PORT" > "$TARGET_DIR/$INSTANCE_FILE"
