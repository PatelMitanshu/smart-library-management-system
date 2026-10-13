drop database if exists smart_library;
create database smart_library;
use smart_library;

create table authors (
    author_id int primary key auto_increment,
    name varchar(100) not null,
    email varchar(100) unique
);

create table books (
    book_id int primary key auto_increment,
    title varchar(150) not null,
    author_id int not null,
    category varchar(50) not null,
    isbn varchar(20) unique not null,
    published_date date not null,
    price decimal(10,2) not null,
    available_copies int not null default 0,
    foreign key (author_id) references authors(author_id),
    check (price >= 0),
    check (available_copies >= 0)
);

create table members (
    member_id int primary key auto_increment,
    name varchar(100) not null,
    email varchar(100) unique not null,
    phone_number varchar(20),
    membership_date date not null
);

create table transactions (
    transaction_id int primary key auto_increment,
    member_id int not null,
    book_id int not null,
    borrow_date date not null,
    return_date date,
    fine_amount decimal(10,2) not null default 0,
    foreign key (member_id) references members(member_id),
    foreign key (book_id) references books(book_id),
    check (fine_amount >= 0),
    check (return_date is null or return_date >= borrow_date)
);

insert into authors (name, email) values
(' george orwell ', 'george.orwell@example.com'),
('jane austen', null),
('yuval noah harari', 'yuval.harari@example.com'),
('j.k. rowling', 'jk.rowling@example.com'),
('rachel carson', 'rachel.carson@example.com'),
('martin fowler', 'martin.fowler@example.com'),
('leo tolstoy', 'leo.tolstoy@example.com');

insert into books
    (title, author_id, category, isbn, published_date, price, available_copies)
values
('1984', 1, 'fiction', '9780451524935', '1949-06-08', 350.00, 2),
('animal farm', 1, 'fiction', '9780451526342', '1945-08-17', 250.00, 3),
('pride and prejudice', 2, 'classic', '9780141439518', '1813-01-28', 450.00, 1),
('sapiens', 3, 'history', '9780062316097', '2011-01-01', 700.00, 2),
('harry potter and the philosopher stone', 4, 'fantasy', '9780747532699', '1997-06-26', 800.00, 0),
('silent spring', 5, 'science', '9780618249060', '1962-09-27', 480.00, 2),
('refactoring', 6, 'technology', '9780134757599', '2018-11-19', 950.00, 1),
('war and peace', 7, 'classic', '9780199232765', '1869-01-01', 600.00, 2),
('clean code', 6, 'technology', '9780132350884', '2008-08-01', 900.00, 1),
('the pragmatic programmer', 6, 'technology', '9780135957059', '2019-09-13', 850.00, 2),
('the origin of species', 5, 'science', '9780451529060', '1859-11-24', 520.00, 1);

insert into members (name, email, phone_number, membership_date) values
('amit shah', 'amit@example.com', '9876500001', '2021-03-15'),
('neha patel', 'neha@example.com', '9876500002', '2022-05-20'),
('rohan mehta', 'rohan@example.com', '9876500003', '2023-01-10'),
('priya singh', 'priya@example.com', '9876500004', '2020-11-30'),
('karan joshi', 'karan@example.com', '9876500005', '2024-02-12'),
('meera desai', 'meera@example.com', '9876500006', '2021-09-01');

insert into transactions
    (member_id, book_id, borrow_date, return_date, fine_amount)
values
(1, 1, '2023-01-05', '2023-01-15', 0.00),
(1, 4, '2023-03-10', '2023-03-25', 20.00),
(1, 5, '2023-06-12', '2023-06-30', 40.00),
(1, 7, '2024-01-08', '2024-01-20', 0.00),
(2, 1, '2023-02-01', '2023-02-12', 0.00),
(2, 6, '2023-08-15', '2023-08-29', 10.00),
(2, 9, '2024-02-14', null, 0.00),
(3, 5, '2024-03-05', null, 0.00),
(4, 2, '2022-12-20', '2023-01-02', 0.00),
(4, 8, '2023-04-18', '2023-05-05', 15.00),
(4, 10, '2023-09-10', '2023-09-20', 0.00),
(5, 3, '2024-04-01', '2024-04-12', 0.00),
(6, 11, '2022-07-15', '2022-07-30', 5.00);

-- crud operations
start transaction;

insert into authors (name, email)
values ('new author', 'new.author@example.com');

insert into members (name, email, phone_number, membership_date)
values ('new member', 'new.member@example.com', '9876500099', curdate());

insert into books
    (title, author_id, category, isbn, published_date, price, available_copies)
values
('new library book', 8, 'fiction', '9780000000001', '2024-01-01', 300.00, 2);

update books
set available_copies = available_copies - 1
where book_id = 3 and available_copies > 0;

update books
set available_copies = available_copies + 1
where book_id = 3;

