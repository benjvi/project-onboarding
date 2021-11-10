#!/bin/bash
set -euo pipefail

readonly cluster="$1"

# improvement: the list of namespaces might be better accessed as a "terraform output", not directly from the tfstate file
cat deployed-projects/*/terraform.tfstate | jq -s '.[] | .resources[] | select(.type == "kubernetes_namespace") | [{ cluster: ( .provider |  split(".")[-1] ), namespace: ( .instances[].attributes.metadata[0].name ) }]' | jq -r ".[] | select(.cluster == \"$cluster\") | .namespace"
