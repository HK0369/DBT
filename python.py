import random
import string
import pymysql

# Generate random data functions
def random_string(length):
    return ''.join(random.choice(string.ascii_lowercase) for i in range(length))

def random_date(start_year, end_year):
    year = random.randint(start_year, end_year)
    month = random.randint(1, 12)
    day = random.randint(1, 28)
    return f"{year}-{month:02d}-{day:02d}"

# Connect to database
connection = pymysql.connect(host="localhost", user="root", password="1234567890", database="dbt24_a1_pes1ug21cs217_harikrishna")
cursor = connection.cursor()

# Insert data into Directors
directors = []
for i in range(100):
    name = random_string(20)
    dob = random_date(1940, 2000)
    directors.append((name, dob))
cursor.executemany("INSERT INTO Directors (name, dob) VALUES (%s, %s)", directors)

# Insert data into Genres
genres = ["Action", "Comedy", "Drama", "Thriller", "Sci-Fi"]
cursor.executemany("INSERT INTO Genres (name) VALUES (%s)", genres)

# Insert data into Actors
actors = []
for i in range(10000):  # 10,000 Actors
    name = random_string(20)
    dob = random_date(1960, 2005)
    actors.append((name, dob))
cursor.executemany("INSERT INTO Actors (name, dob) VALUES (%s, %s)", actors)

# Insert data into Movies
movies = []
for i in range(10000):
    title = random_string(50)
    release_year = random.randint(1990, 2023)
    director_id = random.randint(1, 100)
    genre_id = random.randint(1, 5)
    cursor.execute("INSERT INTO Movies (title, release_year, director_id, genre_id) VALUES (%s, %s, %s, %s)",
                   (title, release_year, director_id, genre_id))
    movie_id = cursor.lastrowid
    movies.append(movie_id)

# Insert data into Cast with reference to existing movies and actors
cast = []
for movie_id in movies:
    num_actors = random.randint(1, 3)
    actor_ids = random.sample(range(1, 10001), num_actors)
    for actor_id in actor_ids:
        character_name = random_string(20)
        cast.append((movie_id, actor_id, character_name))

cursor.executemany("INSERT INTO Cast (movie_id, actor_id, character_name) VALUES (%s, %s, %s)", cast)

# Commit changes and close connection
connection.commit()
cursor.close()
connection.close()

print("Data insertion completed!")
