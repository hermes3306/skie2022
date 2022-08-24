// 제약조건 설정
//CREATE CONSTRAINT IF NOT EXISTS ON (bus: `BusStation`) ASSERT bus.`station_id` IS UNIQUE;

// bus_station_all.csv 로드
//:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTIklzvtThBMu876zP-d1oxMFl1h5Na5KJd7LnzWpXvIzgYFKxq8gaeub77dwnB8t5fVHzF3cHtv5Ir/pub?gid=1981090009&single=true&output=csv' AS nodeRecord

//  BusStation 노드 생성
MERGE (n: `BusStation` { `station_id`: nodeRecord.`station_id` })
SET n.`station_name` = nodeRecord.`station_name`
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)});

// bus_station_apt.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQK8j8yiohftDUlFWkmr09ZB3WToM0pkwJebY_uCFNRz9TEpqtMxYAjsqtebyNTfEIQ0CSvwOB5_7Lb/pub?gid=700110950&single=true&output=csv' AS nodeRecord

// (:Apartment)-[:NEAR]->(:BusStation) 관계 생성
MATCH (apt:Apartment {apt_id: toInteger(nodeRecord.apt_id)}), (bs:BusStation {station_id: nodeRecord.station_id})
MERGE (apt)-[r:NEAR]->(bs)
SET r.distance = toFloat(nodeRecord.dist);
