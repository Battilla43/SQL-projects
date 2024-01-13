-- 1. For each member (card number, first, middle and last name) and for each genre type, how many book copies of the type the member borrowed.
-- If a member borrowed a given book more then once, it should be counted once.
-- If the member Jen, Karen Green with card number 1 borrowed 5 non-fiction books and 0 fiction books, then the following tuples should be in the result of the query.
-- 1 | Jen | Karen | Green | 1 | 5
-- 1 | Jen | Karen | Green | 0 | 0
-- ------------------------------
-- WRITE_YOUR_QUERY_HERE for 1.
select MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name,
count(case when GENRE.type = 0 then GENRE.type end) as fiction,
count(case when GENRE.type = 1 then GENRE.type end) as nonfiction
from MEMBER, GENRE, BORROW, BOOK
where MEMBER.card_no = BORROW.card_no
and GENRE.genre_id = BOOK.genre_id
group by MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name;
-- ________________________________
-- 2. For every author (ID, first, middle and last name), how many books he is an author of.
-- There can be authors not associated with any book.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 2.
select AUTHOR.author_id, AUTHOR.first_name, AUTHOR.middle_name, AUTHOR.last_name, count(BOOK.title) as books_authored
from AUTHOR, BOOK_AUTHOR, BOOK
where AUTHOR.author_id = BOOK_AUTHOR.author_id
and BOOK_AUTHOR.ISBN = BOOK.ISBN
group by AUTHOR.author_id, AUTHOR.first_name, AUTHOR.middle_name, AUTHOR.last_name;
-- ________________________________
-- 3. For every book copy (barcode, ISBN and title), how many times it was borrowed.
-- There can be book copies that were never borrowed.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 3.
select COPY.barcode, COPY.ISBN, BOOK.title, count(BORROW.date_borrowed) as borrowed
from COPY, BOOK, BORROW
where COPY.barcode = BORROW.barcode
and COPY.ISBN = BOOK.ISBN
group by COPY.barcode, COPY.ISBN, BOOK.title;
-- ________________________________
-- 4. For every member (card number, first, middle and last name), how many loans he paid a late fee for.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 4.
select MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name, count(BORROW.date_returned) as Returned_loans
from MEMBER, BORROW
where MEMBER.card_no = BORROW.card_no
and BORROW.paid != null
group by MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name;
-- ________________________________
-- 5. For exery first, middle and last name in the database, the number of authors who have it and the number of members who have it.
-- If there is 1 author named Jen, Karen Green and two members named Jen, Karen Green, then the following tuple should be in the result of the query.
-- Jen | Karen | Green | 1 | 2
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 5.
select AUTHOR.first_name, AUTHOR.middle_name, AUTHOR.last_name, count(AUTHOR.author_id) as num_authors, count(MEMBER.card_no) as members
from AUTHOR, MEMBER
where AUTHOR.first_name = MEMBER.first_name
and AUTHOR.middle_name = MEMBER.middle_name
and AUTHOR.last_name = MEMBER.last_name
group by AUTHOR.first_name, AUTHOR.middle_name, AUTHOR.last_name;
-- ________________________________
-- 6. For every member (card number, first, middle and last name), how many book copies they borrowed in 2020, 2021 and 2022.
-- If there is a member named Jen, Karen Green with card number 1, and she borrowed 10 book copies in 2021, 5 in 2022 and none in 2020, then the following tuple should be in the result of the query.analyze
-- 1 | Jen | Karen | Green | 0 | 10 | 5
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 6.
select MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name,
count(case when BORROW.date_borrowed between '2020-01-01' and '2020-12-31' then BORROW.date_borrowed end) as year_0,
count(case when BORROW.date_borrowed between '2021-01-01' and '2021-12-31' then BORROW.date_borrowed end) as year_1,
count(case when BORROW.date_borrowed between '2022-01-01' and '2022-12-31' then BORROW.date_borrowed end) as year_2
from MEMBER, BORROW, COPY
where MEMBER.card_no = BORROW.card_no
and BORROW.barcode = COPY.barcode
group by MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name;
-- ________________________________
-- 7. Starting from the first year in which some book copy was borrowed (do not assume any specific value), for each year, for each month of the year, how many book copies were borrowed that month.
-- 2021 | 0 | 1 | 10 | 11 | 1 | 2 | 3 | 2 | 10 | 11 | 12 | 3 <--- 0 book copies were borrowed in January, 1 in Feb, 10 in March etc.
-- 2022 | 1 | 2 | 5 | 21 | 23 | 12 | 6 | 2 | 7 | 1 | 0 | 0
-- You may find this helpful ---> https://stackoverflow.com/questions/626797/sql-to-return-list-of-years-since-a-specific-year .
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 7.
select year(BORROW.date_borrowed),
count(case when month(BORROW.date_borrowed) = 1 then month(BORROW.date_borrowed) end) as January,
count(case when month(BORROW.date_borrowed) = 2 then month(BORROW.date_borrowed) end) as February,
count(case when month(BORROW.date_borrowed) = 3 then month(BORROW.date_borrowed) end) as March,
count(case when month(BORROW.date_borrowed) = 4 then month(BORROW.date_borrowed) end) as April,
count(case when month(BORROW.date_borrowed) = 5 then month(BORROW.date_borrowed) end) as May,
count(case when month(BORROW.date_borrowed) = 6 then month(BORROW.date_borrowed) end) as June,
count(case when month(BORROW.date_borrowed) = 7 then month(BORROW.date_borrowed) end) as July,
count(case when month(BORROW.date_borrowed) = 8 then month(BORROW.date_borrowed) end) as August,
count(case when month(BORROW.date_borrowed) = 9 then month(BORROW.date_borrowed) end) as September,
count(case when month(BORROW.date_borrowed) = 10 then month(BORROW.date_borrowed) end) as October,
count(case when month(BORROW.date_borrowed) = 11 then month(BORROW.date_borrowed) end) as November,
count(case when month(BORROW.date_borrowed) = 12 then month(BORROW.date_borrowed) end) as December
from BORROW
group by year(BORROW.date_borrowed);
-- ________________________________
-- 8. For each member (card number, first, middle and last name) the last day he borrowed anything and how many book copies he borrowed that day.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 8.
select MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name, count(distinct BORROW.barcode)
from MEMBER natural join BORROW
where MEMBER.card_no = BORROW.card_no
group by MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name
having max(BORROW.date_borrowed);
-- ________________________________
-- 9. For each book (ISBN and title), the number of authors and the number of copies the library owns.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 9.
select BOOK.ISBN, BOOK.title, count(distinct AUTHOR.author_id) as Authors, count(distinct COPY.barcode) as Copies
from COPY natural join BOOK natural join BOOK_AUTHOR natural join AUTHOR
group by BOOK.ISBN, BOOK.title;
-- ________________________________
-- 10. For each book (ISBN and title) the number of members who borrowed some of its copies and returned it on the same day.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 10.
select BOOK.ISBN, BOOK.title, BORROW.date_borrowed, BORROW.date_returned
from BOOK, BORROW, COPY
where BOOK.ISBN = COPY.ISBN
and COPY.barcode = BORROW.barcode
having datediff(BORROW.date_borrowed, BORROW.date_returned) = 0;