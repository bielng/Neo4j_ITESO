/**

How to use MATCH to read data

How to use MERGE to write data

**/
MATCH (n:Person)
WHERE n.name = 'Tom Hanks'
RETURN n

MATCH (m:Movie)<-[r:ACTED_IN]-(p:Person)
WHERE m.title = 'Toy Story'
RETURN m, r, p

MATCH (m:Movie)-[r:IN_GENRE]->(g:Genre)
WHERE m.title = 'Toy Story'
RETURN m, r, g

MATCH (u:User)-[r:RATED]->(m:Movie)
WHERE u.name = "Mr. Jason Love"
RETURN u, r, m

MATCH (u:User)-[r:RATED]->(m:Movie)
WHERE u.name = "Mr. Jason Love"
RETURN u.name, r.rating, m.title

MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE p.name = 'Tom Hanks'
RETURN p.name AS person, m.title AS title, r.role AS role

MERGE (m:Movie {title: "Arthur the King"})
SET m.released = datetime('2024-01-01')
RETURN m

MERGE (m:Movie {title: "Arthur the King"})
MERGE (u:User {name: "Adam"})
MERGE (u)-[r:RATED {rating: 5}]->(m)
RETURN u, r, m

/// Cypher

MATCH (p:Person)
WHERE p.name = 'Tom Hanks' OR p.name = 'Rita Wilson'
RETURN p.name, p.born

// Traversing Relationships

MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE 2000 <= m.released <= 2003
RETURN p.name, m.title, m.released

MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name = 'Jack Nicholson' AND m.tagline IS NOT NULL
RETURN m.title, m.tagline

/**
Cypher has a set of string-related keywords that you can use in your WHERE clauses to test string property values. You can specify STARTS WITH, ENDS WITH, and CONTAINS.
**/

MATCH (p:Person)-[:ACTED_IN]->()
WHERE p.name STARTS WITH 'Michael'
RETURN p.name

MATCH (p:Person)-[:ACTED_IN]->()
WHERE toLower(p.name) STARTS WITH 'michael'
RETURN p.name

MATCH (p:Person)-[:WROTE]->(m:Movie)
WHERE NOT exists((p)-[:DIRECTED]->(m))
RETURN p.name, m.title

MATCH (p:Person)
WHERE p.born IN [1965, 1970, 1975]
RETURN p.name, p.born

MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE 'Neo' IN r.roles AND m.title = 'The Matrix'
RETURN p.name, r.roles

MERGE (p:Person {name: 'Michael Caine'})

MATCH (p:Person {name: 'Daniel Kaluuya'})
RETURN p

MATCH (p:Person {name: 'Michael Caine'})
MATCH (m:Movie {title: 'The Dark Knight'})
MERGE (p)-[:ACTED_IN]->(m)

MATCH
  (p:Person {name: 'Michael Caine'})-[:ACTED_IN]-
  (m:Movie {title: 'The Dark Knight'})
RETURN p, m

MERGE (p:Person {name: 'Chadwick Boseman'})
MERGE (m:Movie {title: 'Black Panther'})
MERGE (p)-[:ACTED_IN]-(m)

MERGE
  (p:Person {name: 'Emily Blunt'})-[:ACTED_IN]->
  (m:Movie {title: 'A Quiet Place'})
RETURN p, m

// Updating Properties

MATCH (p:Person {name: 'Michael Caine'})
MERGE (m:Movie {title: 'Batman Begins'})
MERGE (p)-[:ACTED_IN {roles: ['Alfred Penny']}]->(m)
RETURN p, m

MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE p.name = 'Michael Caine' AND m.title = 'The Dark Knight'
SET r.roles = ['Alfred Penny']
RETURN p, r, m

MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE p.name = 'Michael Caine' AND m.title = 'The Dark Knight'
SET r.roles = ['Alfred Penny'], m.released = 2008
RETURN p, r, m

MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE p.name = 'Michael Caine' AND m.title = 'The Dark Knight'
SET r.roles = ['Mr. Alfred Penny']
RETURN p, r, m

// Removing properties

MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE p.name = 'Michael Caine' AND m.title = 'The Dark Knight'
REMOVE r.roles
RETURN p, r, m

// Alternative: Setting to null

MATCH (p:Person)
WHERE p.name = 'Gene Hackman'
SET p.born = null
RETURN p

// Merge Processing

// Find or create a person with this name
MERGE (p:Person {name: 'Michael Caine'})

// Find or create a movie with this title
MERGE (m:Movie {title: 'The Cider House Rules'})

// Find or create a relationship between the two nodes
MERGE (p)-[:ACTED_IN]->(m)

// Adding or Updating a Movie

MERGE (m:Movie {title: 'Rocketman'})
  ON CREATE SET m.createdAt = datetime()
  ON MATCH SET m.updatedAt = datetime()
SET
  m.tagline = "The Only Way to Tell His Story is to live His Fantasy.",
  m.released = 2019
RETURN m

// Deleting Data

MERGE (p:Person {name: 'Jane Doe'})

MATCH (p:Person {name: 'Jane Doe'})
DELETE p

MATCH
  (p:Person {name: 'Jane Doe'})-[r:ACTED_IN]->(m:Movie {title: 'The Matrix'})
DELETE r
RETURN p, m

MATCH (p:Person {name: 'Jane Doe'})
MATCH (m:Movie {title: 'The Matrix'})
MERGE (p)-[:ACTED_IN]->(m)
RETURN p, m

MATCH (p:Person {name: 'Jane Doe'})
DETACH DELETE p

MATCH (n)
DETACH DELETE n

MATCH (p:Person {name: 'Jane Doe'})
SET p: Developer
RETURN p

MATCH (p:Person {name: 'Jane Doe'})
REMOVE p: Developer
RETURN p

MATCH (p:Person {name: 'Jane Doe'})
DETACH DELETE p

CALL db.labels()

MATCH (e:Person {name: "Emil Eifrem"})-[]->(n)
DETACH DELETE e, n