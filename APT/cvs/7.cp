// 제약조건 설정
//CREATE CONSTRAINT IF NOT EXISTS ON (kinder: `Kinder`) ASSERT kinder.`name` IS UNIQUE;

// apt_kinder.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vS8hmuEKzOUwJQwwzSd0XlZD-DfAQ1EtQd_-c2lmAHX6IOxerWYnn0XPAp9vDSOEOifh_lGVy6gRcwz/pub?gid=540904510&single=true&output=csv' AS nodeRecord

// Kinder 노드 생성
MERGE (n: `Kinder` { `name`: nodeRecord.`name` })
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)})

// (:Apartment)-[:NEAR]->(:Kinder) 관계 생성
WITH nodeRecord, n
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
MERGE (apt)-[r:NEAR]->(n)
SET r.distance = toFloat(nodeRecord.dist);
