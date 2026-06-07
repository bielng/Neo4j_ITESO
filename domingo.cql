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

/**

Identifying a New Relationship

**/

MATCH (sandy:User {name: 'Sandy Jones'})
MATCH (clinton:User {name: 'Clinton Spencer'})
MATCH (apollo:Movie {title: 'Apollo 13'})
MATCH (sleep:Movie {title: 'Sleepless in Seattle'})
MATCH (hoffa:Movie {title: 'Hoffa'})
MERGE (sandy)-[:RATED {rating: 5}]->(apollo)
MERGE (sandy)-[:RATED {rating: 4}]->(sleep)
MERGE (clinton)-[:RATED {rating: 3}]->(apollo)
MERGE (clinton)-[:RATED {rating: 3}]->(sleep)
MERGE (clinton)-[:RATED {rating: 3}]->(hoffa)

//Testing with Instance Model

// Use case #1: What people acted in a movie?

MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Sleepless in Seattle'
RETURN p.name AS Actor

//Use case #2: What person directed a movie?
MATCH (p:Person)-[:DIRECTED]-(m:Movie)
WHERE m.title = 'Hoffa'
RETURN p.name AS Director

// Use case #3: What movies did a person act in?
MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks'
RETURN m.title AS Movie

// Use case #4: How many users rated a movie?
MATCH (u:User)-[:RATED]-(m:Movie)
WHERE m.title = 'Apollo 13'
RETURN count(*) AS `Number of reviewers`

//Use case #5: Who was the youngest person to act in a movie?
MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Hoffa'
RETURN p.name AS Actor, p.born AS `Year Born`
ORDER BY p.born DESC
LIMIT 1

// Use case #6: What role did a person play in a movie?
MATCH (p:Person)-[r:ACTED_IN]-(m:Movie)
WHERE m.title = 'Sleepless in Seattle' AND p.name = 'Meg Ryan'
RETURN r.role AS Role

// Use case #7: What is the highest rated movie in a particular year according to imDB?
MATCH (m:Movie)
WHERE m.released STARTS WITH '1995'
RETURN m.title AS Movie, m.imdbRating AS Rating
ORDER BY m.imdbRating DESC
LIMIT 1

MERGE
  (casino:Movie
    {
      title: 'Casino',
      tmdbId: 524,
      released: '1995-11-22',
      imdbRating: 8.2,
      genres: ['Drama', 'Crime']
    })
MERGE (martin:Person {name: 'Martin Scorsese', tmdbId: 1032})
MERGE (martin)-[:DIRECTED]->(casino)

// Use case #8: What drama movies did an actor act in?
MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks' AND 'Drama' IN m.genres
RETURN m.title AS Movie

// Use case #9: What users gave a movie a rating of 5?
MATCH (u:User)-[r:RATED]-(m:Movie)
WHERE m.title = 'Apollo 13' AND r.rating = 5
RETURN u.name AS Reviewer



/**
Refactoring
**/


MATCH (p:Person)-[:ACTED_IN]-()
WHERE p.born < '1950'
RETURN p.name


// PROFILE MATCH (p:Person)-[:ACTED_IN]-()
WHERE p.born < '1950'
RETURN p.name


MATCH (p:Person)
WHERE exists ((p)-[:ACTED_IN]-())
SET p:Actor




// Adding the Actor Label

MATCH (p:Actor)
RETURN p


//

MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Sleepless in Seattle'
RETURN p.name AS Actor

MATCH (p:Actor)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Sleepless in Seattle'
RETURN p.name AS Actor


MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks'
RETURN m.title AS Movie

MATCH (p:Actor)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks'
RETURN m.title AS Movie


MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Hoffa'
RETURN  p.name AS Actor, p.born as `Year Born` ORDER BY p.born DESC LIMIT 1

MATCH (p:Actor)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Hoffa'
RETURN  p.name AS Actor, p.born as `Year Born` ORDER BY p.born DESC LIMIT 1


MATCH (p:Person)-[r:ACTED_IN]-(m:Movie)
WHERE m.title = 'Sleepless in Seattle' AND
p.name = 'Meg Ryan'
RETURN  r.role AS Role

MATCH (p:Actor)-[r:ACTED_IN]-(m:Movie)
WHERE m.title = 'Sleepless in Seattle' AND
p.name = 'Meg Ryan'
RETURN  r.role AS Role




MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks' AND
'Drama' IN m.genres
RETURN m.title AS Movie

MATCH (p:Actor)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks' AND
'Drama' IN m.genres
RETURN m.title AS Movie



