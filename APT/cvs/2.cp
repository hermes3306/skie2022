// apt_slope.csv 로드
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRT_m7Dg2yS5u-kAcv13LScQvgOOYh3pV-zw7CepWk43JQZu1ahANvEwkcSqvwZj_8LRCxvj8SWshiL/pub?gid=196962442&single=true&output=csv' AS nodeRecord

// Apartment 에 slope 속성 추가
MATCH (apt:Apartment {apt_id:toInteger(nodeRecord.apt_id)})
SET apt.slope = toInteger(nodeRecord.badge);
