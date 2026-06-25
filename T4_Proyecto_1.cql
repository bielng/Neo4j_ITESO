// Proyecto 1
// Spotify Artist Feature Collaboration Network - Red de Colaboración de ARTIST de Spotify
// Luciano Nieves, Carlos Gordoa, Tabal Biel

// Analisis
// Esquema del grafo
CALL db.schema.visualization();

// Contar los Nodos
MATCH (a:ARTIST)
RETURN COUNT(a) AS Total_ARTIST;

// Contar los tipos de relaciones
MATCH ()-[r:COLLABORATE_WITH]-()
RETURN COUNT(DISTINCT r) AS Total_Relaciones;

// Top 10 de los ARTIST con mayores relaciones
MATCH (n:ARTIST)-[r:COLLABORATE_WITH]-(m:ARTIST)
RETURN n.name AS Artista, COUNT(DISTINCT r) AS Artista_con_mas_Colaboraciones
ORDER BY Artista_con_mas_Colaboraciones DESC
LIMIT 10;

// ARTIST latinos mostrando el genero que hace
MATCH (n:ARTIST)-[r:COLLABORATE_WITH]-(m:ARTIST)
WHERE 
RETURN n.name AS Artista_Latinos, a.genres AS Generos
ORDER BY Artista_con_mas_Colaboraciones DESC
LIMIT 10;

// Centralidad y Comunidad
// Crear un subgrafo 
CALL gds.graph.project(
    'MyArtistGraph',
    'ARTIST',
    'COLLABORATE_WITH', 
    {relationshipProperties: 'genres'}
);

