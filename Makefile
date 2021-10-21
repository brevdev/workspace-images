DOCKERCMD=docker

pushDocker_WorkspaceBase0:
	$(eval registry=public.ecr.aws/r3q7i5p9/brev-workspace-env-pub)
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}

	cd workspace-base-0 && $(DOCKERCMD) build -t ${registry} .
	$(DOCKERCMD) push ${registry}:latest

pushDocker_WorkspaceBase1Dev:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=public.ecr.aws/r3q7i5p9/brev-workspace-env-pub)
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}  

	cd workspace-base-1 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

pushDocker_UbuntuProxyIDEACommunity2020.3.4_Dev:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=public.ecr.aws/r3q7i5p9/ubuntu-proxy-ideacommunity2020)
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}  

	cd ubuntu-proxy-IDEACommunity2020.3.4 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}

pushDocker_WorkspaceBase1Prod:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/workspace-ubuntu-20)
	docker login

	cd workspace-base-1 && $(DOCKERCMD) build --no-cache -t ${registry}:${tag} . && cd -

	$(DOCKERCMD) push ${registry}:${tag}