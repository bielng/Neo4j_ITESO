// PRÁCTICA 2 - MINERÍA DE GRAFOS
// Aplicando algoritmos de centralidad y detección de comunidades
// Base de datos: Aeropuertos del mundo
// 1. CREAR LA BASE DE DATOS E IMPORTAR DATOS
CREATE DATABASE airports;: USE airports;

// Verificar versiones de plugins
RETURN apoc.version() AS apocVersion;

// 2. ANÁLISIS BÁSICO DEL GRAFO

// 2.1 Esquema general del grafo
CALL db.schema.visualization();

// Conteo de nodos y atributos
MATCH (a:Airport)
RETURN COUNT(a) AS totalAirports, KEYS(a) AS attributes
LIMIT 1;

// Conteo de relaciones y sus atributos
MATCH ()-[r:ROUTE]->()
RETURN COUNT(r) AS totalRoutes, KEYS(r) AS attributes
LIMIT 1;

// 2.2 Vista del grafo completo (muestra de 300 nodos para el browser)
MATCH (a:Airport)-[r:ROUTE]->(b:Airport)
RETURN a, r, b
LIMIT 300;

// Antes de exportar a Gephi: confirmar que latitud y longitud ya son float
MATCH (a:Airport)
RETURN a.Label, a.latitude, a.longitude
LIMIT 5;

// 2.3 Diámetro y densidad del grafo
// Densidad = E / (N * (N - 1))
MATCH (a:Airport)
WITH COUNT(a) AS N
MATCH ()-[r:ROUTE]->()
WITH N, COUNT(r) AS E
RETURN N AS totalNodes, E AS totalEdges, toFloat(E) / (N * (N - 1)) AS density;

// Diámetro aproximado usando GDS (camino más largo entre nodos alcanzables)
// Se puede estimar con All Pairs Shortest Path en un subgrafo pequeño
// Para el grafo completo se reporta a partir de los resultados de GDS.

// 3. CONSULTAS BÁSICAS

// 3.1 Número de aeropuertos por país (top 12)
MATCH (a:Airport)
RETURN a.country AS country, COUNT(a) AS numAirports
ORDER BY numAirports DESC
LIMIT 12;

// 3.2 Los 12 aeropuertos con más conexiones (grado sin dirección)
MATCH (a:Airport)-[r:ROUTE]-()
RETURN a.Label AS airport, a.country AS country, COUNT(r) AS connections
ORDER BY connections DESC
LIMIT 12;

// 3.3 [Bloom] Frase de búsqueda para grafo a 1 salto
// En Bloom crear la frase: "Grafo a un salto de $aeropuerto"
// Query que ejecuta Bloom internamente:
MATCH path = (a:Airport {Label: $aeropuerto})-[:ROUTE*1]-(b:Airport)
RETURN path;

// 3.4 [Bloom] Frase de búsqueda para grafo a 2 saltos
// En Bloom crear la frase: "Grafo a dos saltos de $aeropuerto"
// Query que ejecuta Bloom internamente:
MATCH path = (a:Airport {Label: $aeropuerto})-[:ROUTE*1..2]-(b:Airport)
RETURN path;

// 4. PREGUNTAS GUÍA
// (Las preguntas se documentan en el reporte; aquí se incluyen los queries
//  que las responden, organizados por algoritmo)

// -- CENTRALIDAD --
// P1 Degree:     ¿Cuáles son los aeropuertos con más rutas totales?
// P2 InDegree:   ¿Cuáles aeropuertos reciben más vuelos?
// P3 OutDegree:  ¿Cuáles aeropuertos emiten más vuelos?
// P4 PageRank:   ¿Cuáles aeropuertos son más influyentes en la red?
// P5 Betweenness:¿Qué aeropuerto, si cierra, afecta más la conectividad?
// P6 Closeness:  ¿Desde qué aeropuerto se puede llegar a todos en menos escalas?

// -- COMUNIDADES --
// P7  Louvain:   ¿Qué grupos de aeropuertos forman hubs naturales?
// P8  LabelProp: ¿Cómo se propagan los retrasos entre comunidades de aeropuertos?
// P9  Triangles: ¿Qué aeropuertos están en triángulos de rutas?
// P10 K1Color:   ¿Cómo podemos agrupar aeropuertos que no comparten rutas directas?
// P11 SCC:       ¿Qué aeropuertos forman circuitos cerrados de rutas directas?
// P12 WCC:       ¿Existen aeropuertos o grupos de aeropuertos aislados de la red?

