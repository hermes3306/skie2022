// 제약조건 설정
//CREATE CONSTRAINT IF NOT EXISTS ON (hospital: `Hospital`) ASSERT hospital.`name` IS UNIQUE;

// apt_hospital.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTNlxKXHqWXNA7TNWcn8kb2B41Mx5iWFHU7lCgbOKMs-wxs5yxMkae3JNconXoqGB3VnMpLewPOl4i1/pub?gid=806087151&single=true&output=csv' AS nodeRecord

// Hospital 노드 생성
MERGE (n: `Hospital` { `name`: nodeRecord.`name` })
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)})

// (:Apartment)-[:NEAR]->(:Hospital) 관계 생성
WITH nodeRecord, n
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
MERGE (apt)-[r:NEAR]->(n)
SET r.distance = toFloat(nodeRecord.dist);
