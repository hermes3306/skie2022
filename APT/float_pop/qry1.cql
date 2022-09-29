MATCH (a:Apartment)-[r:HAVE]-(f:FloatingPopulation)
RETURN a.apt_title,f.ratio_10, f.ratio_20, f.ratio_50
ORDER BY f.ratio_10 DESC 
limit 10
