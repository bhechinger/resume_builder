---
--- Types for Resume Builder
---

CREATE TYPE generic_status AS (
	rcode INTEGER,
	message VARCHAR
);

CREATE TYPE multireturn AS (
	which INTEGER,
	id INTEGER,
	name VARCHAR
);

CREATE TYPE contact_info_text AS (
	rcode INTEGER,
	id INTEGER,
	prefix VARCHAR,
	name VARCHAR,
	last_name VARCHAR,
	suffix VARCHAR,
	title VARCHAR,
	address1 VARCHAR,
	address2 VARCHAR,
	city VARCHAR,
	state VARCHAR,
	zip VARCHAR,
	home_phone VARCHAR,
	cell_phone VARCHAR,
	work_phone VARCHAR,
	alt_phone VARCHAR,
	pager VARCHAR,
	email VARCHAR,
	web_url VARCHAR
);

CREATE TYPE experience_info_text AS (
	rcode INTEGER,
	resume VARCHAR,
	title VARCHAR,
	start_date VARCHAR,
	end_date VARCHAR,
	company VARCHAR,
	company_city VARCHAR,
	company_state VARCHAR,
	details VARCHAR
);

CREATE TYPE education_info_text AS (
	rcode INTEGER,
	resume VARCHAR,
	school VARCHAR,
	school_city VARCHAR,
	school_state VARCHAR,
	program VARCHAR,
	attendence_date VARCHAR,
	degree VARCHAR,
	gpa VARCHAR[],
	extra VARCHAR[]
);

CREATE TYPE certification_info_text AS (
	rcode INTEGER,
	resume VARCHAR,
	name VARCHAR,
	receive_date VARCHAR,
	expires_date VARCHAR,
	certificate_id VARCHAR
);

CREATE TYPE formatted_skill_list AS (
	skill_group VARCHAR,
	subskill_group VARCHAR,
	skills VARCHAR
);

CREATE TYPE skillset_pair AS (
	rcode INTEGER,
	message VARCHAR,
	id INTEGER,
	skillgroup VARCHAR,
	subskillgroup VARCHAR,
	skillname VARCHAR
);
