// PRÁCTICA 3 - MINERÍA DE GRAFOS (GRAPH MINING)
// Graph Database: Neo4j
// Complete Cypher Script for Project Execution
// Create the Database
CREATE DATABASE LetsCook;

//  1: CLEAR DATABASE

// MATCH (n) DETACH DELETE n;

//  2: CREATE CONSTRAINTS AND INDEXES

// Create constraints for unique identifiers
CREATE CONSTRAINT client_id IF NOT EXISTS
FOR (c:Client)
REQUIRE c.id_cliente IS UNIQUE;

CREATE CONSTRAINT product_id IF NOT EXISTS
FOR (p:Product)
REQUIRE p.id_producto IS UNIQUE;

CREATE CONSTRAINT operation_id IF NOT EXISTS
FOR (o:Operation)
REQUIRE o.id_operacion IS UNIQUE;

// Create indexes for performance
CREATE INDEX product_name_idx IF NOT EXISTS
FOR (p:Product)
ON (p.Producto);

CREATE INDEX operation_date_idx IF NOT EXISTS
FOR (o:Operation)
ON (o.fecha_operacion);

//  3: LOAD DATA FROM CSV FILES

// Load Clients
LOAD CSV WITH HEADERS FROM 'file:///Clientes.csv' AS row
CREATE (c:Client {id_cliente: toInteger(row.id_cliente)});

// Load Products
LOAD CSV WITH HEADERS FROM 'file:///Productos.csv' AS row
CREATE
  (p:Product {id_producto: toInteger(row.id_producto), Producto: row.Producto});

// Load Operations
/**LOAD CSV WITH HEADERS FROM 'file:///Operaciones.csv' AS row
CREATE
  (o:Operation
    {
      id_operacion: toInteger(row.id_operacion),
      fecha_operacion: date(row.fecha_operacion),
      year: toInteger(row.year)
    });**/

LOAD CSV WITH HEADERS FROM 'file:///Operaciones.csv' AS row
CREATE
  (o:Operation
    {
      id_operacion: toInteger(row.id_operacion),
      fecha_operacion:
        date({
          day: toInteger(split(row.fecha_operacion, '/')[0]),
          month: toInteger(split(row.fecha_operacion, '/')[1]),
          year: toInteger(split(row.fecha_operacion, '/')[2])
        }),
      year: toInteger(row.year)
    });

// Load Relationships: Client -> MADE -> Operation
LOAD CSV WITH HEADERS FROM 'file:///Operaciones.csv' AS row
MATCH (c:Client {id_cliente: toInteger(row.id_cliente)})
MATCH (o:Operation {id_operacion: toInteger(row.id_operacion)})
CREATE (c)-[:MADE]->(o);

// Load Relationships: Operation -> CONTAINS -> Product (with quantity)
LOAD CSV WITH HEADERS FROM 'file:///Detalles.csv' AS row
MATCH (o:Operation {id_operacion: toInteger(row.id_operacion)})
MATCH (p:Product {id_producto: toInteger(row.id_producto)})
CREATE (o)-[:CONTAINS {cantidad: toInteger(row.cantidad_producto)}]->(p);

//  4: VERIFY DATA LOADED CORRECTLY (Basic Graph Analysis)

// 4.1 Count nodes
MATCH (n)
RETURN labels(n) AS NodeType, count(n) AS Count;

// 4.2 Count relationships
MATCH ()-[r]->()
RETURN type(r) AS RelType, count(r) AS Count;

// 4.3 Graph schema visualization
CALL db.schema.visualization();

// 4.4 Basic statistics
MATCH (c:Client)
RETURN count(c) AS TotalClients;
MATCH (p:Product)
RETURN count(p) AS TotalProducts;
MATCH (o:Operation)
RETURN count(o) AS TotalOperations;
MATCH ()-[r:CONTAINS]->()
RETURN count(r) AS TotalDetails;

// 4.5 Verify data integrity
MATCH (o:Operation)-[c:CONTAINS]->(p:Product)
RETURN
  count(DISTINCT o) AS OperationsWithProducts,
  count(DISTINCT p) AS ProductsInOperations,
  sum(c.cantidad) AS TotalQuantity;

//  5: CREATE PRODUCT-TO-PRODUCT RELATIONSHIPS FOR GRAPH ALGORITHMS

