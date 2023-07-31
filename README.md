I use SQL Fiddle (http://sqlfiddle.com) to practice and solve this problem. To see the result, on SQL Fiddle:
- choose MS SQL Server 2017
- copy the portion to create table from the sql script to the left window to create Schema
- copy the solution portion from the sql script to the right window. Note: need to select Keyword GO from the dropdown for Query Teminator under the right window before executing the script.

## syntax used in SQL script

If I had access to the SQL server, I would use the #temp table instead of CTE and subqueries (I wasn't able to use temp table on SQL Fiddle for some reasons). I prefer #temp tables since they make the script more readable and easier to test and verify the results along the way.

## The logic to solve the problem:

The company uses First in First out, meaning that the oldest inventory that come in to warehouse is the first to be sold out until the first inventory batch is depleted; then the inventory from the 2nd oldest batch will be used for selling and so on. 
Thus, we need to calculate the total inventory bought during each of these 4 periods; the next step is to calculate the total sold items, then subtract them from 1st batch inventory, then 2nd batch, then 3rd batch etc. 

For this particular problem, we can consider:
-	0-90 days old -> 1st batch
-	91-180 days old -> 2nd batch
-	181-270 days old -> 3rd batch
-	271 – 365 days old -> 4th batch

Simple example for illustration: 
-	For the 1st batch, we bought 5 items; the 2nd we bought 3 items; the 3rd 4 items & the 4th 5 items.
-	Over the time, we sold out total 7 items.
-	Since 7 (sold) > 5 (bought), thus we know that the inventory from the 1st batch was all used up, 2 remaining sold items must come from the 2nd batch. And since 2 (sold) < 3 (bought) we still have 1 item left from 2nd batch. The bought items from 3rd & 4th batch remain unsold.


Website where I found this problem: https://techtfq.com/blog/real-sql-interview-question-asked-by-a-faang-company
You will find several solutions besides the website creator's solution and his video explaining his logic. The solution posted by random 'googler' was mine which is similar to the solution shown in the sql script.