MATCH (p:Person)
WHERE p.born < '1950'
RETURN p.name

MATCH (p:Actor)
WHERE p.born < '1950'
RETURN p.name


// Adding the Director Label



// Eliminating Duplicate Data

// Adding Language Data

MATCH (apollo:Movie {title: 'Apollo 13'})
MATCH (sleep:Movie {title: 'Sleepless in Seattle'})
MATCH (hoffa:Movie {title: 'Hoffa'})
MATCH (casino:Movie {title: 'Casino'})
SET apollo.languages = ['English']
SET sleep.languages =  ['English']
SET hoffa.languages =  ['English', 'Italian', 'Latin']
SET casino.languages =  ['English']


MATCH (m:Movie)
WHERE 'Italian' IN m.languages
RETURN m.title




// Refactoring Duplicate Data

// Creating Language Nodes



MATCH (m:Movie)
UNWIND m.languages AS language

MERGE (l:Language {name:language})
MERGE (m)-[:IN_LANGUAGE]->(l)
SET m.languages = null

/**

MATCH (m:Movie)
WHERE 'Italian' IN m.languages
RETURN m.title

**/


MATCH (m:Movie)-[:IN_LANGUAGE]-(l:Language)
WHERE  l.name = 'Italian'
RETURN m.title


// Adding Genre nodes

MATCH (m:Movie)
UNWIND m.genres AS genre
MERGE (g:Genre {name:genre})
MERGE (m)-[:IN_GENRE]->(g)
SET m.languages = null

MATCH (m:Movie)-[:IN_GENRE]->(g:Genre)
RETURN m.title, g.name;

MATCH (p:Actor)-[:ACTED_IN]->(m:Movie)-[:IN_GENRE]->(g:Genre)
WHERE p.name = 'Tom Hanks'
  AND g.name = 'Drama'
RETURN m.title AS Movie;


// Eliminating Complex Data in Nodes

// Specific Relationships

MATCH (n:Actor)-[:ACTED_IN]->(m:Movie)
CALL apoc.merge.relationship(n,
  'ACTED_IN_' + left(m.released,4),
  {},
  {},
  m ,
  {}
) YIELD rel
RETURN count(*) AS `Number of relationships merged`;


MATCH (n:Actor)-[:ACTED_IN]->(m:Movie)
CALL apoc.merge.relationship(n,
  'ACTED_IN_' + left(m.released,4),
  {},
  {},
  m ,
  {}
) YIELD rel
RETURN count(*) AS `Number of relationships merged`;



MATCH (p:Actor)-[:ACTED_IN_1995]->(m:Movie)
WHERE p.name = 'Tom Hanks'
RETURN m.title AS Movie



MATCH (n:Person)-[:DIRECTED]->(m:Movie)
CALL apoc.merge.relationship(n,
  'DIRECTED_' + left(m.released,4),
  {},
  {},
  m ,
  {}
) YIELD rel
RETURN count(*) AS `Number of relationships merged`


MATCH (p:Person)-[:ACTED_IN_1995|DIRECTED_1995]->()
RETURN p.name as `Actor or Director`



// Modify this query to use the -[:RATED]->()
// relationship to create a new RATED_{rating}
// relationship between the :User and a :Movie
MATCH (u:User)-[:RATED]->(m:Movie)
CALL apoc.merge.relationship(u,
  'RATED_' + left(m.released,4),
  {},
  {},
  m ,
  {}
) YIELD rel
RETURN count(*) AS `Number of relationships merged`


MATCH (u:User)-[r:RATED]->(m:Movie)
WHERE m.title = 'Apollo 13' AND
r.rating = 5
RETURN u.name as Reviewer




MATCH (u:User)-[r:RATED]->(m:Movie)
CALL apoc.merge.relationship(
  u,
  'RATED_' + r.rating,
  {},
  {},
  m,
  {}
) YIELD rel
RETURN count(*) AS `Number of relationships merged`;



// Adding Intermediate Nodes


MATCH (a:Actor)-[r:ACTED_IN]->(m:Movie)
MERGE (ro:Role {name: r.role})
MERGE (a)-[:PLAYED]->(ro)
MERGE (ro)-[:IN_MOVIE]->(m)
RETURN count(ro) AS `Number of roles processed`;


MATCH (a:Actor)-[:PLAYED]->(ro:Role)-[:IN_MOVIE]->(m:Movie)
RETURN a.name AS Actor, ro.name AS Role, m.title AS Movie;


