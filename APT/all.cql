match(n) detach delete n;

// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (apt: `Apartment`) ASSERT apt.`apt_id` IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS ON (region_code: `Region`) ASSERT region_code.`region_code` IS UNIQUE;

// apt_info.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTc_mAKF78DEloooXtrpRent-OzssLxuOvzRlOaYP47Ckf7gdZleo-ovqfWM3F4AYvpxclJ11Qg_g2u/pub?gid=349222695&single=true&output=csv' AS nodeRecord

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


// apt_slope.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRT_m7Dg2yS5u-kAcv13LScQvgOOYh3pV-zw7CepWk43JQZu1ahANvEwkcSqvwZj_8LRCxvj8SWshiL/pub?gid=196962442&single=true&output=csv' AS nodeRecord

// Apartment 에 slope 속성 추가
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
SET apt.slope = toInteger(nodeRecord.badge);

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

// 실거래가 정보는 UNIQUE 제약을 걸 수 없으므로 매번 CREATE 로 생성한다. 따라서 아래 Import 절차 진행 전에 이 전의 노드를 모두 삭제해야 한다.
MATCH (n:`Contract`) DETACH DELETE n;

// apt_real_price.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTR8CN1SN2Hbp5A-x1FzfqrV2VxExTY9-EMnzDOwEtvyrY8HqV4uD5gui0YoMmkV_J3FMrwTa7luGaQ/pub?gid=2075593761&single=true&output=csv' AS nodeRecord

// Trade 노드 생성
CREATE (n: `Contract`)
SET n.`join_key` = toInteger(nodeRecord.`join_key`)
SET n.`area_use` = toFloat(nodeRecord.`area_use`)
SET n.`deal_type` = nodeRecord.`deal_type`
SET n.`contract_ym` = nodeRecord.`contract_ym`
SET n.`price` = toInteger(nodeRecord.`price`)

// (:Apartment)-[:TRADE]->(:Contract) 관계 생성
WITH nodeRecord, n
MATCH (apt:Apartment {join_key:toInteger(nodeRecord.join_key)})
MERGE (apt)-[r:`TRADE`]->(n);

// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (daycare: `Daycare`) ASSERT daycare.`name` IS UNIQUE;

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


// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (hospital: `Hospital`) ASSERT hospital.`name` IS UNIQUE;

// apt_hospital.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTNlxKXHqWXNA7TNWcn8kb2B41Mx5iWFHU7lCgbOKMs-wxs5yxMkae3JNconXoqGB3VnMpLewPOl4i1/pub?gid=806087151&single=true&output=csv' AS nodeRecord

// Hospital 노드 생성
MERGE (n: `Hospital` { `name`: nodeRecord.`name` })
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)})

// (:Apartment)-[:NEAR]->(:Hospital) 관계 생성
WITH nodeRecord, n
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
MERGE (apt)-[r:NEAR]->(n)
SET r.distance = toFloat(nodeRecord.dist);

// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (kinder: `Kinder`) ASSERT kinder.`name` IS UNIQUE;

// apt_kinder.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vS8hmuEKzOUwJQwwzSd0XlZD-DfAQ1EtQd_-c2lmAHX6IOxerWYnn0XPAp9vDSOEOifh_lGVy6gRcwz/pub?gid=540904510&single=true&output=csv' AS nodeRecord

// Kinder 노드 생성
MERGE (n: `Kinder` { `name`: nodeRecord.`name` })
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)})

// (:Apartment)-[:NEAR]->(:Kinder) 관계 생성
WITH nodeRecord, n
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
MERGE (apt)-[r:NEAR]->(n)
SET r.distance = toFloat(nodeRecord.dist);

// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (mart: `Mart`) ASSERT mart.`name` IS UNIQUE;

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

// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (park: `Park`) ASSERT park.`name` IS UNIQUE;

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


// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (school: `School`) ASSERT school.`name` IS UNIQUE;

