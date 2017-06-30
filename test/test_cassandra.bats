@test "cassandra is the correct version" {
  run docker run --net vnet smizy/cassandra:${TAG} cqlsh -e 'SELECT release_version FROM system.local' cassandra.vnet
  [ $status -eq 0 ]

  echo ">>>${lines[1]}<<<"

  [ "${lines[0]}" = " release_version" ]
  [ "${lines[1]}" = "-----------------" ]
  [ "${lines[2]}" = "          3.11.0" ]
}