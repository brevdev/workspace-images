Images to be used for brev workspaces


# Development

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

### prod

get the current release version for `ubuntu-proxy`

```
$ aws dynamodb get-item --table-name brev-deploy-prod  \
                        --key '{"pk": {"S": "workspace_template:4nbb4lg2s"}, "sk": {"S": "workspace_template"}}' \
                        --region us-east-1 \
                        --projection-expression "#I" \
                        --expression-attribute-names '{ "#I": "image"}'

```

Output:

```
{
    "Item": {
        "image": {
            "S": "brevdev/ubuntu-proxy:0.1.16"
        }
    }
}

```

Create new release

```
$ make prod-push-ubuntu-proxy tag=0.1.17
```

### admins only

get the current release version for `ubuntu-proxy`

```
$ aws dynamodb get-item --table-name brev-deploy-prod  \
                        --key '{"pk": {"S": "workspace_template:v7nd45zsc"}, "sk": {"S": "workspace_template"}}' \
                        --region us-east-1 \
                        --projection-expression "#I" \
                        --expression-attribute-names '{ "#I": "image"}'

```

Output:

```
{
    "Item": {
        "image": {
            "S": "brevdev/ubuntu-proxy:0.1.16"
        }
    }
}

```

Create new release

```
$ make prod-admin-push-ubuntu-proxy tag=0.1.17
```