// Calcular la memoria
CALL gds.pageRank.write.estimate(
    'MyArtistGraph',
    {
        maxIterations: 20,
        dampingFactor: 0.85,
        writeProperty: 'pagerank'
    }
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory;


// Atributos degree - ARTIST
CALL gds.graph.project(
    'ArtistUndirectedDegreeGraph',
    'ARTIST',
    {CCOLLABORATE_WITH: {
        orientation: 'UNDIRECTED',
        properties: 'genres'
        }
    }
);

// Añade el atributo Degree
CALL gds.degree.write(
    'ArtistUndirectedDegreeGraph',
    {writeProperty: 'degree'}
)
YIELD centralityDistribution, nodePropertiesWritten;

// Atributos indegree - ARTIST
CALL gds.graph.project(
    'ArtistReverseInDegreeGraph',
    'ARTIST',
    {CCOLLABORATE_WITH: {
        orientation: 'REVERSE',
        properties: 'genres'
        }
    }
);

// Añade el atributo Indegree
CALL gds.degree.write(
    'ArtistReverseInDegreeGraph',
    {writeProperty: 'indegree'}
)
YIELD centralityDistribution, nodePropertiesWritten;


// Atributos outdegree - ARTIST
CALL gds.graph.project(
    'ArtistNaturalOutDegreeGraph',
    'ARTIST',
    {COLLABORATE_WITH: {
        orientation: 'NATURAL',
        properties: 'genres'
        }
    }
);


// Atributos outdegree - ARTIST
CALL gds.graph.project(
    'ArtistNaturalOutDegreeGraph',
    'ARTIST',
    {COLLABORATE_WITH: {
        orientation: 'NATURAL',
        properties: 'genres'
        }
    }
);

// Añade el atributo Outdegree
CALL gds.degree.write(
    'ArtistNaturalOutDegreeGraph',
    {writeProperty: 'outdegree'}
)
YIELD centralityDistribution, nodePropertiesWritten;

// Atributos outdegree - ARTIST
CALL gds.graph.project(
    'ArtistNaturalOutDegreeGraph',
    'ARTIST',
    {DESTINO: {
        orientation: 'NATURAL',
        properties: 'genres'
        }
    }
);

// Atributos PageRank - ARTIST
CALL gds.pageRank.write(
    'MyArtistGraph',
    {
        maxIterations: 20,
        dampingFactor: 0.85,
        writeProperty: 'pagerank'
    }
)
YIELD nodePropertiesWritten, ranIterations
RETURN nodePropertiesWritten, ranIterations

// Closseness Centrality

// 1) calcular la memoria
CALL gds.closeness.write.estimate(
    'MyArtistGraph',
    {
        writeProperty: 'closeness'
    }
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory;

// 2) Ejecutar el algoritmo
/** CALL gds.closeness.write('MyArtistGraph',)
YIELD nodeId, score;
RETURN gds.util.asNode(nodeId).Name AS Name, score
ORDER BY score DESC, Name ASC; **/

CALL gds.closeness.write('MyArtistGraph', { writeProperty: 'closeness' })
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

// 3) Escribimos el resutado como un atributo extra en cada nodo
CALL gds.closeness.write(
    'MyArtistGraph',
    {writeProperty: 'closeness'}
)
YIELD centralityDistribution, nodePropertiesWritten;
RETURN centralityDistribution.min AS minimusScore, 
       centralityDistribution.mean AS meanScore, 
       centralityDistribution.max AS maxScore
       nodePropertiesWritten;

// Betweenness Centrality - ARTIST
CALL gds.betweenness.write(
    'MyArtistGraph',
    {writeProperty: 'betweenness'}
)
YIELD nodePropertiesWritten
RETURN nodePropertiesWritten

// Añadir el atributo
CALL gds.labelPropagation.write(
    'MyArtistGraph',
    {writeProperty: 'labelPropagation'})
YIELD communityCount, ranIterations, didConverge;

// Nodos por comunidad labelPropagation
MATCH (a:ARTIST)
RETURN
    a.labelPropagation,
    COUNT(a.name) AS Total,
    COLLECT(a.name) AS ARTIST
ORDER BY Total DESC;

// 1. Fase de Comunidad (Análisis Macro)
// Pregunta 1 (Identificación): ¿Cuáles son las 5 comunidades de aRTIST más grandes en el grafo mapeadas 
// mediante el algoritmo de Detección de Comunidades de Louvain basado en la relación :COLABORATE_WITH?
CALL gds.louvain.write(
    'MyArtistGraph',
    {
        writeProperty: 'louvainCommunity'
    }
)
YIELD communityCount, modularity, nodePropertiesWritten
RETURN
    communityCount AS NumeroComunidades,
    modularity AS Modularidad,
    nodePropertiesWritten AS ARTISTActualizados;

MATCH (a:Artist)
WHERE a.louvainCommunity IS NOT NULL
RETURN
    a.louvainCommunity AS Comunidad,
    COUNT(a) AS NumeroARTIST,
    COLLECT(a.name)[0..10] AS EjemplosARTIST
ORDER BY NumeroARTIST DESC
LIMIT 5;

// Pregunta 2 (Cohesión Interna - Seguimiento): De las 5 comunidades identificadas en el paso anterior, 
// ¿cuál de ellas presenta la mayor densidad de grafos (proporción de conexiones reales :COLABRATE_WITH internas frente 
// a las conexiones totales posibles entre sus miembros)?

// Pregunta 3 (Puentes Inter-comunidad - Seguimiento): ¿Cuáles son los 5 aRTIST que poseen el mayor número de 
// relaciones :COLABORATE_WITH dirigidas hacia nodos que pertenecen a una comunidad de Louvain distinta a la suya?

// 2. Fase de Centralidad (Análisis Micro)

// Pregunta 4 (Volumen de Colaboraciones): Dentro de la comunidad con mayor densidad interna 
// detectada en la Pregunta 2, ¿cuáles son los 5 aRTIST con el mayor Degree Centrality (Grado de Centralidad) 
// considerando únicamente la relación :COLABORÓ_CON?

// Pregunta 5 (Accesibilidad y Cercanía - Seguimiento): De los 5 aRTIST preseleccionados con mayor grado, 
// ¿cuál de ellos tiene la mayor Closeness Centrality (Centralidad de Cercanía) calculada de forma aislada dentro de su 
// subgrafo comunitario?

// Pregunta 6 (Prestigio e Influencia Real - Seguimiento): Al ejecutar el algoritmo de PageRank sobre el subgupo analizado, 
// ¿cuál es el artista que obtiene el mayor puntaje de relevancia?