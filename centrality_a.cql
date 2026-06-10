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
    'myGraph',
    'Villian',
    'COMPANION' {relationshipProperties: 'Weight'}
);

// cal la merio

// algo

CALL gds.pageRank.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name AS Name, score
ORDER BY score DESC, Name ASC;



// Add the attribute centrality of nodes

CALL gds.pageRank.write(
    'myGraph',
    {
        maxIterations: 20,
        dampingFactor: 0.85,
        writeProperty: 'pageRank'
    }
)

YIELD nodePropertiesWritten, ranIterations;



MATCH (v:Villian)
RETURN v.Name, v.pageRank
ORDER BY v.pagerank DESC
LIMIT 5;




// memory needed

CALL gds.pageRank.write.estimate(
    'myGraph',
    {
        maxIterations: 20,
        dampingFactor: 0.85,
        writeProperty: 'pageRank'
    }
)

YIELD nodeCount, RelationshipCount, bytesMin, bytesMax, requiredMemory



// Betweenness Algo

CALL gds.graph.project(
    'myGraph',
    'Villian',
    'COMPANION', {relationshipProperties: 'Weight'}
);

// 

CALL gds.betweenness.write(
    'myGraph',
    {writeProperty: 'betweenness'}
)

YIELD nodePropertiesWritten;

// TOP 5 OF VILLIAN

MATCH (v:Villian)
RETURN v.Name, v.betweenness
ORDER BY v.betweenness DESC
LIMIT 5;

/**
>>>>>>>>>>> SuperHeroes 


**/



OPTIONAL MATCH (z:SuperHero)
MATCH (m:SuperHero)-[r]-(n:SuperHero)
RETURN m, r, n, z;




CALL gds.graph.project(
    'newGraph',
    'SuperHero',
    'FRIEND_OF', {relationshipProperties: 'Weight'}
);


CALL gds.pageRank.write(
    'newGraph',
    {
        maxIterations: 20,
        dampingFactor: 0.85,
        writeProperty: 'pageRank'
    }
)

YIELD nodePropertiesWritten, ranIterations;

// cal la merio

// algo

CALL gds.pageRank.stream('newGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name AS Name, score
ORDER BY score DESC, Name ASC;


MATCH (s:SuperHero)
RETURN s.Name, s.pageRank
ORDER BY s.pagerank DESC
LIMIT 5;


CALL gds.betweenness.write(
    'newGraph',
    {writeProperty: 'betweenness'}
)

YIELD nodePropertiesWritten;

// TOP 5 OF VILLIAN

MATCH (s:SuperHero)
RETURN s.Name, s.betweenness
ORDER BY s.betweenness DESC
LIMIT 5;



OPTIONAL MATCH (z:SuperHero)
MATCH (m:SuperHero)-[r]-(n:SuperHero)
RETURN m, r, n, z;



// INDEGREE REVERSE

CALL gds.graph.project(
    'myReverseInDegreeGraph',
    'Villian',
    {COMPANION: {
        orientation: 'REVERSE',
        properties: 'Weight'
    }}
);
// OUTDEGREE NATURAL (default)
CALL gds.graph.project(
    'myNaturalOutDegreeGraph',
    'Villian',
    {COMPANION: {
        orientation: 'NATURAL',
        properties: 'Weight'
    }}
);
// Degree UNDIRECTED

CALL gds.graph.project(
    'myUndirectedDegreeGraph',
    'Villian',
    {COMPANION: {
        orientation: 'UNDIRECTED',
        properties: 'Weight'
    }}
);


// active subgraph

CALL gds.graph.list()
YIELD graphName;


CALL gds.graph.list()
YIELD graphName, nodeCount, relationshipCount, memoryUsage;


CALL gds.betweenness.write('myReverseInDegreeGraph', { writeProperty: 'indegree' })
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten


CALL gds.betweenness.write('myNaturalOutDegreeGraph', { writeProperty: 'outdegree' })
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten



CALL gds.betweenness.write('myUndirectedDegreeGraph', { writeProperty: 'degree' })
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

// outdegree

// degree


// 


MATCH (v:Villian{Name:'Lex Luthor'})
CALL{
    WITH v
    MATCH (n)<-[r:COMPANION]-()
    RETURN COUNT(r) AS INDEGREE
}

CALL{
    WITH v
    MATCH (n)-[r:COMPANION]->()
    RETURN COUNT(r) AS OUTDEGREE
}

CALL{
    WITH v
    MATCH (n)-[r:COMPANION]-()
    RETURN COUNT(r) AS DEGREE
}

RETURN v.Name, INDEGREE, OUTDEGREE, DEGREE


// 

MATCH (v:Villian{Name:'Lex Luthor'})
RETURN v.Name, v.indegree, v.outdegree, v.degree;



//






