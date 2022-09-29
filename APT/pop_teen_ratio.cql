match(n: `PopTeenRatio`) detach delete n;

LOAD CSV WITH HEADERS FROM 'file:///mobilephone_pop_teen_ratio.csv' AS csv

CREATE (n: `PopTeenRatio`)
SET n.`coord` 		= point({x:toInteger(csv.x_coord), y:toInteger(csv.y_coord)})
//SET n.`x_coord`		= toInteger(csv.`x_coord`)
//SET n.`y_coord`		= toInteger(csv.`y_coord`)
SET n.`total_sum` 	= toFloat(csv.`total_sum`)
SET n.`teenager_sum` 	= toFloat(csv.`teenager_sum`)
SET n.`teen_ratio` 	= toFloat(csv.`teen_ratio`)
