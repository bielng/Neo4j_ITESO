

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