---
--- Postgresql tables for Resume Builder
---

SET search_path = public, pg_catalog;

--
CREATE TABLE months (
	id SERIAL NOT NULL PRIMARY KEY,
	short_name VARCHAR NOT NULL,
	long_name VARCHAR NOT NULL,
	UNIQUE (short_name),
	UNIQUE (long_name)
);
REVOKE ALL ON TABLE months FROM PUBLIC;
GRANT ALL ON TABLE months TO wonko;
REVOKE ALL ON TABLE months_id_seq FROM PUBLIC;
GRANT ALL ON TABLE months_id_seq TO wonko;

CREATE TABLE titles (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR NOT NULL,
	UNIQUE (name)
);
REVOKE ALL ON TABLE titles FROM PUBLIC;
GRANT ALL ON TABLE titles TO wonko;
REVOKE ALL ON TABLE titles_id_seq FROM PUBLIC;
GRANT ALL ON TABLE titles_id_seq TO wonko;

CREATE TABLE skill_groups (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR NOT NULL,
	UNIQUE (name)
);
REVOKE ALL ON TABLE skill_groups FROM PUBLIC;
GRANT ALL ON TABLE skill_groups TO wonko;
REVOKE ALL ON TABLE skill_groups_id_seq FROM PUBLIC;
GRANT ALL ON TABLE skill_groups_id_seq TO wonko;

CREATE TABLE skill_info (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR
);
REVOKE ALL ON TABLE skill_info FROM PUBLIC;
GRANT ALL ON TABLE skill_info TO wonko;
REVOKE ALL ON TABLE skill_info_id_seq FROM PUBLIC;
GRANT ALL ON TABLE skill_info_id_seq TO wonko;

CREATE TABLE dates (
	id SERIAL NOT NULL PRIMARY KEY,
	month INTEGER REFERENCES months(id),
	day INTEGER,
	year INTEGER,
	CONSTRAINT check_month CHECK (month >= 0 AND month < 14),
	CONSTRAINT check_day CHECK (day >= 0 AND day < 31),
	CONSTRAINT check_year CHECK (year > 0 AND year < 10000),
	UNIQUE (day, month, year)
);
REVOKE ALL ON TABLE dates FROM PUBLIC;
GRANT ALL ON TABLE dates TO wonko;
REVOKE ALL ON TABLE dates_id_seq FROM PUBLIC;
GRANT ALL ON TABLE dates_id_seq TO wonko;

CREATE TABLE phones (
	id SERIAL NOT NULL PRIMARY KEY,
	area_code INTEGER NOT NULL,
	prefix INTEGER NOT NULL,
	last INTEGER NOT NULL,
	extention INTEGER,
	CONSTRAINT check_area_code CHECK (area_code > 199 AND area_code < 1000),
	CONSTRAINT check_prefix CHECK (prefix > 99 AND prefix < 1000),
	CONSTRAINT check_last CHECK (last > 0 AND last < 10000),
	CONSTRAINT check_ext CHECK (extention > -2),
	UNIQUE (area_code, prefix, last, extention)
);
REVOKE ALL ON TABLE phones FROM PUBLIC;
GRANT ALL ON TABLE phones TO wonko;
REVOKE ALL ON TABLE phones_id_seq FROM PUBLIC;
GRANT ALL ON TABLE phones_id_seq TO wonko;

CREATE TABLE contact_info (
	id SERIAL NOT NULL PRIMARY KEY,
	prefix VARCHAR,
	name VARCHAR NOT NULL,
	suffix VARCHAR,
	title VARCHAR,
	address1 VARCHAR,
	address2 VARCHAR,
	city VARCHAR,
	state VARCHAR,
	zip INTEGER,
	zip4 INTEGER,
	home_phone INTEGER REFERENCES phones(id),
	cell_phone INTEGER REFERENCES phones(id),
	work_phone INTEGER REFERENCES phones(id),
	alt_phone INTEGER REFERENCES phones(id),
	pager INTEGER REFERENCES phones(id),
	email VARCHAR,
	web_url VARCHAR,
	CONSTRAINT check_zip CHECK (zip > 0 AND zip < 100000),
	CONSTRAINT check_zip4 CHECK (zip4 > -1 AND zip4 < 10000),
	UNIQUE (name)
);
REVOKE ALL ON TABLE contact_info FROM PUBLIC;
GRANT ALL ON TABLE contact_info TO wonko;
REVOKE ALL ON TABLE contact_info_id_seq FROM PUBLIC;
GRANT ALL ON TABLE contact_info_id_seq TO wonko;

