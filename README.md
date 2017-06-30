# docker-cassandra
[![](https://images.microbadger.com/badges/image/smizy/cassandra.svg)](https://microbadger.com/images/smizy/cassandra "Get your own image badge on microbadger.com") 
[![](https://images.microbadger.com/badges/version/smizy/cassandra.svg)](https://microbadger.com/images/smizy/cassandra "Get your own version badge on microbadger.com")
[![CircleCI](https://circleci.com/gh/smizy/docker-cassandra.svg?style=svg&circle-token=524cf9de6cdd8e1d44f2fbd1875d2138f223185a)](https://circleci.com/gh/smizy/docker-cassandra)

Apache Cassandra docker image based on alpine

Note that this image is unstable and under development.

## Small setup

```
# network 
docker network create vnet

# startup cassandra
docker run --net vnet --name cassandra -d smizy/cassandra:3.11-alpine 

# tail logs
docker logs -f cassandra

# cqlsh access
docker run -it --rm --net vnet smizy/cassandra:3.11-alpine cqlsh cassandra.vnet

Connected to Test Cluster at cassandra.vnet:9042.
[cqlsh 5.0.1 | Cassandra 3.11 | CQL spec 3.4.4 | Native protocol v4]
Use HELP for help.
cqlsh> 
cqlsh> SELECT release_version, cluster_name FROM system.local;

 release_version | cluster_name
-----------------+--------------
            3.11 | Test Cluster

(1 rows)
cqlsh> exit
```

## Cluster setup on single host

```
# startup cassandra
docker-compose up -d 

# tail logs for a while
docker-compose logs -f 

# check ps
docker-compose ps

   Name                Command             State                        Ports                       
---------------------------------------------------------------------------------------------------
cassandra-1   entrypoint.sh cassandra -f   Up      7000/tcp, 7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp 
cassandra-2   entrypoint.sh cassandra -f   Up      7000/tcp, 7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp 
cassandra-3   entrypoint.sh cassandra -f   Up      7000/tcp, 7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp

# check node status
docker-compose exec cassandra-1 nodetool status

Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address     Load       Tokens    Owns (effective)  Host ID                               Rack
UN  172.18.0.2  103.66 KiB  256      66.3%             30e50198-03ef-46dc-a521-9b77c11b185b  rack1
UN  172.18.0.3  100.4 KiB   256      62.5%             aa610862-ac91-4be7-9495-de54773752b3  rack1
UN  172.18.0.4  80.23 KiB   256      71.2%             d624fec9-1a5d-48ce-a229-20ad5a691757  rack1

# stop cassandra  
docker-compose stop

# cleanup container 
docker-compose rm -v

```

