# smart library management system

this is a small mysql project for managing a library. i made it around the
requirements in the project sheet: books, authors, members and borrowing
transactions.

## files

- `library_manangent.sql` - creates the database, tables, sample data and all
  required queries.

## database design

the database is called `smart_library`.

| table | purpose |
| --- | --- |
| `authors` | stores author names and email addresses |
| `books` | stores book details and the number of available copies |
| `members` | stores library member details |
| `transactions` | stores borrowing, return and fine information |

`books.author_id` is connected to `authors.author_id`.
`transactions.member_id` is connected to `members.member_id`, and
`transactions.book_id` is connected to `books.book_id`.

## how to run

1. open mysql workbench.
2. open `library_manangent.sql`.
3. run the complete file.
4. the file creates `smart_library` again, so it is better for a fresh demo
   database.
5. the queries are arranged in the same order as the task sheet.

the file contains examples of:

- insert, update, delete and select
- where, having and limit
- and, or and not
- order by and group by
- sum, avg, max, min and count
- primary keys and foreign keys
- inner, left, right and full outer join simulation
- subqueries
- date, string and case functions
- rank, cumulative count and moving average window functions

## query output

the output below follows the query order in `library_manangent.sql`. the
values are written one row per line so they are easy to compare with mysql
workbench. `null` means that mysql returned a null value. the crud select
contains the temporary row and then the rollback removes it.

### crud select: books with available copies

```text
book_id | title | author_id | category | isbn | published_date | price | available_copies
1 | 1984 | 1 | fiction | 9780451524935 | 1949-06-08 | 350.00 | 2
2 | animal farm | 1 | fiction | 9780451526342 | 1945-08-17 | 250.00 | 3
3 | pride and prejudice | 2 | classic | 9780141439518 | 1813-01-28 | 450.00 | 1
4 | sapiens | 3 | history | 9780062316097 | 2011-01-01 | 700.00 | 2
6 | silent spring | 5 | science | 9780618249060 | 1962-09-27 | 480.00 | 2
7 | refactoring | 6 | technology | 9780134757599 | 2018-11-19 | 950.00 | 1
8 | war and peace | 7 | classic | 9780199232765 | 1869-01-01 | 600.00 | 2
9 | clean code | 6 | technology | 9780132350884 | 2008-08-01 | 900.00 | 1
10 | the pragmatic programmer | 6 | technology | 9780135957059 | 2019-09-13 | 850.00 | 2
11 | the origin of species | 5 | science | 9780451529060 | 1859-11-24 | 520.00 | 1
12 | new library book | 8 | fiction | 9780000000001 | 2024-01-01 | 300.00 | 2
```

the insert, update and delete statements do not return a result set. after
`rollback`, the temporary author, member and book are not saved.

### books published after 2015

```text
7 | refactoring | 6 | technology | 9780134757599 | 2018-11-19 | 950.00 | 1
10 | the pragmatic programmer | 6 | technology | 9780135957059 | 2019-09-13 | 850.00 | 2
```

### five most expensive books

```text
7 | refactoring | 950.00
9 | clean code | 900.00
10 | the pragmatic programmer | 850.00
5 | harry potter and the philosopher stone | 800.00
4 | sapiens | 700.00
```

### members who joined before 2022

```text
1 | amit shah | amit@example.com | 9876500001 | 2021-03-15
4 | priya singh | priya@example.com | 9876500004 | 2020-11-30
6 | meera desai | meera@example.com | 9876500006 | 2021-09-01
```

### science books below 500

```text
6 | silent spring | 5 | science | 9780618249060 | 1962-09-27 | 480.00 | 2
```

### books not available for borrowing

```text
5 | harry potter and the philosopher stone | 4 | fantasy | 9780747532699 | 1997-06-26 | 800.00 | 0
```

### members joined after 2020 or who borrowed more than 3 books

```text
1 | amit shah | 4
2 | neha patel | 3
3 | rohan mehta | 1
5 | karan joshi | 1
6 | meera desai | 1
```

