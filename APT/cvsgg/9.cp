// 제약조건 설정
//CREATE CONSTRAINT IF NOT EXISTS ON (park: `Park`) ASSERT park.`name` IS UNIQUE;

// apt_park.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQQaLtfE7-Z8JPyjJDtuqKbFPoNwipC7Mbsk0YNWKFS1xDDxg71xTN9fxCq2V4TSRnn9oq6Xm1iX-cC/pub?gid=171692443&single=true&output=csv' AS nodeRecord

// Park 노드 생성
MERGE (n: `Park` { `name`: nodeRecord.`name` })
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)})

// (:Apartment)-[:NEAR]->(:Park) 관계 생성
WITH nodeRecord, n
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
MERGE (apt)-[r:NEAR]->(n)
SET r.distance = toFloat(nodeRecord.dist);
