

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
