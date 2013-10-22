---
--- Stored Procedures for Resume Builder
---

---
--- Experience Handling
---

CREATE OR REPLACE FUNCTION get_exp_info_text(INTEGER) RETURNS SETOF experience_info_text AS $$
	DECLARE
		the_expid ALIAS FOR $1;
		exp_info experience_info%ROWTYPE;
		output experience_info_text%ROWTYPE;
	BEGIN
		SELECT INTO exp_info * FROM get_exp_info(the_expid);
		SELECT INTO output.title name FROM get_title(exp_info.title);
		SELECT INTO output.company name FROM get_schoolco(exp_info.company);
		SELECT INTO output.company_city city FROM get_contactinfo_text(output.company);
		SELECT INTO output.company_state state FROM get_contactinfo_text(output.company);
		output.details := exp_info.details;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_exp_info(INTEGER) RETURNS SETOF experience_info AS $$
	DECLARE
		the_expid ALIAS FOR $1;
		output experience_info%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM experience_info WHERE id = the_expid;
		IF NOT FOUND THEN
			output.id := -1;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_exp_info(VARCHAR, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_title ALIAS FOR $1;
		the_company ALIAS FOR $2;
		titleid INTEGER;
		companyid INTEGER;
		output generic_status%ROWTYPE;
	BEGIN
		SELECT INTO titleid id FROM get_title(the_title);
		SELECT INTO companyid id FROM get_schoolco(the_company);

		SELECT INTO output.rcode id FROM experience_info WHERE title = titleid AND company = companyid;

		IF NOT FOUND THEN
			output.rcode := -1;
			output.message := 'experience info not found';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_exp_info(INTEGER, VARCHAR, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_expid ALIAS FOR $1;
		the_title ALIAS FOR $2;
		the_company ALIAS FOR $3;
		output generic_status%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM add_exp_info(the_expid, the_title, the_company, NULL);

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_exp_info(INTEGER, VARCHAR, VARCHAR, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_expid ALIAS FOR $1;
		the_title ALIAS FOR $2;
		the_company ALIAS FOR $3;
		the_details ALIAS FOR $4;
		titleid INTEGER;
		start_dateid INTEGER;
		end_dateid INTEGER;
		companyid INTEGER;
		output generic_status%ROWTYPE;
	BEGIN
		SELECT INTO titleid id FROM get_title(the_title);
		SELECT INTO companyid id FROM get_schoolco(the_company);

		IF (the_expid = 0) THEN
			--- we are adding data
			SELECT INTO output * FROM get_exp_info(the_title, the_company);
			IF (output.rcode = -1) THEN
				IF the_details IS NOT NULL THEN
					INSERT INTO experience_info (title, company, details) VALUES (titleid, companyid, the_details);
				ELSE
					INSERT INTO experience_info (title, company) VALUES (titleid, companyid);
				END IF;
				SELECT INTO output * FROM get_exp_info(the_title, the_company);
				output.message := 'record added';
			ELSE
				output.message := 'record already exists';
			END IF;
		ELSE
			--- we are updating data
			UPDATE experience_info SET title = titleid, company = companyid WHERE id = the_expid;
			IF the_details IS NOT NULL THEN
				UPDATE experience_info SET details = the_details WHERE id = the_expid;
				output.rcode := the_expid;
				output.message := 'record updated';
			END IF;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_exp_details(INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_expid ALIAS FOR $1;
		the_details ALIAS FOR $2;
		output generic_status%ROWTYPE;
	BEGIN
		PERFORM * FROM experience_info WHERE id = the_expid;
		IF NOT FOUND THEN
			output.rcode := -1;
			output.message := 'no such experience info record';
		ELSE
			UPDATE experience_info SET details = the_details WHERE id = the_expid;
			output.rcode := 0;
			output.message := 'experience details updated';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_exp(INTEGER) RETURNS SETOF experience_info_text AS $$
	DECLARE
		the_expid ALIAS FOR $1;
		exp experience%ROWTYPE;
		output experience_info_text%ROWTYPE;
	BEGIN
		SELECT INTO exp * FROM experience WHERE id = the_expid;
		IF NOT FOUND THEN
			output.rcode := -1;
		ELSE
			SELECT INTO output * FROM get_exp_info_text(exp.exp);
			SELECT INTO output.resume name FROM get_resume(exp.resume);
			SELECT INTO output.start_date name FROM get_date(exp.start_date);
			SELECT INTO output.end_date name FROM get_date(exp.end_date);
			output.rcode := 0;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_resume_exp(VARCHAR) RETURNS SETOF experience_info_text AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		output experience_info_text%ROWTYPE;
	BEGIN
		FOR output IN SELECT * FROM get_resume_exp((SELECT id FROM get_resume(the_resume))) LOOP
			RETURN NEXT output;
		END LOOP;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_resume_exp(INTEGER) RETURNS SETOF experience_info_text AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		exp experience%ROWTYPE;
		output experience_info_text%ROWTYPE;
	BEGIN
		PERFORM * FROM experience WHERE resume = the_resumeid;
		IF NOT FOUND THEN
			output.rcode := -1;
			RETURN NEXT output;
		ELSE
			FOR exp IN SELECT * FROM experience WHERE resume = the_resumeid LOOP
				SELECT INTO output * FROM get_exp_info_text(exp.exp);
				SELECT INTO output.resume name FROM get_resume(exp.resume);
				SELECT INTO output.start_date name FROM get_date(exp.start_date);
				SELECT INTO output.end_date name FROM get_date(exp.end_date);
				output.rcode := 0;
				RETURN NEXT output;
			END LOOP;
		END IF;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_exp(INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_expid ALIAS FOR $1;
		the_resume ALIAS FOR $2;
		the_start_date ALIAS FOR $3;
		the_end_date ALIAS FOR $4;
		the_title ALIAS FOR $5;
		the_company ALIAS FOR $6;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_exp(the_expid, (SELECT id FROM get_resume(the_resume)), (SELECT id FROM get_date(the_start_date)), (SELECT id FROM get_date(the_end_date)), (SELECT id FROM experience_info WHERE title = (SELECT id FROM get_title(the_title)) AND company = (SELECT id FROM get_schoolco(the_company))));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_exp(INTEGER, VARCHAR, VARCHAR, VARCHAR, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_expid ALIAS FOR $1;
		the_resume ALIAS FOR $2;
		the_start_date ALIAS FOR $3;
		the_end_date ALIAS FOR $4;
		the_expinfoid ALIAS FOR $5;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_exp(the_expid, (SELECT id FROM get_resume(the_resume)), (SELECT id FROM get_date(the_start_date)), (SELECT id FROM get_date(the_end_date)), the_expinfoid);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_exp(INTEGER, VARCHAR, INTEGER, VARCHAR, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_expid ALIAS FOR $1;
		the_resume ALIAS FOR $2;
		the_start_date ALIAS FOR $3;
		the_end_date ALIAS FOR $4;
		the_expinfoid ALIAS FOR $5;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_exp(the_expid, (SELECT id FROM get_resume(the_resume)), the_start_date, (SELECT id FROM get_date(the_end_date)), the_expinfoid);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_exp(INTEGER, VARCHAR, VARCHAR, INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_expid ALIAS FOR $1;
		the_resume ALIAS FOR $2;
		the_start_date ALIAS FOR $3;
		the_end_date ALIAS FOR $4;
		the_expinfoid ALIAS FOR $5;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_exp(the_expid, (SELECT id FROM get_resume(the_resume)), (SELECT id FROM get_date(the_start_date)), the_end_date, the_expinfoid);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_exp(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_expid ALIAS FOR $1;
		the_resumeid ALIAS FOR $2;
		the_start_date ALIAS FOR $3;
		the_end_date ALIAS FOR $4;
		the_expinfoid ALIAS FOR $5;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		PERFORM * FROM resumes WHERE id = the_resumeid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'resume not found';
		END IF;

		PERFORM * FROM experience_info WHERE id = the_expinfoid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'experience info not found';
		END IF;

		IF (output.which <> -1) THEN
			IF (the_expid = 0) THEN
				--- add
				SELECT INTO output.id id FROM experience WHERE resume = the_resumeid AND start_date = the_start_date AND end_date = the_end_date AND exp = the_expinfoid;
				IF NOT FOUND THEN
					INSERT INTO experience (resume, start_date, end_date, exp) VALUES (the_resumeid, the_start_date, the_end_date, the_expinfoid);
					SELECT INTO output.id id FROM experience WHERE resume = the_resumeid AND start_date = the_start_date AND end_date = the_end_date AND exp = the_expinfoid;
					output.name := 'added experience ' || output.id || ' to have resume ' || the_resumeid || ' and experience info ' || the_expinfoid;
				END IF;
			ELSE
				--- update
				UPDATE experience SET resume = the_resumeid, exp = the_expinfoid, start_date = the_start_date, end_date = the_end_date WHERE id = the_expid;
				output.name := 'updated experience ' || the_expid || ' to have resume ' || the_resumeid || ' and experience info ' || the_expinfoid;
			END IF;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
