

// comments en Cypher CQL

// Graph

// Nodes

()
(:Producto)
(:PRODUCTO)
(:producto)

// Edges or Relations
-[:BUY] -> 
<- [:SEARCH] -
-[:ES_PARTE_DE] ->

// Attributes

{}
{nombre:'electronicos'}

// CREATE NEW NODE

CREATE (:Producto);

CREATE (:Producto {nombre: 'cellular'});
CREATE (:Producto {nombre: 'cellular', precio: 1200});

// Create a new database with name 'EXAMPLE'

CREATE DATABASE ejemplos;

// Apunta a la nueva base de datos

//:use ejemplos;

// Limpiar las ventnas

//:clear;

// SQL

/** select nombre
from Clientes
where idCliente = 2;

IN CYPHER

SELECT - RETURN
FROM   - MATCH
WHERE - WHERE 

MATCH
WHERE
RETURN

SELECT c.nombre
FROM Clientes AS c
WHERE IdCliente = 2;

MARCH  (c:Clientes)
WHERE  c.IdClientes = 2
RETURN c.nombre;


SELECT 'Hello Class';

RETURN 'Hola Clase';

SELECT 19 * 20; 

RETURN 19 * 20;
**/

//CREATE (:Producto);

//CREATE (:Producto {nombre: 'cellular'});
//CREATE (:Producto {nombre: 'cellular', precio: 1200});

//Consulta para que me muestre todos tipo Producto

MATCH (p:Producto)
RETURN p;

MATCH (p:Producto)
RETURN p.nombre, p.precio;

// wednesday 27

// Create a complete graph

CREATE
  (p:Producto),
  (c:Cliente),
  (cat:Categoria),
  (c)-[r:BUSCO]->(p),
  (c)-[buy:COMPRO]->(p),
  (p)-[rc:ES_PARTE_DE]->(cat);

// Show the complete graph

MATCH (n)-[r]->(m)
RETURN n, r, m;

OPTIONAL MATCH (nodge_without_connections)
MATCH (n)-[r]->(m)
RETURN nodge_without_connections, n, r, m;

// the schema

CALL db.schema.visualization;

//

CREATE (p:Persona {nombre: 'Juan'})-[:AMIGO]->(op:Persona {nombre: 'Pedro'});

// counts the nodes

MATCH (p:Persona)
RETURN COUNT(p) AS NumeroNodosPersona;

//

MATCH (p:Producto)
RETURN COUNT(p) AS NumeroNodosProducto;

//

MATCH (p:Categoria)
RETURN COUNT(p) AS NumeroNodosCategoria;

//
MATCH (p:Cliente)
RETURN COUNT(p) AS NumeroNodosCliente;

// create both nodes and edges

MATCH (n)
DETACH DELETE n;


// agregations functions

COUNT(), SUM(), AVG(), MAX(), MIN()

// Cypher extra functions\

COUNT(), SUM(), AVG(), MAX(), MIN(), COLLECT()

// 

MATCH (p:Producto)
RETURN COUNT(p) AS NumProductos, COLLECT(p.nombre);

MATCH (p:Producto)
RETURN COUNT(p.nombre) AS NumNombresProductos, COLLECT(p.nombre);



/**
1. Crea una base de datos nueva llamda 'amigos'
2. Dentro de bases de datos 'amigos'
3. Crea los 5 nodos tipo :Amigo con nombre (libre)
4. crea 10 relationes :AMIGO_DE entre los nodos :Amigo que decidas (libre)
5. Muestra el esquema del grafo
6. Muestra el grafo completa
7. Crea una consulta que me diga cuantos nombres de :Amigo hay y cuales son los nombres
**/
// 

CREATE DATABASE amigos;

:use amigos;


CREATE
  (t:Amigo{nombre:'TAJ'}),
  (c:Amigo{nombre:'Chris'}),
  (u:Amigo{nombre:'Ubaldo'}),
  (g:Amigo{nombre:'Gatwech'}),
  (f:Amigo{nombre:'Fahmo'}), 

  (t)-[:AMIGO_DE]->(c),
  (t)-[:AMIGO_DE]->(u),
  (t)-[:AMIGO_DE]->(g),

  (c)-[:AMIGO_DE]->(u),
  (c)-[:AMIGO_DE]->(f),

  (u)-[:AMIGO_DE]->(g),
  (u)-[:AMIGO_DE]->(f),

  (g)-[:AMIGO_DE]->(f),
  (g)-[:AMIGO_DE]->(c),

  (f)-[:AMIGO_DE]->(t);



// show the complete graph 
OPTIONAL MATCH (z)
MATCH (n)-[r]->(m)
RETURN n, r, m;

// visualise the schema
CALL db.schema.visualization;

// to count name and show them

MATCH (a:Amigo)
RETURN COUNT(a.nombre) AS NumeroDeNombres, COLLECT(a.nombre) AS Nombres;


