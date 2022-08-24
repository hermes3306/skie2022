
// 제약조건 설정
//CREATE CONSTRAINT IF NOT EXISTS ON (apt: `Apartment`) ASSERT apt.`apt_id` IS UNIQUE;
//CREATE CONSTRAINT IF NOT EXISTS ON (region_code: `Region`) ASSERT region_code.`region_code` IS UNIQUE;

// apt_info.csv 로드
LOAD CSV WITH HEADERS FROM 'file:///apt_school.csv' AS nodeRecord

// Apartment 노드 생성
MERGE (n: `Apartment` { `apt_id`: toInteger(nodeRecord.`apt_id`) })
SET n.`addr` = nodeRecord.`addr`
SET n.`primary_no` = toInteger(nodeRecord.`primary_no`)
SET n.`sub_no` = toInteger(nodeRecord.`sub_no`)
SET n.`dong_name` = nodeRecord.`apt_title` // apt_title 은 잘못 들어간 컬럼. 동이름임
SET n.`apt_title` = nodeRecord.`n_apt_title` // n_apt_title 이 진짜 아파트 이름
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)})
SET n.`sectors` = nodeRecord.`sectors`
SET n.`construction` = nodeRecord.`construction`
SET n.`completion` = toInteger(nodeRecord.`completion`)
SET n.`households` = toInteger(nodeRecord.`households`)
SET n.`heating_system` = nodeRecord.`heating_system`
SET n.`heating_resource` = nodeRecord.`heating_resource`
SET n.`max_floor` = nodeRecord.`max_floor`
SET n.`min_floor` = nodeRecord.`min_floor`
SET n.`parking_capacity` = toFloat(nodeRecord.`parking_capacity`)
SET n.`parking_lot` = toInteger(nodeRecord.`parking_lot`) // '-' 은 null 로 들어감
SET n.`community` = toInteger(nodeRecord.`community`) // '-' 은 null 로 들어감
SET n.`min_area_supply` = toFloat(nodeRecord.`min_area_supply`)
SET n.`max_area_supply` = toFloat(nodeRecord.`max_area_supply`)
SET n.`min_area_use` = toFloat(nodeRecord.`min_area_use`)
SET n.`max_area_use` = toFloat(nodeRecord.`max_area_use`)
SET n.`addr_street` = nodeRecord.`addr_street`
SET n.`addr_short` = nodeRecord.`addr_short`
SET n.`executor` = nodeRecord.`executor`
SET n.`homepage` = nodeRecord.`homepage`
SET n.`telno` = nodeRecord.`telno`
SET n.`category1` = nodeRecord.`category1`
SET n.`category2` = nodeRecord.`category2`
SET n.`available_date` = nodeRecord.`available_date`
SET n.`ncode` = toInteger(nodeRecord.`ncode`)
SET n.`in_use` = toInteger(nodeRecord.`in_use`)
SET n.`deal_cnt` = toInteger(nodeRecord.`deal_cnt`)
SET n.`lease_cnt` = toInteger(nodeRecord.`lease_cnt`)
SET n.`rent_cnt` = toInteger(nodeRecord.`rent_cnt`)
SET n.`sido_code` = toInteger(nodeRecord.`sido_code`)
SET n.`dong_code` = toInteger(nodeRecord.`dong_code`)
SET n.`gubun` = nodeRecord.`gubun`
SET n.`join_key` = toInteger(nodeRecord.`join_key`)
SET n.`area_supply_pyeong` = toInteger(nodeRecord.`area_supply_pyeong`)

// Region 노드 생성
MERGE (m:Region {region_code: toInteger(nodeRecord.region_code)})

// (:Apartment)-[:IN]->(:Region) 관계 생성
MERGE (n)-[:IN]->(m);
