create database dbt24_a1_pes1ug21cs217_harikrishna;
show databases;
use dbt24_a1_pes1ug21cs217_harikrishna;
create table Movies (movie_id int primary key auto_increment, title varchar(255) not null, release_year int, director_id int references Directors (director_id), genre_id int references Genres (genre_id));
create table Directors (director_id int primary key auto_increment, name varchar(255) not null, dob date);
create table Genres (genre_id int primary key auto_increment, name varchar(255) not null);
create table Cast (movie_id int references Movies(movie_id), actor_id int references Actors(actor_id), character_name varchar(255), primary key(movie_id, actor_id));
create table Actors(actor_id int primary key auto_increment, name varchar(255) not null, dob date);
insert into actors values('1', 'PES1UG21CS217 Harikrishna', '2003-09-09');
select * from Actors;


-- populate the database (with random values) with a python file

-- display the data and count of the movies table
select * from movies;
select count(*) from movies;

-- display the data and count of the directors table
select * from directors;
select count(*) from directors;

-- display the data and count of the genres table
select * from genres;
select count(*) from genres;

-- display the data and count of the cast table
select * from cast;
select count(*) from cast;

-- display the data and count of the actors table
select * from actors;
select count(*) from actors;

-- index scan example1
create index idx_mov_gen on movies(genre_id);
select * from movies where genre_id=2;
select count(*) from movies where genre_id=2;

-- index scan exmaple2
create index ix_mov_year_on on movies(release_year);
select * from movies where release_year=2000;
select count(*) from movies where release_year=2000;

-- table scan example1
select * from movies where release_year>2005;
select count(*) from movies where release_year>2005;

-- table scan example2
select * from actors where dob>'2004-07-19';
select count(*) from actors where dob>'2004-07-19';

-- simple three table join with normal select statement
select movies.title, genres.name as genre, actors.name as actor_name from movies join genres on movies.movie_id=genres.genre_id join cast on movies.movie_id=cast.movie_id join actors on cast.actor_id=actors.actor_id;

-- contitional select statement with three table join
select movies.title, actors.name as actor_name, cast.character_name from movies join cast on movies.movie_id=cast.movie_id join actors on cast.actor_id=actors.actor_id where movies.release_year>2010;

-- before indexing query execution
select movies.title, genres.name as genre, actors.name as actor_name, cast.character_name from cast join movies on cast.movie_id=movies.movie_id join genres on movies.genre_id=genres.genre_id join actors on cast.actor_id=actors.actor_id;
explain select movies.title, genres.name as genre, actors.name as actor_name, cast.character_name from cast join movies on cast.movie_id=movies.movie_id join genres on movies.genre_id=genres.genre_id join actors on cast.actor_id=actors.actor_id;

-- indexing
create index ix_mov_title on movies(title);
create index ix_mov_gen_id on movies(genre_id);
create index ix_act_name on actors(name);
create index ix_cst_mov_id on cast (movie_id);
create index ix_cst_act_id on cast (actor_id);

-- after indexing query execution
select movies.title, genres.name as genre, actors.name as actor_name, cast.character_name from cast join movies on cast.movie_id=movies.movie_id join genres on movies.genre_id=genres.genre_id join actors on cast.actor_id=actors.actor_id;
explain select movies.title, genres.name as genre, actors.name as actor_name, cast.character_name from cast join movies on cast.movie_id=movies.movie_id join genres on movies.genre_id=genres.genre_id join actors on cast.actor_id=actors.actor_id;


-- base query before optimization techniques
select movies.title, genres.name as genre_name, actors.name as actor_name, cast.character_name from cast join movies on cast.movie_id=movies.movie_id join genres on movies.genre_id=genres.genre_id join actors on cast.actor_id=actors.actor_id;
explain select movies.title, genres.name as genre_name, actors.name as actor_name, cast.character_name from cast join movies on cast.movie_id=movies.movie_id join genres on movies.genre_id=genres.genre_id join actors on cast.actor_id=actors.actor_id;

-- optimization techniques :-
-- altering the join order of tables in multi-table join queries example1
select movies.title, genres.name as genre, actors.name as actor_name, cast.character_name from movies join genres on movies.genre_id=genres.genre_id join cast on movies.movie_id=cast.movie_id join actors on cast.actor_id=actors.actor_id;

-- altering the join order of tables in multi-table join queries example2
select movies.title, genres.name as genre, actors.name as actor_name, cast.character_name from cast join actors on cast.actor_id=actors.actor_id join movies on cast.movie_id=movies.movie_id join genres on movies.genre_id=genres.genre_id;

-- variety of join types such as left joins
select movies.title, genres.name as genre, actors.name as actor_name, cast.character_name from movies join genres on movies.genre_id=genres.genre_id left join cast on movies.movie_id=cast.movie_id left join actors on cast.actor_id=actors.actor_id;

-- subqueries
select movies.title, genres.name as genre from movies join genres on movies.genre_id=genres.genre_id where movies.movie_id in (select movie_id from cast where actor_id=1);
select movies.title, genres.name as genre from movies join genres on movies.genre_id=genres.genre_id where movies.movie_id in (select movie_id from cast where actor_id=2);
