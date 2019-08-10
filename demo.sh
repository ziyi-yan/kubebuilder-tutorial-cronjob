#!/bin/bash

########################
# include the magic
########################
. hack/demo-magic/demo-magic.sh

# demo-magic config
TYPE_SPEED=100

# hide the evidence
clear


# Put your stuff here
pe "kind create cluster --config hack/kind-config.yaml --image kindest/node:v1.14.3"

export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"

pe "kubectl cluster-info"

pe "kubectl create namespace cert-manager"

pe "kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true"

pe "kind load docker-image quay.io/jetstack/cert-manager-cainjector:v0.8.1"
pe "kind load docker-image quay.io/jetstack/cert-manager-webhook:v0.8.1"
pe "kind load docker-image quay.io/jetstack/cert-manager-controller:v0.8.1"
pe "kind load docker-image gcr.io/kubebuilder/kube-rbac-proxy:v0.4.0"

p "kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.8.1/cert-manager.yaml"
kubectl apply -f hack/cert-manager.yaml
pe "watch -t kubectl get pods -n cert-manager"

pe "# Install cronjob CRD"
pe "make install"

pe "kind load docker-image docker.io/ladrift/kubebuilder-tutorial-cronjob-controller:v1.0.0"

pe "# Install cronjob controller"
pe "make deploy"

pe "watch -t kubectl get pods -n kubebuilder-tutorial-cronjob-system"

pe "cat config/samples/batch_v1_cronjob.yaml"
pe "kubectl create -f config/samples/batch_v1_cronjob.yaml"

pe "kubectl get cronjob.batch.tutorial.kubebuilder.io -o yaml"

pe "watch kubectl get job"
