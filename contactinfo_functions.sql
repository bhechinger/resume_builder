---
--- Stored Procedures for Resume Builder
---

CREATE OR REPLACE FUNCTION get_contactinfo(VARCHAR) RETURNS SETOF contact_info AS $$
	DECLARE
		the_name ALIAS FOR $1;
		output contact_info%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM contact_info WHERE name = the_name;
		IF NOT FOUND THEN
			INSERT INTO contact_info (name) VALUES (the_name);
			SELECT INTO output * FROM contact_info WHERE name = the_name;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_contactinfo(INTEGER) RETURNS SETOF contact_info AS $$
	DECLARE
		the_id ALIAS FOR $1;
		output contact_info%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM contact_info WHERE id = the_id;
		IF NOT FOUND THEN
			output.id := -1;
			output.name := 'contact not found';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_contactinfo_text(VARCHAR) RETURNS SETOF contact_info_text AS $$
	DECLARE
		the_name ALIAS FOR $1;
		output contact_info_text%ROWTYPE;
	BEGIN
		SELECT INTO output.id id FROM contact_info WHERE name = the_name;
		IF NOT FOUND THEN
			INSERT INTO contact_info (name) VALUES (the_name);
			SELECT INTO output.id id FROM contact_info WHERE name = the_name;
		ELSE
			SELECT INTO output * FROM get_contactinfo_text(output.id);
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_contactinfo_text(INTEGER) RETURNS SETOF contact_info_text AS $$
	DECLARE
		the_id ALIAS FOR $1;
		tmpinfo contact_info%ROWTYPE;
		output contact_info_text%ROWTYPE;
		split_name VARCHAR[];
	BEGIN
		SELECT INTO tmpinfo * FROM contact_info WHERE id = the_id;
		IF NOT FOUND THEN
			output.id := -1;
			output.name := 'contact not found';
		ELSE
			output.id := tmpinfo.id;
			output.prefix := tmpinfo.prefix;
			output.name := tmpinfo.name;
			split_name := regexp_split_to_array(tmpinfo.name, ' ');
			output.last_name := split_name[array_upper(split_name, 1)]; --- extract last
			output.suffix := tmpinfo.suffix;
			output.address1 := tmpinfo.address1;
			output.address2 := tmpinfo.address2;
			output.city := tmpinfo.city;
			output.state := tmpinfo.state;
			IF tmpinfo.zip4 IS NOT NULL THEN
				output.zip := tmpinfo.zip || '-' || tmpinfo.zip4;
			ELSE
				output.zip := tmpinfo.zip;
			END IF;

			SELECT INTO output.home_phone name FROM get_phone(tmpinfo.home_phone);
			IF (output.home_phone = 'phone record not found') THEN
				output.home_phone = NULL;
			END IF;

			SELECT INTO output.cell_phone name FROM get_phone(tmpinfo.cell_phone);
			IF (output.cell_phone = 'phone record not found') THEN
				output.cell_phone = NULL;
			END IF;

			SELECT INTO output.work_phone name FROM get_phone(tmpinfo.work_phone);
			IF (output.work_phone = 'phone record not found') THEN
				output.work_phone = NULL;
			END IF;

			SELECT INTO output.alt_phone name FROM get_phone(tmpinfo.alt_phone);
			IF (output.alt_phone = 'phone record not found') THEN
				output.alt_phone = NULL;
			END IF;

			SELECT INTO output.pager name FROM get_phone(tmpinfo.pager);
			IF (output.pager = 'phone record not found') THEN
				output.pager = NULL;
			END IF;

			output.email := tmpinfo.email;
			output.web_url := tmpinfo.web_url;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_contactinfo(VARCHAR, VARCHAR, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_name ALIAS FOR $1;
		the_column ALIAS FOR $2;
		the_value ALIAS FOR $3;
		contactid INTEGER;
		output multireturn%ROWTYPE;
	BEGIN
		SELECT INTO contactid id FROM get_contactinfo(the_name);
		SELECT INTO output * FROM set_contactinfo(contactid, the_column, the_value);
		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_contactinfo(INTEGER, VARCHAR, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_id ALIAS FOR $1;
		the_column ALIAS FOR $2;
		the_value ALIAS FOR $3;
		query VARCHAR;
		tmparray VARCHAR[];
		tmpinteger INTEGER;
		output multireturn%ROWTYPE;
	BEGIN
		IF (the_column = 'zip4') THEN
			output.which := -1;
			output.name := 'Do not directly update zip4, update the entire zip code';
			RETURN NEXT output;
			RETURN;
		END IF;

		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 3;
		output.name := quote_literal(the_column) || ' updated for contact list ' || quote_literal((SELECT name FROM get_contactinfo(the_id)));

		PERFORM * FROM contact_info WHERE id = the_id;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'no such contact';
		ELSEIF (the_column = 'zip') THEN
			--- Parse ZIP code
			IF (length(the_value) < 5) THEN
				output.which := -1;
				output.name := 'Invalid ZIP format';
			ELSEIF (length(the_value) = 5) THEN
				PERFORM * FROM regexp_matches(the_value, '^[0-9]{5}$');
				IF NOT FOUND THEN
					output.which := -1;
					output.name := 'Invalid ZIP format';
				ELSE
					query := 'UPDATE contact_info SET zip = ' || quote_literal(the_value) || ' WHERE id = ' || the_id || '; UPDATE contact_info SET zip4 = NULL WHERE id = ' || the_id;
					EXECUTE query;
				END IF;
			ELSE
				SELECT INTO tmparray regexp_split_to_array FROM regexp_split_to_array(the_value,  E'[() A-Za-z-]+');
				IF ((length(tmparray[1]) = 5) AND (length(tmparray[2]) = 4)) THEN
					query := 'UPDATE contact_info SET zip = ' || quote_literal(tmparray[1]) || ' WHERE id = ' || the_id || '; UPDATE contact_info SET zip4 = ' || quote_literal(tmparray[2]) || ' WHERE id = ' || the_id;
					EXECUTE query;
				ELSE
					output.which := -1;
					output.name := 'Invalid ZIP format';
				END IF;
			END IF;
		ELSE
			IF ((the_column = 'home_phone') OR (the_column = 'cell_phone') OR (the_column = 'work_phone') OR (the_column = 'alt_phone') OR (the_column = 'pager')) THEN
				SELECT INTO tmpinteger id FROM get_phone(the_value);
				query := 'UPDATE contact_info SET ' || quote_ident(the_column) || ' = ' || quote_literal(tmpinteger) || ' WHERE id = ' || quote_literal(the_id);
				EXECUTE query;
			ELSE
				query := 'UPDATE contact_info SET ' || quote_ident(the_column) || ' = ' || quote_literal(the_value) || ' WHERE id = ' || quote_literal(the_id);
				EXECUTE query;
			END IF;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
