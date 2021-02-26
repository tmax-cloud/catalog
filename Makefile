VERSION ?= 5.0.0
OP_VERSION ?= v0.2.0

.PHONY: all db was version

all: db was version

db:
	/bin/bash _hack/gen-db.sh all

was:
	/bin/bash _hack/gen-was.sh all

version:
	/bin/bash _hack/version.sh ${VERSION} ${OP_VERSION}
