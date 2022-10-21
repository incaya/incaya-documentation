help: # Display available commands
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-image:
	rm -f hugo/config.toml
	rm -rf hugo/public
	rm -rf hugo/content
	docker build -t incaya-documentation-fr --target french --force-rm .
	docker build -t incaya-documentation-en --target english --force-rm .

push-image:
	docker tag incaya-documentation-fr ghcr.io/incaya/incaya-documentation:latest
	docker push ghcr.io/incaya/incaya-documentation:latest
	docker tag incaya-documentation-fr ghcr.io/incaya/incaya-documentation:fr
	docker push ghcr.io/incaya/incaya-documentation:fr
	docker tag incaya-documentation-en ghcr.io/incaya/incaya-documentation:en
	docker push ghcr.io/incaya/incaya-documentation:en

publish: build-image push-image ## Build then push Docker image on Github registry

.PHONY: publish
