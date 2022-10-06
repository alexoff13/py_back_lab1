import sqlite3

import pandas as pd

connection = sqlite3.connect('library_lab.sqlite')
connection.executescript("""
drop table if exists genre;
drop table if exists publisher;
drop table if exists book;

create table publisher
(
    publisher_id   INTEGER primary key autoincrement,
    publisher_name VARCHAR(40)
);

insert into publisher (publisher_name)
values ('ЭКСМО'),
       ('ДРОФА'),
       ('АСТ');

create table genre
(
    genre_id   INTEGER primary key autoincrement,
    genre_name VARCHAR(30)
);

insert into genre (genre_name)
values ('Роман'),
       ('Приключения'),
       ('Поэзия');

create table book
(
    book_id           INTEGER primary key autoincrement,
    title             VARCHAR(80),
    genre_id          int,
    publisher_id      INT,
    year_publication  INT,
    available_numbers INT,
    foreign key (genre_id) references genre (genre_id) on delete cascade,
    foreign key (publisher_id) references publisher (publisher_id) on delete cascade
);
insert into book(title, genre_id, publisher_id, year_publication, available_numbers)
values ('Мастер и Маргарита', 1, 2, 2014, 5),
       ('Таинственный остров', 2, 2, 2015, 10),
       ('Бородино', 3, 3, 2015, 12),
       ('Дубровский', 1, 2, 2020, 7),
       ('Вокруг света за 80 дней', 2, 2, 2019, 5),
       ('Убийства по алфавиту', 1, 1, 2017, 9),
       ('Затерянный мир', 2, 1, 2020, 3),
       ('Герой нашего времени', 1, 3, 2017, 2),
       ('Смерть поэта', 3, 1, 2020, 2),
       ('Поэмы', 3, 3, 2019, 5);
""")
connection.commit()

print(
    pd.read_sql("""
select b.title,
       g.genre_name,
       b.available_numbers
from book as b
         inner join genre g
                    on b.genre_id = g.genre_id
where b.available_numbers between :a and :b
    """, con=connection, params={'a': 1, 'b': 3}))

print(
    pd.read_sql("""
select b.title,
       p.publisher_name,
       b.year_publication
from book as b
         inner join publisher as p
                    on b.publisher_id = p.publisher_id
where b.title not like '% %'
  and b.year_publication > :year_publication
    """, con=connection, params={'year_publication': 2013}))

print(
    pd.read_sql("""
select g.genre_name             as genre_name,
       sum(b.available_numbers) as available_numbers
from book as b
         left join genre as g
                    on g.genre_id = b.genre_id
where b.year_publication > :year_publication
group by genre_name
    """, con=connection, params={'year_publication': 2013}))

df = pd.read_sql("""
select b.title             as "Книга",
       g.genre_name        as "Жанр",
       p.publisher_name    as "Издательство",
       b.available_numbers as "Количество"
from book as b
         inner join genre as g
                    on g.genre_id = b.genre_id
         inner join publisher as p
                    on p.publisher_id = b.publisher_id
where b.available_numbers > 3
""", con=connection)
print(df)
print(df.Книга)
print(df.loc[2])
print('Количество строк: {}, Количество столбцов: {}'.format(*df.shape))
print(df.columns)

publishers = ('Дрофа', 'АСТ')

print(
    pd.read_sql("""
select b.title
from book as b
         inner join publisher as p
                    on p.publisher_id = b.publisher_id
where p.publisher_name in {}
and b.year_publication between 2016 and 2019
""".format(publishers), con=connection))

connection.close()
