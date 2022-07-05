Images to be used for brev workspaces


# Development

## Useful commands

```
$ make dev-push-ubuntu-proxy tag=$(git rev-parse --short=6 HEAD)
```

```
$ make dev-run-ubuntu-proxy tag=$(git rev-parse --short=6 HEAD)
```

```
$ make dev-shell-ubuntu-proxy
```

## Release commands

To release, we create a new tag. When we rebuild the image, we download the latest version of the CLI.

### 1) Get the current release version for `ubuntu-proxy`

This tell us which tag to use. Just bump the version up -- so here it would be `0.1.17` for the next version.

```
$ make prod-get-ubuntu-proxy

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

### 2) Create new release

Use the lastest tag. Here it would be `0.1.17`.

```
$ git tag 0.1.17
$ git push origin 0.1.17
```

### Releasing to Admins Only

Right now we auto update admin template when we release to prod. When making a custom admin release ensure you disable this behavior. Search for `admin -- auto deploys` in readme then comment out to remove.

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
            "S": "brevdev/ubuntu-proxy:0.3.12-beta-setup"
        }
    }
}
```

Create new release

```
$ make prod-admin-push-ubuntu-proxy tag=0.3.14-beta-setup
```
