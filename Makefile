.PHONY: dev-push-ubuntu-proxy dev-run-ubuntu-proxy
DOCKERCMD=docker

##################
###### CI ########
##################

build-ci:
	docker build ubuntu-proxy --file ubuntu-proxy/Dockerfile --tag ubuntu-proxy:test

get-current-ci:
	aws dynamodb get-item --table-name brev-deploy-prod --key '{"pk": {"S": "workspace_template:4nbb4lg2s"}, "sk": {"S": "workspace_template"}}'  --region us-east-1 --projection-expression "#I" --expression-attribute-names '{ "#I": "image"}'

update-template-ci:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	aws dynamodb update-item --table-name brev-deploy-prod  --key '{"pk": {"S": "workspace_template:4nbb4lg2s"}, "sk": {"S": "workspace_template"}}' --attribute-updates '{"image": {"Value": {"S": "registry.hub.docker.com/brevdev/ubuntu-proxy:${tag}"},"Action": "PUT"}}' --return-values UPDATED_NEW --region us-east-1

#################
###### DEV ######
#################

build-ubuntu-proxy:
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=public.ecr.aws/r3q7i5p9/ubuntu-proxy)
	cd ubuntu-proxy && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -

dev-run-ubuntu-proxy: build-ubuntu-proxy
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=public.ecr.aws/r3q7i5p9/ubuntu-proxy)
	docker kill ubuntu-proxy || true
	docker run  --privileged=true --name ubuntu-proxy --rm -i -t  ${registry}:${tag} bash

dev-shell-ubuntu-proxy:
	docker exec -it ubuntu-proxy bash

dev-push-ubuntu-proxy: build-ubuntu-proxy
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=public.ecr.aws/r3q7i5p9/ubuntu-proxy)
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}
	$(DOCKERCMD) push ${registry}:${tag}
	git tag ${registry}-${tag} && git push origin ${registry}-${tag}

##################
###### PROD ######
##################

update-workspace-template:
	[ "${template_id}" ] || ( echo "'template_id' not provided"; exit 1 )
	[ "${image}" ] || ( echo "'template_id' not provided"; exit 1 )
	aws dynamodb update-item --table-name brev-deploy-prod  --key '{"pk": {"S": "workspace_template:${template_id}"}, "sk": {"S": "workspace_template"}}' --attribute-updates '{"image": {"Value": {"S": "${image}"},"Action": "PUT"}}' --return-values UPDATED_NEW --region us-east-1

prod-update-workspace-template:
	[ "${tag}" ] || ( echo "'template_id' not provided"; exit 1 )
	make update-workspace-template template_id=4nbb4lg2s image=registry.hub.docker.com/brevdev/ubuntu-proxy:${tag}

prod-get-ubuntu-proxy:
	aws dynamodb get-item --table-name brev-deploy-prod --key '{"pk": {"S": "workspace_template:4nbb4lg2s"}, "sk": {"S": "workspace_template"}}' --region us-east-1 --projection-expression "#I" --expression-attribute-names '{ "#I": "image"}'

prod-push-ubuntu-proxy: diff
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy)
	docker login
	cd ubuntu-proxy && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}
	make prod-update-workspace-template tag=${tag}
	git tag ${registry}-${tag} && git push origin ${registry}-${tag}

prod-admin-get-ubuntu-proxy:
	aws dynamodb get-item --table-name brev-deploy-prod  \
    	--key '{"pk": {"S": "workspace_template:v7nd45zsc"}, "sk": {"S": "workspace_template"}}' \
        --region us-east-1 \
        --projection-expression "#I" \
        --expression-attribute-names '{ "#I": "image"}'

prod-admin-update-workspace-template:
	[ "${tag}" ] || ( echo "'template_id' not provided"; exit 1 )
	make update-workspace-template template_id=v7nd45zsc image=registry.hub.docker.com/brevdev/ubuntu-proxy:${tag}

prod-admin-push-ubuntu-proxy: diff
	[ "${tag}" ] || ( echo "'tag' not provided"; exit 1 )
	$(eval registry=brevdev/ubuntu-proxy)
	docker login
	cd ubuntu-proxy && $(DOCKERCMD) build -t ${registry}:${tag} . && cd -
	$(DOCKERCMD) push ${registry}:${tag}
	make prod-admin-update-workspace-template tag=${tag}
	git tag ${registry}-${tag} && git push origin ${registry}-${tag}

.PHONY: diff
diff: ## git diff
	$(call print-target)
	git diff --exit-code
	RES=$$(git status --porcelain) ; if [ -n "$$RES" ]; then echo $$RES && exit 1 ; fi


unzip-brevmon:
	tar xvf ${file} brevmon