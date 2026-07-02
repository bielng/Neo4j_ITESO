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

CALL gds.nodeSimilarity.stream('myDirectedGraph') YIELD node1, node2, similarity
RETURN
  gds.util.asNode(node1).Name AS Villian_1,
  gds.util.asNode(node2).Name AS Villian_2,
  similarity
ORDER BY similarity DESC, Villian_1, Villian_2

CALL
  gds.nodeSimilarity.stats(
    'myDirectedGraph'
  )
  YIELD nodesCompared, similarityPairs

CALL
  gds.nodeSimilarity.write(
    'myDirectedGraph',
    {writeRelationshipType: 'SIMILAR_Node_Similarity', writeProperty: 'score'}
  )
  YIELD nodesCompared, relationshipsWritten