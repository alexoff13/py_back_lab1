drop table if exists author;

create table author
(
    author_id   INTEGER primary key autoincrement,
    author_name VARCHAR(30)
);

insert into author (author_name)
values ('Пушкин А.С.'),
       ('Агата Кристи'),
       ('Жюль Верн'),
       ('Ильф И.А.'),
       ('Петров Е.П.'),
       ('Булгаков М.А.'),
       ('Лермонтов М.Ю.'),
       ('Стругацкий А.Н.'),
       ('Стругацкий Б.Н.'),
       ('Дойл Артур Конан'),
       ('Достоевский Ф.М.');

drop table if exists genre;

create table genre
(
    genre_id   INTEGER primary key autoincrement,
    genre_name VARCHAR(30)
);

insert into genre (genre_name)
values ('Роман'),
       ('Приключения'),
       ('Детектив'),
       ('Лирика'),
       ('Фантастика'),
       ('Фэнтези');

drop table if exists publisher;

create table publisher
(
    publisher_id   INTEGER primary key autoincrement,
    publisher_name VARCHAR(40)
);

insert into publisher (publisher_name)
values ('ЭКСМО'),
       ('ПИТЕР'),
       ('РОСМЭН'),
       ('АЛЬФА-КНИГА'),
       ('ДРОФА'),
       ('АСТ'),
       ('НАУКА');

drop table if exists reader;

create table reader
(
    reader_id   INTEGER primary key autoincrement,
    reader_name VARCHAR(30)
);

insert into reader (reader_name)
values ('Иванов М.С.'),
       ('Петров Ф.С.'),
       ('Федоров П.Р.'),
       ('Абрамова А.А.'),
       ('Самарин С.С.'),
       ('Туполев И.Д.'),
       ('Баранов П.В.');

drop table if exists book;

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
values ('Двенадцать стульев', 1, 3, 2018, 1),
       ('Золотой теленок', 1, 1, 2014, 3),
       ('Мастер и Маргарита', 1, 5, 2014, 5),
       ('Таинственный остров', 2, 4, 2015, 0),
       ('Пуаро ведет следствие', 3, 5, 2008, 2),
       ('Евгений Онегин', 1, 4, 2011, 8),
       ('Бородино', 4, 6, 2015, 0),
       ('Трудно быть богом', 5, 5, 2018, 2),
       ('Пикник на обочине', 5, 3, 2018, 9),
       ('Дубровский', 1, 5, 2020, 7),
       ('Собачье сердце', 1, 5, 2015, 6),
       ('Понедельник начинается в субботу', 5, 3, 2012, 2),
       ('Вокруг света за 80 дней', 2, 5, 2019, 5),
       ('Смерть на Ниле', 3, 1, 2017, 8),
       ('Убийства по алфавиту', 3, 4, 2017, 9),
       ('Загадочное происшествие', 3, 5, 2018, 5),
       ('Капитанская дочка', 1, 4, 2016, 5),
       ('Этюд в багровых тонах', 3, 4, 2020, 0),
       ('Приключения Шерлока Холмса', 3, 3, 2013, 1),
       ('Записки о Шерлоке Холмсе', 3, 5, 2015, 1),
       ('Затерянный мир', 2, 2, 2020, 0),
       ('Стихи', 4, 1, 2019, 6),
       ('Поэмы', 4, 6, 2020, 8),
       ('Герой нашего времени', 1, 6, 2017, 2),
       ('Стихи', 4, 3, 2017, 5),
       ('Одноэтажная Америка', 1, 2, 2015, 3),
       ('Смерть поэта', 4, 3, 2020, 2),
       ('Поэмы', 4, 4, 2019, 5),
       ('Скрюченный домишко', 3, 5, 2018, 2);

drop table if exists book_author;

