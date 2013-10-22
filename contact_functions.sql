---
--- Stored Procedures for Resume Builder
---

---
--- Contact Handling
---

CREATE OR REPLACE FUNCTION set_contact(VARCHAR, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_contact ALIAS FOR $1;
		the_schoolco ALIAS FOR $2;
		output multireturn%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM set_contact((SELECT id FROM get_contactinfo(the_contact)), (SELECT id FROM get_contactinfo(the_schoolco)));

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_contact(INTEGER, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_contact ALIAS FOR $1;
		the_schoolco ALIAS FOR $2;
		output multireturn%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM set_contact(the_contact, (SELECT id FROM get_contactinfo(the_schoolco)));

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_contact(VARCHAR, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_contact ALIAS FOR $1;
		the_schoolco ALIAS FOR $2;
		output multireturn%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM set_contact((SELECT id FROM get_contactinfo(the_contact)), the_schoolco);

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_contact(INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_contactid ALIAS FOR $1;
		the_schoolcoid ALIAS FOR $2;
		tmprec contact_info%ROWTYPE;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 3;

		SELECT INTO tmprec * FROM get_contactinfo(the_contactid);
		IF (tmprec.id = -1) THEN
			output.which := -1;
			output.name := tmprec.name;
			RETURN NEXT output;
			RETURN;
		END IF;

		SELECT INTO tmprec * FROM get_contactinfo(the_schoolcoid);
		IF (tmprec.id = -1) THEN
			output.which := -1;
			output.name := tmprec.name;
			RETURN NEXT output;
			RETURN;
		END IF;

		PERFORM * FROM schoolco WHERE schoolco_info = the_schoolcoid;
		IF FOUND THEN
			UPDATE schoolco SET contact_info = the_contactid WHERE schoolco_info = the_schoolcoid;
		ELSE
			INSERT INTO schoolco (contact_info, schoolco_info) VALUES (the_contactid, the_schoolcoid);
		END IF;

		output.name := 'Updated schoolco table, set schoolcoid ' || the_schoolcoid || ' to have contactid ' || the_contactid;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_contact(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_schoolco ALIAS FOR $1;
		contactinfoid INTEGER;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 2;

		SELECT INTO contactinfoid id FROM get_contactinfo(the_schoolco);
		SELECT INTO output.id contact_info FROM schoolco WHERE schoolco_info = contactinfoid;
		IF output.id IS NOT NULL THEN
			SELECT INTO output.name name FROM get_contactinfo(output.id);
		ELSE
			output.which := -1;
			output.name := 'company/school has no contact';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_contact(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_schoolcoid ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 2;

		SELECT INTO output.id contact_info FROM schoolco WHERE schoolco_info = the_schoolcoid;
		IF output.id IS NOT NULL THEN
			SELECT INTO output.name name FROM get_contactinfo(output.id);
		ELSE
			output.which := -1;
			output.name := 'company/school has no contact';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
