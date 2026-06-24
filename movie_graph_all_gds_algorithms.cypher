// ============================================================================
// NEO4J GDS MOVIE GRAPH - FULL CYPHER PRACTICE FILE
// ============================================================================
//
// Goal:
// This file helps you master the pattern for Neo4j Graph Data Science algorithms
// using a Movie Graph database.
//
// Main node labels used:
//   (:Person)
//   (:Movie)
//
// Main relationship types used:
//   (:Person)-[:ACTED_IN]->(:Movie)
//   (:Person)-[:DIRECTED]->(:Movie)
//
// Important:
// 1. Run each section step by step.
// 2. If a graph name already exists, drop it first.
// 3. The pattern is always:
//
//    A) Project graph
//    B) Run algorithm in stream mode OR write mode
//    C) Return results
//    D) Drop graph when finished
//
// ============================================================================
// ============================================================================
// 0. BASIC DATABASE CHECKS
// ============================================================================
// Check APOC version
RETURN apoc.version() AS apocVersion;

// Check GDS version
CALL gds.version() YIELD version
RETURN version AS gdsVersion;

// See node labels in database
MATCH (n)
UNWIND labels(n) AS label
RETURN label, COUNT(n) AS total
ORDER BY total DESC;

// See relationship types in database
MATCH ()-[r]->()
RETURN type(r) AS relationshipType, COUNT(r) AS total
ORDER BY total DESC;

// View small movie graph sample
MATCH (p:Person)-[r]->(m:Movie)
RETURN p, r, m
LIMIT 50;

// ============================================================================
// 1. DEGREE CENTRALITY
// ============================================================================
//
// Question answered:
// "Who has the most connections?"
//
// In Movie Graph:
// - Person -> Movie means the person acted in or directed a movie.
// - Degree can show people connected to many movies.
// - Degree can also show movies connected to many people.
//
// Orientations:
// NATURAL    = outgoing direction
// REVERSE    = incoming direction
// UNDIRECTED = ignore direction
//
// ============================================================================

// ----------------------------------------------------------------------------
// 1A. OUTDEGREE - NATURAL ORIENTATION
// ----------------------------------------------------------------------------
//
// Meaning:
// Person -> Movie
// Counts how many movies a person points to.
//
// Example:
// Tom Hanks ACTED_IN many movies, so his outdegree may be high.
// ----------------------------------------------------------------------------

// Drop graph if it already exists
CALL gds.graph.drop('movie_outdegree_graph', false) YIELD graphName
RETURN graphName;

