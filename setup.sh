#!/bin/bash
docker pull quay.io/jetstack/cert-manager-cainjector:v0.8.1
docker pull quay.io/jetstack/cert-manager-webhook:v0.8.1
docker pull quay.io/jetstack/cert-manager-controller:v0.8.1
make docker-build IMG=docker.io/ladrift/kubebuilder-tutorial-cronjob-controller:v1.0.0
