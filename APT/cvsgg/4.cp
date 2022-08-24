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
