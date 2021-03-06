---
title: Config Reference
---

Name | Description | Default
---|---|---
auto_prune | Prune and delete old hashed resources like Secret and ConfigMap. | true
builder | What docker build command to use. Can use `docker` or `gcloud` to build the Docker image. | docker
kubectl.context | What kubectl context to auto-switch to. | nil
kubectl.context_keep | Whether or not to keep the context switched | true
kubectl.exit_on_fail.apply  | Whether or not continue if the `kubectl apply` fails. Note, can use `KUBES_EXIT_ON_FAIL=0` env var to set to false. | true
kubectl.exit_on_fail.delete | Whether or not continue if the `kubectl delete` fails. | false
kubectl.order.kinds | Change ordering for Kubernetes Kinds. | See [source code](https://github.com/boltops-tools/kubes/blob/master/lib/kubes/config.rb#L52)
kubectl.order.roles | Change ordering for Kubes Roles. | See [source code](https://github.com/boltops-tools/kubes/blob/master/lib/kubes/config.rb#L44)
logger | Logger object | Logger.new($stdout)
logger.level | Logger level. Can also be set with `KUBES_LOG_LEVEL` env var | info
repo | The Docker repo to use. Required to be set. | nil
skip | List of resources to skip. Can also be set with the `KUBES_SKIP` env var. `KUBES_SKIP` should be a list of strings separated by spaces. It adds onto the `config.skip` option. | []
state.docker_image_path | Where to store the state file with the last build Docker image. | .kubes/state/docker_image.txt
suffix_hash | Whether or not to append suffix hash to ConfigMap and Secret | true
