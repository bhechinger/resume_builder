---
--- Stored Procedures for Resume Builder
---

---
--- User Handling
---

CREATE OR REPLACE FUNCTION get_user(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_user ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		SELECT INTO output.id id FROM users WHERE name = the_user;
		IF NOT FOUND THEN
			INSERT INTO users (name) VALUES (the_user);
			SELECT INTO output.id id FROM users WHERE name = the_user;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_user(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_userid ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 1;

		SELECT INTO output.name name FROM users WHERE id = the_userid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'user not found';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_userinfo(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_user ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM get_userinfo((SELECT id FROM get_user(the_user)));

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_userinfo(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_userid ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		SELECT INTO output.id contact_info FROM users WHERE id = the_userid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'user not found';
		END IF;
		IF output.id IS NULL THEN
			output.which := -1;
			output.name := 'user info not found';
		END IF;
		SELECT INTO output.name name FROM get_contactinfo(output.id);

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_userinfo(VARCHAR, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_user ALIAS FOR $1;
		the_userinfo ALIAS FOR $2;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 3;

		SELECT INTO output * FROM set_userinfo((SELECT id FROM get_user(the_user)), (SELECT id FROM get_contactinfo(the_userinfo)));

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_userinfo(VARCHAR, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_user ALIAS FOR $1;
		the_userinfo ALIAS FOR $2;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 3;

		SELECT INTO output * FROM set_userinfo((SELECT id FROM get_user(the_user)), the_userinfo);

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_userinfo(INTEGER, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_user ALIAS FOR $1;
		the_userinfo ALIAS FOR $2;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 3;

		SELECT INTO output * FROM set_userinfo(the_user, (SELECT id FROM get_contactinfo(the_userinfo)));

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_userinfo(INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_userid ALIAS FOR $1;
		the_userinfoid ALIAS FOR $2;
		tmprec contact_info%ROWTYPE;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 3;

		SELECT INTO tmprec * FROM get_contactinfo(the_userinfoid);
		IF (tmprec.id = -1) THEN
			output.id := tmprec.id;
			output.name := tmprec.name;
			RETURN NEXT output;
			RETURN;
		END IF;

		SELECT INTO tmprec * FROM get_user(the_userid);
		IF (tmprec.id = -1) THEN
			output.id := tmprec.id;
			output.name := tmprec.name;
			RETURN NEXT output;
			RETURN;
		END IF;

		UPDATE users SET contact_info = the_userinfoid WHERE id = the_userid;
		output.name := 'set user ' || the_userid || ' to have contactinfo ' || the_userinfoid;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
