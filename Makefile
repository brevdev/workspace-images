.PHONY: ubuntu-proxy
DOCKERCMD=docker

tag ?= $(git rev-parse --short=12 HEAD)

dev-push-ubuntu-proxy:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=public.ecr.aws/r3q7i5p9/brev-workspace-env-pub)
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}  

	cd ubuntu-proxy && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/workspace-ubuntu-20)
	docker login

	cd ubuntu-proxy && $(DOCKERCMD) build --no-cache -t ${registry}:${tag} . && cd -

	$(DOCKERCMD) push ${registry}:${tag}


