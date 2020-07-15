# -*- Makefile -*-

PORT := 9999

stack:
	docker stack deploy -c docker-compose.yml aptly

build:
	./build.sh

create-volume:
	./create-volume.sh

generate-keypair:
	./generate-keypair.sh

run:
	PORT=$(PORT) ./run.sh

shell:
	docker exec -it aptly /bin/bash

stop:
	docker stop aptly

key:
	curl -L http://localhost:$(PORT)/aptly_repo_signing.key

apt-key-add:
	curl -sL http://localhost:$(PORT)/aptly_repo_signing.key | sudo apt-key add -

install-sources-list:
	echo "deb http://localhost:$(PORT)/ ubuntu main" | sudo tee /etc/apt/sources.list.d/aptly.list

generate-htpasswd:
	./generate-htpasswd.sh

test-api:
	curl -u admin:foobar http://localhost:$(PORT)/api/version
