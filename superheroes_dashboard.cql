MATCH (s:SuperHero {Name: 'Iron Man'})
RETURN s.Name, s.indegree, s.outdegree, s.degree;

// InDegree (REVERSE orientation)
CALL
  gds.graph.project(
    'sMyReverseInDegreeGraph',
    'SuperHero',
    {FRIEND_OF: {orientation: 'REVERSE', properties: 'Weight'}}
  );
// OutDegree (NATURAL orientation)
CALL
  gds.graph.project(
    'sMyNaturalOutDegreeGraph',
    'SuperHero',
    {FRIEND_OF: {orientation: 'NATURAL', properties: 'Weight'}}
  );
// Degree (UNDIRECTED orientation)
CALL
  gds.graph.project(
    'sMyUndirectedDegreeGraph',
    'SuperHero',
    {FRIEND_OF: {orientation: 'UNDIRECTED', properties: 'Weight'}}
  );

CALL
  gds.degree.write(
    'sMyReverseInDegreeGraph',
    {writeProperty: 'indegree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten;
CALL
  gds.degree.write(
    'sMyNaturalOutDegreeGraph',
    {writeProperty: 'outdegree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten;
CALL
  gds.degree.write(
    'sMyUndirectedDegreeGraph',
    {writeProperty: 'degree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten;

CALL
  gds.pageRank.write(
    'sMyNaturalOutDegreeGraph',
    {writeProperty: 'pageRank', maxIterations: 20, dampingFactor: 0.85}
  )
  YIELD nodePropertiesWritten, ranIterations;

CALL
  gds.betweenness.write(
    'sMyUndirectedDegreeGraph',
    {writeProperty: 'betweenness'}
  )
  YIELD centralityDistribution, nodePropertiesWritten;

CALL
  gds.closeness.write(
    'sMyNaturalOutDegreeGraph',
    {writeProperty: 'closeness'}
  )
  YIELD centralityDistribution, nodePropertiesWritten;

// Dashboard
//schema
CALL db.schema.visualization

// Total de nodos por etiqueta
MATCH (n)
UNWIND labels(n) AS Etiqueta
RETURN Etiqueta, count(n) AS Total_Nodos
ORDER BY Total_Nodos DESC;

// Villian Subgraph

MATCH (m:SuperHero)-[r:FRIEND_OF]-(n:SuperHero)
RETURN m, r, n;

// Degree Distribution

MATCH (s:SuperHero)
WITH s.degree AS Degree, count(s) AS NumSuperHero
RETURN Degree, NumSuperHero
ORDER BY Degree;

// PageRank Distribution

MATCH (s:SuperHero)
RETURN round(s.pageRank, 1) AS PageRank, count(s) AS NumSuperHero
ORDER BY PageRank;

// Betweenness Distribution

MATCH (s:SuperHero)
RETURN s.betweenness AS Betweenness, count(s) AS NumSuperHero
ORDER BY Betweenness;

// Closeness

MATCH (s:SuperHero)
RETURN s.Name, s.closeness
ORDER BY s.closeness DESC;

// report

MATCH (s:SuperHero {Name: $superhero_name})
CALL (s) {
  MATCH (s)-[r]-(o)
  RETURN count(r) AS Degree
}
CALL (s) {
  MATCH (s)<-[r]-(o)
  RETURN count(r) AS InDegree
}
CALL (s) {
  MATCH (s)-[r]->(o)
  RETURN count(r) AS OutDegree
}
RETURN
  s.Name AS Name,
  Degree,
  InDegree,
  OutDegree,
  s.betweenness AS Betweenness,
  s.pageRank AS PageRank,
  s.closeness AS Closeness