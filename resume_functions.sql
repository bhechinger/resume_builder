---
--- Stored Procedures for Resume Builder
---
--- Resume Handling
---

CREATE OR REPLACE FUNCTION get_resume(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;
		
		SELECT INTO output.id id FROM resumes WHERE name = the_resume;
		IF NOT FOUND THEN
			INSERT INTO resumes (name) VALUES (the_resume);
			SELECT INTO output.id id FROM resumes WHERE name = the_resume;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_resume(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 1;

		SELECT INTO output.name name FROM resumes WHERE id = the_resumeid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'resume not found';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_resume_owner(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM get_resume_owner((SELECT id FROM get_resume(the_resume)));

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_resume_owner(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 2;
		
		SELECT INTO output.id userid FROM resumes WHERE id = the_resumeid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'no such resume';
		ELSEIF output.id IS NULL THEN
			output.which := -1;
			output.name := 'resume has no owner';
		ELSE
			SELECT INTO output.name name FROM get_user(output.id);
		END IF;


		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_resume_owner(VARCHAR, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_user ALIAS FOR $2;
		output multireturn%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM set_resume_owner((SELECT id FROM get_resume(the_resume)), (SELECT id FROM get_user(the_user)));

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_resume_owner(INTEGER, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_user ALIAS FOR $2;
		output multireturn%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM set_resume_owner(the_resume, (SELECT id FROM get_user(the_user)));

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_resume_owner(VARCHAR, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_user ALIAS FOR $2;
		output multireturn%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM set_resume_owner((SELECT id FROM get_resume(the_resume)), the_user);

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_resume_owner(INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		the_userid ALIAS FOR $2;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 3;

		SELECT INTO output.id id FROM resumes WHERE id = the_resumeid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'resume not found';
		END IF;

		SELECT INTO output.id id FROM users WHERE id = the_userid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'resume not found';
		END IF;

		IF output.which <> -1 THEN
			UPDATE resumes SET userid = the_userid WHERE id = the_resumeid;
			output.name := 'set resume ' || the_resumeid || ' to have userid ' || the_userid;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