CREATE TABLE schoolco (
	id SERIAL NOT NULL PRIMARY KEY,
	schoolco_info INTEGER REFERENCES contact_info(id),
	contact_info INTEGER REFERENCES contact_info(id),
	UNIQUE (schoolco_info, contact_info)
);
REVOKE ALL ON TABLE schoolco FROM PUBLIC;
GRANT ALL ON TABLE schoolco TO wonko;
REVOKE ALL ON TABLE schoolco_id_seq FROM PUBLIC;
GRANT ALL ON TABLE schoolco_id_seq TO wonko;

CREATE TABLE users (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR NOT NULL,
	contact_info INTEGER REFERENCES contact_info(id),
	UNIQUE (name)
);
REVOKE ALL ON TABLE users FROM PUBLIC;
GRANT ALL ON TABLE users TO wonko;
REVOKE ALL ON TABLE users_id_seq FROM PUBLIC;
GRANT ALL ON TABLE users_id_seq TO wonko;

CREATE TABLE objectives (
	id SERIAL NOT NULL PRIMARY KEY,
	objective VARCHAR,
	UNIQUE (objective)
);
REVOKE ALL ON TABLE objectives FROM PUBLIC;
GRANT ALL ON TABLE objectives TO wonko;
REVOKE ALL ON TABLE objectives_id_seq FROM PUBLIC;
GRANT ALL ON TABLE objectives_id_seq TO wonko;

CREATE TABLE resumes (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR NOT NULL,
	userid INTEGER REFERENCES users(id),
	objective INTEGER REFERENCES objectives(id),
	UNIQUE (name)
);
REVOKE ALL ON TABLE resumes FROM PUBLIC;
GRANT ALL ON TABLE resumes TO wonko;
REVOKE ALL ON TABLE resumes_id_seq FROM PUBLIC;
GRANT ALL ON TABLE resumes_id_seq TO wonko;

CREATE TABLE skillsets (
	id SERIAL NOT NULL PRIMARY KEY,
	skill INTEGER REFERENCES skill_info(id),
	skillgroup INTEGER REFERENCES skill_groups(id),
	subskillgroup INTEGER REFERENCES skill_groups(id),
	UNIQUE (skill, skillgroup, subskillgroup)
);
REVOKE ALL ON TABLE skillsets FROM PUBLIC;
GRANT ALL ON TABLE skillsets TO wonko;
REVOKE ALL ON TABLE skillsets_id_seq FROM PUBLIC;
GRANT ALL ON TABLE skillsets_id_seq TO wonko;

CREATE TABLE skills (
	id SERIAL NOT NULL PRIMARY KEY,
	resume INTEGER REFERENCES resumes(id),
	skill INTEGER REFERENCES skillsets(id),
	UNIQUE (resume, skill)
);
REVOKE ALL ON TABLE skills FROM PUBLIC;
GRANT ALL ON TABLE skills TO wonko;
REVOKE ALL ON TABLE skills_id_seq FROM PUBLIC;
GRANT ALL ON TABLE skills_id_seq TO wonko;

CREATE TABLE experience_info (
	id SERIAL NOT NULL PRIMARY KEY,
	title INTEGER REFERENCES titles(id),
	company INTEGER REFERENCES schoolco(id),
	details VARCHAR,
	UNIQUE (title, company)
);
REVOKE ALL ON TABLE experience_info FROM PUBLIC;
GRANT ALL ON TABLE experience_info TO wonko;
REVOKE ALL ON TABLE experience_info_id_seq FROM PUBLIC;
GRANT ALL ON TABLE experience_info_id_seq TO wonko;

CREATE TABLE experience (
	id SERIAL NOT NULL PRIMARY KEY,
	resume INTEGER REFERENCES resumes(id),
	exp INTEGER REFERENCES experience_info(id),
	start_date INTEGER REFERENCES dates(id),
	end_date INTEGER REFERENCES dates(id),
	UNIQUE (resume, exp, start_date, end_date)
);
REVOKE ALL ON TABLE experience FROM PUBLIC;
GRANT ALL ON TABLE experience TO wonko;
REVOKE ALL ON TABLE experience_id_seq FROM PUBLIC;
GRANT ALL ON TABLE experience_id_seq TO wonko;

CREATE TABLE education_info (
	id SERIAL NOT NULL PRIMARY KEY,
	school VARCHAR NOT NULL,
	school_info INTEGER REFERENCES schoolco(id),
	program VARCHAR DEFAULT NULL,
	attendence_date INTEGER REFERENCES dates(id),
	degree VARCHAR DEFAULT NULL,
	gpa VARCHAR[] DEFAULT NULL,
	extra VARCHAR[] DEFAULT NULL,
	UNIQUE (school, school_info, program, attendence_date, degree, gpa, extra)
);
REVOKE ALL ON TABLE education_info FROM PUBLIC;
GRANT ALL ON TABLE education_info TO wonko;
REVOKE ALL ON TABLE education_info_id_seq FROM PUBLIC;
GRANT ALL ON TABLE education_info_id_seq TO wonko;

