CREATE DATABASE shv

:use shv

// see the APOC version

RETURN apoc.version()

// see the GDS version

CALL gds.version()


OPTIONAL MATCH (z:Villian)
MATCH (m:Villian)-[r]-(n:Villian)
RETURN m, r, n, z;




//Degree
// InDegree  REVERSE
// Outdegree  NATURAL (default)
// Degree    UNDIRECTED
// InDegree  REVERSE
CALL
  gds.graph.project(
    'newMyReverseInDegreeGraph',
    'Villian',
    {COMPANION: {orientation: 'REVERSE', properties: 'Weight'}}
  );

// Outdegree  NATURAL (default)
CALL
  gds.graph.project(
    'newMyNaturalOutDegreeGraph',
    'Villian',
    {COMPANION: {orientation: 'NATURAL', properties: 'Weight'}}
  );

// Degree    UNDIRECTED
CALL
  gds.graph.project(
    'newMyUndirectedDegreeGraph',
    'Villian',
    {COMPANION: {orientation: 'UNDIRECTED', properties: 'Weight'}}
  );

//Muestre los subgrafos activos
CALL
  gds.graph.list(
  )
  YIELD graphName, nodeCount, relationshipCount, memoryUsage;

// Añadir el atributo indegree
CALL
  gds.degree.write(
    'newMyReverseInDegreeGraph',
    {writeProperty: 'indegree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten

// Añadir el atributo outdegree
CALL
  gds.degree.write(
    'newMyNaturalOutDegreeGraph',
    {writeProperty: 'outdegree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten

// Añadir el atributo degree
CALL
  gds.degree.write(
    'newMyUndirectedDegreeGraph',
    {writeProperty: 'degree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten

//Ejercicio
//-Crea un tablero que reciba el nombre de un Villano y muestre su InDegree, OutDEgree y Degree

MATCH (v:Villian {Name: 'Loki'})
RETURN v.Name, v.indegree, v.outdegree, v.degree;

MATCH (v:Villian {Name: 'Lex Luthor'})
RETURN v.Name, v.indegree, v.outdegree, v.degree;

// Superheros

// v.Name, v.closeness

//Closness Centrality
CALL
  gds.closeness.write(
    'newMyNaturalOutDegreeGraph',
    {writeProperty: 'closeness'}
  )
  YIELD centralityDistribution, nodePropertiesWritten

//
MATCH (v:Villian {Name: 'Lex Luthor'})
RETURN v.Name, v.closeness

MATCH (v:Villian)
RETURN v.Name, v.closeness
ORDER BY v.closeness DESC;

//

MATCH (s:SuperHero {Name: 'Iron Man'})
RETURN s.Name, s.indegree, s.outdegree, s.degree;

/** 

+++++++++++++++++++

**/

CALL
  gds.graph.project(
    'sMyReverseInDegreeGraph',
    'SuperHero',
    {FRIEND_OF: {orientation: 'REVERSE', properties: 'Weight'}}
  );

// Outdegree  NATURAL (default)
CALL
  gds.graph.project(
    'sMyNaturalOutDegreeGraph',
    'SuperHero',
    {FRIEND_OF: {orientation: 'NATURAL', properties: 'Weight'}}
  );

// Degree    UNDIRECTED
CALL
  gds.graph.project(
    'sMyUndirectedDegreeGraph',
    'SuperHero',
    {FRIEND_OF: {orientation: 'UNDIRECTED', properties: 'Weight'}}
  );

//Muestre los subgrafos activos
CALL
  gds.graph.list(
  )
  YIELD graphName, nodeCount, relationshipCount, memoryUsage;

// Añadir el atributo indegree
CALL
  gds.degree.write(
    'sMyReverseInDegreeGraph',
    {writeProperty: 'indegree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten

// Añadir el atributo outdegree
CALL
  gds.degree.write(
    'sMyNaturalOutDegreeGraph',
    {writeProperty: 'outdegree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten

// Añadir el atributo degree
CALL
  gds.degree.write(
    'sMyUndirectedDegreeGraph',
    {writeProperty: 'degree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten

MATCH (s:SuperHero {Name: 'Hawkman'})
RETURN s.Name, s.indegree, s.outdegree, s.degree;

CALL
  gds.closeness.write(
    'sMyNaturalOutDegreeGraph',
    {writeProperty: 'closeness'}
  )
  YIELD centralityDistribution, nodePropertiesWritten

MATCH (s:SuperHero {Name: 'Hawkman'})
RETURN s.Name, s.closeness

MATCH (s:SuperHero)
RETURN s.Name, s.closeness
ORDER BY s.closeness DESC;

// subgraph villian
// degree - 8 degree numvillian
// indegree -  2
// outdegree - 6
// pageRank - 0.612 pagerank numvillian
// Between - 93 betweenness numvillian