// 5.1 Create BUY_TOGETHER relationship (co-occurrence in same operation)
MATCH (p1:Product)<-[:CONTAINS]-(o:Operation)-[:CONTAINS]->(p2:Product)
WHERE p1.id_producto < p2.id_producto
WITH p1, p2, count(o) AS frequency
MERGE (p1)-[r:BUY_TOGETHER]->(p2)
SET r.frequency = frequency;

// Create reverse relationship for undirected analysis
MATCH (p1:Product)-[r:BUY_TOGETHER]->(p2:Product)
MERGE (p2)-[r2:BUY_TOGETHER]->(p1)
SET r2.frequency = r.frequency;

// 5.2 Create PURCHASED relationship (Client -> Product through operations)
MATCH (c:Client)-[:MADE]->(o:Operation)-[:CONTAINS]->(p:Product)
WITH c, p, count(o) AS purchase_count
MERGE (c)-[r:PURCHASED]->(p)
SET r.count = purchase_count;

//

CALL gds.graph.drop('productGraph', false) YIELD graphName
RETURN graphName;

CALL
  gds.graph.project(
    'productGraph',
    'Product',
    {BUY_TOGETHER: {orientation: 'UNDIRECTED', properties: 'frequency'}}
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

//  6: DASHBOARD 1 - BASIC STATISTICS

// 6.1 TOP 5 MOST PURCHASED PRODUCTS (by total quantity)
MATCH (p:Product)<-[c:CONTAINS]-(:Operation)
RETURN
  p.id_producto AS ProductID,
  p.Producto AS ProductName,
  sum(c.cantidad) AS TotalQuantity
ORDER BY TotalQuantity DESC
LIMIT 5;

// 6.2 AVERAGE PRODUCTS PURCHASED PER CLIENT
MATCH (c:Client)-[:MADE]->(o:Operation)-[con:CONTAINS]->(p:Product)
WITH c, sum(con.cantidad) AS client_total
RETURN round(avg(client_total), 2) AS AvgProductsPerClient;

// 6.3 AVERAGE PRODUCTS PURCHASED PER YEAR
MATCH (o:Operation)-[c:CONTAINS]->(:Product)
WITH o.year AS Year, sum(c.cantidad) AS YearTotal, count(o) AS NumOperations
RETURN Year, round(YearTotal * 1.0 / NumOperations, 2) AS AvgProductsPerYear
ORDER BY Year;

// 6.4 AVERAGE PRODUCTS PURCHASED PER OPERATION
MATCH (o:Operation)-[c:CONTAINS]->(:Product)
WITH o, sum(c.cantidad) AS OpTotal
RETURN round(avg(OpTotal), 2) AS AvgProductsPerOperation;

//  7: DASHBOARD 2 - PRODUCT RECOMMENDATIONS

// RECOMMENDATION BY PURCHASE HISTORY

MATCH
  (target:Product {id_producto: $product_id})<-[:CONTAINS]-
  (o:Operation)-[:CONTAINS]->
  (rec:Product)
WHERE rec.id_producto <> target.id_producto
WITH rec, count(DISTINCT o) AS timesBoughtTogether
ORDER BY timesBoughtTogether DESC
LIMIT 4
RETURN
  rec.id_producto AS ProductID,
  rec.Producto AS ProductName,
  timesBoughtTogether AS PurchaseHistoryScore;

//  RECOMMENDATION BY CENTRALITY (6.2)

// 3.1 Degree Centrality (global, diagnostic)
CALL gds.degree.stream('productGraph') YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS product, score
ORDER BY score DESC
LIMIT 4
RETURN
  product.id_producto AS ProductID,
  product.Producto AS ProductName,
  score AS DegreeScore;

// 3.2 PageRank Centrality (global, diagnostic)
CALL
  gds.pageRank.stream(
    'productGraph',
    {relationshipWeightProperty: 'frequency'}
  )
  YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS product, score
ORDER BY score DESC
LIMIT 4
RETURN
  product.id_producto AS ProductID,
  product.Producto AS ProductName,
  score AS PageRankScore;

// 3.3 Betweenness Centrality (global, diagnostic)
CALL gds.betweenness.stream('productGraph') YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS product, score
ORDER BY score DESC
LIMIT 4
RETURN
  product.id_producto AS ProductID,
  product.Producto AS ProductName,
  score AS BetweennessScore;

// 3.4 Closeness Centrality (global, diagnostic)
CALL gds.closeness.stream('productGraph') YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS product, score
ORDER BY score DESC
LIMIT 4
RETURN
  product.id_producto AS ProductID,
  product.Producto AS ProductName,
  score AS ClosenessScore;

// 3.5 Product-specific Top 4 by centrality
// Param: $product_id
MATCH
  (p:Product {id_producto: $product_id})<-[:CONTAINS]-
  (o:Operation)-[:CONTAINS]->
  (rec:Product)
WHERE p.id_producto <> rec.id_producto
WITH rec, count(o) AS cooccurrence
ORDER BY cooccurrence DESC
LIMIT 20
WITH collect(rec) AS candidates

CALL
  gds.pageRank.stream(
    'productGraph',
    {relationshipWeightProperty: 'frequency'}
  )
  YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS product, score, candidates
WHERE product IN candidates
RETURN
  product.id_producto AS ProductID,
  product.Producto AS ProductName,
  score AS CentralityScore
ORDER BY score DESC
LIMIT 4;

// RECOMMENDATION BY COMMUNITY DETECTION (6.3)

// 4.1 Louvain (global, diagnostic)
CALL
  gds.louvain.stream(
    'productGraph',
    {relationshipWeightProperty: 'frequency'}
  )
  YIELD nodeId, communityId
WITH gds.util.asNode(nodeId) AS product, communityId
WITH communityId, collect(product) AS products, count(*) AS communitySize
ORDER BY communitySize DESC
LIMIT 10
RETURN
  communityId,
  communitySize,
  [p IN products[0..5] | p.Producto] AS SampleProducts;

// 4.2 Label Propagation (global, diagnostic)
CALL
  gds.labelPropagation.stream(
    'productGraph',
    {relationshipWeightProperty: 'frequency'}
  )
  YIELD nodeId, communityId
WITH gds.util.asNode(nodeId) AS product, communityId
WITH communityId, collect(product) AS products, count(*) AS communitySize
ORDER BY communitySize DESC
LIMIT 10
RETURN
  communityId,
  communitySize,
  [p IN products[0..5] | p.Producto] AS SampleProducts;

// 4.3 Weakly Connected Components (global, diagnostic)
CALL gds.wcc.stream('productGraph') YIELD nodeId, componentId
WITH gds.util.asNode(nodeId) AS product, componentId
WITH componentId, collect(product) AS products, count(*) AS componentSize
ORDER BY componentSize DESC
LIMIT 10
RETURN
  componentId,
  componentSize,
  [p IN products[0..5] | p.Producto] AS SampleProducts;

// 4.4 Triangle Count (global, diagnostic)
CALL gds.triangleCount.stream('productGraph') YIELD nodeId, triangleCount
WITH gds.util.asNode(nodeId) AS product, triangleCount
ORDER BY triangleCount DESC
LIMIT 10
RETURN
  product.id_producto AS ProductID,
  product.Producto AS ProductName,
  triangleCount;

// 4.5 Local Clustering Coefficient (global, diagnostic)
CALL
  gds.localClusteringCoefficient.stream(
    'productGraph'
  )
  YIELD nodeId, localClusteringCoefficient
WITH gds.util.asNode(nodeId) AS product, localClusteringCoefficient
ORDER BY localClusteringCoefficient DESC
LIMIT 10
RETURN
  product.id_producto AS ProductID,
  product.Producto AS ProductName,
  localClusteringCoefficient;

// 4.6 Node Similarity / Jaccard (global, diagnostic)
CALL gds.nodeSimilarity.stream('productGraph') YIELD node1, node2, similarity
WITH gds.util.asNode(node1) AS p1, gds.util.asNode(node2) AS p2, similarity
ORDER BY similarity DESC
LIMIT 10
RETURN
  p1.id_producto AS Product1ID,
  p1.Producto AS Product1,
  p2.id_producto AS Product2ID,
  p2.Producto AS Product2,
  similarity;

// 4.7 Product-specific Top 4 by community (this feeds the dashboard)

// Param: $product_id
CALL
  gds.louvain.stream(
    'productGraph',
    {relationshipWeightProperty: 'frequency'}
  )
  YIELD nodeId, communityId
WITH gds.util.asNode(nodeId) AS product, communityId
WITH collect({product: product, communityId: communityId}) AS assignments

WITH
  assignments,
  [a IN assignments WHERE a.product.id_producto = $product_id][0].communityId AS targetCommunity
WHERE targetCommunity IS NOT NULL

UNWIND assignments AS a
WITH a.product AS rec, a.communityId AS communityId, targetCommunity
WHERE communityId = targetCommunity AND rec.id_producto <> $product_id
RETURN
  rec.id_producto AS ProductID,
  rec.Producto AS ProductName,
  communityId AS CommunityID
LIMIT 4;