# docker-cassandra
[![](https://images.microbadger.com/badges/image/smizy/cassandra.svg)](https://microbadger.com/images/smizy/cassandra "Get your own image badge on microbadger.com") 
[![](https://images.microbadger.com/badges/version/smizy/cassandra.svg)](https://microbadger.com/images/smizy/cassandra "Get your own version badge on microbadger.com")
[![CircleCI](https://circleci.com/gh/smizy/docker-cassandra.svg?style=svg&circle-token=524cf9de6cdd8e1d44f2fbd1875d2138f223185a)](https://circleci.com/gh/smizy/docker-cassandra)

Apache Cassandra docker image based on alpine

Note that this image is unstable and under development.

```
docker run --net vnet --name cassandra -d  smizy/cassandra:3.9-alpine 
docker run --net vnet -it --rm smizy/cassandra:3.9-alpine cqlsh cassandra.vnet

Connected to Test Cluster at cassandra.vnet:9042.
[cqlsh 5.0.1 | Cassandra 3.9 | CQL spec 3.4.2 | Native protocol v4]
Use HELP for help.
cqlsh> SELECT release_version, cluster_name FROM system.local;

cluster_name | release_version
--------------+-----------------
 Test Cluster |             3.9

(1 rows)
cqlsh> exit
```