// 제약조건 설정
//CREATE CONSTRAINT IF NOT EXISTS ON (highway: `Highway`) ASSERT highway.`no` IS UNIQUE;

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
