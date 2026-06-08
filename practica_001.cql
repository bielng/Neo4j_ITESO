CREATE DATABASE Practica;: 
USE Practica;

CALL db.schema.visualization()

MATCH (p:Person)-[r:HABLA_CON]-(op:Person)
WHERE p.MovieChar = 'jango fett'
RETURN p, r, op

MATCH (p:Person)-[r:HABLA_CON]-(op:Person)
WHERE p.MovieChar = 'clone commander cody'
RETURN p, r, op

MATCH (p:Person)-[r]-(op)
RETURN
  p.MovieChar AS Nombre,
  count(r) AS Cantidad,
  collect(op.MovieChar) AS Persons
ORDER BY count(r) DESC
LIMIT 4

MATCH (p:Person {MovieChar: 'bib fortuna'})
CALL (p) {
  MATCH (p:Person)-[r]-(op)
  RETURN count(r) AS Degree
}
CALL (p) {
  MATCH (p:Person)<-[r]-(op)
  RETURN count(r) AS InDegree
}
CALL (p) {
  MATCH (p:Person)-[r]->(op)
  RETURN count(r) AS OutDegree
}
RETURN p.MovieChar AS Name, Degree, InDegree, OutDegree

MATCH (p:Person {MovieChar: 'lando'})-[r]-(op:Person)
RETURN
  p.MovieChar AS Name,
  count(r) AS Cantidad,
  collect(op.MovieChar) AS Persons

MATCH (p:Person)-[r*2]-(op:Person)
WHERE p.MovieChar = $person_moviechar
RETURN p, r, op

CREATE (:Person {MovieChar: 'Taban', Scenes: 110, UniqueID: 9999})

MERGE (taban:Person {MovieChar: 'Taban'})
MERGE (boba:Person {MovieChar: 'boba fett'})
MERGE (lando:Person {MovieChar: 'lando'})
MERGE (yoda:Person {MovieChar: 'yoda'})
MERGE (maul:Person {MovieChar: 'darth maul'})
MERGE (padme:Person {MovieChar: 'padme'})

MERGE (taban)-[:HABLA_CON]->(boba)
MERGE (taban)-[:HABLA_CON]->(lando)
MERGE (taban)-[:HABLA_CON]->(yoda)
MERGE (taban)-[:HABLA_CON]->(maul)
MERGE (taban)-[:HABLA_CON]->(padme)

MATCH (p:Person {MovieChar: 'Taban'})-[r]->(m)
RETURN p, r, m



// 
MATCH (p:Person)-[r*2]-(op:Person)
WHERE p.MovieChar = $person_moviechar
RETURN p, r, op


:param Personaje => 'qui-gon';



MATCH (p:Person)

CALL (p) {
    MATCH (p)<-[r]-()
    RETURN count(r) AS InDegree
}

RETURN p.MovieChar AS Personaje,
       InDegree
ORDER BY InDegree DESC