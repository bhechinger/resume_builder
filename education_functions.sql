---
--- Stored Procedures for Resume Builder
---
--- Education Handling
---

CREATE OR REPLACE FUNCTION get_edu_info(INTEGER) RETURNS SETOF education_info AS $$
	DECLARE
		the_eduid ALIAS FOR $1;
		output education_info%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM education_info WHERE id = the_eduid;
		IF NOT FOUND THEN
			output.id := -1;
		ELSE
			output.id := 1;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_edu_info_text(INTEGER) RETURNS SETOF education_info_text AS $$
	DECLARE
		the_eduid ALIAS FOR $1;
		edu_info education_info%ROWTYPE;
		output education_info_text%ROWTYPE;
	BEGIN
		SELECT INTO edu_info * FROM get_edu_info(the_eduid);
		output.rcode := edu_info.id;
		IF (edu_info.id = -1) THEN
			output.school := 'education information not found';
		ELSE
			output.school := edu_info.school;
			SELECT INTO output.school_city city FROM get_contactinfo_text(output.school);
			SELECT INTO output.school_state state FROM get_contactinfo_text(output.school);
			output.program := edu_info.program;
			SELECT INTO output.attendence_date name FROM get_date(edu_info.attendence_date);
			output.degree := edu_info.degree;
			output.gpa := edu_info.gpa;
			output.extra := edu_info.extra;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_edu_info(VARCHAR, VARCHAR, VARCHAR, VARCHAR) RETURNS SETOF education_info AS $$
	DECLARE
		the_school ALIAS FOR $1;
		the_program ALIAS FOR $2;
		the_attendence_date ALIAS FOR $3;
		the_degree ALIAS FOR $4;
		attendence_dateid INTEGER;
		output education_info%ROWTYPE;
	BEGIN
		SELECT INTO attendence_dateid id FROM get_date(the_attendence_date);
		SELECT INTO output.id id FROM education_info WHERE school = the_school AND program = the_program AND attendence_date = attendence_dateid AND degree = the_degree;

		IF NOT FOUND THEN
			output.id := -1;
			output.school := 'education info not found';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_edu_info(INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_eduid ALIAS FOR $1;
		the_school ALIAS FOR $2;
		the_program ALIAS FOR $3;
		the_attendencedate ALIAS FOR $4;
		the_degree ALIAS FOR $5;
		output generic_status%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM add_edu_info(the_eduid, the_school, the_program, the_attendencedate, the_degree, NULL, NULL);

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_edu_info(INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR[]) RETURNS SETOF generic_status AS $$
	DECLARE
		the_eduid ALIAS FOR $1;
		the_school ALIAS FOR $2;
		the_program ALIAS FOR $3;
		the_attendencedate ALIAS FOR $4;
		the_degree ALIAS FOR $5;
		the_gpa ALIAS FOR $6;
		output generic_status%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM add_edu_info(the_eduid, the_school, the_program, the_attendencedate, the_degree, the_gpa, NULL);

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_edu_info(INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR[], VARCHAR[]) RETURNS SETOF generic_status AS $$
	DECLARE
		the_eduid ALIAS FOR $1;
		the_school ALIAS FOR $2;
		the_program ALIAS FOR $3;
		the_attendencedate ALIAS FOR $4;
		the_degree ALIAS FOR $5;
		the_gpa ALIAS FOR $6;
		the_extra ALIAS FOR $7;
		output generic_status%ROWTYPE;
		query VARCHAR;
		num_rows INTEGER;
	BEGIN
		output.rcode := 0;

		IF the_eduid = 0 THEN
			--- add (unless exists)
			--- build list of columns to check against (don't check if the input data is NULL)
			query := 'SELECT * FROM education_info WHERE school = ' || quote_literal(the_school) || ' AND program = ' || quote_literal(the_program) || ' AND attendence_date = ' || (SELECT id FROM get_date(the_attendencedate));

			IF the_degree IS NOT NULL THEN
				query := query || ' AND degree = ' || quote_literal(the_degree);
			END IF;
			IF the_gpa IS NOT NULL THEN
				query := query || ' AND gpa = ' || quote_literal(the_gpa);
			END IF;
			IF the_extra IS NOT NULL THEN
				query := query || ' AND extra = ' || quote_literal(the_extra);
			END IF;

			EXECUTE query;
			GET DIAGNOSTICS num_rows = ROW_COUNT;

			IF num_rows != 0 THEN
				output.rcode := -1;
				output.message := 'attempted to add a record that already exists';
			ELSE
				INSERT INTO education_info (school, school_info, program, attendence_date, degree, gpa, extra) VALUES (the_school, (SELECT id FROM get_schoolco(the_school)), the_program, (SELECT id FROM get_date(the_attendencedate)), the_degree, the_gpa, the_extra);
				output.message := 'education info added';
				SELECT INTO output.rcode id FROM education_info WHERE school = the_school AND program = the_program AND attendence_date = (SELECT id FROM get_date(the_attendencedate)) AND degree = the_degree AND gpa = the_gpa AND extra = the_extra;
			END IF;
		ELSE
			--- update (unless does not exist)
			PERFORM * FROM education_info WHERE id = the_eduid;
			IF FOUND THEN
				UPDATE education_info SET school = the_school, program = the_program, attendence_date = (SELECT id FROM get_date(the_attendencedate)), degree = the_degree WHERE id = the_eduid;
				output.message := 'education info updated';
			ELSE
				output.rcode := -2;
				output.message := 'attempted to update non-existant record: ' || the_eduid;
			END IF;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_edu_gpa(INTEGER, VARCHAR[]) RETURNS SETOF generic_status AS $$
	DECLARE
		the_id ALIAS FOR $1;
		the_gpa ALIAS FOR $2;
		output generic_status%ROWTYPE;
	BEGIN
		PERFORM * FROM education_info WHERE id = the_id;
		IF NOT FOUND THEN
			output.rcode := -1;
			output.message := 'no such education info record';
		ELSE
			--- Check that it's an array of only 1 or 2 fields, those are the only two valid options
			IF (array_upper(the_gpa) < 1) OR (array_upper(the_gpa) > 2) THEN
				output.rcode := -2;
				output.message := 'The GPA array is not within range';
			END IF;
			UPDATE education_info SET gpa = the_gpa WHERE id = the_id;
			output.rcode := 0;
			output.message := 'education gpa updated';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_edu_extra(INTEGER, VARCHAR[]) RETURNS SETOF generic_status AS $$
	DECLARE
		the_id ALIAS FOR $1;
		the_extra ALIAS FOR $2;
		output generic_status%ROWTYPE;
	BEGIN
		PERFORM * FROM education_info WHERE id = the_id;
		IF NOT FOUND THEN
			output.rcode := -1;
			output.message := 'no such education info record';
		ELSE
			UPDATE education_info SET extra = the_extra WHERE id = the_id;
			output.rcode := 0;
			output.message := 'education extra updated';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_edu(INTEGER) RETURNS SETOF education_info_text AS $$
	DECLARE
		the_eduid ALIAS FOR $1;
		edu education%ROWTYPE;
		output education_info_text%ROWTYPE;
	BEGIN
		SELECT INTO edu * FROM education WHERE id = the_eduid;
		IF NOT FOUND THEN
			output.rcode := -1;
		ELSE
			SELECT INTO output * FROM get_edu_info_text(edu.edu);
			SELECT INTO output.resume name FROM get_resume(edu.resume);
			output.rcode := 0;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_resume_edu(VARCHAR) RETURNS SETOF education_info_text AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		output education_info_text%ROWTYPE;
	BEGIN
		FOR output IN SELECT * FROM get_resume_edu((SELECT id FROM get_resume(the_resume))) LOOP
			RETURN NEXT output;
		END LOOP;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_resume_edu(INTEGER) RETURNS SETOF education_info_text AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		edu education%ROWTYPE;
		output education_info_text%ROWTYPE;
	BEGIN
		PERFORM * FROM education WHERE resume = the_resumeid;
		IF NOT FOUND THEN
			output.rcode := -1;
			RETURN NEXT output;
		ELSE
			FOR edu IN SELECT * FROM education WHERE resume = the_resumeid LOOP
				SELECT INTO output * FROM get_edu_info_text(edu.edu);
				SELECT INTO output.resume name FROM get_resume(edu.resume);
				output.rcode := 0;
				RETURN NEXT output;
			END LOOP;
		END IF;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_edu(INTEGER, INTEGER, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_eduid ALIAS FOR $1;
		the_resume ALIAS FOR $2;
		the_eduinfoid ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_edu(the_eduid, the_resume, (SELECT id FROM education_info WHERE school = the_eduinfoid));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_edu(INTEGER, VARCHAR, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_eduid ALIAS FOR $1;
		the_resume ALIAS FOR $2;
		the_eduinfoid ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_edu(the_eduid, (SELECT id FROM get_resume(the_resume)), (SELECT id FROM education_info WHERE school = the_eduinfoid));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_edu(INTEGER, VARCHAR, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_eduid ALIAS FOR $1;
		the_resume ALIAS FOR $2;
		the_eduinfoid ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_edu(the_eduid, (SELECT id FROM get_resume(the_resume)), the_eduinfoid);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_edu(INTEGER, INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_eduid ALIAS FOR $1;
		the_resumeid ALIAS FOR $2;
		the_eduinfoid ALIAS FOR $3;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		PERFORM * FROM resumes WHERE id = the_resumeid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'resume not found';
		END IF;

		PERFORM * FROM education_info WHERE id = the_eduinfoid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'education info not found';
		END IF;

		IF (output.which <> -1) THEN
			IF (the_eduid = 0) THEN
				--- add
				SELECT INTO output.id id FROM education WHERE resume = the_resumeid AND edu = the_eduinfoid;
				IF NOT FOUND THEN
					INSERT INTO education (resume, edu) VALUES (the_resumeid, the_eduinfoid);
					SELECT INTO output.id id FROM education WHERE resume = the_resumeid AND edu = the_eduinfoid;
					output.name := 'added education ' || output.id || ' to have resume ' || the_resumeid || ' and education info ' || the_eduinfoid;
				END IF;
			ELSE
				--- update
				UPDATE education SET resume = the_resumeid, edu = the_eduinfoid WHERE id = the_eduid;
				output.name := 'updated education ' || the_eduid || ' to have resume ' || the_resumeid || ' and education info ' || the_eduinfoid;
			END IF;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