// apt_school.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTt4sC-LTIibLdbxJwKmKCxDtzgMLRFXtC5ns7GdXjhGJvlBFFQKFUba58WoLdBOWJw37ce1FUs8SDk/pub?gid=676751154&single=true&output=csv' AS nodeRecord

// School 노드 생성
MERGE (n: `School` { `name`: nodeRecord.`school_name` })
SET n.`hakgun` = nodeRecord.`hakgudo_name`
SET n.`gubun` = nodeRecord.`school_gubun`
SET n.`establishment` = nodeRecord.`establishment`
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)})
SET n.`homepage` = nodeRecord.`homepage`

// (:Apartment)-[:NEAR]->(:School) 관계 생성
WITH nodeRecord, n
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
MERGE (apt)-[r:NEAR]->(n)
SET r.distance = toFloat(nodeRecord.dist);

// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (bus: `BusStation`) ASSERT bus.`station_id` IS UNIQUE;

// bus_station_all.csv 로드
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


// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (bus: `BusRoute`) ASSERT bus.`route_id` IS UNIQUE;

// bus_route_all.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vSQ2QZ_hwv4qwSLoL_kjI6m7sSFMaEjbm-wl21IOp5eUShY7Fi4AABjk9OjZSUdFRgPzQueiZ5bmxnD/pub?gid=451189410&single=true&output=csv' AS nodeRecord

//  BusRoute 노드 생성
MERGE (n: `BusRoute` { `route_id`: nodeRecord.`route_id` })
SET n.`route_name` = nodeRecord.`route_name`
SET n.`route_type` = nodeRecord.`route_type`;

// bus_route_station_all.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQrQ7Rqw2RNe221cH78mnEowIyVZdUkUyB07Y5RU2DKX4eczRGtk65xH1U1rn1WdkxH2kpkKjHEtrsZ/pub?gid=1609769136&single=true&output=csv' AS nodeRecord

// (:BusRoute)-[:STOP_AT]->(:BusStation) 관계 생성
MATCH (route:BusRoute {route_id: nodeRecord.route_id}), (station:BusStation {station_id: nodeRecord.station_id})
MERGE (route)-[r:STOP_AT]->(station);

// 연결되지 않은 (:BusRoute) 삭제
MATCH (n:BusRoute) WHERE NOT (n)-[]-() DELETE n;
MATCH (n:BusStation) WHERE NOT (n)-[]-() DELETE n;

// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (goodwaytowalk: `GoodWayToWalk`) ASSERT goodwaytowalk.`no` IS UNIQUE;

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

// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (highway: `Highway`) ASSERT highway.`no` IS UNIQUE;

// highway.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQEM8cJ0DOTjoPMRjUmxo1XNycdOG9b9AX0eosGsdcIJ0TNcLjxPTdtik-Y4rfipU3gTmd8toHvxsBC/pub?gid=131423954&single=true&output=csv' AS nodeRecord

// Highway 노드 생성
MERGE (n: `Highway` { `no`: toInteger(nodeRecord.`no`) })
SET n.`name` = nodeRecord.`highway_nm`
SET n.`coord` = point({latitude: toFloat(nodeRecord.`lat`), longitude: toFloat(nodeRecord.`lon`)});

// highway_apt.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRQ59j13vbwV6dHQIdrWP5rNc-K3wSEXVz55zuSsdTz_21AJJnJxh7QIqSgXid41JGDkbTW_c_F02Ac/pub?gid=686949205&single=true&output=csv' AS nodeRecord

// (:Apartment)-[:NEAR]->(:Highway) 관계 생성
MATCH (apt:Apartment {apt_id: toInteger(nodeRecord.apt_id)}), (highway:Highway {no: toInteger(nodeRecord.highway_no)})
MERGE (apt)-[r:NEAR]->(highway)
SET r.distance = toFloat(nodeRecord.dist);

// 제약조건 설정
CREATE CONSTRAINT IF NOT EXISTS ON (subway: `Subway`) ASSERT subway.`no` IS UNIQUE;

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


