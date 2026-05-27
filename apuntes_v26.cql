

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
  (P)-[rc:ES_PARTE_DE]->(cat);

// Show the complete graph

MATCH (n)-[r]->(m)
RETURN n, r, m;

OPTIONAL MATCH (nodge_without_connections)
MATCH (n)-[r]->(m)
RETURN nodge_without_connections, n, r, m;

// the schema

CALL db.schema.visualization;

//

CREATE (p:Persona {nombre: 'Juan'})-[:AMIFO]->(op:Persona {nombre: 'Pedro'});

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