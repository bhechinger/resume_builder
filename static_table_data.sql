---
--- The months of the year static table
---

INSERT INTO months (id, short_name, long_name) VALUES (0, 'Pre', 'Present');
INSERT INTO months (id, short_name, long_name) VALUES (1, 'Jan', 'January');
INSERT INTO months (id, short_name, long_name) VALUES (2, 'Feb', 'February');
INSERT INTO months (id, short_name, long_name) VALUES (3, 'Mar', 'March');
INSERT INTO months (id, short_name, long_name) VALUES (4, 'Apr', 'April');
INSERT INTO months (id, short_name, long_name) VALUES (5, 'May', 'May');
INSERT INTO months (id, short_name, long_name) VALUES (6, 'Jun', 'June');
INSERT INTO months (id, short_name, long_name) VALUES (7, 'Jul', 'July');
INSERT INTO months (id, short_name, long_name) VALUES (8, 'Aug', 'August');
INSERT INTO months (id, short_name, long_name) VALUES (9, 'Sep', 'September');
INSERT INTO months (id, short_name, long_name) VALUES (10, 'Oct', 'October');
INSERT INTO months (id, short_name, long_name) VALUES (11, 'Nov', 'November');
INSERT INTO months (id, short_name, long_name) VALUES (12, 'Dec', 'December');

---
--- This is some dummy data so that get_date() can work with NULL/invalid input and return 0
---

INSERT INTO months (id, short_name, long_name) VALUES (13, 'NUL', 'NULL');
INSERT INTO dates (id, month) VALUES (0, 13);
