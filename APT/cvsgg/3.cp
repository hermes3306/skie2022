// 타입 정보는 UNIQUE 제약을 걸 수 없으므로 매번 CREATE 로 생성한다. 따라서 아래 Import 절차 진행 전에 이 전의 ApartmentType 노드를 모두 삭제해야 한다.
MATCH (n:ApartmentType) DETACH DELETE n;

// apt_type.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vSsfL8NIMnn2fmHhvGRSM8qKs5dVbXLLvjhWHupALjNcJOrVMstvEXW7bSE7PlUBFIE1_WlNQ-QV_bQ/pub?gid=1393455740&single=true&output=csv' AS nodeRecord

// ApartmentType 노드 생성
CREATE (n: `ApartmentType`)
SET n.`space` = nodeRecord.`space`
SET n.`area_group` = toInteger(nodeRecord.`area_group`)
SET n.`area_use` = toFloat(nodeRecord.`area_use`)
SET n.`area_supply` = toFloat(nodeRecord.`area_supply`)
SET n.`rooms` = toInteger(nodeRecord.`rooms`)
SET n.`restrooms` = toInteger(nodeRecord.`restrooms`)
SET n.`entrance` = nodeRecord.`entrance`
SET n.`deposit_avg` = toInteger(nodeRecord.`deposit_avg`)
SET n.`deposit_summer` = toInteger(nodeRecord.`deposit_summer`)
SET n.`deposit_winter` = toInteger(nodeRecord.`deposit_winter`)
SET n.`floor_plan_url` = nodeRecord.`floor_plan_url`
SET n.`households` = toInteger(nodeRecord.`households`)
SET n.`area_supply_pyeong` = toInteger(nodeRecord.`area_supply_pyeong`)
SET n.`households_n` = toInteger(nodeRecord.`households_n`)
SET n.`households_s` = toInteger(nodeRecord.`households_s`)
SET n.`price` = nodeRecord.`price`

// (:Apartment)-[:HAVE]->(:ApartmentType) 관계 생성
WITH nodeRecord, n
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
MERGE (apt)-[r:HAVE]->(n);