create table book_author
(
    book_author_id INTEGER primary key autoincrement,
    book_id        INT,
    author_id      INT,
    foreign key (book_id) references book (book_id) on delete cascade,
    foreign key (author_id) references author (author_id) on delete cascade
);

insert into book_author(book_id, author_id)
values (1, 4),
       (1, 5),
       (2, 4),
       (2, 5),
       (3, 6),
       (4, 3),
       (5, 2),
       (6, 1),
       (7, 7),
       (8, 8),
       (8, 9),
       (9, 8),
       (9, 9),
       (10, 1),
       (11, 6),
       (12, 8),
       (12, 9),
       (13, 3),
       (14, 2),
       (15, 2),
       (16, 2),
       (17, 1),
       (18, 10),
       (19, 10),
       (20, 10),
       (21, 10),
       (22, 1),
       (23, 1),
       (24, 7),
       (25, 7),
       (26, 4),
       (26, 5),
       (27, 7),
       (28, 7),
       (29, 2);

drop table if exists book_reader;

create table book_reader
(
    book_reader_id INTEGER primary key autoincrement,
    book_id        int,
    reader_id      INT,
    borrow_date    DATE,
    return_date    DATE,
    foreign key (book_id) references book (book_id) on delete cascade,
    foreign key (reader_id) references reader (reader_id) on delete cascade
);

insert into book_reader(book_id, reader_id, borrow_date, return_date)
values (4, 4, '2020-09-11', '2020-09-24'),
       (12, 6, '2020-09-11', null),
       (29, 5, '2020-09-17', '2020-10-10'),
       (27, 6, '2020-09-18', '2020-10-14'),
       (15, 4, '2020-09-18', '2020-10-04'),
       (18, 1, '2020-09-21', '2020-10-09'),
       (22, 4, '2020-09-25', '2020-10-10'),
       (1, 3, '2020-09-28', '2020-10-07'),
       (26, 2, '2020-09-30', '2020-10-08'),
       (27, 1, '2020-10-05', '2020-10-13'),
       (18, 2, '2020-10-06', null),
       (26, 2, '2020-10-06', '2020-10-26'),
       (11, 1, '2020-10-06', '2020-10-13'),
       (3, 5, '2020-10-08', '2020-10-27'),
       (20, 6, '2020-10-08', '2020-10-23'),
       (20, 3, '2020-10-09', '2020-10-29'),
       (2, 2, '2020-10-09', '2020-10-12'),
       (27, 6, '2020-10-13', '2020-10-17'),
       (28, 4, '2020-10-15', '2020-11-04'),
       (5, 1, '2020-10-15', '2020-10-18'),
       (29, 1, '2020-10-15', '2020-10-29'),
       (3, 6, '2020-10-15', null),
       (9, 6, '2020-10-16', '2020-10-19'),
       (15, 2, '2020-10-17', '2020-11-08'),
       (8, 6, '2020-10-19', null),
       (18, 1, '2020-10-20', null),
       (23, 5, '2020-10-21', null),
       (4, 5, '2020-10-22', '2020-10-28'),
       (26, 3, '2020-10-23', '2020-10-28'),
       (5, 6, '2020-10-24', '2020-11-01'),
       (8, 2, '2020-10-28', '2020-11-18'),
       (21, 5, '2020-10-30', null),
       (20, 1, '2020-10-30', '2020-11-26'),
       (14, 4, '2020-10-30', '2020-11-10'),
       (8, 6, '2020-11-01', null),
       (11, 4, '2020-11-06', '2020-11-26'),
       (28, 6, '2020-11-09', '2020-11-28'),
       (14, 3, '2020-11-14', null),
       (24, 2, '2020-11-15', null),
       (5, 6, '2020-11-17', null),
       (11, 3, '2020-11-21', '2020-12-12'),
       (14, 1, '2020-11-23', null),
       (4, 5, '2020-11-23', null),
       (23, 5, '2020-11-28', null),
       (21, 3, '2020-11-29', '2020-12-21');
