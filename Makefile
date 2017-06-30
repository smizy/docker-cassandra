.PHONY: all
all: runtime

.PHONY: clean
clean:
	docker rmi -f smizy/cassandra:${TAG} || :

.PHONY: runtime
runtime:
	docker build \
		--build-arg BUILD_DATE=${BUILD_DATE} \
		--build-arg VCS_REF=${VCS_REF} \
		--build-arg VERSION=${VERSION} \
		--no-cache -t smizy/cassandra:${TAG} . 
	docker images | grep cassandra

.PHONY: test
test:
	(docker network ls | grep vnet ) || docker network create vnet
	docker run --net vnet --name cassandra --hostname cassandra.vnet -e MAX_HEAP_SIZE=2048M -e HEAP_NEWSIZE=800M -d  smizy/cassandra:${TAG}
	docker run --net vnet smizy/cassandra:${TAG}  bash -c 'for i in $$(seq 200); do nc -z cassandra.vnet 9042 && echo "test starting" && break; echo -n .; sleep 1; [ $$i -ge 300 ] && echo timeout && exit 124; done'  
	
	bats test/test_*.bats