// Project graph
CALL
  gds.graph.project(
    'movie_outdegree_graph',
    ['Person', 'Movie'],
    {ACTED_IN: {orientation: 'NATURAL'}, DIRECTED: {orientation: 'NATURAL'}}
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

// Stream degree result without saving to database
CALL gds.degree.stream('movie_outdegree_graph') YIELD nodeId, score
RETURN
  gds.util.asNode(nodeId).name AS name,
  labels(gds.util.asNode(nodeId)) AS labels,
  score AS outdegree
ORDER BY outdegree DESC, name ASC
LIMIT 20;

// Write outdegree as property
CALL
  gds.degree.write(
    'movie_outdegree_graph',
    {writeProperty: 'outdegree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution, nodePropertiesWritten;

// Check saved property
MATCH (p:Person)
RETURN p.name AS person, p.outdegree AS outdegree
ORDER BY outdegree DESC
LIMIT 20;

// ----------------------------------------------------------------------------
// 1B. INDEGREE - REVERSE ORIENTATION
// ----------------------------------------------------------------------------
//
// Meaning:
// Reverse direction makes Movie -> Person.
// Useful for checking how many incoming links a node has.
// ----------------------------------------------------------------------------

CALL gds.graph.drop('movie_indegree_graph', false) YIELD graphName
RETURN graphName;

CALL
  gds.graph.project(
    'movie_indegree_graph',
    ['Person', 'Movie'],
    {ACTED_IN: {orientation: 'REVERSE'}, DIRECTED: {orientation: 'REVERSE'}}
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

CALL
  gds.degree.write(
    'movie_indegree_graph',
    {writeProperty: 'indegree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution, nodePropertiesWritten;

MATCH (m:Movie)
RETURN m.title AS movie, m.indegree AS indegree
ORDER BY indegree DESC
LIMIT 20;

// ----------------------------------------------------------------------------
// 1C. TOTAL DEGREE - UNDIRECTED ORIENTATION
// ----------------------------------------------------------------------------
//
// Meaning:
// Ignore direction.
// Count all connections.
// ----------------------------------------------------------------------------

CALL gds.graph.drop('movie_degree_graph', false) YIELD graphName
RETURN graphName;

CALL
  gds.graph.project(
    'movie_degree_graph',
    ['Person', 'Movie'],
    {
      ACTED_IN: {orientation: 'UNDIRECTED'},
      DIRECTED: {orientation: 'UNDIRECTED'}
    }
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

CALL
  gds.degree.write(
    'movie_degree_graph',
    {writeProperty: 'degree'}
  )
  YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution, nodePropertiesWritten;

MATCH (n)
WHERE n:Person OR n:Movie
RETURN
  coalesce(n.name, n.title) AS name,
  labels(n) AS labels,
  n.degree AS degree
ORDER BY degree DESC
LIMIT 20;

// ============================================================================
// 2. CLOSENESS CENTRALITY
// ============================================================================
//
// Question answered:
// "Who can reach everyone quickly?"
//
// Meaning:
// A node has high closeness if it is close to many other nodes.
//
// In Movie Graph:
// A person with high closeness is near many actors/movies through short paths.
//
// Usually use UNDIRECTED for easier interpretation in movie networks.
// ============================================================================

CALL gds.graph.drop('movie_closeness_graph', false) YIELD graphName
RETURN graphName;

CALL
  gds.graph.project(
    'movie_closeness_graph',
    ['Person', 'Movie'],
    {
      ACTED_IN: {orientation: 'UNDIRECTED'},
      DIRECTED: {orientation: 'UNDIRECTED'}
    }
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

// Stream closeness
CALL gds.closeness.stream('movie_closeness_graph') YIELD nodeId, score
RETURN
  coalesce(gds.util.asNode(nodeId).name, gds.util.asNode(nodeId).title) AS name,
  labels(gds.util.asNode(nodeId)) AS labels,
  score AS closeness
ORDER BY closeness DESC
LIMIT 20;

// Write closeness property
CALL
  gds.closeness.write(
    'movie_closeness_graph',
    {writeProperty: 'closeness'}
  )
  YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution, nodePropertiesWritten;

// Check saved property
MATCH (p:Person)
RETURN p.name AS person, p.closeness AS closeness
ORDER BY closeness DESC
LIMIT 20;

// ============================================================================
// 3. BETWEENNESS CENTRALITY
// ============================================================================
//
// Question answered:
// "Who is the bridge between groups?"
//
// Meaning:
// High betweenness means the node appears often on shortest paths.
//
// In Movie Graph:
// A person/movie with high betweenness connects different actor/movie groups.
// ============================================================================

CALL gds.graph.drop('movie_betweenness_graph', false) YIELD graphName
RETURN graphName;

CALL
  gds.graph.project(
    'movie_betweenness_graph',
    ['Person', 'Movie'],
    {
      ACTED_IN: {orientation: 'UNDIRECTED'},
      DIRECTED: {orientation: 'UNDIRECTED'}
    }
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

// Stream betweenness
CALL gds.betweenness.stream('movie_betweenness_graph') YIELD nodeId, score
RETURN
  coalesce(gds.util.asNode(nodeId).name, gds.util.asNode(nodeId).title) AS name,
  labels(gds.util.asNode(nodeId)) AS labels,
  score AS betweenness
ORDER BY betweenness DESC
LIMIT 20;

// Write betweenness property
CALL
  gds.betweenness.write(
    'movie_betweenness_graph',
    {writeProperty: 'betweenness'}
  )
  YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution, nodePropertiesWritten;

// Check saved property
MATCH (p:Person)
RETURN p.name AS person, p.betweenness AS betweenness
ORDER BY betweenness DESC
LIMIT 20;

// ============================================================================
// 4. PAGERANK
// ============================================================================
//
// Question answered:
// "Who is important because important nodes point to them?"
//
// Meaning:
// PageRank gives higher score to nodes connected from other important nodes.
//
// In Movie Graph:
// A movie may rank high if many important people connect to it.
// A person may rank high depending on graph direction.
// ============================================================================

CALL gds.graph.drop('movie_pagerank_graph', false) YIELD graphName
RETURN graphName;

// Project directed graph using natural direction
CALL
  gds.graph.project(
    'movie_pagerank_graph',
    ['Person', 'Movie'],
    {ACTED_IN: {orientation: 'NATURAL'}, DIRECTED: {orientation: 'NATURAL'}}
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

// Estimate memory before writing PageRank
CALL
  gds.pageRank.write.estimate(
    'movie_pagerank_graph',
    {maxIterations: 20, dampingFactor: 0.85, writeProperty: 'pageRank'}
  )
  YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory
RETURN nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory;

// Stream PageRank
CALL
  gds.pageRank.stream(
    'movie_pagerank_graph',
    {maxIterations: 20, dampingFactor: 0.85}
  )
  YIELD nodeId, score
RETURN
  coalesce(gds.util.asNode(nodeId).name, gds.util.asNode(nodeId).title) AS name,
  labels(gds.util.asNode(nodeId)) AS labels,
  score AS pageRank
ORDER BY pageRank DESC
LIMIT 20;

// Write PageRank property
CALL
  gds.pageRank.write(
    'movie_pagerank_graph',
    {maxIterations: 20, dampingFactor: 0.85, writeProperty: 'pageRank'}
  )
  YIELD nodePropertiesWritten, ranIterations
RETURN nodePropertiesWritten, ranIterations;

// Check saved property
MATCH (m:Movie)
RETURN m.title AS movie, m.pageRank AS pageRank
ORDER BY pageRank DESC
LIMIT 20;

// ============================================================================
// 5. WCC - WEAKLY CONNECTED COMPONENTS
// ============================================================================
//
// Question answered:
// "Which nodes are connected in the same group if direction is ignored?"
//
// Meaning:
// WCC finds connected islands/components.
//
// In Movie Graph:
// It can show disconnected movie-person groups.
// ============================================================================

CALL gds.graph.drop('movie_wcc_graph', false) YIELD graphName
RETURN graphName;

CALL
  gds.graph.project(
    'movie_wcc_graph',
    ['Person', 'Movie'],
    {
      ACTED_IN: {orientation: 'UNDIRECTED'},
      DIRECTED: {orientation: 'UNDIRECTED'}
    }
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

// Write WCC community property
CALL
  gds.wcc.write(
    'movie_wcc_graph',
    {writeProperty: 'communityWCC'}
  )
  YIELD componentCount, componentDistribution
RETURN componentCount, componentDistribution;

// Show groups
MATCH (n)
WHERE n:Person OR n:Movie
RETURN
  n.communityWCC AS communityWCC,
  COUNT(n) AS numberOfNodes,
  COLLECT(coalesce(n.name, n.title))[0..20] AS sampleMembers
ORDER BY numberOfNodes DESC;

// Optional: make community start from 1 instead of 0
MATCH (n)
WHERE (n:Person OR n:Movie) AND n.communityWCC IS NOT NULL
SET n.communityWCC = n.communityWCC + 1
RETURN n.communityWCC AS communityWCC, COUNT(n) AS numberOfNodes
ORDER BY numberOfNodes DESC;

// ============================================================================
// 6. SCC - STRONGLY CONNECTED COMPONENTS
// ============================================================================
//
// Question answered:
// "Which nodes can reach each other following direction?"
//
// Meaning:
// SCC uses directed paths.
// Every node in the same SCC can reach every other node in that SCC.
//
// Important:
// The basic Movie Graph mostly has Person -> Movie relationships only.
// That means SCC may produce many small components.
// This is normal.
// ============================================================================

CALL gds.graph.drop('movie_scc_graph', false) YIELD graphName
RETURN graphName;

CALL
  gds.graph.project(
    'movie_scc_graph',
    ['Person', 'Movie'],
    {ACTED_IN: {orientation: 'NATURAL'}, DIRECTED: {orientation: 'NATURAL'}}
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

CALL
  gds.scc.write(
    'movie_scc_graph',
    {writeProperty: 'communitySCC'}
  )
  YIELD componentCount, componentDistribution
RETURN componentCount, componentDistribution;

MATCH (n)
WHERE n:Person OR n:Movie
RETURN
  n.communitySCC AS communitySCC,
  COUNT(n) AS numberOfNodes,
  COLLECT(coalesce(n.name, n.title))[0..20] AS sampleMembers
ORDER BY numberOfNodes DESC;

// ============================================================================
// 7. LOUVAIN COMMUNITY DETECTION
// ============================================================================
//
// Question answered:
// "Which natural community/group does each node belong to?"
//
// Meaning:
// Louvain finds communities by maximizing modularity.
//
// In Movie Graph:
// It can group actors and movies that are closely related.
// ============================================================================

CALL gds.graph.drop('movie_louvain_graph', false) YIELD graphName
RETURN graphName;

CALL
  gds.graph.project(
    'movie_louvain_graph',
    ['Person', 'Movie'],
    {
      ACTED_IN: {orientation: 'UNDIRECTED'},
      DIRECTED: {orientation: 'UNDIRECTED'}
    }
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

// Write Louvain community
CALL
  gds.louvain.write(
    'movie_louvain_graph',
    {writeProperty: 'louvain'}
  )
  YIELD communityCount, modularity, modularities
RETURN communityCount, modularity, modularities;

// Show communities
MATCH (n)
WHERE n:Person OR n:Movie
RETURN
  n.louvain AS louvainCommunity,
  COUNT(n) AS numberOfNodes,
  COLLECT(coalesce(n.name, n.title))[0..20] AS sampleMembers
ORDER BY numberOfNodes DESC;

// ============================================================================
// 8. LABEL PROPAGATION
// ============================================================================
//
// Question answered:
// "Which community label spreads through the network?"
//
// Meaning:
// Each node starts with a label.
// Nodes update their label based on neighbor labels.
// Very fast for large graphs.
//
// In Movie Graph:
// Finds actor/movie communities quickly.
// ============================================================================

CALL gds.graph.drop('movie_labelprop_graph', false) YIELD graphName
RETURN graphName;

CALL
  gds.graph.project(
    'movie_labelprop_graph',
    ['Person', 'Movie'],
    {
      ACTED_IN: {orientation: 'UNDIRECTED'},
      DIRECTED: {orientation: 'UNDIRECTED'}
    }
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

// Write label propagation result
CALL
  gds.labelPropagation.write(
    'movie_labelprop_graph',
    {writeProperty: 'labelPropagation'}
  )
  YIELD communityCount, ranIterations, didConverge
RETURN communityCount, ranIterations, didConverge;

// Show communities
MATCH (n)
WHERE n:Person OR n:Movie
RETURN
  n.labelPropagation AS labelPropagationCommunity,
  COUNT(n) AS numberOfNodes,
  COLLECT(coalesce(n.name, n.title))[0..20] AS sampleMembers
ORDER BY numberOfNodes DESC;

// ----------------------------------------------------------------------------
// 8B. LABEL PROPAGATION WITH SEED PROPERTY
// ----------------------------------------------------------------------------
//
// This is an advanced pattern.
// A seed property forces or guides the starting community.
//
// Example:
// We use the community of "Tom Hanks" as a seed.
// ----------------------------------------------------------------------------

// First check Tom Hanks current labelPropagation value
MATCH (p:Person {name: 'Tom Hanks'})
RETURN p.name AS person, p.labelPropagation AS oldCommunity;

// Save seed property on Tom Hanks
MATCH (p:Person {name: 'Tom Hanks'})
SET p.seedCommunity = p.labelPropagation
RETURN p.name AS person, p.seedCommunity AS seedCommunity;

// Drop old seed graph
CALL gds.graph.drop('movie_labelprop_seed_graph', false) YIELD graphName
RETURN graphName;

// Project graph with node property seedCommunity
CALL
  gds.graph.project(
    'movie_labelprop_seed_graph',
    ['Person', 'Movie'],
    {
      ACTED_IN: {orientation: 'UNDIRECTED'},
      DIRECTED: {orientation: 'UNDIRECTED'}
    },
    {nodeProperties: ['seedCommunity']}
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

// Run label propagation using seed property
CALL
  gds.labelPropagation.write(
    'movie_labelprop_seed_graph',
    {seedProperty: 'seedCommunity', writeProperty: 'labelPropagationSeed'}
  )
  YIELD communityCount, ranIterations, didConverge
RETURN communityCount, ranIterations, didConverge;

// Show seeded result
MATCH (n)
WHERE n:Person OR n:Movie
RETURN
  n.labelPropagationSeed AS seededCommunity,
  COUNT(n) AS numberOfNodes,
  COLLECT(coalesce(n.name, n.title))[0..20] AS sampleMembers
ORDER BY numberOfNodes DESC;

// ============================================================================
// 9. K1 COLORING
// ============================================================================
//
// Question answered:
// "How can we color nodes so connected nodes do not share the same color?"
//
// Meaning:
// Connected neighbor nodes should receive different colors.
//
// In Movie Graph:
// Useful pattern for scheduling, grouping, or conflict separation.
// ============================================================================

CALL gds.graph.drop('movie_k1color_graph', false) YIELD graphName
RETURN graphName;

CALL
  gds.graph.project(
    'movie_k1color_graph',
    ['Person', 'Movie'],
    {
      ACTED_IN: {orientation: 'UNDIRECTED'},
      DIRECTED: {orientation: 'UNDIRECTED'}
    }
  )
  YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;

// Write K1 coloring result
CALL
  gds.k1coloring.write(
    'movie_k1color_graph',
    {writeProperty: 'k1color'}
  )
  YIELD nodeCount, colorCount, ranIterations, didConverge
RETURN nodeCount, colorCount, ranIterations, didConverge;

// Show color groups
MATCH (n)
WHERE n:Person OR n:Movie
RETURN
  n.k1color AS color,
  COUNT(n) AS numberOfNodes,
  COLLECT(coalesce(n.name, n.title))[0..20] AS sampleMembers
ORDER BY color ASC;

// Optional: make color start from 1 instead of 0
MATCH (n)
WHERE (n:Person OR n:Movie) AND n.k1color IS NOT NULL
SET n.k1color = n.k1color + 1
RETURN
  n.k1color AS color,
  COUNT(n) AS numberOfNodes,
  COLLECT(coalesce(n.name, n.title))[0..20] AS sampleMembers
ORDER BY color ASC;

// ============================================================================
// 10. FINAL SUMMARY QUERIES
// ============================================================================
//
// These queries help you see all algorithm properties saved on nodes.
// ============================================================================

// Person summary
MATCH (p:Person)
RETURN
  p.name AS person,
  p.indegree AS indegree,
  p.outdegree AS outdegree,
  p.degree AS degree,
  p.closeness AS closeness,
  p.betweenness AS betweenness,
  p.pageRank AS pageRank,
  p.communityWCC AS communityWCC,
  p.communitySCC AS communitySCC,
  p.louvain AS louvain,
  p.labelPropagation AS labelPropagation,
  p.labelPropagationSeed AS labelPropagationSeed,
  p.k1color AS k1color
ORDER BY degree DESC
LIMIT 30;

// Movie summary
MATCH (m:Movie)
RETURN
  m.title AS movie,
  m.indegree AS indegree,
  m.outdegree AS outdegree,
  m.degree AS degree,
  m.closeness AS closeness,
  m.betweenness AS betweenness,
  m.pageRank AS pageRank,
  m.communityWCC AS communityWCC,
  m.communitySCC AS communitySCC,
  m.louvain AS louvain,
  m.labelPropagation AS labelPropagation,
  m.labelPropagationSeed AS labelPropagationSeed,
  m.k1color AS k1color
ORDER BY degree DESC
LIMIT 30;

// ============================================================================
// 11. CLEANUP OPTIONAL
// ============================================================================
//
// Use these only if you want to remove in-memory GDS graphs.
// It does NOT delete your database nodes.
// ============================================================================

CALL gds.graph.list() YIELD graphName, nodeCount, relationshipCount, memoryUsage
RETURN graphName, nodeCount, relationshipCount, memoryUsage
ORDER BY graphName;

// Drop all practice graphs one by one if needed
CALL gds.graph.drop('movie_outdegree_graph', false);
CALL gds.graph.drop('movie_indegree_graph', false);
CALL gds.graph.drop('movie_degree_graph', false);
CALL gds.graph.drop('movie_closeness_graph', false);
CALL gds.graph.drop('movie_betweenness_graph', false);
CALL gds.graph.drop('movie_pagerank_graph', false);
CALL gds.graph.drop('movie_wcc_graph', false);
CALL gds.graph.drop('movie_scc_graph', false);
CALL gds.graph.drop('movie_louvain_graph', false);
CALL gds.graph.drop('movie_labelprop_graph', false);
CALL gds.graph.drop('movie_labelprop_seed_graph', false);
CALL gds.graph.drop('movie_k1color_graph', false);

// ============================================================================
// END OF FILE
// ============================================================================
//
// Master pattern:
//
// 1. Drop old graph
// 2. Project graph
// 3. Stream algorithm to preview
// 4. Write algorithm property
// 5. Query saved property
//
// Centrality:
// Degree -> Closeness -> Betweenness -> PageRank
//
// Connectivity:
// WCC -> SCC
//
// Community:
// Louvain -> Label Propagation
//
// Coloring:
// K1 Coloring
//
// ============================================================================