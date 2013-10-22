---
--- Stored Procedures for Resume Builder
---

---
--- SchoolCo Handling
---

CREATE OR REPLACE FUNCTION get_schoolco(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_name ALIAS FOR $1;
		contactinfoid INTEGER;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		SELECT INTO contactinfoid id FROM get_contactinfo(the_name);
		SELECT INTO output.id id FROM schoolco WHERE schoolco_info = contactinfoid;
		IF NOT FOUND THEN
			INSERT INTO schoolco (schoolco_info) VALUES (contactinfoid);
			SELECT INTO output.id id FROM schoolco WHERE schoolco_info = contactinfoid;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_schoolco(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_id ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 1;

		SELECT INTO output.name name FROM get_contactinfo((SELECT schoolco_info FROM schoolco WHERE id = the_id));
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'company/school not found';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
