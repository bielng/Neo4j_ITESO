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

//

MATCH (source:Villian {Name: 'Lex Luthor'})
CALL
  gds.allShortestPaths.delta.write(
    'myUndirectedGraph',
    {
      sourceNode: source,
      relationshipWeightProperty: 'Weight',
      writeRelationshipType: 'PATH_Lex_Luthor_Undirected',
      writeNodeID: true,
      writeCosts: true
    }
  )
  YIELD relationshipsWritten
RETURN relationshipsWritten