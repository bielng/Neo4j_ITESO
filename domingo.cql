// Creating Nodes
/**
Run the Cypher code below to:

Delete any nodes already existing in your sandbox.

Add the Person and Movie nodes to the graph which will serve as our initial instance model.
**/
MATCH (n)
DETACH DELETE n;

MERGE
  (:Movie
    {
      title: 'Apollo 13',
      tmdbId: 568,
      released: '1995-06-30',
      imdbRating: 7.6,
      genres: ['Drama', 'Adventure', 'IMAX']
    })
MERGE (:Person {name: 'Tom Hanks', tmdbId: 31, born: '1956-07-09'})
MERGE (:Person {name: 'Meg Ryan', tmdbId: 5344, born: '1961-11-19'})
MERGE (:Person {name: 'Danny DeVito', tmdbId: 518, born: '1944-11-17'})
MERGE (:Person {name: 'Jack Nicholson', tmdbId: 514, born: '1937-04-22'})
MERGE
  (:Movie
    {
      title: 'Sleepless in Seattle',
      tmdbId: 858,
      released: '1993-06-25',
      imdbRating: 6.8,
      genres: ['Comedy', 'Drama', 'Romance']
    })
MERGE
  (:Movie
    {
      title: 'Hoffa',
      tmdbId: 10410,
      released: '1992-12-25',
      imdbRating: 6.6,
      genres: ['Crime', 'Drama']
    })

// You can verify that the nodes have been created by running this code:

MATCH (n)
RETURN n

/**
Creating More Nodes



**/

MERGE (s:User {userId: 534})
SET s.name = "Sandy Jones"

MERGE (c:User {userId: 105})
SET c.name = "Clinton Spencer"

MATCH (u:User)
RETURN u.userId, u.name

/**

Modeling Relationships

**/

MATCH (apollo:Movie {title: 'Apollo 13'})
MATCH (tom:Person {name: 'Tom Hanks'})
MATCH (meg:Person {name: 'Meg Ryan'})
MATCH (danny:Person {name: 'Danny DeVito'})
MATCH (sleep:Movie {title: 'Sleepless in Seattle'})
MATCH (hoffa:Movie {title: 'Hoffa'})
MATCH (jack:Person {name: 'Jack Nicholson'})

// create the relationships between nodes
MERGE (tom)-[:ACTED_IN {role: 'Jim Lovell'}]->(apollo)
MERGE (tom)-[:ACTED_IN {role: 'Sam Baldwin'}]->(sleep)
MERGE (meg)-[:ACTED_IN {role: 'Annie Reed'}]->(sleep)
MERGE (danny)-[:ACTED_IN {role: 'Bobby Ciaro'}]->(hoffa)
MERGE (danny)-[:DIRECTED]->(hoffa)
MERGE (jack)-[:ACTED_IN {role: 'Jimmy Hoffa'}]->(hoffa)

MATCH (p:Person)-[a:ACTED_IN|DIRECTED]->(m:Movie)
RETURN p, a, m