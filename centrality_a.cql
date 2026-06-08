CREATE DATABASE shv

:use shv

// see the APOC version

RETURN apoc.version()

// see the GDS version

CALL gds.version()


OPTIONAL MATCH (z:Villian)
MATCH (m:Villian)-[r]-(n:Villian)
RETURN m, r, n, z;


// PageRank

// 1) Crear un subgrafo

CALL gds.graph.project(
    'MyGraph',
    'Villian',
    'COMPANION' {relationshipProperties: 'Weight'}
);

// cal la merio

// algo

CALL gds.pageRank.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name AS Name, score
ORDER BY score DESC, Name ASC;