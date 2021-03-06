#!/usr/bin/env bash

# ensure we're not on a detached head
git checkout master

# until we switch to the new kubernetes / jenkins credential implementation use git credentials store
git config credential.helper store

helm init --client-only
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo add chartmuseum http://chartmuseum.build.cd.jenkins-x.io
make release
