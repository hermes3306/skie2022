// 제약조건 설정
//CREATE CONSTRAINT IF NOT EXISTS ON (subway: `Subway`) ASSERT subway.`no` IS UNIQUE;

// subway_station_api.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTOAIbcJC8aEnoG6nfiPKBtlSpcH_GyT1QS3hQKAG7HT-NARK6XdjHSMu0P3BY-NJWT27wz4_Kss7RV/pub?gid=1641438675&single=true&output=csv' AS nodeRecord

// Subway 노드 생성
MERGE (n: `Subway` { `no`: toInteger(nodeRecord.`no`) })
SET n.`station_cd` = toInteger(nodeRecord.`station_cd`)
SET n.`station_nm` = nodeRecord.`station_nm`
SET n.`line_num` = nodeRecord.`line_num`
SET n.`line_name` = nodeRecord.`line_name`
SET n.`fr_code` = nodeRecord.`fr_code`
SET n.`coord` = point({latitude: toFloat(nodeRecord.`ypoint_wgs`), longitude: toFloat(nodeRecord.`xpoint_wgs`)});

// subway_station_apt.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTk-JlJWT3f4y42NMpo1yq6JmSWiZOwCaQGECQnkCiBgoOfKT29J7-rE9V7g9gEKGALvesGro9qlRii/pub?gid=1835856580&single=true&output=csv' AS nodeRecord

// (:Apartment)-[:NEAR]->(:Subway) 관계 생성
MATCH (apt:Apartment {apt_id: toInteger(nodeRecord.apt_id)}), (subway:Subway {no: toInteger(nodeRecord.subway_station_no)})
MERGE (apt)-[r:NEAR]->(subway)
SET r.distance = toFloat(nodeRecord.dist);
