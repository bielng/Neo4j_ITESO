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


MATCH (cat1:Category)<-[:PART_OF]-(p:Product {productName: "Chai"})<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)-[:PART_OF]->(cat2:Category)
WHERE  op <> p AND cat1 = cat2
RETURN
    cat1.categoryName,
    p.productName,
    op.productName,
    cat2.categoryName,
    COUNT(o.orderID) AS orderCount
ORDER BY orderCount DESC
LIMIT 6;



/** MATCH (prov1:Supplier)<-[]-(p:Product)<-[r:ORDERS]-(o:Order)-[r2:ORDERS]->(op:Product)-[]->(prov2:Supplier)
WHERE  p.productName = "Chai" AND prov1 = prov2
RETURN
    prov1.companyName,
    p.productName,
    op.productName,
    prov2.companyName,
    COUNT(o.orderID) AS orderCount
ORDER BY orderCount DESC
LIMIT 6; **/



MATCH (prov1:Supplier)-[]->(p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)<-[]-(prov2:Supplier)
WHERE p.productName = "Chai"
  AND prov1 = prov2
  AND p <> op
RETURN
    prov1.companyName,
    p.productName,
    op.productName,
    prov2.companyName,
    COUNT(o.orderID) AS orderCount
ORDER BY orderCount DESC
LIMIT 6;




// MATCH (p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)-[:ORDER]->(o:Order)<-[:PURCHASED]-(c:Customer)
MATCH (p:Product)<--(o:Order)-->(op:Product), (o)<--(c:Customer)
WHERE p.productName = "Chang" AND c.companyName =  "Save-a-lot Market"
RETURN p.productName,c.companyName,op.productName, COUNT(o.orderID) AS CuentaOrdenes
ORDER BY CuentaOrdenes DESC 
LIMIT 5;


MATCH (p:Product)<--(o:Order)-->(op:Product)
MATCH (o)<--(c:Customer)
WHERE p.productName = "Chai"
  AND c.companyName = "North/South"
RETURN p.productName,
       c.companyName,
       op.productName,
       COUNT(o.orderID)
ORDER BY COUNT(o.orderID) DESC
LIMIT 5;




MATCH (c:Customer)-->(o:Order)-->(p:Product)<--(o2:Order)-->(op:Product) 
MATCH (o2:Order)<--(c2:Customer)
WHERE c.postalCode = '1010' AND p.productName = "Sir Rodney's Scones" AND c.postalCode = c2.postalCode AND c.companyName > c2.companyName
RETURN c.postalCode, o.orderID, p.productName, o2.orderID, op.productName, c2.postalCode, c.companyName, c2.companyName
ORDER BY o.orderID, p.productName, o2.orderID, op.productName;

MATCH (c:Customer)-[:PURCHASED]->(o:Order)-[:ORDERS]->(p:Product)<-[:ORDERS]-(o2:Order)-[:ORDERS]->(op:Product) 
MATCH (o2:Order)<-[:PURCHASED]-(c2:Customer)
WHERE c.postalCode = "1010" AND p.productName = "Sir Rodney's Scones" AND c.postalCode = c2.postalCode AND c.companyName > c2.companyName
RETURN c.postalCode, o.orderID, p.productName, o2.orderID, op.productName, c2.postalCode, c.companyName, c2.companyName
ORDER BY o.orderID, p.productName, o2.orderID, op.productName; 



MATCH (c:Customer)-[:PURCHASED]->(o:Order)-[:ORDERS]->(p:Product)<-[:ORDERS]-(o2:Order)-[:ORDERS]->(op:Product) 
MATCH (o2:Order)<-[:PURCHASED]-(c2:Customer)
WHERE c.postalCode = "5033" AND p.productName = "Queso Cabrales" AND c.postalCode = c2.postalCode AND c.companyName > c2.companyName
RETURN c.postalCode, o.orderID, p.productName, o2.orderID, op.productName, c2.postalCode, c.companyName, c2.companyName
ORDER BY o.orderID, p.productName, o2.orderID, op.productName





////

// construir la relation de producto con producto
MATCH (p:Product)<--(o:Order)-->(op:Product)
WITH p, op , COUNT(o.orderID) as qty
MERGE (p)-[:BUY_TOGETHER{quantity:qty}]->(op)











