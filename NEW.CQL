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
    'MyNaturalOutDegreeGraph',
    {writeProperty: 'closeness'}
  )
  YIELD centralityDistribution, nodePropertiesWritten

//
MATCH (v:Villian {Name: 'Lex Luthor'})
RETURN v.Name, v.closeness

MATCH (v:Villian)
RETURN v.Name, v.closeness
ORDER BY v.closeness DESC;