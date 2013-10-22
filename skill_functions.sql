---
--- Stored Procedures for Resume Builder
---
--- SkillGroup/Skills Handling
---

CREATE OR REPLACE FUNCTION get_skillgroup(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		SELECT INTO output.id id FROM skill_groups WHERE name = the_skillgroup;
		IF NOT FOUND THEN
			INSERT INTO skill_groups (name) VALUES (the_skillgroup);
			SELECT INTO output.id id FROM skill_groups WHERE name = the_skillgroup;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillgroup(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 1;

		SELECT INTO output.name name FROM skill_groups WHERE id = the_skillgroup;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'skillgroup not found';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skill(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skill ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 1;

		SELECT INTO output.name name FROM skill_info WHERE id = the_skill;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'no such skill';
		END IF;

		RETURN next output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skill(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skill ALIAS FOR $1;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		SELECT INTO output.id id FROM skill_info WHERE name = the_skill;
		IF NOT FOUND THEN
			INSERT INTO skill_info (name) VALUES (the_skill);
			SELECT INTO output.id id FROM skill_info WHERE name = the_skill;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(VARCHAR, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_skillname ALIAS FOR $2;
	BEGIN
		RETURN QUERY SELECT * FROM get_skillset((SELECT id FROM get_skillgroup(the_skillgroup)), 0, (SELECT id FROM get_skill(the_skillname)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(VARCHAR, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_skillname ALIAS FOR $2;
	BEGIN
		RETURN QUERY SELECT * FROM get_skillset((SELECT id FROM get_skillgroup(the_skillgroup)), 0, the_skillname);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(INTEGER, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_skillname ALIAS FOR $2;
	BEGIN
		RETURN QUERY SELECT * FROM get_skillset(the_skillgroup, 0, (SELECT id FROM get_skill(the_skillname)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_skillname ALIAS FOR $2;
	BEGIN
		RETURN QUERY SELECT * FROM get_skillset(the_skillgroup, 0, the_skillname);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(VARCHAR, VARCHAR, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
		the_skillname ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM get_skillset((SELECT id FROM get_skillgroup(the_skillgroup)), (SELECT id FROM get_skillgroup(the_subskillgroup)), (SELECT id FROM get_skill(the_skillname)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(VARCHAR, INTEGER, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
		the_skillname ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM get_skillset((SELECT id FROM get_skillgroup(the_skillgroup)), the_subskillgroup, (SELECT id FROM get_skill(the_skillname)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(VARCHAR, VARCHAR, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
		the_skillname ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM get_skillset((SELECT id FROM get_skillgroup(the_skillgroup)), (SELECT id FROM get_skillgroup(the_subskillgroup)), the_skillname);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(VARCHAR, INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
		the_skillname ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM get_skillset((SELECT id FROM get_skillgroup(the_skillgroup)), the_subskillgroup, the_skillname);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(INTEGER, VARCHAR, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
		the_skillname ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM get_skillset(the_skillgroup, (SELECT id FROM get_skillgroup(the_subskillgroup)), (SELECT id FROM get_skill(the_skillname)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(INTEGER, INTEGER, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
		the_skillname ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM get_skillset(the_skillgroup, the_subskillgroup, (SELECT id FROM get_skill(the_skillname)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(INTEGER, VARCHAR, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
		the_skillname ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM get_skillset(the_skillgroup, (SELECT id FROM get_skillgroup(the_subskillgroup)), the_skillname);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(INTEGER, INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
		the_skillname ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM get_skillset(the_skillgroup, the_subskillgroup, the_skillname);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(INTEGER, INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
		the_skillname ALIAS FOR $3;
		output multireturn%ROWTYPE;
		subskillgroup_l INTEGER;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		SELECT INTO output * FROM get_skill(the_skillname);
		IF output.which = -1 THEN
			RETURN NEXT output;
			RETURN;
		END IF;

		SELECT INTO output * FROM get_skillgroup(the_skillgroup);
		IF output.which = -1 THEN
			RETURN NEXT output;
			RETURN;
		END IF;

		IF the_subskillgroup = 0 THEN
			--- We need to make sure this exists since it needs to be our placeholder due to referencial integrity constraints
			SELECT INTO subskillgroup_l id FROM get_skillgroup('PLACEHOLDER');
		ELSE
			SELECT INTO output * FROM get_skillgroup(the_subskillgroup);
			IF output.which = -1 THEN
				RETURN NEXT output;
				RETURN;
			END IF;
			subskillgroup_l := the_subskillgroup;
		END IF;

		output.name := '';

		SELECT INTO output.id id FROM skillsets WHERE skill = the_skillname AND skillgroup = the_skillgroup AND subskillgroup = subskillgroup_l;
		IF NOT FOUND THEN
			INSERT INTO skillsets (skillgroup, subskillgroup, skill) VALUES (the_skillgroup, subskillgroup_l, the_skillname);
			SELECT INTO output.id id FROM skillsets WHERE skill = the_skillname AND skillgroup = the_skillgroup AND subskillgroup = subskillgroup_l;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillset(INTEGER) RETURNS SETOF skillset_pair AS $$
	DECLARE
		the_skillset ALIAS FOR $1;
		output skillset_pair%ROWTYPE;
		skillset skillsets%ROWTYPE;
	BEGIN
		SELECT INTO skillset * FROM skillsets WHERE id = the_skillset;
		IF NOT FOUND THEN
			output.rcode := -1;
			output.message := 'no such skillset';
		ELSE
			output.rcode := 0;
			SELECT INTO output.skillgroup name FROM get_skillgroup(skillset.skillgroup);
			SELECT INTO output.subskillgroup name FROM get_skillgroup(skillset.subskillgroup);
			IF output.subskillgroup = 'PLACEHOLDER' THEN
				output.subskillgroup := NULL;
			END IF;
			SELECT INTO output.skillname name FROM get_skill(skillset.skill);
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skill_list(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
	BEGIN
		RETURN QUERY SELECT * FROM get_skill_list((SELECT id FROM get_skillgroup(the_skillgroup)), 0);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skill_list(VARCHAR, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
	BEGIN
		RETURN QUERY SELECT * FROM get_skill_list((SELECT id FROM get_skillgroup(the_skillgroup)), (SELECT id FROM get_skillgroup(the_subskillgroup)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skill_list(INTEGER, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
	BEGIN
		RETURN QUERY SELECT * FROM get_skill_list(the_skillgroup, (SELECT id FROM get_skillgroup(the_subskillgroup)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skill_list(VARCHAR, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
	BEGIN
		RETURN QUERY SELECT * FROM get_skill_list((SELECT id FROM get_skillgroup(the_skillgroup)), the_subskillgroup);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skill_list(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
	BEGIN
		RETURN QUERY SELECT * FROM get_skill_list(the_skillgroup, 0);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skill_list(INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_skillgroup ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
		tmprec skillsets%ROWTYPE;
		output multireturn%ROWTYPE;
		subskillgroup_l INTEGER;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := -1;

		IF the_subskillgroup = 0 THEN
			SELECT INTO subskillgroup_l id FROM get_skillgroup('PLACEHOLDER');
		ELSE
			subskillgroup_l := the_subskillgroup;
		END IF;

		FOR tmprec IN SELECT * FROM skillsets WHERE skillgroup = the_skillgroup AND subskillgroup = subskillgroup_l LOOP
			output.which := 2;
			output.id := tmprec.id;
			SELECT INTO output.name name FROM get_skill(tmprec.skill);
			RETURN NEXT output;
		END LOOP;

		IF output.which = -1 THEN
			output.name := 'no skills for skillgroup';
			RETURN NEXT output;
		END IF;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_skillgroup_list() RETURNS SETOF multireturn AS $$
	DECLARE
		tmprec skill_groups%ROWTYPE;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 2;

		FOR tmprec IN SELECT * FROM skill_groups WHERE name != 'PLACEHOLDER' LOOP
			output.id := tmprec.id;
			output.name := tmprec.name;
			RETURN NEXT output;
		END LOOP;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

---
--- output a list of skills and skillgroups useful for sticking into the output latex
---

CREATE OR REPLACE FUNCTION formatted_skill_list(INTEGER) RETURNS SETOF formatted_skill_list AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		tmprec RECORD;
		output formatted_skill_list%ROWTYPE;
		skillset skillset_pair%ROWTYPE;
		skill_output VARCHAR[][];
		sg_found BOOLEAN;
	BEGIN
		FOR tmprec IN SELECT * FROM skills WHERE resume = the_resumeid LOOP
			SELECT INTO skillset * FROM get_skillset(tmprec.skill);
			IF skill_output IS NULL THEN
				skill_output := ARRAY[[skillset.skillgroup, skillset.subskillgroup, skillset.skillname]];
			ELSE
				sg_found := FALSE;
				FOR i IN 1..array_upper(skill_output, 1) LOOP
					IF skill_output[i][1] = skillset.skillgroup AND (skill_output[i][2] = skillset.subskillgroup OR skillset.subskillgroup IS NULL) THEN
						skill_output[i][3] := skill_output[i][3] || ', ' || skillset.skillname;
						sg_found := TRUE;
					END IF;
				END LOOP;
				IF sg_found IS FALSE THEN
					skill_output := skill_output || ARRAY[[skillset.skillgroup, skillset.subskillgroup, skillset.skillname]];
				END IF;
			END IF;
		END LOOP;

		FOR i IN 1..array_upper(skill_output, 1) LOOP
			output.skill_group := skill_output[i][1];
			output.subskill_group := skill_output[i][2];
			output.skills := skill_output[i][3];
			RETURN NEXT output;
		END LOOP;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

---
--- Add skill/group to resume
---

CREATE OR REPLACE FUNCTION add_resume_skill(VARCHAR, VARCHAR, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_skill ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill((SELECT id FROM get_resume(the_resume)), (SELECT id FROM get_skillgroup(the_skillgroup)), 0, (SELECT id FROM get_skill(the_skill)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(INTEGER, VARCHAR, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_skill ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill(the_resume, (SELECT id FROM get_skillgroup(the_skillgroup)), 0, (SELECT id FROM get_skill(the_skill)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(INTEGER, INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_skill ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill(the_resume, the_skillgroup, 0, (SELECT id FROM get_skill(the_skill)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(VARCHAR, VARCHAR, INTEGER) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_skill ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill((SELECT id FROM get_resume(the_resume)), (SELECT id FROM get_skillgroup(the_skillgroup)), 0, the_skill);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(VARCHAR, INTEGER, INTEGER) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_skill ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill((SELECT id FROM get_resume(the_resume)), the_skillgroup, 0, the_skill);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(VARCHAR, VARCHAR, VARCHAR, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_subskillgroup ALIAS FOR $3;
		the_skill ALIAS FOR $4;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill((SELECT id FROM get_resume(the_resume)), (SELECT id FROM get_skillgroup(the_skillgroup)), (SELECT id FROM get_skillgroup(the_subskillgroup)), (SELECT id FROM get_skill(the_skill)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(VARCHAR, VARCHAR, INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_subskillgroup ALIAS FOR $3;
		the_skill ALIAS FOR $4;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill((SELECT id FROM get_resume(the_resume)), (SELECT id FROM get_skillgroup(the_skillgroup)), the_subskillgroup, (SELECT id FROM get_skill(the_skill)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(INTEGER, VARCHAR, VARCHAR, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_subskillgroup ALIAS FOR $3;
		the_skill ALIAS FOR $4;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill(the_resume, (SELECT id FROM get_skillgroup(the_skillgroup)), (SELECT id FROM get_skillgroup(the_subskillgroup)), (SELECT id FROM get_skill(the_skill)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(INTEGER, VARCHAR, INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_subskillgroup ALIAS FOR $3;
		the_skill ALIAS FOR $4;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill(the_resume, (SELECT id FROM get_skillgroup(the_skillgroup)), the_subskillgroup, (SELECT id FROM get_skill(the_skill)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(INTEGER, INTEGER, VARCHAR, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
		the_skillgroup ALIAS FOR $3;
		the_skill ALIAS FOR $4;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill(the_resume, the_skillgroup, (SELECT id FROM get_skillgroup(the_subskillgroup)), (SELECT id FROM get_skill(the_skill)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(INTEGER, INTEGER, INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_subskillgroup ALIAS FOR $2;
		the_skillgroup ALIAS FOR $3;
		the_skill ALIAS FOR $4;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill(the_resume, the_skillgroup, the_subskillgroup, (SELECT id FROM get_skill(the_skill)));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(VARCHAR, VARCHAR, VARCHAR, INTEGER) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_subskillgroup ALIAS FOR $3;
		the_skill ALIAS FOR $4;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill((SELECT id FROM get_resume(the_resume)), (SELECT id FROM get_skillgroup(the_skillgroup)), (SELECT id FROM get_skillgroup(the_subskillgroup)), the_skill);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(VARCHAR, VARCHAR, INTEGER, INTEGER) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_subskillgroup ALIAS FOR $3;
		the_skill ALIAS FOR $4;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill((SELECT id FROM get_resume(the_resume)), (SELECT id FROM get_skillgroup(the_skillgroup)), the_subskillgroup, the_skill);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(VARCHAR, INTEGER, VARCHAR, INTEGER) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_subskillgroup ALIAS FOR $3;
		the_skill ALIAS FOR $4;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill((SELECT id FROM get_resume(the_resume)), the_skillgroup, (SELECT id FROM get_skillgroup(the_subskillgroup)), the_skill);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(VARCHAR, INTEGER, INTEGER, INTEGER) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_subskillgroup ALIAS FOR $3;
		the_skill ALIAS FOR $4;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill((SELECT id FROM get_resume(the_resume)), the_skillgroup, the_subskillgroup, the_skill);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(INTEGER, INTEGER, INTEGER) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_skill ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_skill(the_resume, the_skillgroup, 0, the_skill);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_skill(INTEGER, INTEGER, INTEGER, INTEGER) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_skillgroup ALIAS FOR $2;
		the_subskillgroup ALIAS FOR $3;
		the_skill ALIAS FOR $4;
		output generic_status%ROWTYPE;
		skillset multireturn%ROWTYPE;
	BEGIN
		SELECT INTO skillset * FROM get_skillset(the_skillgroup, the_subskillgroup, the_skill);
		IF skillset.which = -1 THEN
			output.rcode := -1;
			output.message := skillset.name;
			RETURN NEXT output;
			RETURN;
		END IF;

		PERFORM * FROM skills WHERE resume = the_resume AND skill = skillset.id;
		IF NOT FOUND THEN
			INSERT INTO skills (resume, skill) VALUES (the_resume, skillset.id);
			output.rcode := 0;
			output.message := 'added skillset ' || skillset.id || ' to resume ' || the_resume;
		ELSE
			output.rcode := 1;
			output.message := 'skillset ' || skillset.id || ' already assigned to resume ' || the_resume;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
