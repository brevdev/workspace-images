DOCKERCMD=docker

pushDocker_WorkspaceBase0:
	$(eval ecrDomain=public.ecr.aws/r3q7i5p9/brev-workspace-env-pub)
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ecrDomain}

	cd workspace-base-0 && $(DOCKERCMD) build -t ${ecrDomain} .
	$(DOCKERCMD) push ${ecrDomain}:latest