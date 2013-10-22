Input Tables:
resume_builder=# select * from skills;
 id | resume | skill 
----+--------+-------
  1 |      1 |     1
  2 |      1 |     6
  3 |      1 |     5
  4 |      1 |     4
  5 |      1 |     2
(5 rows)

resume_builder=# select * from skill_info;
 id | sgroup |      sname      
----+--------+-----------------
  1 |      1 | Big Ones
  2 |      1 | Little Ones
  3 |      2 | Straight Brooms
  4 |      2 | Kitchen Brooms
  5 |      2 | Desk Brooms
  6 |      2 | Crooked Brooms
(6 rows)

resume_builder=# select * from skill_groups;
 id |   name   
----+----------
  1 | Wrenches
  2 | Brooms
(2 rows)

Query:
SELECT sg.name AS skill_group, si.sname AS skill_name FROM skills s, skill_info si, skill_groups sg WHERE s.resume = 1 AND si.id = s.skill AND sg.id = si.sgroup;

Output:
 skill_group |   skill_name   
-------------+----------------
 Wrenches    | Big Ones
 Wrenches    | Little Ones
 Brooms      | Kitchen Brooms
 Brooms      | Desk Brooms
 Brooms      | Crooked Brooms
(5 rows)
