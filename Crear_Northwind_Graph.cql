//Crea la base de datos northwind
// CREATE DATABASE northwind
//Apunta a la base de datos northwind
//:use northwind
//Ejecuta, bloque por bloque, las demás instrucciones para crear los nodos, los índices y las relaciones
//Crea los nodos Product
LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/products.csv" AS row
CREATE (n:Product)
SET
  n = row,
  n.unitPrice = toFloat(row.unitPrice),
  n.unitsInStock = toInteger(row.unitsInStock),
  n.unitsOnOrder = toInteger(row.unitsOnOrder),
  n.reorderLevel = toInteger(row.reorderLevel),
  n.discontinued = (row.discontinued <> "0");

//Crea los nodos Category
LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/categories.csv" AS row
CREATE (n:Category)
SET n = row;

//Crea los nodos Supplier
LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/suppliers.csv" AS row
CREATE (n:Supplier)
SET n = row;

//Crea índices
CREATE INDEX Prodcut_productiID
FOR (p:Product)
ON (p.productID);
CREATE INDEX Category_categoryID
FOR (c:Category)
ON (c.categoryID);
CREATE INDEX Supplier_supplierID
FOR (s:Supplier)
ON (s.supplierID);

//Crea la relación PART_OF
MATCH (p:Product)
MATCH (c:Category)
WHERE p.categoryID = c.categoryID
MERGE (p)-[:PART_OF]->(c);

//Crea la relación SUPPLIES
MATCH (p:Product)
MATCH (s:Supplier)
WHERE p.supplierID = s.supplierID
MERGE (s)-[:SUPPLIES]->(p);

//Crea los nodos Customer
LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/customers.csv" AS row
CREATE (n:Customer)
SET n = row;

//Crea los nodos Order
LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/orders.csv" AS row
CREATE (n:Order)
SET n = row;

//Crea índices
CREATE INDEX Customer_customerID
FOR (c:Customer)
ON (c.customerID);
CREATE INDEX Order_orderID
FOR (o:Order)
ON (o.orderID);

//Crea la relación PURCHASED
MATCH (c:Customer)
MATCH (o:Order)
WHERE c.customerID = o.customerID
MERGE (c)-[:PURCHASED]->(o);

//Crea la relación ORDERS
LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/order-details.csv" AS row
MATCH (p:Product)
MATCH (o:Order)
WHERE p.productID = row.productID AND o.orderID = row.orderID
MERGE (o)-[details:ORDERS]->(p)
SET details = row, details.quantity = toInteger(row.quantity);

//

//Crea la relación ORDERS
/**
LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/order-details.csv" AS row
MATCH (p:Product)
MATCH (o:Order)
WHERE p.productID = o.orderID
MERGE (o)-[details:ORDERS]->(p) **/