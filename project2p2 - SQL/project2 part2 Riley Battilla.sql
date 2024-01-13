-- 1. For each library member his card number, first, middle and last name along with the number of book copies he ever borrowed. There may be members who didn't ever borrow any book copy.
-- ------------------------------
-- WRITE_YOUR_QUERY_HERE for 1.
select MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name, count(COPY.barcode) as num_copies
from MEMBER natural join BORROW natural join COPY
group by MEMBER.card_no;
-- ________________________________
-- 2. Members (their card numbers, first, middle and last names) who held a book copy the longest. 
-- There can be one such member or more than one. 
-- Don't take into accout a case that someone borrowed the same book copy again.
-- Don't take into account members who borrowed a book copy and didn't return it yet.

-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 2.
select MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name, BORROW.date_borrowed, BOOK.title
from MEMBER natural join BORROW natural join COPY natural join BOOK
order by BORROW.date_borrowed ASC;
-- ________________________________
-- 3. For each book (ISBN and title) the number of copies the library owns.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 3.
 select BOOK.ISBN, BOOK.title, count(COPY.barcode) as num_copies
 from BOOK natural join COPY
 group by BOOK.ISBN;
-- ________________________________
-- 4. Books (ISBNs and titles), if any, having exactly 3 authors.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 4.
select BOOK.ISBN, BOOK.title, count(BOOK_AUTHOR.author_id) as author_num
from BOOK natural join BOOK_AUTHOR natural join AUTHOR
group by BOOK.ISBN
having author_num = 3;
-- ________________________________
-- 5. For each author (ID, first, middle and last name) the number of books he wrote.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 5.
select AUTHOR.author_id, AUTHOR.first_name, AUTHOR.middle_name, AUTHOR.last_name, count(BOOK_AUTHOR.ISBN) as book_num
from AUTHOR natural join BOOK_AUTHOR natural join BOOK
group by AUTHOR.author_id;
-- ________________________________
-- 6. Card number, first, middle and last name of members, if any, who borrowed some book by Chartrand(s). 
-- Remove duplicates from the result.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 6.
select MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name
from MEMBER natural join BORROW natural join COPY natural join BOOK natural join BOOK_AUTHOR
where BOOK_AUTHOR.author_id = 0
group by MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name
order by count(*) desc;
-- ________________________________
-- 7. Most popular author(s) (their IDs and first, middle and last names) in the library.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 7.
select AUTHOR.author_id, AUTHOR.first_name, AUTHOR.middle_name, AUTHOR.last_name
from AUTHOR natural join BOOK_AUTHOR natural join BOOK
group by AUTHOR.author_id, AUTHOR.first_name, AUTHOR.middle_name, AUTHOR.last_name
order by count(*) desc;
-- ________________________________
-- 8. Card numbers, first, middle, last names and addresses of members whose libray card will expire within the next month.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 8.
select MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name, MEMBER.street, MEMBER.apt_no, MEMBER.city, MEMBER.state, MEMBER.zip_code
from MEMBER
where member.card_exp_date >= '2022-11-01' and MEMBER.card_exp_date <= '2022-22-30'
-- ________________________________
-- 9. Card numbers, first, middle and last names of members along with the amount of money they owe to the library. 
-- Assume that if a book copy is returned one day after the due date, a member ows 0.25 cents to the library.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 9.
WITH late_days AS 
(SELECT card_no, datediff(now(), date_add(date_borrowed, INTERVAL renewals_no * 14 DAY)) * .25 as fees
FROM borrow
WHERE date_returned IS NULL AND renewals_no <= 2 AND datediff(now(), date_add(date_borrowed, INTERVAL renewals_no * 14 DAY)) > 14
ORDER BY card_no)
SELECT member.card_no, first_name, middle_name, last_name, sum(late_days.fees) AS fees
FROM member RIGHT JOIN late_days ON member.card_no = late_days.card_no
GROUP BY card_no;
-- ________________________________
-- 10. The amount of money the library earned (received money for) from late returns.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 10.
select sum(BORROW.paid) as total
from BORROW;
-- ________________________________
-- 11. Members (their card numbers, first, middle and last names) who borrowed more non-fiction books than fiction books.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 11.
select distinct MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name
from MEMBER natural join BORROW natural join BOOK natural join GENRE;
-- ________________________________
-- 12. Name of the most popular publisher(s).
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 12.
select BOOK.publisher
from BOOK natural join COPY natural join BORROW
group by BOOK.publisher
order by count(*) desc;
-- ________________________________
-- 13. Members (card numbers, first, middle and last names) who never borrowed any book copy and whose card expired.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 13.
select MEMBER.card_no, MEMBER.first_name, MEMBER.middle_name, MEMBER.last_name
from MEMBER natural join BORROW
where MEMBER.card_exp_date <= '2022-10-06'
and BORROW.date_borrowed is null;
-- ________________________________
-- 14. The most popular genre(s).
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 14.
select GENRE.name
from GENRE natural join BOOK natural join COPY natural join BORROW
group by GENRE.name
order by count(*) desc;
-- ________________________________
-- 15. For each state, in which some member lives, the most pupular last name(s). 
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 15.
select MEMBER.last_name, MEMBER.state, count(MEMBER.last_name)
from MEMBER
group by MEMBER.last_name, MEMBER.state
having count(MEMBER.last_name) > 1;
-- ________________________________
-- 16. Books (ISBNs and titles) that don't have any authors. 
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 16.
select BOOK.ISBN, BOOK.title
from BOOK natural join BOOK_AUTHOR natural join AUTHOR
where author_id is null; 
-- ________________________________
-- 17. Members (card numbers) who borrowed the same book more than once (not necessarily the same copy of a book).
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 17.
select card_no from 
    (select card_no, count(borrow.barcode) as codeCount from borrow,copy,book 
    where borrow.barcode = copy.barcode and copy.ISBN = book.ISBN group by card_no) as temp 
where codeCount > 1;
-- ________________________________
-- 18. Number of members from Cookeville, TN and from Algood, TN.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 18.
select MEMBER.city, count(*) as num_people
from MEMBER
where MEMBER.city = "Cookeville" or MEMBER.city = "Algood"
and MEMBER.state = "TN"
group by MEMBER.city;
-- ________________________________
-- 19. Card numbers and emails of members who should return a book copy tomorrow. If these members didn't renew their loan twice, then they still have a chance to renew their loan. If they won't renew or return a book tomorrow, then they will be charged for the following day(s).
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 19.
select MEMBER.card_no, MEMBER.email_address
from MEMBER natural join BORROW natural join COPY
where BORROW.renewals_no < 2
and BORROW.date_returned is null
and BORROW.date_borrowed < '2022-09-23';
-- ________________________________
-- 20. Condition of a book copy that was borrowed the most often, not necessarily held the longest.
-- --------------------------------
-- WRITE_YOUR_QUERY_HERE for 20.
select distinct card_no, email_address 
from member natural join borrow 
where date_returned is null and ( (datediff(now(), date_borrowed) > 13 and renewals_no = 0) or (datediff(now(), date_borrowed) > 27 and renewals_no = 1) or (datediff(now(), date_borrowed) > 41 and renewals_no = 2) );
-- ________________________________
