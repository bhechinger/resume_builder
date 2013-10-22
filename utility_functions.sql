---
--- misc utiltity functions
---

CREATE OR REPLACE FUNCTION get_rb_column_as_list(VARCHAR, VARCHAR, VARCHAR) RETURNS VARCHAR AS $$
	DECLARE
		the_column ALIAS FOR $1;
		the_table ALIAS FOR $2;
		the_condition ALIAS FOR $3;
	BEGIN
		RETURN (SELECT get_column_as_list(the_column, the_table, 'used_by = ''' || the_condition || ''' OR used_by = ''all'''));
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_column_as_list(VARCHAR, VARCHAR, VARCHAR) returns VARCHAR AS $$
	DECLARE
		the_column ALIAS FOR $1;
		the_table ALIAS FOR $2;
		the_condition ALIAS FOR $3;
		output VARCHAR;
		query VARCHAR;
		templatename VARCHAR;
	BEGIN
		IF (the_column IS NULL) OR (the_table IS NULL) THEN
			output := 'The column or the table input values are NULL';
			RETURN output;
		END IF;

		IF the_condition IS NULL THEN
			query := 'SELECT ' || quote_ident(the_column) || ' FROM ' || quote_ident(the_table);
		ELSE
			query := 'SELECT ' || quote_ident(the_column) || ' FROM ' || quote_ident(the_table) || ' WHERE ' || the_condition;
		END IF;

		FOR templatename IN EXECUTE query LOOP
			IF output IS NULL THEN
				output := templatename;
			ELSE
				output := output || ' ' || templatename;
			END IF;
		END LOOP;

		RETURN output;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_schoolco_list() RETURNS SETOF generic_status AS $$
	DECLARE
		cur_schoolco schoolco%ROWTYPE;
		output generic_status%ROWTYPE;
	BEGIN
		FOR cur_schoolco IN SELECT * FROM schoolco LOOP
			SELECT INTO output.message name FROM get_contactinfo(cur_schoolco.schoolco_info);
			--- IF cur_schoolco.contact_info < 1 THEN
			IF cur_schoolco.contact_info IS NULL THEN
				SELECT INTO output.message * FROM regexp_replace(output.message, '$', ' (Has No Contact Info)', 'g');
			END IF;
			RETURN NEXT output;
		END LOOP;

	RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_array_first_match(VARCHAR, VARCHAR[][]) RETURNS VARCHAR AS $$
	DECLARE
		the_index ALIAS FOR $1;
		the_array ALIAS FOR $2;
		output VARCHAR;
	BEGIN
		SELECT INTO output * FROM get_array_match(the_index, the_array);
		RETURN output;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_array_match(VARCHAR, VARCHAR[][]) RETURNS SETOF VARCHAR AS $$
	DECLARE
		the_index ALIAS FOR $1;
		the_array ALIAS FOR $2;
		i INTEGER;
		output VARCHAR DEFAULT NULL;
	BEGIN
		IF the_array IS NOT NULL THEN
			FOR i IN 1..array_upper(the_array, 1) LOOP
				--- the_array[i][1] is the "key"
				--- the_array[i][2] is the "value"
				IF the_array[i][1] = the_index THEN
					output := the_array[i][2];
					RETURN NEXT output;
				END IF;
			END LOOP;
		END IF;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_comma_string(VARCHAR, VARCHAR[][]) RETURNS VARCHAR AS $$
	DECLARE
		the_index ALIAS FOR $1;
		the_array ALIAS FOR $2;
		output VARCHAR;
	BEGIN
		SELECT INTO output * FROM get_array_first_match(the_index, the_array);
		IF output IS NULL THEN
			RETURN ', ';
		ELSE
			RETURN output;
		END IF;
	END;
$$ LANGUAGE plpgsql;