CREATE TABLE education (
	id SERIAL NOT NULL PRIMARY KEY,
	resume INTEGER REFERENCES resumes(id),
	edu INTEGER REFERENCES education_info(id),
	UNIQUE (resume, edu)
);
REVOKE ALL ON TABLE education FROM PUBLIC;
GRANT ALL ON TABLE education TO wonko;
REVOKE ALL ON TABLE education_id_seq FROM PUBLIC;
GRANT ALL ON TABLE education_id_seq TO wonko;

CREATE TABLE certification_info (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR NOT NULL,
	receive_date INTEGER REFERENCES dates(id),
	expires_date INTEGER REFERENCES dates(id),
	certificate_id VARCHAR,
	UNIQUE (name, receive_date, expires_date, certificate_id)
);
REVOKE ALL ON TABLE certification_info FROM PUBLIC;
GRANT ALL ON TABLE certification_info TO wonko;
REVOKE ALL ON TABLE certification_info_id_seq FROM PUBLIC;
GRANT ALL ON TABLE certification_info_id_seq TO wonko;

CREATE TABLE certifications (
	id SERIAL NOT NULL PRIMARY KEY,
	resume INTEGER REFERENCES resumes(id),
	cert INTEGER REFERENCES certification_info(id),
	UNIQUE (resume, cert)
);
REVOKE ALL ON TABLE certifications FROM PUBLIC;
GRANT ALL ON TABLE certifications TO wonko;
REVOKE ALL ON TABLE certifications_id_seq FROM PUBLIC;
GRANT ALL ON TABLE certifications_id_seq TO wonko;

CREATE TABLE resume_templates (
	id SERIAL NOT NULL PRIMARY KEY,
	template_name VARCHAR NOT NULL,
	header VARCHAR,
	name VARCHAR,
	permanent_address VARCHAR,
	present_address VARCHAR,
	seperator VARCHAR,
	objective VARCHAR,
	education_header VARCHAR,
	edu_comma_list VARCHAR[][],
	education VARCHAR,
	experience_header VARCHAR,
	experience VARCHAR,
	skills_header VARCHAR,
	skills VARCHAR,
	skill_list_header VARCHAR,
	skill_list_item VARCHAR,
	skill_list_footer VARCHAR,
	certifications_header VARCHAR,
	certifications VARCHAR,
	footer VARCHAR,
	template_order VARCHAR[],
	UNIQUE (template_name)
);
REVOKE ALL ON TABLE resume_templates FROM PUBLIC;
GRANT ALL ON TABLE resume_templates TO wonko;
REVOKE ALL ON TABLE resume_templates_id_seq FROM PUBLIC;
GRANT ALL ON TABLE resume_templates_id_seq TO wonko;

CREATE TABLE coverletter_templates (
	id SERIAL NOT NULL PRIMARY KEY,
	template_name VARCHAR,
	header VARCHAR,
	signature VARCHAR,
	contact_info VARCHAR,
	personal_info VARCHAR,
	opening VARCHAR,
	paragraph VARCHAR,
	closing VARCHAR,
	UNIQUE (header, signature, contact_info, personal_info, opening, closing)
);
REVOKE ALL ON TABLE coverletter_templates FROM PUBLIC;
GRANT ALL ON TABLE coverletter_templates TO wonko;
REVOKE ALL ON TABLE coverletter_templates_id_seq FROM PUBLIC;
GRANT ALL ON TABLE coverletter_templates_id_seq TO wonko;

CREATE TABLE misc_files (
	id SERIAL NOT NULL PRIMARY KEY,
	filename VARCHAR,
	filecontent VARCHAR,
	used_by VARCHAR,
	UNIQUE (filename)
);
REVOKE ALL ON TABLE misc_files FROM PUBLIC;
GRANT ALL ON TABLE misc_files TO wonko;
REVOKE ALL ON TABLE misc_files_id_seq FROM PUBLIC;
GRANT ALL ON TABLE misc_files_id_seq TO wonko;

CREATE TABLE cover_letters (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR,
	paragraphs VARCHAR[],
	UNIQUE (name)
);
REVOKE ALL ON TABLE cover_letters FROM PUBLIC;
GRANT ALL ON TABLE cover_letters TO wonko;
REVOKE ALL ON TABLE cover_letters_id_seq FROM PUBLIC;
GRANT ALL ON TABLE cover_letters_id_seq TO wonko;
