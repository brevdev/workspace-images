Images to be used for brev workspaces


# Devolopment

## useful commands

```
$ make dev-push-ubuntu-proxy tag=$(git rev-parse --short=6 HEAD)
```

```
$ make dev-run-ubuntu-proxy tag=$(git rev-parse --short=6 HEAD)
```

```
$ make dev-shell-ubuntu-proxy
```

## release commands
```
$ make prod-push-ubuntu-proxy tag=0.1.16
$ aws dynamodb update-item --table-name brev-deploy-prod  --key '{"pk": {"S": "workspace_template:4nbb4lg2s"}, "sk": {"S": "workspace_template"}}' --attribute-updates '{"image": {"Value": {"S": "brevdev/ubuntu-proxy:0.1.16"},"Action": "PUT"}}' --return-values UPDATED_NEW 
$ 
```
