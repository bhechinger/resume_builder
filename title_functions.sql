---
--- Title related Stored Procedures for Resume Builder
---

CREATE OR REPLACE FUNCTION get_title(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_title ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		SELECT INTO output.id id FROM titles WHERE name = the_title;
		IF NOT FOUND THEN
			INSERT INTO titles (name) VALUES (the_title);
			SELECT INTO output.id id FROM titles WHERE name = the_title;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_title(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_titleid ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 1;

		SELECT INTO output.name name FROM titles WHERE id = the_titleid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'title not found';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
