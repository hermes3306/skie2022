cypher-shell -u neo4j -p re91na00 "match(n) detach delete n;"
echo deleted all nodes

cat all.cql | cypher-shell -u neo4j -p re91na00
