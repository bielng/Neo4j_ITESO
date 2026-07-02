CALL
  gds.graph.project(
    'myDirectedGraph',
    'Villian',
    {COMPANION: {orientation: 'NATURAL', properties: 'Weight'}}
  );

CALL
  gds.graph.project(
    'myUndirectedGraph',
    'Villian',
    {COMPANION: {orientation: 'UNDIRECTED', properties: 'Weight'}}
  );