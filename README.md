# docker-cassandra

Apache Cassandra docker image based on alpine

Note that this image is unstable and under development.

```
docker build --build-arg "VERSION=3.9" -t local/cassandra .
docker run --net vnet --name cassandra -d  local/cassandra 
docker run --net vnet -it --rm local/cassandra cqlsh cassandra.vnet
```