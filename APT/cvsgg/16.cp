// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (subwayf: `SubwayFuture`) ASSERT subwayf.`no` IS UNIQUE;

// subway_station_future.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vSwmFErZk3REFUzbVWsS4Kvae2Fgo4DrLR6vc_j1WB8xusQQdRjtxbLfq5IAeugobRvX7aW8TkEUGkx/pub?gid=1493978514&single=true&output=csv' AS nodeRecord

// SubwayFuture 노드 생성
MERGE (n: `SubwayFuture` { `no`: toInteger(nodeRecord.`no`) })
SET n.`line_no` = toInteger(nodeRecord.`line_no`)
SET n.`line_name` = nodeRecord.`line_name`
SET n.`station_name` = nodeRecord.`station_name`
SET n.`scheduled_date` = nodeRecord.`scheduled_date`
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)})
SET n.`progress` = nodeRecord.`progress`;

// subway_station_future_apt.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQu-6m76lKgUzB4ln2yDRrTDRrrJMrPfhSimkFHHoRx7gAk9S2BhYhF69I7O-H7cUspO0LRruuI65Wb/pub?gid=838260646&single=true&output=csv' AS nodeRecord

// (:Apartment)-[:NEAR]->(:SubwayFuture) 관계 생성
MATCH (apt:Apartment {apt_id: toInteger(nodeRecord.apt_id)}), (subwayFuture:SubwayFuture {no: toInteger(nodeRecord.station_no)})
MERGE (apt)-[r:NEAR]->(subwayFuture)
SET r.distance = toFloat(nodeRecord.dist);
