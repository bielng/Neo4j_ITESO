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

///

MATCH (source:Villian {Name: 'Lex Luthor'})
CALL
  gds.allShortestPaths.delta.write(
    'mydirectedGraph',
    {
      sourceNode: source,
      relationshipWeightProperty: 'Weight',
      writeRelationshipType: 'PATH_Lex_Luthor',
      writeNodeIDs: true,
      writeCosts: true
    }
  )
  YIELD relationshipsWritten
RETURN relationshipsWritten

///

// Step 1

MATCH
  (source:Villian {Name: 'Lex Luthor'})-[r:PATH_Lex_Luthor]->
  (ov:Villian {Name: 'Catwoman'})
WHERE r.nodeIDs IS NOT NULL AND size(r.nodeIds) >= 2
RETURN r.nodeIds;

//

/**MATCH (v:Villain)
WHERE id(v) = 38
RETURN v.Name**/

///

UNWIND range(0, 4) AS i
RETURN i;

//

WITH [id IN [24, 38, 31] | gds.util.asNode(id)] AS nodes
RETURN nodes;