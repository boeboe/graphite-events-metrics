IMAGE = boeboe/graphite-events-metrics
TAG = 1.0.0


default: build push

build:
	docker build --pull -t ${IMAGE}:${TAG} --build-arg VERSION=${TAG} .
	docker tag ${IMAGE}:${TAG} ${IMAGE}:${TAG}
	docker tag ${IMAGE}:${TAG} ${IMAGE}:latest

build-clean:
	docker build --pull --no-cache -t ${IMAGE}:${TAG} --build-arg VERSION=${TAG} .
	docker tag ${IMAGE}:${TAG} ${IMAGE}:${TAG}
	docker tag ${IMAGE}:${TAG} ${IMAGE}:latest

push:
	docker push ${IMAGE}:${TAG}
	docker push ${IMAGE}:latest

remove:
	docker rm jsontopickle

kill:
	docker kill jsontopickle

run_local: remove
	docker run --name jsontopickle  -p 8008:8000 \
		-e GRAPHITE_ADDRESS='change' -e GRAPHITE_PICKLE_PORT='2004' \
		jsontopickle

run_remote: remove
	docker run --name jsontopickle  -p 8008:8000 \
		-e GRAPHITE_ADDRESS='change' -e GRAPHITE_PICKLE_PORT='2004' \
		${IMAGE}:${TAG}
