match(n:FloatingPopulation) detach delete n;

// apt_info.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTcEB4wJkieRZljHBnHdnqdWkrjRonPVHHukykW2WfDUuI7nNUZ7wdI25torXnhOYl1fpyN7vUXBjRj/pub?gid=0&single=true&output=csv' AS nodeRecord

// FloatingPopulation 노드 생성
CREATE (n: `FloatingPopulation`)
SET n.`apt_id`		= toInteger(nodeRecord.`apt_id`)
SET n.`ratio_10` 	= toFloat(nodeRecord.`ratio_10`)
SET n.`ratio_20` 	= toFloat(nodeRecord.`ratio_20`)
SET n.`ratio_30` 	= toFloat(nodeRecord.`ratio_30`)
SET n.`ratio_40` 	= toFloat(nodeRecord.`ratio_40`)
SET n.`ratio_50` 	= toFloat(nodeRecord.`ratio_50`)



// (:Apartment)-[:HAVE]->(:FloatingPopulation) 관계 생성 
WITH nodeRecord, n
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
MERGE (apt)-[r:HAVE]->(n)
