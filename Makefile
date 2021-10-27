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

dev-push-ubuntu-proxy-rstudio1.4.1717:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=public.ecr.aws/r3q7i5p9/ubuntu-proxy-rstudio141717)
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}
	cd ubuntu-proxy-rstudio1.4.1717 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
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

prod-push-ubuntu-proxy-rstudio1.4.1717:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-rstudio141717)
	docker login
	cd ubuntu-proxy-rstudio1.4.1717 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy-clion2020.3.4:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-clion202034)
	docker login
	cd ubuntu-proxy-clion2020.3.4 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy-datagrip2020.3.2:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-datagrip202032)
	docker login
	cd ubuntu-proxy-datagrip2020.3.2 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy-goland2020.3.5:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-goland202035)
	docker login
	cd ubuntu-proxy-goland2020.3.5 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy-mps2020.3:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-mps20203)
	docker login
	cd ubuntu-proxy-mps2020.3 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy-phpstorm2020.3.3:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-phpstorm202033)
	docker login
	cd ubuntu-proxy-phpstorm2020.3.3 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy-pycharmcommunity2020.3.5:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-pycharmcommunity202035)
	docker login
	cd ubuntu-proxy-pycharmcommunity2020.3.5 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy-pycharmprofessional2020.3.5:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-pycharmprofessional202035)
	docker login
	cd ubuntu-proxy-pycharmprofessional2020.3.5 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy-rider2020.3.4:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-rider202034)
	docker login
	cd ubuntu-proxy-rider2020.3.4 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

prod-push-ubuntu-proxy-rubymine2020.3.2:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy-rubymine202032)
	docker login
	cd ubuntu-proxy-rubymine2020.3.2 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}
