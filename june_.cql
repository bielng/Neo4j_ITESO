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