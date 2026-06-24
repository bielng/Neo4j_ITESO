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

// k1coloring superheroes

CALL
  gds.graph.project(
    'SmyUndirectedGraph',
    'SuperHero',
    {FRIEND_OF: {orientation: 'UNDIRECTED'}}
  )

CALL
  gds.k1coloring.write(
    'SmyUndirectedGraph',
    {writeProperty: 'k1color'}
  )
  YIELD nodeCount, colorCount, ranIterations, didConverge

MATCH (s:SuperHero)
RETURN s.k1color, COUNT(s.Name), COLLECT(s.Name)
ORDER BY COUNT(s.Name) DESC;

//

MATCH (s:SuperHero)
SET s.k1color = s.k1color + 1
RETURN
  s.k1color AS Color,
  COUNT(s.Name) AS NumIntegrantes,
  COLLECT(s.Name) AS Integrantes
ORDER BY COUNT(s.Name), s.k1color

//

//

//

CALL
  gds.graph.project(
    'myUndirectedGraph',
    'Villian',
    {COMPANION: {orientation: 'DIRECTED'}}
  )

CALL
  gds.graph.project(
    'MyDirectedGraph',
    'Villian',
    {COMPANION: {orientation: 'DIRECTED', properties: 'Weight'}}
  );

//

// Añadimos una restricción iniciando con la semilla de Joker

MATCH (v:Villian)
WHERE v.Name = 'Joker'
SET v.comunidadInicial = v.labelPropagation;

// Subgrafo con la nueva semilla

CALL
  gds.graph.project(
    'myAlterGraph',
    'Villian',
    {COMPANION: {orientation: 'UNDIRECTED'}},
    {nodeProperties: ['comunidadInicial']}
  );

// Añadir el atributo con la semilla de Joker

CALL
  gds.labelPropagation.write(
    'myAlterGraph',
    {seedProperty: 'comunidadInicial', writeProperty: 'labelPropagationSeed'}
  )
  YIELD communityCount, ranIterations, didConverge;

// Crear un subgrafo

CALL
  gds.graph.project(
    'myUndirectedGraph',
    'Villian',
    {COMPANION: {orientation: 'UNDIRECTED', properties: 'Weight'}}
  );

// Alterar la estructura del grafo

CALL
  gds.wcc.write(
    'myUndirectedGraph',
    {writeProperty: 'communityWCC'}
  )
  YIELD componentCount, componentDistribution;

// Villanos por comunidad

MATCH (v:Villian)
RETURN v.communityWCC, COUNT(v.Name), collect(v.Name)
ORDER BY COUNT(v.Name) DESC;

// Actualizar las comunidades para eliminar el CERO

MATCH (v:Villian)
SET v.communityWCC = v.communityWCC + 1
RETURN v.communityWCC, COUNT(v.Name), collect(v.Name)
ORDER BY COUNT(v.Name) DESC;

///

///

////

///

///

CALL
  gds.graph.project(
    '_myGraph',
    'Villian',
    {COMPANION: {Properties: 'Weight'}}
  )

// alterr la structure del grafo

CALL
  gds.scc.write(
    '_myGraph',
    {writeProperty: 'communitySCC'}
  )
  YIELD componentCount, componentDistribution

MATCH (v:Villian)
RETURN v.communitySCC, COUNT(v.Name), collect(v.Name)
ORDER BY COUNT(v.Name) DESC;

// Actualizar las comunidades para eliminar el CERO

MATCH (v:Villian)
SET v.communitySCC = v.communitySCC + 1
RETURN v.communitySCC, COUNT(v.Name), collect(v.Name)
ORDER BY COUNT(v.Name) DESC;

//

MATCH (p)
UNWIND labels(p) AS label
RETURN label, COUNT(p)
ORDER BY count(p) DESC

MATCH (p)
UNWIND labels(p) AS label
RETURN label, COUNT(p), COLLECT(p)

MATCH (p)
UNWIND labels(p) AS label
RETURN label, COUNT(p), COLLECT(p)
ORDER BY count(p) DESC

/** 
PageRank
Betweenness
Degree
Closeness

**/