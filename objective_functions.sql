---
--- Stored Procedures for Resume Builder
---
--- Objective Handling
---

CREATE OR REPLACE FUNCTION get_objective(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_objectiveid ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 1;

		SELECT INTO output.name objective FROM objectives WHERE id = the_objectiveid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'no such objective';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_objective(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_objective ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		SELECT INTO output.id id FROM objectives WHERE objective = the_objective;

		IF NOT FOUND THEN
			INSERT INTO objectives (objective) VALUES (the_objective);
			SELECT INTO output.id id FROM objectives WHERE objective = the_objective;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_resume_objective(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM get_resume_objective((SELECT objective FROM resumes WHERE name = the_resume));

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_resume_objective(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		objectiveid INTEGER;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 1;

		SELECT INTO objectiveid objective FROM resumes WHERE id = the_resumeid;
		IF NOT FOUND THEN
			--- this needs testing
			output.which := -1;
			output.name := 'either no such resume or resume has no objective';
		ELSE
			SELECT INTO output.name name FROM get_objective(objectiveid);
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_resume_objective(VARCHAR, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_objective ALIAS FOR $2;
		output generic_status%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM set_resume_objective((SELECT id FROM get_resume(the_resume)), (SELECT id FROM get_objective(the_objective)));

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_resume_objective(INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		the_objective ALIAS FOR $2;
		output generic_status%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM set_resume_objective(the_resumeid, (SELECT id FROM get_objective(the_objective)));

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_resume_objective(VARCHAR, INTEGER) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_objectiveid ALIAS FOR $2;
		output generic_status%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM set_resume_objective((SELECT id FROM get_resume(the_resume)), the_objectiveid);

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_resume_objective(INTEGER, INTEGER) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		the_objectiveid ALIAS FOR $2;
		rcode INTEGER;
		output generic_status%ROWTYPE;
	BEGIN
		SELECT INTO rcode which FROM get_resume(the_resumeid);
		IF rcode = -1 THEN
			output.rcode := -1;
			output.message := 'no such resume';

			RETURN NEXT output;
			RETURN;
		END IF;

		SELECT INTO rcode which FROM get_objective(the_objectiveid);
		IF rcode = -1 THEN
			output.rcode := -2;
			output.message := 'no such objective';

			RETURN NEXT output;
			RETURN;
		END IF;

		--- If we got this far then both the resume id and objective id check out
		UPDATE resumes SET objective = the_objectiveid WHERE id = the_resumeid;
		output.rcode := 0;
		output.message := 'objective ' || quote_literal(the_objectiveid) || ' assigned to resume ' || quote_literal(the_resumeid);

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