### books sorted by title

```text
1 | 1984
2 | animal farm
9 | clean code
5 | harry potter and the philosopher stone
3 | pride and prejudice
10 | the pragmatic programmer
7 | refactoring
4 | sapiens
6 | silent spring
11 | the origin of species
8 | war and peace
```

### borrowed books by member

```text
1 | amit shah | 4
2 | neha patel | 3
4 | priya singh | 3
3 | rohan mehta | 1
5 | karan joshi | 1
6 | meera desai | 1
```

### book count by category

```text
classic | 2
fantasy | 1
fiction | 2
history | 1
science | 2
technology | 3
```

### aggregate results

```text
category | total_books
classic | 2
fantasy | 1
fiction | 2
history | 1
science | 2
technology | 3

average_book_price
622.73

lowest_book_price
250.00

book_id | title | borrow_count
1 | 1984 | 2

total_fines_collected
90.00
```

### inner join: books and authors

```text
1984 |  george orwell 
animal farm |  george orwell 
pride and prejudice | jane austen
sapiens | yuval noah harari
harry potter and the philosopher stone | j.k. rowling
silent spring | rachel carson
refactoring | martin fowler
war and peace | leo tolstoy
clean code | martin fowler
the pragmatic programmer | martin fowler
the origin of species | rachel carson
```

### left join: members and transactions

```text
1 | amit shah | 1 | 2023-01-05
1 | amit shah | 2 | 2023-03-10
1 | amit shah | 3 | 2023-06-12
1 | amit shah | 4 | 2024-01-08
2 | neha patel | 5 | 2023-02-01
2 | neha patel | 6 | 2023-08-15
2 | neha patel | 7 | 2024-02-14
3 | rohan mehta | 8 | 2024-03-05
4 | priya singh | 9 | 2022-12-20
4 | priya singh | 10 | 2023-04-18
4 | priya singh | 11 | 2023-09-10
5 | karan joshi | 12 | 2024-04-01
6 | meera desai | 13 | 2022-07-15
```

### right join: books and transactions

```text
1984 | 1 | 2023-01-05
sapiens | 2 | 2023-03-10
harry potter and the philosopher stone | 3 | 2023-06-12
refactoring | 4 | 2024-01-08
1984 | 5 | 2023-02-01
silent spring | 6 | 2023-08-15
clean code | 7 | 2024-02-14
harry potter and the philosopher stone | 8 | 2024-03-05
animal farm | 9 | 2022-12-20
war and peace | 10 | 2023-04-18
the pragmatic programmer | 11 | 2023-09-10
pride and prejudice | 12 | 2024-04-01
the origin of species | 13 | 2022-07-15
```

### full outer join simulation

```text
1 | amit shah | 1
1 | amit shah | 2
1 | amit shah | 3
1 | amit shah | 4
2 | neha patel | 5
2 | neha patel | 6
2 | neha patel | 7
3 | rohan mehta | 8
4 | priya singh | 9
4 | priya singh | 10
4 | priya singh | 11
5 | karan joshi | 12
6 | meera desai | 13
```

### books borrowed by members registered after 2022

```text
harry potter and the philosopher stone
pride and prejudice
```

### most borrowed books

```text
1984 | 2
harry potter and the philosopher stone | 2
```

### members who never borrowed a book

```text
empty result set
```

### publication year count

```text
1813 | 1
1859 | 1
1869 | 1
1945 | 1
1949 | 1
1962 | 1
1997 | 1
2008 | 1
2011 | 1
2018 | 1
2019 | 1
```

### borrowed days

the two open transactions use the current date when the query is run. the
following values were produced on 2026-10-13.

```text
1 | 10
2 | 15
3 | 18
4 | 12
5 | 11
6 | 14
7 | 972
8 | 952
9 | 13
10 | 17
11 | 10
12 | 11
13 | 15
```

### formatted borrow dates

