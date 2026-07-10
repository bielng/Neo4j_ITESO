// 6. Shortest Path (Dijkstra)
// Embudo más corto y eficiente entre una pelicula
// de un solo genero (casual) y un estreno premium
MATCH (source:Peliculas {title: 'Toy Story (1995)'})
MATCH (target:Peliculas {title: 'Matrix, The (1999)'})
CALL
  gds.shortestPath.dijkstra.write(
    'mymovieUndirectedGraph',
    {
      sourceNode: source,
      targetNode: target,
      relationshipWeightProperty: 'Weight',
      writeRelationshipType: 'Dijkstra_Embudo_Premium',
      writeNodeIds: true,
      writeCosts: true
    }
  )
  YIELD relationshipsWritten
RETURN relationshipsWritten;

// Mostrar la ruta del embudo de conversion
MATCH
  (source:Peliculas {title: 'Toy Story (1995)'})-[r:Dijkstra_Embudo_Premium]->
  (ov:Peliculas {title: 'Matrix, The (1999)'})
WHERE r.nodeIds IS NOT NULL AND size(r.nodeIds) >= 2
WITH [id IN r.nodeIds | gds.util.asNode(id)] AS nodes
UNWIND range(0, size(nodes) - 2) AS i
WITH nodes[i] AS n1, nodes[i + 1] AS n2
MATCH (n1)-[rel:CALIFICO]-(n2)
RETURN n1, rel, n2;

// 7. Minimum Weight Spanning Tree (MWST)
// Esqueleto minimo de licencias a retener

MATCH (source:Peliculas {title: 'Forrest Gump (1994)'})
CALL
  gds.spanningTree.write(
    'mymovieUndirectedGraph',
    {
      sourceNode: source,
      relationshipWeightProperty: 'Weight',
      writeProperty: 'Cost',
      writeRelationshipType: 'MWST_Catalogo_Minimo'
    }
  )
  YIELD effectiveNodeCount
RETURN effectiveNodeCount;

//

MATCH (source:Peliculas {title: 'Forrest Gump (1994)'})
CALL gds.spanningTree.write(
  'mymovieUndirectedGraph',
  {
    sourceNode: source,
    relationshipWeightProperty: 'Weight',
    writeProperty: 'Cost',
    writeRelationshipType: 'MWST_Catalogo_Minimo'
  }
)
YIELD effectiveNodeCount, totalWeight, relationshipsWritten
RETURN effectiveNodeCount, totalWeight, relationshipsWritten;

// Visualizar el esqueleto de licencias resultante
MATCH
  (source:Peliculas {title: 'Forrest Gump (1994)'})-[r:MWST_Catalogo_Minimo]->
  (ov:Peliculas)
WHERE r.nodeIds IS NOT NULL AND size(r.nodeIds) >= 2
WITH [id IN r.nodeIds | gds.util.asNode(id)] AS nodes
UNWIND range(0, size(nodes) - 2) AS i
WITH nodes[i] AS n1, nodes[i + 1] AS n2
MATCH (n1)-[rel:CALIFICO]-(n2)
RETURN n1, rel, n2
LIMIT 50;

///

MATCH path = (source:Peliculas {title: 'Forrest Gump (1994)'})-[:MWST_Catalogo_Minimo*]-(ov:Peliculas)
RETURN path
LIMIT 50;

// 8. Random Walk (Caminata Aleatoria)
// Probabilidad empirica de un "callejon sin salida"
// durante una sesion de zapping

CALL
  gds.randomWalk.stream(
    'mymovieDirectedGraph',
    {walkLength: 4, walksPerNode: 100, randomSeed: 42, concurrency: 1}
  )
  YIELD nodeIds, path
WITH nodeIds, size(nodeIds) AS Pasos_Reales
RETURN
  Pasos_Reales,
  COUNT(*) AS Total_Caminatas,
  toFloat(COUNT(*)) / 100.0 AS Proporcion_del_Total
ORDER BY Pasos_Reales ASC;


///

CALL gds.randomWalk.stream(
  'mymovieDirectedGraph',
  {walkLength: 4, walksPerNode: 100, randomSeed: 42, concurrency: 1}
)
YIELD nodeIds, path
WITH nodeIds, size(nodeIds) AS Pasos_Reales
WITH collect(Pasos_Reales) AS todos, count(*) AS granTotal
UNWIND todos AS Pasos_Reales


WITH Pasos_Reales, granTotal, COUNT(*) AS Total_Caminatas


RETURN
  Pasos_Reales,
  Total_Caminatas,
  toFloat(Total_Caminatas) / granTotal AS Proporcion_del_Total
ORDER BY Pasos_Reales ASC;

//

CALL gds.randomWalk.stream(
  'mymovieDirectedGraph',
  {walkLength: 4, walksPerNode: 100, randomSeed: 42, concurrency: 1}
)
YIELD nodeIds, path
WITH nodeIds, size(nodeIds) AS Pasos_Reales
WITH collect(Pasos_Reales) AS todos, count(*) AS granTotal
UNWIND todos AS Pasos_Reales


WITH Pasos_Reales, granTotal, COUNT(*) AS Total_Caminatas


RETURN
  Pasos_Reales,
  Total_Caminatas,
  toFloat(Total_Caminatas) / granTotal AS Proporcion_del_Total
ORDER BY Pasos_Reales ASC;

// Nota: si Pasos_Reales < 4 (walkLength esperado),
// significa que la caminata quedo "atascada" (callejon sin salida)
// antes de completar los pasos solicitados.

// 9. Betweenness Centrality
// Peliculas puente entre segmentos de audiencia distintos

CALL gds.betweenness.stream('mymovieUndirectedGraph') YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS p, score
WHERE p:Peliculas
RETURN p.title AS Pelicula_Puente, score AS Nivel_De_Intermediacion
ORDER BY score DESC
LIMIT 10;


///////

////

CALL gds.graph.project(
'MyMovieGraph',
['Usuario', 'Peliculas'],
{CALIFICO: {
orientation: 'NATURAL',
properties: 'Weight'
}
}
);