// 5. PROYECCIÓN DE SUBGRAFOS Y CÁLCULO DE ATRIBUTOS

// DROP de subgrafos previos (ejecutar si ya existen)

CALL gds.graph.drop('airport_natural', false) YIELD graphName;
CALL gds.graph.drop('airport_reverse', false) YIELD graphName;
CALL gds.graph.drop('airport_undirected', false) YIELD graphName;

// Proyecciones base

// NATURAL (outgoing) – para OutDegree, PageRank, SCC
CALL
  gds.graph.project(
    'airport_natural',
    'Airport',
    {ROUTE: {orientation: 'NATURAL'}}
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

// REVERSE (incoming) – para InDegree
CALL
  gds.graph.project(
    'airport_reverse',
    'Airport',
    {ROUTE: {orientation: 'REVERSE'}}
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

// UNDIRECTED – para Degree, Closeness, Betweenness, WCC, Louvain, LabelProp, Triangles, K1Color
CALL
  gds.graph.project(
    'airport_undirected',
    'Airport',
    {ROUTE: {orientation: 'UNDIRECTED'}}
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

// Listar subgrafos activos
CALL gds.graph.list() YIELD graphName, nodeCount, relationshipCount, memoryUsage
RETURN graphName, nodeCount, relationshipCount, memoryUsage;

// 5.1 Degree (grado total – UNDIRECTED)

CALL
  gds.degree.write(
    'airport_undirected',
    {writeProperty: 'degree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution, nodePropertiesWritten;

// Verificar
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.degree AS degree
ORDER BY a.degree DESC
LIMIT 10;

// 5.2 InDegree (REVERSE orientation)

CALL
  gds.degree.write(
    'airport_reverse',
    {writeProperty: 'inDegree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution, nodePropertiesWritten;

// Verificar
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.inDegree AS inDegree
ORDER BY a.inDegree DESC
LIMIT 10;

// 5.3 OutDegree (NATURAL orientation)

CALL
  gds.degree.write(
    'airport_natural',
    {writeProperty: 'outDegree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution, nodePropertiesWritten;

// Verificar
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.outDegree AS outDegree
ORDER BY a.outDegree DESC
LIMIT 10;

// 5.4 PageRank (NATURAL orientation)

CALL
  gds.pageRank.write(
    'airport_natural',
    {maxIterations: 20, dampingFactor: 0.85, writeProperty: 'pageRank'}
  )
  YIELD nodePropertiesWritten, ranIterations
RETURN nodePropertiesWritten, ranIterations;

// Verificar top 10
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.pageRank AS pageRank
ORDER BY a.pageRank DESC
LIMIT 10;

// 5.5 Betweenness Centrality (UNDIRECTED)

CALL
  gds.betweenness.write(
    'airport_undirected',
    {writeProperty: 'betweenness'}
  )
  YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution, nodePropertiesWritten;

// Verificar top 10
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.betweenness AS betweenness
ORDER BY a.betweenness DESC
LIMIT 10;

// 5.6 Closeness Centrality (UNDIRECTED)

CALL
  gds.closeness.write(
    'airport_undirected',
    {writeProperty: 'closeness'}
  )
  YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution, nodePropertiesWritten;

// Verificar top 10
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.closeness AS closeness
ORDER BY a.closeness DESC
LIMIT 10;

// 5.7 Louvain Community Detection (UNDIRECTED)

CALL
  gds.louvain.write(
    'airport_undirected',
    {writeProperty: 'louvain'}
  )
  YIELD communityCount, modularity, modularities
RETURN communityCount, modularity, modularities;

// Verificar comunidades
MATCH (a:Airport)
RETURN
  a.louvain AS louvainCommunity,
  COUNT(a) AS numAirports,
  COLLECT(a.name)[0..10] AS sample
ORDER BY numAirports DESC
LIMIT 10;

// 5.8 Label Propagation (UNDIRECTED)

CALL
  gds.labelPropagation.write(
    'airport_undirected',
    {writeProperty: 'labelPropagation'}
  )
  YIELD communityCount, ranIterations, didConverge
RETURN communityCount, ranIterations, didConverge;

// Verificar comunidades
MATCH (a:Airport)
RETURN
  a.labelPropagation AS community,
  COUNT(a) AS numAirports,
  COLLECT(a.name)[0..10] AS sample
ORDER BY numAirports DESC
LIMIT 10;

// Label Propagation con semilla (ejemplo: aeropuerto de Frankfurt)
MATCH (a:Airport {name: 'Frankfurt am Main Airport'})
SET a.seedCommunity = a.labelPropagation
RETURN a.name, a.seedCommunity;

CALL gds.graph.drop('airport_undirected_seed', false) YIELD graphName;

CALL
  gds.graph.project(
    'airport_undirected_seed',
    'Airport',
    {ROUTE: {orientation: 'UNDIRECTED'}},
    {nodeProperties: ['seedCommunity']}
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

CALL
  gds.labelPropagation.write(
    'airport_undirected_seed',
    {seedProperty: 'seedCommunity', writeProperty: 'labelPropagationSeed'}
  )
  YIELD communityCount, ranIterations, didConverge
RETURN communityCount, ranIterations, didConverge;

CALL gds.graph.drop('airport_undirected_seed', false) YIELD graphName;

// 5.9 Triangle Count (UNDIRECTED)

CALL
  gds.triangleCount.write(
    'airport_undirected',
    {writeProperty: 'triangleCount'}
  )
  YIELD globalTriangleCount, nodeCount
RETURN globalTriangleCount, nodeCount;

// Verificar top 10 por triángulos
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.triangleCount AS triangles
ORDER BY a.triangleCount DESC
LIMIT 10;

// 5.10 K1 Coloring (UNDIRECTED)

CALL
  gds.k1coloring.write(
    'airport_undirected',
    {writeProperty: 'k1color'}
  )
  YIELD nodeCount, colorCount, ranIterations, didConverge
RETURN nodeCount, colorCount, ranIterations, didConverge;

// Ajustar colores para que inicien desde 1 en lugar de 0
MATCH (a:Airport)
SET a.k1color = a.k1color + 1
RETURN
  a.k1color AS color,
  COUNT(a) AS numAirports,
  COLLECT(a.name)[0..10] AS sample
ORDER BY a.k1color;

// 5.11 Strongly Connected Components – SCC (NATURAL)

CALL
  gds.scc.write(
    'airport_natural',
    {writeProperty: 'communitySCC'}
  )
  YIELD componentCount, componentDistribution
RETURN componentCount, componentDistribution;

// Ajustar para eliminar el cero
MATCH (a:Airport)
SET a.communitySCC = a.communitySCC + 1
RETURN
  a.communitySCC AS sccCommunity,
  COUNT(a) AS numAirports,
  COLLECT(a.name)[0..10] AS sample
ORDER BY numAirports DESC
LIMIT 10;

// 5.12 Weakly Connected Components – WCC (UNDIRECTED)

CALL
  gds.wcc.write(
    'airport_undirected',
    {writeProperty: 'communityWCC'}
  )
  YIELD componentCount, componentDistribution
RETURN componentCount, componentDistribution;

// Ajustar para eliminar el cero
MATCH (a:Airport)
SET a.communityWCC = a.communityWCC + 1
RETURN
  a.communityWCC AS wccCommunity,
  COUNT(a) AS numAirports,
  COLLECT(a.name)[0..10] AS sample
ORDER BY numAirports DESC
LIMIT 10;

// 6. ANÁLISIS ESTRUCTURAL – QUERIES PARA EL TABLERO (NEODASH)

// -- CENTRALIDAD --

// P1: Aeropuertos con más rutas totales (Degree)
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.degree AS degree
ORDER BY a.degree DESC
LIMIT 12;

// P2: Aeropuertos que más vuelos reciben (InDegree)
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.inDegree AS inDegree
ORDER BY a.inDegree DESC
LIMIT 12;

// P3: Aeropuertos que más vuelos emiten (OutDegree)
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.outDegree AS outDegree
ORDER BY a.outDegree DESC
LIMIT 12;

// P4: Aeropuertos más influyentes en la red (PageRank)
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.pageRank AS pageRank
ORDER BY a.pageRank DESC
LIMIT 12;

// P5: Aeropuerto cuyo cierre más afectaría la conectividad (Betweenness)
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.betweenness AS betweenness
ORDER BY a.betweenness DESC
LIMIT 12;

// P6: Aeropuerto desde el que se llega a todos con menos escalas (Closeness)
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.closeness AS closeness
ORDER BY a.closeness DESC
LIMIT 12;

// -- COMUNIDADES --

// P7: Grupos naturales de aeropuertos (Louvain) – top 12 comunidades más grandes
MATCH (a:Airport)
RETURN
  a.louvain AS community,
  COUNT(a) AS numAirports,
  COLLECT(a.name)[0..5] AS sampleAirports
ORDER BY numAirports DESC
LIMIT 12;

// P8: Comunidades por propagación de etiquetas (Label Propagation)
MATCH (a:Airport)
RETURN
  a.labelPropagation AS community,
  COUNT(a) AS numAirports,
  COLLECT(a.name)[0..5] AS sampleAirports
ORDER BY numAirports DESC
LIMIT 12;

// P9: Aeropuertos en más triángulos de rutas (Triangle Count)
MATCH (a:Airport)
RETURN a.name AS airport, a.country AS country, a.triangleCount AS triangles
ORDER BY a.triangleCount DESC
LIMIT 12;

// P10: Distribución de colores sin conflicto de rutas (K1 Coloring)
MATCH (a:Airport)
RETURN
  a.k1color AS color,
  COUNT(a) AS numAirports,
  COLLECT(a.name)[0..5] AS sampleAirports
ORDER BY a.k1color;

// P11: Circuitos cerrados de rutas directas (SCC)
MATCH (a:Airport)
RETURN
  a.communitySCC AS sccCommunity,
  COUNT(a) AS numAirports,
  COLLECT(a.name)[0..5] AS sampleAirports
ORDER BY numAirports DESC
LIMIT 12;

// P12: Aeropuertos o grupos aislados (WCC)
MATCH (a:Airport)
RETURN
  a.communityWCC AS wccCommunity,
  COUNT(a) AS numAirports,
  COLLECT(a.name)[0..5] AS sampleAirports
ORDER BY numAirports DESC
LIMIT 12;

// ----------------------------------------------------------------------------
// Tablero: Perfil completo de un aeropuerto (parámetro $name para NeoDash)
// ----------------------------------------------------------------------------
MATCH (a:Airport {name: $name})
RETURN
  a.name AS airport,
  a.country AS country,
  a.degree AS degree,
  a.inDegree AS inDegree,
  a.outDegree AS outDegree,
  a.pageRank AS pageRank,
  a.betweenness AS betweenness,
  a.closeness AS closeness,
  a.louvain AS louvain,
  a.labelPropagation AS labelPropagation,
  a.triangleCount AS triangles,
  a.k1color AS k1color,
  a.communitySCC AS scc,
  a.communityWCC AS wcc;

// Resumen global de todos los atributos en todos los aeropuertos
MATCH (a:Airport)
RETURN
  a.name AS airport,
  a.country AS country,
  a.degree AS degree,
  a.inDegree AS inDegree,
  a.outDegree AS outDegree,
  a.pageRank AS pageRank,
  a.betweenness AS betweenness,
  a.closeness AS closeness,
  a.louvain AS louvain,
  a.labelPropagation AS labelPropagation,
  a.triangleCount AS triangles,
  a.k1color AS k1color,
  a.communitySCC AS scc,
  a.communityWCC AS wcc
ORDER BY a.degree DESC
LIMIT 50;

// 7. LIMPIEZA DE SUBGRAFOS (opcional, no elimina datos de la BD)

CALL gds.graph.list() YIELD graphName, nodeCount, relationshipCount, memoryUsage
RETURN graphName, nodeCount, relationshipCount, memoryUsage
ORDER BY graphName;

CALL gds.graph.drop('airport_natural', false) YIELD graphName;
CALL gds.graph.drop('airport_reverse', false) YIELD graphName;
CALL gds.graph.drop('airport_undirected', false) YIELD graphName;