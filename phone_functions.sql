---
--- Stored Procedures for Resume Builder
---
--- Phone Handling
---

CREATE OR REPLACE FUNCTION get_phone(INTEGER, INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_areacode ALIAS FOR $1;
		the_prefix ALIAS FOR $2;
		the_last ALIAS FOR $3;
		output multireturn%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM get_phone(the_areacode, the_prefix, the_last, -1);
		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_phone(INTEGER, INTEGER, INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_areacode ALIAS FOR $1;
		the_prefix ALIAS FOR $2;
		the_last ALIAS FOR $3;
		the_extention ALIAS FOR $4;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		IF ((the_areacode < 200) AND (the_areacode > 999)) THEN
			output.which := -1;
			output.name := 'invalid area code';
		END IF;
		IF ((the_prefix < 100) AND (the_prefix > 999)) THEN
			output.which := -1;
			output.name := 'invalid prefix';
		END IF;
		IF ((the_last < 1) AND (the_last > 999)) THEN
			output.which := -1;
			output.name := 'invalid last four digits';
		END IF;

		IF output.which = -1 THEN
			RETURN NEXT output;
			RETURN;
		END IF;

		SELECT INTO output.id id FROM phones WHERE area_code = the_areacode AND prefix = the_prefix AND last = the_last AND extention = the_extention;

		IF NOT FOUND THEN
			INSERT INTO phones (area_code, prefix, last, extention) VALUES (the_areacode, the_prefix, the_last, the_extention);
			SELECT INTO output.id id FROM phones WHERE area_code = the_areacode AND prefix = the_prefix AND last = the_last AND extention = the_extention;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_phone(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_phoneid ALIAS FOR $1;
		last_buf VARCHAR;
		phonenum phones%ROWTYPE;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 1;

		SELECT INTO phonenum * FROM phones WHERE id = the_phoneid;

		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'phone record not found';
			RETURN NEXT output;
			RETURN;
		END IF;

		IF (phonenum.last < 10) THEN
			last_buf := '000' || phonenum.last;
		ELSEIF (phonenum.last < 100) THEN
			last_buf := '00' || phonenum.last;
		ELSEIF (phonenum.last < 1000) THEN
			last_buf := '0' || phonenum.last;
		ELSE
			last_buf := phonenum.last;
		END IF;

		IF (phonenum.extention = -1) THEN
			output.name := '(' || phonenum.area_code || ') ' || phonenum.prefix || '-' || last_buf;
		ELSE
			output.name := '(' || phonenum.area_code || ') ' || phonenum.prefix || '-' || last_buf || ' x' || phonenum.extention;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_phone(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_phonenum ALIAS FOR $1;
		currow INTEGER DEFAULT 0;
		phonenum VARCHAR[];
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		SELECT INTO phonenum regexp_split_to_array FROM regexp_split_to_array((SELECT * FROM regexp_replace(the_phonenum, '^[() A-Za-z-]+', '')),  E'[() A-Za-z-]+');

		IF (length(phonenum[1]) > 9) THEN
			SELECT INTO phonenum regexp_matches FROM regexp_matches(phonenum[1], '([0-9]{3})([0-9]{3})([0-9]{4})([0-9]*)');
		END IF;

		IF (length(phonenum[1]) != 3) THEN
			output.name := 'invalid area code: ' || phonenum[1];
			output.which := -1;
		END IF;

		IF (length(phonenum[2]) != 3) THEN
			output.name := 'invalid prefix: ' || phonenum[2];
			output.which := -1;
		END IF;

		IF (length(phonenum[3]) != 4) THEN
			output.name := 'invalid last four: ' || phonenum[3];
			output.which := -1;
		END IF;

		IF (output.which = -1) THEN
			RETURN NEXT output;
			RETURN;
		END IF;

		IF ((phonenum[4] IS NOT NULL) AND (length(phonenum[4]) != 0)) THEN
			SELECT INTO output * FROM get_phone(phonenum[1]::INTEGER, phonenum[2]::INTEGER, phonenum[3]::INTEGER, phonenum[4]::INTEGER);
		ELSE
			SELECT INTO output * FROM get_phone(phonenum[1]::INTEGER, phonenum[2]::INTEGER, phonenum[3]::INTEGER);
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
