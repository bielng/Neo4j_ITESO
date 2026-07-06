CALL
  gds.graph.project(
    'myUndirectedGraph',
    'Villian',
    {COMPANION: {orientation: 'UNDIRECTED', properties: 'Weight'}}
  );

CALL
  gds.graph.project(
    'mydirectedGraph',
    'Villian',
    {COMPANION: {orientation: 'NATURAL', properties: 'Weight'}}
  );

CALL
  gds.graph.list(
  )
  YIELD graphName, nodeCount, relationshipCount, database, creationTime;