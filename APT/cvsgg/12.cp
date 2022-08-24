// 제약조건 설정
//CREATE CONSTRAINT IF NOT EXISTS ON (bus: `BusRoute`) ASSERT bus.`route_id` IS UNIQUE;

// bus_route_all.csv 로드
USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vSQ2QZ_hwv4qwSLoL_kjI6m7sSFMaEjbm-wl21IOp5eUShY7Fi4AABjk9OjZSUdFRgPzQueiZ5bmxnD/pub?gid=451189410&single=true&output=csv' AS nodeRecord

//  BusRoute 노드 생성
MERGE (n: `BusRoute` { `route_id`: nodeRecord.`route_id` })
SET n.`route_name` = nodeRecord.`route_name`
SET n.`route_type` = nodeRecord.`route_type`;

// bus_route_station_all.csv 로드
USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQrQ7Rqw2RNe221cH78mnEowIyVZdUkUyB07Y5RU2DKX4eczRGtk65xH1U1rn1WdkxH2kpkKjHEtrsZ/pub?gid=1609769136&single=true&output=csv' AS nodeRecord

// (:BusRoute)-[:STOP_AT]->(:BusStation) 관계 생성
MATCH (route:BusRoute {route_id: nodeRecord.route_id}), (station:BusStation {station_id: nodeRecord.station_id})
MERGE (route)-[r:STOP_AT]->(station);

// 연결되지 않은 (:BusRoute) 삭제
MATCH (n:BusRoute) WHERE NOT (n)-[]-() DELETE n;
MATCH (n:BusStation) WHERE NOT (n)-[]-() DELETE n;
