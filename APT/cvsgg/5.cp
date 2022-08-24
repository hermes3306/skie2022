// 제약조건 설정
//CREATE CONSTRAINT IF NOT EXISTS ON (daycare: `Daycare`) ASSERT daycare.`name` IS UNIQUE;

// apt_daycare.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRcmnOv8nDJfFFyer4pc3gHIJqznWoIeR8zJtzVxOclUpIRZvsgbxk0o3bBaw7WDjLO6k-FdXvKpSRJ/pub?gid=693624626&single=true&output=csv' AS nodeRecord

// Daycare 노드 생성
MERGE (n: `Daycare` { `name`: nodeRecord.`name` })
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)})
SET n.`url` = nodeRecord.`url`

// (:Apartment)-[:NEAR]->(:Daycare) 관계 생성
WITH nodeRecord, n
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
MERGE (apt)-[r:NEAR]->(n)
SET r.distance = toFloat(nodeRecord.dist);
