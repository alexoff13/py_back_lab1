import sqlite3

import pandas as pd

connection = sqlite3.connect('library.sqlite')

print('=' * 50 + ' Задание 2 ' + '=' * 50 + '\n')

print(connection.execute("""
select g.genre_name                          as genre_name,
       count(b.title)                        as count_book,
       coalesce(sum(b.available_numbers), 0) as count_copies,
       min(b.year_publication)               as min_year_publication
from genre as g
         left join book as b
                    on g.genre_id = b.genre_id
group by genre_name
order by genre_name
""").fetchall())

print(connection.execute("""
select b.title                                               as title,
       br.borrow_date                                        as borrow_date,
       br.return_date                                        as return_date,
       julianday(br.return_date) - julianday(br.borrow_date) as count_days
from reader r
         inner join book_reader as br
                    on r.reader_id = br.reader_id
         inner join book as b
                    on b.book_id = br.book_id
where r.reader_name = :reader_name
  and not br.return_date is null
order by julianday(br.return_date) - julianday(br.borrow_date) desc
""", {'reader_name': 'Федоров П.Р.'}).fetchall())

print(connection.execute("""
with genre_counts as (select g.genre_name as genre_name,
                             count(1)     as count
                      from genre g
                               inner join book  as b
                                          on g.genre_id = b.genre_id
                               inner join book_reader as br
                                          on b.book_id = br.book_id
                      group by g.genre_name),
     genre_counts_rank as (select g.genre_name                        as genre_name,
                                  g.count                             as count,
                                  rank() over (order by g.count desc) as rank
                           from genre_counts as g)
select genre_name,
       count
from genre_counts_rank
where rank = 1
order by genre_name
""").fetchall())

print('=' * 50 + ' Задание 3 ' + '=' * 50 + '\n')

print(pd.read_sql("""
select b.title        as "Название",
       r.reader_name  as "Читатель",
       br.borrow_date as "Дата"
from book as b
         inner join book_reader as br
                    on b.book_id = br.book_id
         inner join reader as r
                    on r.reader_id = br.reader_id
where cast(strftime('%m', br.borrow_date) as int) = 10 -- Октябрь
order by br.borrow_date,
         r.reader_name,
         b.title
""", con=connection, params={}))

print(pd.read_sql("""
select b.title            as "Название",
       g.genre_name       as "Жанр",
       b.year_publication as "Год",
       case
           when b.year_publication < 2014 then 'III'
           when b.year_publication > 2017 then 'I'
           else 'II'
           end            as "Группа"
from book as b
         inner join publisher as p
                    on p.publisher_id = b.publisher_id
         inner join genre as g
                    on g.genre_id = b.genre_id
where p.publisher_name = :publisher_name
order by "Группа" desc,
         "Год",
         "Название"
""", con=connection, params={'publisher_name': 'АЛЬФА-КНИГА'}))

print(pd.read_sql("""
select b.title                          as "Название",
       b.available_numbers              as "Количество",
       coalesce(count(br.reader_id), 0) as "Количество_выдачи"
from book as b
         left join book_reader as br
                   on b.book_id = br.book_id
group by b.title,
         b.available_numbers
order by "Количество_выдачи" desc,
         "Название",
         "Количество"
""", con=connection, params={'publisher_name': 'АЛЬФА-КНИГА'}))
