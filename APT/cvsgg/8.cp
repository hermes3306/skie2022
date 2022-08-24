// 제약조건 설정
//CREATE CONSTRAINT IF NOT EXISTS ON (mart: `Mart`) ASSERT mart.`name` IS UNIQUE;

// apt_mart.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQsynS5Ocn7DpDy50MyJCN6dOTf3vk4lfeM1oboPugKZAd_s_M_V7O9SksIu8LnT2l2T2Q34LTuAert/pub?gid=507843600&single=true&output=csv' AS nodeRecord

// Mart 노드 생성
MERGE (n: `Mart` { `name`: nodeRecord.`name` })
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)})

// (:Apartment)-[:NEAR]->(:Mart) 관계 생성
WITH nodeRecord, n
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
MERGE (apt)-[r:NEAR]->(n)
SET r.distance = toFloat(nodeRecord.dist);
