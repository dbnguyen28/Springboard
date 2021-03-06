
/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT 
        name
      , membercost
   FROM Facilities
  WHERE membercost <> 0;

/* Q2: How many facilities do not charge a fee to members? */

SELECT count(name)
FROM Facilities
WHERE membercost = 0;

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT 
		   facid
	   , name
     , membercost
	   , monthlymaintenance
  FROM Facilities
 where membercost < (monthlymaintenance*0.2)
 ;

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT *
  FROM Facilities
 where facid in (1,5)
;


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT 
        name
      , monthlymaintenance
      , case
	          when monthlymaintenance > 100 then 'expensive'
            else 'cheap'
        end as cost
  FROM  Facilities
;

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

select 
m.firstname
, m.surname
from Members m
join Bookings b
  on m.memid = b.memid
where starttime = (select max(starttime) from Bookings)
;

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT distinct
 	     CONCAT( m.firstname, " ", m.surname ) AS bookings
     , f.name
  FROM Facilities f
  join Bookings b
    on b.facid = f.facid
  join Members m
    on m.memid = b.memid
 where f.name like 'Tennis%'
 order by bookings
 ;

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT 
 	   f.name
     , concat(m.firstname," ", m.surname) as fullname
     , case
           when b.memid=0 then f.guestcost*b.slots
           else f.membercost*b.slots
		   end as cost
  FROM Bookings b
  join Members m
    on m.memid = b.memid
  join Facilities f
    on f.facid = b.facid
where cast(b.starttime AS date)  = '2012-09-14'
  and case
           when b.memid=0 then f.guestcost*b.slots
           else f.membercost*b.slots
        end > 30
order by cost desc
;

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

select *
from
(SELECT 
 	   f.name
     , concat(m.firstname," ", m.surname) as fullname
     , case
           when b.memid=0 then f.guestcost*b.slots
           else f.membercost*b.slots
		   end as cost
     , b.starttime
  FROM Bookings b
  join Members m
    on m.memid = b.memid
  join Facilities f
    on f.facid = b.facid

) a 
where cast(a.starttime AS date)  = '2012-09-14'
  and a.cost > 30
order by cost desc
;

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

select 
      * 
from 
(
select 
	f.name 
      , sum(case
               when b.memid=0 then f.guestcost*b.slots
               else f.membercost*b.slots
	    end) as total_revenue
from Bookings b
join Facilities f
  on b.facid = f.facid
join Members m
  on m.memid = b.memid
group by f.name
) a
where a.total_revenue < 1000
order by a.total_revenue
;




