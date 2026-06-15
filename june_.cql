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