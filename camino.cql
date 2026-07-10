//
// July 07 2026
// Dijstra South-Target Shortest Path
MATCH (source:Villian {Name: 'Ultron'})
MATCH (target:Villian {Name: 'Cheetah'})
CALL
  gds.allShortestPaths.dijkstra.write(
    'myDirectedGraph',
    {
      sourceNode: source,
      relationshipWeightProperty: 'Weight',
      writeRelationshipType: 'Dijkstra_D_Ultron_Cheetaj',
      writeNodeIds: true,
      writeCosts: true
    }
  )
  YIELD relationshipsWritten
RETURN relationshipsWritten

//

WITH [id IN [41, 45, 46, 24, 36] | gds.util.asNode(id)] AS nodes
RETURN nodes;

///

MATCH
  (source:Villian {Name: 'Ultron'})-[r:Dijkstra_D_Ultron_Cheetaj]->
  (ov:Villian {Name: 'Cheetah'})
WHERE r.nodeIds IS NOT NULL AND size(r.nodeIds) >= 2
RETURN r.nodeIds;

///

MATCH
  (source:Villian {Name: 'Ultron'})-[r:Dijkstra_D_Ultron_Cheetaj]->
  (ov:Villian {Name: 'Cheetah'})
WHERE r.nodeIds IS NOT NULL AND size(r.nodeIds) >= 2

WITH [id IN r.nodeIds | gds.util.asNode(id)] AS nodes
UNWIND range(0, size(nodes) - 2) AS i
WITH nodes[i] AS n1, nodes[i + 1] AS n2

MATCH (n1)-[rel:COMPANION]-(n2)
RETURN n1, rel, n2;

/// Minimum Weight Spanning Tree

MATCH (source:Villian {Name: 'Flash Rebirth'})
CALL
  gds.spanningTree.write(
    'myUndirectedGraph',
    {
      sourceNode: source,
      relationshipWeightProperty: 'Weight',
      writeProperty: 'Cost',
      writeRelationshipType: 'MWST'
    }
  )
  YIELD effectiveNodeCount
RETURN effectiveNodeCount

///

//

WITH [id IN [41, 45, 46, 24, 36] | gds.util.asNode(id)] AS nodes
RETURN nodes;

///

MATCH
  (source:Villian {Name: 'Catwoman'})-[r:MWST]->
  (ov:Villian {Name: 'Flash Rebirth'})
WHERE r.nodeIds IS NOT NULL AND size(r.nodeIds) >= 2
RETURN r.nodeIds;
///

MATCH
  (source:Villian {Name: 'Catwoman'})-[r:MWST]->
  (ov:Villian {Name: 'Flash Rebirth'})
WHERE r.nodeIds IS NOT NULL AND size(r.nodeIds) >= 2

WITH [id IN r.nodeIds | gds.util.asNode(id)] AS nodes
UNWIND range(0, size(nodes) - 2) AS i
WITH nodes[i] AS n1, nodes[i + 1] AS n2

MATCH (n1)-[rel:COMPANION]-(n2)
RETURN n1, rel, n2;

///

MATCH (source:Villian {Name: 'Catwoman'})
CALL
  gds.spanningTree.write(
    'myUndirectedGraph',
    {
      sourceNode: source,
      relationshipWeightProperty: 'Weight',
      writeProperty: 'Cost',
      writeRelationshipType: 'MWST_Catwoman'
    }
  )
  YIELD effectiveNodeCount
RETURN effectiveNodeCount

///

MATCH
  (source:Villian {Name: 'Catwoman'})-[r:MWST_Catwoman]->
  (ov:Villian {Name: 'Flash Rebirth'})
WHERE r.nodeIds IS NOT NULL AND size(r.nodeIds) >= 2

WITH [id IN r.nodeIds | gds.util.asNode(id)] AS nodes
UNWIND range(0, size(nodes) - 2) AS i
WITH nodes[i] AS n1, nodes[i + 1] AS n2

MATCH (n1)-[rel:COMPANION]-(n2)
RETURN n1, rel, n2;

///

/***MATCH (source:Villian {Name: 'Catwoman'})
MATCH (target:Villian {Name: 'Flash Rebirth'})
CALL
  gds.spanningTree.write(
    'myUndirectedGraph',
    {
      sourceNode: source,
      relationshipWeightProperty: 'Weight',
      writeProperty: 'Cost',
      writeRelationshipType: 'MWST_Catwoman'
    }
  )
  YIELD effectiveNodeCount
RETURN effectiveNodeCount**/

/// Random walk

CALL
  gds.randomWalk.stream(
    'myDirectedGraph',
    {walkLength: 2, WalksPerNode: 1, randomSeed: 42, concurrency: 1}
  )
  YIELD nodeIds, path
RETURN nodeIds, path

//

MATCH (v:Villian)
WHERE v.Name IN ['Lex Luthor']
WITH COLLECT(v) AS sourceNodes

CALL
  gds.randomWalk.stream(
    'myDirectedGraph',
    {
      sourceNodes: sourceNodes,
      walkLength: 4,
      WalksPerNode: 1,
      randomSeed: 42,
      concurrency: 1
    }
  )
  YIELD nodeIds, path
RETURN nodeIds, [node IN nodes(path) | node.Name] AS Camino;


// 


///  