delete from members
where member_id not in (
    select distinct member_id
    from transactions
    where borrow_date >= date_sub(curdate(), interval 1 year)
)
and not exists (
    select 1
    from transactions old_transactions
    where old_transactions.member_id = members.member_id
);

select *
from books
where available_copies > 0;

rollback;

-- where, having and limit
select *
from books
where published_date > '2015-12-31';

select *
from books
order by price desc
limit 5;

select *
from members
where membership_date < '2022-01-01';

-- and, or and not
select *
from books
where category = 'science' and price < 500;

select *
from books
where not available_copies > 0;

select m.member_id, m.name, count(t.transaction_id) as borrowed_books
from members m
left join transactions t on m.member_id = t.member_id
group by m.member_id, m.name
having m.membership_date > '2020-12-31'
    or count(t.transaction_id) > 3;

-- sorting and grouping
select *
from books
order by title;

select m.member_id, m.name, count(t.transaction_id) as borrowed_books
from members m
left join transactions t on m.member_id = t.member_id
group by m.member_id, m.name
order by borrowed_books desc;

select category, count(*) as total_books
from books
group by category
order by category;

-- aggregate functions
select category, count(*) as total_books
from books
group by category;

select round(avg(price), 2) as average_book_price
from books;

select min(price) as lowest_book_price
from books;

select b.book_id, b.title, x.borrow_count
from books b
join (
    select book_id, count(*) as borrow_count
    from transactions
    group by book_id
) x on b.book_id = x.book_id
order by x.borrow_count desc, b.book_id
limit 1;

select sum(fine_amount) as total_fines_collected
from transactions;

-- inner join
select b.title, a.name as author_name
from books b
inner join authors a on b.author_id = a.author_id;

-- left join
select m.member_id, m.name, t.transaction_id, t.borrow_date
from members m
left join transactions t on m.member_id = t.member_id
order by m.member_id;

-- right join
select b.title, t.transaction_id, t.borrow_date
from transactions t
right join books b on t.book_id = b.book_id;

-- mysql has no full outer join, so union gives the same result
select m.member_id, m.name, t.transaction_id
from members m
left join transactions t on m.member_id = t.member_id
union
select m.member_id, m.name, t.transaction_id
from members m
right join transactions t on m.member_id = t.member_id;

-- subqueries
select distinct b.title
from books b
where b.book_id in (
    select t.book_id
    from transactions t
    join members m on t.member_id = m.member_id
    where m.membership_date > '2022-12-31'
);

select b.title, count(t.transaction_id) as borrow_count
from books b
join transactions t on b.book_id = t.book_id
group by b.book_id, b.title
having count(t.transaction_id) = (
    select max(borrow_count)
    from (
        select count(*) as borrow_count
        from transactions
        group by book_id
    ) counts
);

select *
from members m
where not exists (
    select 1
    from transactions t
    where t.member_id = m.member_id
);

-- date and time functions
select year(published_date) as publication_year, count(*) as total_books
from books
group by year(published_date)
order by publication_year;

select transaction_id, datediff(coalesce(return_date, curdate()), borrow_date)
    as borrowed_days
from transactions;

select transaction_id, date_format(borrow_date, '%d-%m-%y') as formatted_borrow_date
from transactions;

-- string functions
select upper(title) as title_in_uppercase
from books;

select trim(name) as trimmed_author_name
from authors;

select author_id, coalesce(email, 'not provided') as email
from authors;

-- window functions
select b.title,
       count(t.transaction_id) as times_borrowed,
       dense_rank() over (order by count(t.transaction_id) desc) as borrow_rank
from books b
left join transactions t on b.book_id = t.book_id
group by b.book_id, b.title
order by borrow_rank, b.title;

select borrow_date, transaction_id,
       count(*) over (
           order by borrow_date, transaction_id
           rows between unbounded preceding and current row
       ) as cumulative_borrowed_books
from transactions
order by borrow_date, transaction_id;

select month_start, monthly_borrowed,
       round(avg(monthly_borrowed) over (
           order by month_start
           rows between 2 preceding and current row
       ), 2) as moving_average_last_3_months
from (
    select date_format(borrow_date, '%Y-%m-01') as month_start,
           count(*) as monthly_borrowed
    from transactions
    group by date_format(borrow_date, '%Y-%m-01')
) monthly_data
order by month_start;

-- case expressions
select m.member_id, m.name,
       case
           when max(t.borrow_date) >= date_sub(curdate(), interval 6 month)
               then 'active'
           else 'inactive'
       end as membership_status
from members m
left join transactions t on m.member_id = t.member_id
group by m.member_id, m.name;

select title, published_date,
       case
           when published_date > '2020-12-31' then 'new arrival'
           when published_date < '2000-01-01' then 'classic'
           else 'regular'
       end as book_type
from books;
