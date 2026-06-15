CALL
  gds.graph.project(
    'myGraph',
    'Villian',
    {COMPANION: {orientation: 'UNDIRECTED'}}
  )

CALL
  gds.louvain.write(
    'myGraph',
    {writeProperty: 'louvain'}
  )
  YIELD communityCount, modularity, modularities

MATCH (v:Villian)
RETURN v.louvain, COUNT(v.Name), COLLECT(v.Name)
ORDER BY COUNT(v.Name) DESC;

// superheroes

CALL
  gds.graph.project(
    'SmyGraph',
    'Superhero',
    {FRIEND_OF: {orientation: 'UNDIRECTED'}}
  )

CALL
  gds.louvain.write(
    'SmyGraph',
    {writeProperty: 'louvain'}
  )
  YIELD communityCount, modularity, modularities

MATCH (s:SuperHero)
RETURN s.louvain, COUNT(s.Name), COLLECT(s.Name)
ORDER BY COUNT(s.Name) DESC;

// Undirected  K-1 coloring

CALL
  gds.graph.project(
    'myUndirectedGraph',
    'Villian',
    {COMPANION: {orientation: 'UNDIRECTED'}}
  )

CALL
  gds.k1coloring.write(
    'myUndirectedGraph',
    {writeProperty: 'k1color'}
  )
  YIELD nodeCount, colorCount, ranIterations, didConverge

MATCH (v:Villian)
RETURN v.k1color, COUNT(v.Name), COLLECT(v.Name)
ORDER BY COUNT(v.Name) DESC;

//

MATCH (v:Villian)
SET v.k1color = v.k1color + 1
RETURN
  v.k1color AS Color,
  COUNT(v.Name) AS NumIntegrantes,
  COLLECT(v.Name) AS Integrantes
ORDER BY COUNT(v.Name), v.k1color