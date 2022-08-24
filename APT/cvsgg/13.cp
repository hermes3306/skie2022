// 제약조건 설정
//CREATE CONSTRAINT IF NOT EXISTS ON (goodwaytowalk: `GoodWayToWalk`) ASSERT goodwaytowalk.`no` IS UNIQUE;

// good_way_to_walk.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vSsLsmfuJ7djuTrcHLDLqz1Q55DKIDEFSCprHmEiTCD7AzurPdTI1IJeB-sAqonfHbijGaI8QbenzTB/pub?gid=732701406&single=true&output=csv' AS nodeRecord

// GoodWayToWalk 노드 생성
MERGE (n: `GoodWayToWalk` { `no`: toInteger(nodeRecord.`no`) })
SET n.`way_type` = nodeRecord.`way_type`
SET n.`way_name` = nodeRecord.`way_name`;

// good_way_to_walk_apt.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRdXJ_r2BMNjldaIKnRGcNhb20UmVtdZFouptHaMNFz6LN09Hm4qRQAyu1AHC0LDcURz_yhHR3aghTv/pub?gid=139240899&single=true&output=csv' AS nodeRecord

// (:Apartment)-[:NEAR]->(:GoodWayToWalk) 관계 생성
MATCH (apt:Apartment {apt_id: toInteger(nodeRecord.apt_id)}), (way:GoodWayToWalk {no: toInteger(nodeRecord.way_no)})
MERGE (apt)-[r:NEAR]->(way)
SET r.distance = toFloat(nodeRecord.dist)
SET r.`coord` = point({latitude: toFloat(nodeRecord.`y`), longitude: toFloat(nodeRecord.`x`)});
