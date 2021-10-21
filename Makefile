.PHONY: ubuntu-proxy
DOCKERCMD=docker

tag ?= $(git rev-parse --short=12 HEAD)

#################
###### DEV ######
#################

dev-push-ubuntu-proxy:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=public.ecr.aws/r3q7i5p9/ubuntu-proxy)
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}
	cd ubuntu-proxy && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

dev-push-ubuntu-proxy-ideacommunity2020.3.4:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=public.ecr.aws/r3q7i5p9/ubuntu-proxy-ideacommunity202034)
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}
	cd ubuntu-proxy-ideacommunity2020.3.4 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

dev-push-ubuntu-proxy-ideaultimate2020.3.4:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=public.ecr.aws/r3q7i5p9/ubuntu-proxy-ideaultimate202034)
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}
	cd ubuntu-proxy-ideaultimate2020.3.4 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

dev-push-ubuntu-proxy-webstorm2020.3.3:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=public.ecr.aws/r3q7i5p9/ubuntu-proxy-webstorm202033)
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}
	cd ubuntu-proxy-webstorm2020.3.3 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

##################
###### PROD ######
##################

prod-push-ubuntu-proxy:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy)
	docker login
	cd ubuntu-proxy && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy-ideacommunity2020.3.4:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-ideacommunity202034)
	docker login
	cd ubuntu-proxy-ideacommunity2020.3.4 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy-ideaultimate2020.3.4:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-ideaultimate202034)
	docker login
	cd ubuntu-proxy-ideaultimate2020.3.4 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy-webstorm2020.3.3:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-webstorm202033)
	docker login
	cd ubuntu-proxy-webstorm2020.3.3 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}
