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

///

///
////

MATCH (v:Villian)
SET v.Power = toInteger(v.degree);

MATCH (v:Villian)
RETURN v.Name, v.degree, v.Power
ORDER BY v.Power DESC;

MATCH (v:Villian)
RETURN
  gds.graph.project(
    'myKNNgraph',
    v,
    null,
    {sourceNodeProperties: v {.Power}, targetNodeProperties: {}}
  );

CALL
  gds.knn.write(
    'myKNNgraph',
    {
      writeRelationshipType: 'KNN',
      writeProperty: 'score',
      topk: 1,
      randomSeed: 42,
      concurrency: 1,
      nodeProperties: ['Power']
    }
  )
  YIELD nodesCompared, relationshipsWritten;

MATCH (v)-[r:KNN]->(ov)
RETURN v.Name, v.Power, ov.Name, ov.Power, r.score
ORDER BY r.score;