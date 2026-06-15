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