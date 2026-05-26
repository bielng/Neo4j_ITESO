

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