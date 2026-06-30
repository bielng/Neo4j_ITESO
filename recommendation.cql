MATCH (p:Product)<-[r:ORDER]-(o:Order)-[r2:ORDERS]->(op:Product)
WHERE p.productName = "Chai"
RETURN p.productName, op.productName, COUNT(o.orderID)
ORDER BY COUNT(o.orderID) DESC
LIMIT 10;




MATCH (p:Product)<-[r:ORDER]-(o:Order)-[r2:ORDERS]->(op:Product)
WHERE p.productName = "Mozzarella di Giovanni"
RETURN p.productName, op.productName, COUNT(o.orderID)
ORDER BY COUNT(o.orderID) DESC
LIMIT 10;


MATCH (p:Product)<-[r:ORDER]-(o:Order)-[r2:ORDERS]->(op:Product)
WHERE p.productName = "Mozzarella di Giovanni"
RETURN p.productName, op.productName, COUNT(o.orderID)
ORDER BY COUNT(o.orderID) DESC
LIMIT 10;


MATCH (cat1:Category)<-[r:PART_OF]-(p:Product)<-[r2:ORDERS]->(o:Orders)-[r3:ORDERS]->(op:Product)-[r4:PART_OF]->(cat:Category)
WHERE op<>p AND (op)-[:PART_OF]->(cat1)
RETURN cat1.categoryName, p.productName, op.productName, cat2.categoryName COUNT(o.orderID)
ORDER BY COUNT(o.orderID) DESC
LIMIT 10;


MATCH (cat1:Category)<-[:PART_OF]-(p:Product)<-[:ORDERS]-(o:Orders)-[:ORDERS]->(op:Product)-[:PART_OF]->(cat:Category)
WHERE op <> p
  AND cat = cat1
RETURN
    cat.categoryName,
    p.productName,
    op.productName,
    cat1.categoryName,
    COUNT(o.orderID) AS orderCount
ORDER BY orderCount DESC
LIMIT 10;



MATCH (cat1:Category)<-[:PART_OF]-(p:Product)<-[:ORDERS]-(o:Orders)-[:ORDERS]->(op:Product)-[:PART_OF]->(cat2:Category)
WHERE o.productName = "Chai" AND (op)-[:PART_OF]->(cat1)
  AND 
RETURN
    cat2.categoryName,
    p.productName,
    op.productName,
    cat1.categoryName,
    COUNT(o.orderID) AS orderCount
ORDER BY orderCount DESC
LIMIT 10;



MATCH (cat1:Category)<-[:PART_OF]-(p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)-[:PART_OF]->(cat2:Category)
WHERE p.productName = "Chai"
  AND op <> p
  AND cat1 = cat2
RETURN
    cat1.categoryName,
    p.productName,
    op.productName,
    cat2.categoryName,
    COUNT(o.orderID) AS orderCount
ORDER BY orderCount DESC
LIMIT 10;



