#sudo cp ./float_pop.csv /var/lib/neo4j/import/
cypher-shell -u neo4j -p re91na00 "match(n:FloatingPopulation) detach delete n;"
echo deleted FloatingPopulation 
cat float_pop.cql  | cypher-shell -u neo4j -p re91na00
