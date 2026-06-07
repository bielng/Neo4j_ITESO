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