// 28th of may, 2026


// Fahmo's friend

MATCH (a:Amigo{nombre:'TAJ'})
MATCH (n:Amigo{nombre:'Fahmo'})
CREATE (a)-[r:AMIGO_DE]->(n)
RETURN a, r, n;

// Clear a relationship 

// MATCH (a:Amigo{})

MATCH (a:Amigo {nombre:'TAJ'})-[r:AMIGO_DE]->(n:Amigo {nombre:'Fahmo'})
DELETE r;


// in_degree and out_degree of Fahmo ..... 



// Out_Degree Fahmo

MATCH (a:Amigo {nombre:'Fahmo'})-[r:AMIGO_DE]->(m)
RETURN a.nombre, COUNT(r) AS Out_Degree;
// In_Degree Fahmo

MATCH (a:Amigo {nombre:'Fahmo'})<-[r:AMIGO_DE]-(m)
RETURN a.nombre, COUNT(r) AS In_Degree;

// Degree

MATCH (a:Amigo {nombre:'Fahmo'})-[r:AMIGO_DE]-(m)
RETURN a.nombre, COUNT(r) AS Degree;

// 

MATCH (n:Amigo {nombre:'Fahmo'})-[r:AMIGO_DE]->(m)
MATCH (n)<-[r:AMIGO_DE]-(y)
MATCH (n)-[r:AMIGO_DE]-(c)
RETURN n.nombre, COUNT(r) AS Out_Degree,
  COUNT(x) AS In_Degree,
  COUNT(b) AS Degree;


// 

CALL {

}

// Correction

MATCH (n:Amigo{nombre:'TAJ'})
CALL{
  WITH n
  MATCH (n)<-[b:AMIGO_DE]-()
  RETURN COUNT(b) AS In_Degree
}

CALL{
  WITH n
  MATCH (n)-[b:AMIGO_DE]->()
  RETURN COUNT(b) AS Out_Degree
}

CALL{
  WITH n
  MATCH (n)-[b:AMIGO_DE]-()
  RETURN COUNT(b) AS Degree
}

RETURN n.nombre,In_Degree, Out_Degree, Degree; 


CREATE DATABASE movies;

:use movies;

:welcome;





//

// number of the person - Node

MATCH (p:Person)
RETURN COUNT(DISTINCT p) as NumPerson;
// 133 person node, 38 movie node

// Count the relationships

MATCH ()-[r:FOLLOWS]->()
RETURN COUNT(DISTINCT r) as NumFOLLOWS;
// NumFOLLOWS

// count of relationships

MATCH ()-[r:WROTE]->()
RETURN COUNT(DISTINCT r) as NumWROTE;

MATCH ()-[r:DIRECTED]->()
RETURN COUNT(DISTINCT r) as NumDIRECTED;


MATCH ()-[r:REVIEWED]->()
RETURN COUNT(DISTINCT r) as NumREVIEWED;


MATCH ()-[r:PRODUCED]->()
RETURN COUNT(DISTINCT r) as NumPRODUCTED;


MATCH ()-[r:ACTED_IN]->()
RETURN COUNT(DISTINCT r) as NumACTED_IN;

//

call db.schema.relTypeProperties;

//
call db.schema.nodeTypeProperties;


// Tom hanks

MATCH (p:Person{name:'Tom Hanks'})-[r:ACTED_IN]->(m:Movie)
RETURN p, r, m;


/**
1. En cuantas peliculas ha actuado Tom Hanks
2. Cual es el nombre de las personas que actuaron en Appolo 13

3. 

**/

MATCH (p:Person {name: 'Tom Hanks'})-[:ACTED_IN]->(m:Movie)
RETURN COUNT(m) AS NumberOfMovies;

MATCH (p:Person)-[:ACTED_IN]->(m:Movie {title: 'Apollo 13'})
RETURN p.name AS ActorName;


MATCH (p1:Person)-[:FOLLOWS]->(p2:Person)
RETURN p1.name AS Follower,
       p2.name AS Following;



/**
1. Cuantas peliculas hasy en la base de datos
2. Lista de todas las peliculas con su ano de lanzamiento 
3. Cuantos actores hay en la base de datos 
4. cuantas personas han dirigido peliculas 
5. Que actores han participado en la pelicula the Matrix

**/


MATCH (m:Movie)
return COUNT (DISTINXT m);

/**MATCH (m:Movie)
return m.title, m.released;**/

MATCH (m:Movie)
RETURN m.title AS Movie_Title,
       m.released AS Release_Year
       ORDER BY m.released DESC, m.title;


MATCH (p:Person)-[:ACTED_IN]->(:Movie)
RETURN COUNT(DISTINCT p) AS Total_Actors;

//

MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
RETURN p.name AS NumPerson, COLLECT (DISTINCT m.title);
// 


