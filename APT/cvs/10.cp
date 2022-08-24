// 제약조건 설정
//CREATE CONSTRAINT IF NOT EXISTS ON (school: `School`) ASSERT school.`name` IS UNIQUE;

// apt_school.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTt4sC-LTIibLdbxJwKmKCxDtzgMLRFXtC5ns7GdXjhGJvlBFFQKFUba58WoLdBOWJw37ce1FUs8SDk/pub?gid=676751154&single=true&output=csv' AS nodeRecord

// School 노드 생성
MERGE (n: `School` { `name`: nodeRecord.`school_name` })
SET n.`hakgun` = nodeRecord.`hakgudo_name`
SET n.`gubun` = nodeRecord.`school_gubun`
SET n.`establishment` = nodeRecord.`establishment`
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)})
SET n.`homepage` = nodeRecord.`homepage`

// (:Apartment)-[:NEAR]->(:School) 관계 생성
WITH nodeRecord, n
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
MERGE (apt)-[r:NEAR]->(n)
SET r.distance = toFloat(nodeRecord.dist);
