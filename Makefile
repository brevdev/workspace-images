DOCKERCMD=docker

pushDocker_WorkspaceBase1Dev:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=public.ecr.aws/r3q7i5p9/brev-workspace-env-pub)
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}  

	cd workspace-base-1 && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}