MATCH (p:Person)-[:DIRECTED]->(:Movie)
RETURN COUNT(DISTINCT p) AS Total_Directors;


MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE m.title = 'The Matrix'
RETURN p.name AS Actor_Name;

// Keanu Reeves

MATCH (p:Person{name:'Keanu Reeves'})-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(op:Person)
RETURN p.name, m.title, op.name;

/// 

MATCH (p:Person{name:'Keanu Reeves'})-[]->(m:Movie)<-[]-(op:Person)-[]->(om:Movie)<-[]-(ap:Person)
RETURN COUNT(ap);


// 

MATCH (p:Person{name:'Keanu Reeves'})-[*1]-(m)
RETURN COUNT (DISTINCT m) AS Nodos;

//

MATCH (p:Person{name:'Keanu Reeves'})-[*2]-(m)
RETURN COUNT (DISTINCT m) AS Nodos;

// 

MATCH (p:Person{name:'Keanu Reeves'})-[*3]-(m)
RETURN COUNT (DISTINCT m) AS Nodos;

//

MATCH (p:Person{name:'Keanu Reeves'})-[*4]-(m)
RETURN COUNT (DISTINCT m) AS Nodos;

//

MATCH (p:Person{name:'Keanu Reeves'})-[*1..2]-(m)
RETURN COUNT (DISTINCT m) AS Nodos;

// 

MATCH (p:Person{name:'Keanu Reeves'})-[r]-(m)
RETURN p, r, m;


//

MATCH (p:Person{name:'Tom Hanks'})-[*1]-(m)
RETURN COUNT (DISTINCT m) AS Nodos;


//element ID
MATCH (p:Person{name:'Keanu Reeves'})
RETURN p.name, elementid(p);
///

MATCH (n)
WHERE elementid(n) = '4:df934316-0daa-4190-a99b-fb8ce540a7ce:1'
RETURN n;

/// 

:param KR => 'Keanu Reeves';


MATCH (p:Person)
WHERE p.name = $KR
RETURN p.name, elementid(p);

/// 
OPTION MATCH (z)
MATCH (n)-[r]-(m)
RETURN z, n, r, m;


// 02 junio 2026

CALL db.schema.visualization;

///

MATCH (p:Person)
RETURN p.name, p.born;

//

/**

Muestra la ruta mas corta entre "You've Got Mail" y "Cast Away"
Habilita una regla que cambie el tamano de los nodos Movie con respecto al atributo released. 0.25 para menor y 4x para el mayor
Cambia el color de las relationship FOLLOWS a color azul

**/


MATCH (p:Person{name:'River Phoenix'})-[r]->(m)
RETURN p, r, m;


/**

En explore, Realiza una consulta que reciba el nombre de un a pelicula y regrese al grafo a dos saltos

MATCH (m:Movie)-[r*1..2]-(n)
WHERE m.title = $jina
RETURN m, r, n;

En query. Realiza una consulta que reciba el nombre de un actor , como parametro y regre el titulo de las peliculas en las que ha actuado y como lista el nombre de los actores que 
tambien participaron en la misma pelicula 


**/


//MATCH (m:Movie)-[*2]-(om)
//WHERE m.title = $jina
//RETURN m, om;

///


MATCH (m:Movie)-[r*1..2]-(n)
WHERE m.title = $jina
RETURN m, r, n;
//


:param TH => 'Tom Hanks';


MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)<-[r2:ACTED_IN]-(op:Person)
WHERE p.name = $TH
RETURN m.title AS FILM, COLLECT(DISTINCT op.name) AS ACTORS;


//

MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)<-[r2:ACTED_IN]-(op:Person)
WHERE p.name = $TH AND op.name <> $TH
RETURN m.title AS FILM, COLLECT(DISTINCT op.name) AS ACTORS;



/// date 03/06/2026 Dashboard with Neo4j

CALL db.schema.visualization;


// Bar chart 

// Nombre de la pelicula y el numero de actores que participan en ella

MATCH (m:Movie)<-[r:ACTED_IN]-(p:Person)
RETURN m.title AS FILM, COUNT(DISTINCT p.name) AS ACTORS
ORDER BY ACTORS DESC;


/**MATCH (m:Movie)<-[:ACTED_IN]-(p:Person)
RETURN m.title AS FILM,
       COUNT(DISTINCT p.name) AS ACTORS
ORDER BY ACTORS DESC;**/


// line graph of the movies and count of actors
// Pie chart - numero de peliculas por actor

MATCH (p:Person)-[ACTED_IN]->(m:Movie)
RETURN p.name AS ACTOR, COUNT(DISTINCT m.title) AS NumPeliculas
ORDER BY NumPeliculas DESC;


// 

MATCH (p:Person)
RETURN COUNT(DISTINCT p.name);