```text
1 | 05-01-23
2 | 10-03-23
3 | 12-06-23
4 | 08-01-24
5 | 01-02-23
6 | 15-08-23
7 | 14-02-24
8 | 05-03-24
9 | 20-12-22
10 | 18-04-23
11 | 10-09-23
12 | 01-04-24
13 | 15-07-22
```

### uppercase book titles

```text
1984
ANIMAL FARM
PRIDE AND PREJUDICE
SAPIENS
HARRY POTTER AND THE PHILOSOPHER STONE
SILENT SPRING
REFACTORING
WAR AND PEACE
CLEAN CODE
THE PRAGMATIC PROGRAMMER
THE ORIGIN OF SPECIES
```

### trimmed author names

```text
george orwell
jane austen
yuval noah harari
j.k. rowling
rachel carson
martin fowler
leo tolstoy
```

### author email with null replacement

```text
1 | george.orwell@example.com
2 | not provided
3 | yuval.harari@example.com
4 | jk.rowling@example.com
5 | rachel.carson@example.com
6 | martin.fowler@example.com
7 | leo.tolstoy@example.com
```

### book borrow rank

```text
1984 | 2 | 1
harry potter and the philosopher stone | 2 | 1
animal farm | 1 | 2
clean code | 1 | 2
pride and prejudice | 1 | 2
refactoring | 1 | 2
sapiens | 1 | 2
silent spring | 1 | 2
the origin of species | 1 | 2
the pragmatic programmer | 1 | 2
war and peace | 1 | 2
```

### cumulative borrowed books

```text
2022-07-15 | 13 | 1
2022-12-20 | 9 | 2
2023-01-05 | 1 | 3
2023-02-01 | 5 | 4
2023-03-10 | 2 | 5
2023-04-18 | 10 | 6
2023-06-12 | 3 | 7
2023-08-15 | 6 | 8
2023-09-10 | 11 | 9
2024-01-08 | 4 | 10
2024-02-14 | 7 | 11
2024-03-05 | 8 | 12
2024-04-01 | 12 | 13
```

### moving average of monthly borrowed books

```text
2022-07-01 | 1 | 1.00
2022-12-01 | 1 | 1.00
2023-01-01 | 1 | 1.00
2023-02-01 | 1 | 1.00
2023-03-01 | 1 | 1.00
2023-04-01 | 1 | 1.00
2023-06-01 | 1 | 1.00
2023-08-01 | 1 | 1.00
2023-09-01 | 1 | 1.00
2024-01-01 | 1 | 1.00
2024-02-01 | 1 | 1.00
2024-03-01 | 1 | 1.00
2024-04-01 | 1 | 1.00
```

### membership status

```text
1 | amit shah | inactive
2 | neha patel | inactive
3 | rohan mehta | inactive
4 | priya singh | inactive
5 | karan joshi | inactive
6 | meera desai | inactive
```

### book category case result

```text
1984 | 1949-06-08 | classic
animal farm | 1945-08-17 | classic
pride and prejudice | 1813-01-28 | classic
sapiens | 2011-01-01 | regular
harry potter and the philosopher stone | 1997-06-26 | classic
silent spring | 1962-09-27 | classic
refactoring | 2018-11-19 | regular
war and peace | 1869-01-01 | classic
clean code | 2008-08-01 | regular
the pragmatic programmer | 2019-09-13 | regular
the origin of species | 1859-11-24 | classic
```

## notes

the screenshot asks for a full outer join. mysql does not have a direct
`full outer join` command, so the sql file uses a left join and a right join
with `union`. that is the usual mysql way to get the same result.

the crud examples are inside a transaction and end with `rollback`. this lets
the examples run without permanently changing the sample rows used by the
queries below them.

the delete example does not remove members that have transaction history,
because the foreign key should protect that history. the statement therefore
returns no result set and the rollback keeps the demo data unchanged.

the sample rows include returned and still-open transactions. this makes the
fine, overdue, join, subquery and window function examples show useful
results instead of empty output.
