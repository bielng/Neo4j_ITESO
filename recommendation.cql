MATCH (p:Product)<-[r:ORDER]-(o:Order)-[r2:ORDERS]->(op:Product)
WHERE p.productName = "Chai"
RETURN p.productName, op.productName, COUNT(o.orderID)
ORDER BY COUNT(o.orderID) DESC
LIMIT 10;