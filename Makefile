help: # Display available commands
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-image:
	docker build -t incaya-documentation --force-rm .

push-image:
	docker tag incaya-documentation ghcr.io/incaya/incaya-documentation:latest
	docker push ghcr.io/incaya/incaya-documentation:latest

publish: build-image push-image ## Build then push Docker image on Github registry
	docker build -t incaya-documentation --force-rm .

.PHONY: publish
