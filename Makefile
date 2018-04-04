CHART_REPO := http://jenkins-x-chartmuseum:8080
NAME := metrics
OS := $(shell uname)
RELEASE_VERSION := $(shell jx-release-version)

setup:
	helm repo add chartmuseum http://chartmuseum.build.cd.jenkins-x.io
	helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com
	helm repo add stable https://kubernetes-charts.storage.googleapis.com
	helm repo add monocular https://kubernetes-helm.github.io/monocular

build: setup clean
	helm dependency build
	helm lint

install: clean setup build
	helm install . --name $(NAME)

upgrade: clean setup build
	helm upgrade $(NAME) .

delete:
	helm delete --purge $(NAME)

clean: 
	rm -rf charts
	rm -rf ${NAME}*.tgz
	rm -rf requirements.lock

release: setup clean build

ifeq ($(OS),Darwin)
	sed -i "" -e "s/version:.*/version: $(RELEASE_VERSION)/" Chart.yaml
else ifeq ($(OS),Linux)
	sed -i -e "s/version:.*/version: $(RELEASE_VERSION)/" Chart.yaml
else
	exit -1
endif
	git add Chart.yaml
	git commit -a -m "release $(RELEASE_VERSION)" --allow-empty
	git tag -fa v$(RELEASE_VERSION) -m "Release version $(RELEASE_VERSION)"
	git push origin v$(RELEASE_VERSION)
	helm package .
	curl --fail -u $(CHARTMUSEUM_CREDS_USR):$(CHARTMUSEUM_CREDS_PSW) --data-binary "@$(NAME)-platform-$(RELEASE_VERSION).tgz" $(CHART_REPO)/api/charts

