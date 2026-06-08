// Loading CSV files
LOAD CSV WITH HEADERS FROM 'https://data.neo4j.com/importing-cypher/people.csv' AS row
RETURN row

// Creating Nodes, Properties, and Relationships

LOAD CSV WITH HEADERS FROM 'https://data.neo4j.com/importing-cypher/persons.csv' AS row
MERGE (p:Person {tmdbId: toInteger(row.person_tmdbId)})
SET
  p.imdbId = toInteger(row.person_imdbId),
  p.bornIn = row.bornIn,
  p.name = row.name,
  p.bio = row.bio,
  p.poster = row.poster,
  p.url = row.url,
  p.born = row.born,
  p.died = row.died



LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/movies.csv' AS movies

RETURN movies
MERGE (m:Movie {tmdbId: toInteger(movies.movieId)})
SET
  m.movieId = toInteger(row.movieId),
  m.tmdbId = movies.tmdbId,
  m.imdbId = movies.imdbId,
  m.released = movies.released,
  m.title = movies.title,
  m.year = movies.year,
  m.bornplot = movies.plot,
  m.budget = movies.budget

/**
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/movies.csv' AS movies

MERGE (m:Movie {movieId: toInteger(movies.movieId)})
SET
    m.tmdbId = movies.tmdbId,
    m.imdbId = movies.imdbId,
    m.released = movies.released,
    m.title = movies.title,
    m.year = toInteger(movies.year),
    m.plot = movies.plot,
    m.budget = toInteger(movies.budget);
*/



// Unique IDs and Constraints

CREATE CONSTRAINT Person_tmdbId IF NOT EXISTS
FOR (x:Person)
REQUIRE x.tmdbId IS UNIQUE

SHOW CONSTRAINTS

DROP CONSTRAINT [constraint_name]


// ACTED_IN relationship

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/acted_in.csv' AS row
MATCH (p:Person {tmdbId: toInteger(row.person_tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (p)-[r:ACTED_IN]->(m)
SET r.role = row.role



LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/directed.csv' AS row
MATCH (p:Person {tmdbId: toInteger(row.person_tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (p)-[r:ACTED_IN]->(m)
SET r.role = row.role

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/directed.csv' AS row

MATCH (p:Person {tmdbId: toInteger(row.person_tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})

MERGE (p)-[:DIRECTED]->(m);

MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(p:Person)
RETURN p, m



// Data Types
CALL apoc.meta.nodeTypeProperties()
YIELD nodeType, propertyName, propertyTypes


/**Multi-value properties and lists

How to transform a string value into a list

The split function

**/

// list

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/movies.csv'
AS row
MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET
m.tmdbId = toInteger(row.movie_tmdbId),
m.imdbId = toInteger(row.movie_imdbId),
m.released = date(row.released),
m.title = row.title,
m.year = toInteger(row.year),
m.plot = row.plot,
m.budget = toInteger(row.budget),
m.imdbRating = toFloat(row.imdbRating),
m.poster = row.poster,
m.runtime = toInteger(row.runtime),
m.imdbVotes = toInteger(row.imdbVotes),
m.revenue = toInteger(row.revenue),
m.url = row.url,
m.countries = split(row.countries, '|')



/////

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/movies.csv'
AS row

MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET
    m.tmdbId = toInteger(row.movie_tmdbId),
    m.imdbId = toInteger(row.movie_imdbId),
    m.released = date(row.released),
    m.title = row.title,
    m.year = toInteger(row.year),
    m.plot = row.plot,
    m.budget = toInteger(row.budget),
    m.imdbRating = toFloat(row.imdbRating),
    m.poster = row.poster,
    m.runtime = toInteger(row.runtime),
    m.imdbVotes = toInteger(row.imdbVotes),
    m.revenue = toInteger(row.revenue),
    m.url = row.url,
    m.countries = split(row.countries, '|'),
    m.languages = split(row.languages, '|');





//

MATCH (p:Person)-[:ACTED_IN]->()
WITH DISTINCT p SET p:Actor


//

MATCH (a:Actor) RETURN a LIMIT 25

MATCH (p:Person)-[:ACTED_IN]->()
WITH DISTINCT p SET p:Actor


// Resetting the data
MATCH (Person)-[r:ACTED_IN]->(Movie) DELETE r;
MATCH (Person)-[r:DIRECTED]->(Movie) DELETE r;


//


MATCH (p:Person) DETACH DELETE p;
MATCH (m:Movie) DETACH DELETE m;

DROP CONSTRAINT Person_tmdbId IF EXISTS;
DROP CONSTRAINT Movie_movieId IF EXISTS;

CREATE CONSTRAINT Person_tmdbId IF NOT EXISTS
FOR (x:Person)
REQUIRE x.tmdbId IS UNIQUE;

CREATE CONSTRAINT Movie_movieId IF NOT EXISTS
FOR (x:Movie)
REQUIRE x.movieId IS UNIQUE;

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/persons.csv' AS row
MERGE (p:Person {tmdbId: toInteger(row.person_tmdbId)})
SET
p.imdbId = toInteger(row.person_imdbId),
p.bornIn = row.bornIn,
p.name = row.name,
p.bio = row.bio,
p.poster = row.poster,
p.url = row.url,
p.born = date(row.born),
p.died = date(row.died);

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/movies.csv' AS row
MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET
m.tmdbId = toInteger(row.movie_tmdbId),
m.imdbId = toInteger(row.movie_imdbId),
m.released = date(row.released),
m.title = row.title,
m.year = toInteger(row.year),
m.plot = row.plot,
m.budget = toInteger(row.budget),
m.imdbRating = toFloat(row.imdbRating),
m.poster = row.poster,
m.runtime = toInteger(row.runtime),
m.imdbVotes = toInteger(row.imdbVotes),
m.revenue = toInteger(row.revenue),
m.url = row.url,
m.countries = split(row.countries, '|'),
m.languages = split(row.languages, '|');

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/acted_in.csv' AS row
MATCH (p:Person {tmdbId: toInteger(row.person_tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (p)-[r:ACTED_IN]->(m)
SET r.role = row.role;

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/directed.csv' AS row
MATCH (p:Person {tmdbId: toInteger(row.person_tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (p)-[r:DIRECTED]->(m);

MATCH (p:Person)-[:ACTED_IN]->()
WITH DISTINCT p SET p:Actor;

MATCH (p:Person)-[:DIRECTED]->()
WITH DISTINCT p SET p:Director;



:auto
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/persons.csv'
AS row
CALL (row) {
    MERGE (p:Person {tmdbId: toInteger(row.person_tmdbId)})
    SET
    p.imdbId = toInteger(row.person_imdbId),
    p.bornIn = row.bornIn,
    p.name = row.name,
    p.bio = row.bio,
    p.poster = row.poster,
    p.url = row.url,
    p.born = date(row.born),
    p.died = date(row.died)
} IN TRANSACTIONS

