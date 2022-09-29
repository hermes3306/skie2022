sudo cp ./mobilephone_pop_teen_ratio.csv /var/lib/neo4j/import/
cypher-shell -u neo4j -p re91na00 "match(n:pop_teen_ratio) detach delete n;"
echo deleted pop_teen_ration nodes
cat pop_teen_ratio.cql  | cypher-shell -u neo4j -p re91na00
