---LECTURE 21 : ADVANTAGES OF STORED PROCEDURES ---

--PERFORMANCE
--1. EXECUTION PLAN RETENTION AND REUSABILITY OF EXECUTION PLAN (Even a slight change in ad-hoc queries can tend to create new execution plan but that's not the case with SP's)
--2. REDUCES NETWORK TRAFFIC (Unlike ad-hoc queries only the Stored procedures name and it's parameters gets transferred over the network.)

--MAINTAINABILITY
--3. Code reusability and better maintainability (change at 1 place reflect at every place.)

--SECURITY
--4. SP's provide better security : by giving user the access to SP and not to the table and its data itself.
--5. Avoids SQL Injection attack