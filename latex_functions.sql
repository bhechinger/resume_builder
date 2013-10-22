---
--- These are functions that are used to generate the latex output
---

CREATE OR REPLACE FUNCTION gen_latex(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR[][]) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_templatename ALIAS FOR $2;
		the_type ALIAS FOR $3;
		the_column ALIAS FOR $4;
		the_replacemappings ALIAS FOR $5;
	BEGIN
		RETURN QUERY SELECT * FROM gen_latex((SELECT id FROM get_resume(the_resume)), the_templatename, the_type, the_column, the_replacemappings);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gen_latex(INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR[][]) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		the_templatename ALIAS FOR $2;
		the_type ALIAS FOR $3;
		the_column ALIAS FOR $4;
		the_replacemappings ALIAS FOR $5;
		output generic_status%ROWTYPE;
		template resume_templates%ROWTYPE;
		query VARCHAR;
		num_rows INTEGER;
	BEGIN
		IF the_type = 'resume' THEN
			query := 'SELECT ' || quote_ident(the_column) || ' FROM resume_templates WHERE template_name = ' || quote_literal(the_templatename);
		ELSEIF the_type = 'letter' THEN
			query := 'SELECT ' || quote_ident(the_column) || ' FROM coverletter_templates WHERE template_name = ' || quote_literal(the_templatename);
		ELSE
			output.rcode := -1;
			output.message := 'Unknown type: ' || the_type;
			RETURN NEXT output;
			RETURN;
		END IF;

		EXECUTE query INTO output.message;
		GET DIAGNOSTICS num_rows = ROW_COUNT;
		IF num_rows = 0 THEN
			output.rcode := -1;
			output.message := 'no such template: ' || the_templatename;
		ELSIF output.message IS NOT NULL THEN
			--- 1 is the token, 2 is the replacement text
			FOR i IN 1..array_upper(the_replacemappings, 1) LOOP
				IF the_replacemappings[i][2] IS NULL THEN
					SELECT INTO output.message * FROM replace(output.message, the_replacemappings[i][1], '');
				ELSE
					SELECT INTO output.message * FROM replace(output.message, the_replacemappings[i][1], the_replacemappings[i][2]);
				END IF;
			END LOOP;
			--- Clear out \r since we don't want it
			SELECT INTO output.message * FROM replace(output.message, E'\r', '');
			--- Lines that are blank lines followed by \\ break latex.  If we have a mapping that is the only thing on
			--- the line that doesn't map, we'll end up with this situation.
			--- Also, we need to do some general cleanup for different situations.  italics and boldface blocks that ended
			--- up getting a NULL token replacement, things followed by commas that got a NULL token replacement, etc...
			--- TODO: I need to come up with a better regex for this
			SELECT INTO output.message * FROM regexp_replace(output.message, E'\n *\134\134\134\134\n', E'\n', 'g');
			SELECT INTO output.message * FROM regexp_replace(output.message, E'\n *\134\134\134\134', E'', 'g');
			SELECT INTO output.message * FROM regexp_replace(output.message, E'\n *, ', E'', 'g');
			SELECT INTO output.message * FROM regexp_replace(output.message, E'^ *, ', E'', 'g');
			SELECT INTO output.message * FROM regexp_replace(output.message, E'{\\bf }', E'', 'g');
			output.rcode := 0;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gen_resume(VARCHAR, VARCHAR, VARCHAR[]) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_template ALIAS FOR $2;
		the_phoneorder ALIAS FOR $3; --- leave null for defaults
	BEGIN
		RETURN QUERY SELECT * FROM gen_resume((SELECT id FROM get_resume(the_resume)), the_template, the_phoneorder);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gen_resume(INTEGER, VARCHAR, VARCHAR[]) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		the_template ALIAS FOR $2;
		the_phoneorder ALIAS FOR $3; --- leave null for defaults
		output generic_status%ROWTYPE;
		tmprec RECORD;
		contactid INTEGER;
		query VARCHAR;
		phone_number VARCHAR;
		mapping VARCHAR[][];
		phoneorder VARCHAR[];
		templateorder VARCHAR[];
	BEGIN
		--- We need this anyway later, and this will nicely catch an invalid template for us as well
		SELECT INTO templateorder template_order FROM resume_templates WHERE template_name = the_template;
		IF NOT FOUND THEN
			output.rcode := -1;
			output.message := 'template not found: ' || the_template;
			RETURN NEXT output;
			RETURN;
		END IF;

		SELECT INTO contactid contact_info FROM users WHERE id = (SELECT id FROM get_resume_owner(the_resumeid));
		SELECT INTO tmprec * FROM get_contactinfo_text(contactid);

		--- Header
		mapping := ARRAY[['___NAME___', tmprec.name]];
		RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'header', mapping);

		--- Determine which phone number to use for the Name section
		--- If the_phoneorder is null we go with the defaults, which are:
		---    cell_phone first, home_phone second, work_phone third, and alt_phone last
		IF the_phoneorder IS NULL THEN
			phoneorder := ARRAY['cell_phone', 'home_phone', 'work_phone', 'alt_phone'];
		ELSE
			phoneorder := the_phoneorder;
		END IF;

		FOR i IN 1..array_upper(phoneorder, 1) LOOP
			query := 'SELECT ' || quote_ident(phoneorder[i]) || ' FROM get_contactinfo_text(' || contactid || ')';
			EXECUTE query INTO phone_number;
			EXIT WHEN phone_number IS NOT NULL;
		END LOOP;

		--- Name
		mapping := ARRAY[['___NAME___', tmprec.name]];
		RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'name', mapping);

		--- Address
		mapping := ARRAY[['___ADDRESS_STREET___', tmprec.address1], ['___ADDRESS_CITY___',tmprec.city], ['___ADDRESS_STATE___', tmprec.state], ['___ADDRESS_ZIP___', tmprec.zip], ['___ADDRESS_EMAIL___', tmprec.email], ['___ADDRESS_PHONE___', phone_number]];
		RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'present_address', mapping);

		--- Need to add the logic to check if permenant_address exists in both the resume_templates table
		--- and the contact_info table entry.
		--- Actually, We'll need to first add in the ability to store multiple addresses to handle this, so we will
		--- just have to do this later.
		--- SELECT INTO output.message permanent_address FROM resume_templates WHERE template_name = the_template;
		--- IF output.message IS NOT NULL THEN
			--- SELECT INTO output.message permanent_address FROM resume_templates WHERE template_name = the_template;
			--- IF output.message IS NOT NULL THEN
				--- SELECT INTO output * FROM gen_latex(the_resumeid, the_template, 'resume', 'permanent_address', mapping);
				--- RETURN NEXT output;
			--- END IF;
		--- END IF;

		--- Seperator
		SELECT INTO output.message seperator FROM resume_templates WHERE template_name = the_template;
		SELECT INTO output.message * FROM replace(output.message, E'\r', '');
		RETURN NEXT output;

		--- generate sections in the order the resume templates dicates
		FOR i IN 1..array_upper(templateorder, 1) LOOP
			IF templateorder[i] = 'objective' THEN
				RETURN QUERY SELECT * FROM gen_objective(the_resumeid, the_template);
			ELSEIF templateorder[i] = 'education' THEN
				RETURN QUERY SELECT * FROM gen_education(the_resumeid, the_template);
			ELSEIF templateorder[i] = 'experience' THEN
				RETURN QUERY SELECT * FROM gen_experience(the_resumeid, the_template);
			ELSEIF templateorder[i] = 'skills' THEN
				RETURN QUERY SELECT * FROM gen_skills(the_resumeid, the_template);
			ELSEIF templateorder[i] = 'certifications' THEN
				RETURN QUERY SELECT * FROM gen_certifications(the_resumeid, the_template);
			ELSE
				output.message := 'unknown template element: ' || templateorder[i];
				RETURN NEXT output;
			END IF;
		END LOOP;

		--- Footer
		SELECT INTO output.message footer FROM resume_templates WHERE template_name = the_template;
		SELECT INTO output.message * FROM replace(output.message, E'\r', '');
		RETURN NEXT output;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gen_objective(INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		the_template ALIAS FOR $2;
		tmprec RECORD;
		mapping VARCHAR[][];
	BEGIN
		--- Objective
		SELECT INTO tmprec * FROM get_resume_objective(the_resumeid);
		mapping := ARRAY[['___OBJECTIVE___', tmprec.name]];
		RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'objective', mapping);

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gen_education(INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		the_template ALIAS FOR $2;
		output generic_status%ROWTYPE;
		tmprec RECORD;
		mapping VARCHAR[][];
		num_rows INTEGER;
		cur_row INTEGER;
		string_extra VARCHAR;
		string_gpa VARCHAR;
		our_edu_comma_list VARCHAR[][] DEFAULT NULL;
		attendence_date VARCHAR DEFAULT NULL;
		degree_comma VARCHAR DEFAULT NULL;
		program_comma VARCHAR DEFAULT NULL;
		attendence_comma VARCHAR DEFAULT NULL;
		city_comma VARCHAR DEFAULT NULL;
		state_comma VARCHAR DEFAULT NULL;
		gpa_comma VARCHAR DEFAULT NULL;
	BEGIN
		--- Education Header
		SELECT INTO output.message education_header FROM resume_templates WHERE template_name = the_template;
		SELECT INTO output.message * FROM replace(output.message, E'\r', '');
		RETURN NEXT output;

		--- Education
		SELECT INTO num_rows count(*) FROM get_resume_edu(the_resumeid);
		cur_row := 1;

		SELECT INTO our_edu_comma_list edu_comma_list FROM resume_templates WHERE template_name = the_template;

		FOR tmprec IN SELECT * FROM get_resume_edu(the_resumeid) LOOP

			string_extra := array_to_string(tmprec.extra, '/');
			string_gpa := array_to_string(tmprec.gpa, '/');

			IF (tmprec.attendence_date != 'date not found') THEN
				attendence_date := tmprec.attendence_date;
				SELECT INTO attendence_comma get_comma_string('attendence_comma', our_edu_comma_list);
			END IF;

			IF tmprec.program IS NOT NULL THEN
				SELECT INTO program_comma get_comma_string('program_comma', our_edu_comma_list);
			END IF;

			IF tmprec.degree IS NOT NULL THEN
				SELECT INTO degree_comma get_comma_string('degree_comma', our_edu_comma_list);
			END IF;

			IF tmprec.school_city IS NOT NULL THEN
				SELECT INTO city_comma get_comma_string('city_comma', our_edu_comma_list);
			END IF;

			IF tmprec.school_state IS NOT NULL THEN
				SELECT INTO state_comma get_comma_string('state_comma', our_edu_comma_list);
			END IF;

			IF tmprec.gpa IS NOT NULL THEN
				SELECT INTO gpa_comma get_comma_string('gpa_comma', our_edu_comma_list);
			END IF;

			mapping := ARRAY[['___EDUCATION_SCHOOL___', tmprec.school], ['___EDUCATION_DEGREE___', tmprec.degree], ['___EDUCATION_PROGRAM___', tmprec.program], ['___EDUCATION_GRAD_DATE___', attendence_date], ['___EDUCATION_CITY___', tmprec.school_city], ['___EDUCATION_STATE___', tmprec.school_state], ['___EDUCATION_EXTRA___', string_extra], ['___EDUCATION_GPA___', string_gpa], ['___EDUCATION_DEGREE_COMMA___', degree_comma], ['___EDUCATION_PROGRAM_COMMA___', program_comma], ['___EDUCATION_GRAD_DATE_COMMA___', attendence_comma], ['___EDUCATION_CITY_COMMA___', city_comma], ['___EDUCATION_STATE_COMMA___', state_comma], ['___EDUCATION_GPA_COMMA___', gpa_comma]];

			SELECT INTO output * FROM gen_latex(the_resumeid, the_template, 'resume', 'education', mapping);
			IF (cur_row = num_rows) THEN
				SELECT INTO output.message * FROM rtrim(output.message, E'\\');
			END IF;
			cur_row := cur_row + 1;
			RETURN NEXT output;
		END LOOP;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gen_experience(INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		the_template ALIAS FOR $2;
		output generic_status%ROWTYPE;
		tmprec RECORD;
		mapping VARCHAR[][];
	BEGIN
		--- Experience Header
		SELECT INTO output.message experience_header FROM resume_templates WHERE template_name = the_template;
		SELECT INTO output.message * FROM replace(output.message, E'\r', '');
		RETURN NEXT output;

		--- Experience
		FOR tmprec IN SELECT * FROM get_resume_exp(the_resumeid) LOOP
			mapping := ARRAY[['___EXPERIENCE_TITLE___', tmprec.title], ['___EXPERIENCE_COMPANY___', tmprec.company], ['___EXPERIENCE_START_DATE___', tmprec.start_date], ['___EXPERIENCE_END_DATE___', tmprec.end_date], ['___EXPERIENCE_DETAILS___', tmprec.details], ['___COMPANY_CITY___', tmprec.company_city], ['___COMPANY_STATE___', tmprec.company_state]];
			RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'experience', mapping);
		END LOOP;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gen_skills(INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		the_template ALIAS FOR $2;
		output generic_status%ROWTYPE;
		tmprec RECORD;
		mapping VARCHAR[][];
		num_rows INTEGER;
		cur_row INTEGER;
		prev_skill_group VARCHAR;
		no_skill_list VARCHAR;
		subskill_group VARCHAR;
		need_final_close BOOLEAN DEFAULT FALSE;
	BEGIN
		--- Skills Header
		SELECT INTO output.message skills_header FROM resume_templates WHERE template_name = the_template;
		SELECT INTO output.message * FROM replace(output.message, E'\r', '');
		RETURN NEXT output;

		--- Skills
		SELECT INTO num_rows count(*) FROM formatted_skill_list(the_resumeid);
		cur_row := 1;

		--- Are we doing a list or a "regular" set of skills?
		SELECT INTO no_skill_list skills FROM resume_templates WHERE template_name = the_template LIMIT 1;

		FOR tmprec IN SELECT * FROM formatted_skill_list(the_resumeid) LOOP
			IF tmprec.subskill_group IS NOT NULL THEN
				subskill_group := tmprec.subskill_group || ':';
			END IF;
			mapping := ARRAY[['___SKILL_GROUP___', tmprec.skill_group], ['___SUB_SKILL_GROUP___', subskill_group], ['___SKILLS___', tmprec.skills]];
			IF no_skill_list IS NOT NULL THEN
				IF need_final_close IS TRUE THEN
					RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'skill_list_footer', mapping);
					need_final_close := FALSE;
				END IF;
				SELECT INTO output * FROM gen_latex(the_resumeid, the_template, 'resume', 'skills', mapping);
				IF (cur_row = num_rows) THEN
					SELECT INTO output.message * FROM rtrim(output.message, E'\\');
				END IF;
				RETURN NEXT output;
			ELSE
				IF tmprec.subskill_group IS NULL THEN
					IF need_final_close IS TRUE THEN
						RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'skill_list_footer', mapping);
						need_final_close := FALSE;
					END IF;
					RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'skill_list_header', mapping);
					RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'skill_list_item', mapping);
					RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'skill_list_footer', mapping);
					prev_skill_group := NULL;
				ELSE
					IF prev_skill_group IS NULL THEN
						--- This is our first pass with the skill group
						RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'skill_list_header', mapping);
						RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'skill_list_item', mapping);
					ELSIF tmprec.skill_group = prev_skill_group THEN
						RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'skill_list_item', mapping);
					ELSE
						RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'skill_list_footer', mapping);
						RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'skill_list_header', mapping);
						RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'skill_list_item', mapping);
					END IF;
					prev_skill_group := tmprec.skill_group;
					need_final_close := TRUE;
				END IF;
			END IF;
			cur_row := cur_row + 1;
		END LOOP;

		IF need_final_close IS TRUE THEN
			--- We need to finalize our last skill list
			RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'resume', 'skill_list_footer', mapping);
		END IF;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gen_certifications(INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		the_template ALIAS FOR $2;
		output generic_status%ROWTYPE;
		tmprec RECORD;
		mapping VARCHAR[][];
		seperator VARCHAR;
		id_opener VARCHAR;
		id_closer VARCHAR;
		num_rows INTEGER;
		cur_row INTEGER;
	BEGIN
		--- Certifications Header
		SELECT INTO output.message certifications_header FROM resume_templates WHERE template_name = the_template;
		SELECT INTO output.message * FROM replace(output.message, E'\r', '');
		RETURN NEXT output;

		--- Certifications
		SELECT INTO num_rows count(*) FROM get_resume_cert(the_resumeid);
		cur_row := 1;

		FOR tmprec IN SELECT * FROM get_resume_cert(the_resumeid) LOOP
			IF tmprec.expires_date IS NOT NULL THEN
				seperator := '-';
			ELSE
				seperator := '';
			END IF;
			IF tmprec.certificate_id IS NOT NULL THEN
				id_opener := '(';
				id_closer := ')';
			ELSE
				id_opener := '';
				id_closer := '';
			END IF;

			mapping := ARRAY[['___CERTIFICATION_NAME___', tmprec.name], ['___CERTIFICATION_RECEIVE_DATE___', tmprec.receive_date], ['___CERTIFICATION_DATE_SEPERATOR___', seperator], ['___CERTIFICATION_EXPIRES_DATE___', tmprec.expires_date], ['___CERTIFICATION_ID_OPEN___', id_opener], ['___CERTIFICATION_ID_CLOSE___', id_closer], ['___CERTIFICATION_ID___', tmprec.certificate_id]];
			SELECT INTO output * FROM gen_latex(the_resumeid, the_template, 'resume', 'certifications', mapping);
			IF (cur_row = num_rows) THEN
				SELECT INTO output.message * FROM rtrim(output.message, E'\\');
			END IF;
			cur_row := cur_row + 1;
			RETURN NEXT output;
		END LOOP;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gen_coverletter(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR[]) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_company ALIAS FOR $2;
		the_template ALIAS FOR $3;
		the_coverlettername ALIAS FOR $4;
		the_phoneorder ALIAS FOR $5; --- leave null for defaults
	BEGIN
		RETURN QUERY SELECT * FROM gen_coverletter((SELECT id FROM get_resume(the_resume)), (SELECT id FROM get_schoolco(the_company)), the_template, the_coverlettername, the_phoneorder);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gen_coverletter(INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR[]) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		the_company ALIAS FOR $2;
		the_template ALIAS FOR $3;
		the_coverlettername ALIAS FOR $4;
		the_phoneorder ALIAS FOR $5; --- leave null for defaults
	BEGIN
		RETURN QUERY SELECT * FROM gen_coverletter(the_resumeid, (SELECT id FROM get_schoolco(the_company)), the_template, the_coverlettername, the_phoneorder);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gen_coverletter(VARCHAR, INTEGER, VARCHAR, VARCHAR, VARCHAR[]) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		the_companyid ALIAS FOR $2;
		the_template ALIAS FOR $3;
		the_coverlettername ALIAS FOR $4;
		the_phoneorder ALIAS FOR $5; --- leave null for defaults
	BEGIN
		RETURN QUERY SELECT * FROM gen_coverletter((SELECT id FROM get_resume(the_resume)), the_companyid, the_template, the_coverlettername, the_phoneorder);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gen_coverletter(INTEGER, INTEGER, VARCHAR, VARCHAR, VARCHAR[]) RETURNS SETOF generic_status AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		the_companyid ALIAS FOR $2;
		the_template ALIAS FOR $3;
		the_coverlettername ALIAS FOR $4;
		the_phoneorder ALIAS FOR $5; --- leave null for defaults
		output generic_status%ROWTYPE;
		personalinfo RECORD;
		companyinfo contact_info_text%ROWTYPE;
		contactinfo contact_info_text%ROWTYPE;
		contactid INTEGER;
		query VARCHAR;
		phone_number VARCHAR;
		mapping VARCHAR[][];
		phoneorder VARCHAR[];
		paragraph_list VARCHAR[];
		--- numbers VARCHAR[] DEFAULT ARRAY['ONE', 'TWO', 'THREE', 'FOUR', 'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE', 'TEN'];
	BEGIN
		output.rcode := 0;
		SELECT INTO contactid contact_info FROM users WHERE id = (SELECT id FROM get_resume_owner(the_resumeid));
		SELECT INTO personalinfo * FROM get_contactinfo_text(contactid);
		--- Going to have to look into the contactinfo thing, but I think this should do
		SELECT INTO companyinfo * FROM get_contactinfo_text(the_companyid);
		SELECT INTO contactinfo * FROM get_contactinfo_text((SELECT contact_info FROM schoolco WHERE schoolco_info = the_companyid));

		--- Header
		SELECT INTO output.message header FROM coverletter_templates WHERE template_name = the_template;
		IF NOT FOUND THEN
			output.rcode := -1;
			output.message := 'Unknown template: ' || the_template;
		END IF;
		SELECT INTO output.message * FROM replace(output.message, E'\r', '');
		RETURN NEXT output;

		--- Signature
		mapping := ARRAY[['___NAME___', personalinfo.name]];
		RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'letter', 'signature', mapping);

		--- Prospective Employer Contact Info (this needs to come from the prospective employer's contactinfo)
		mapping := ARRAY[['___CONTACT_NAME___', contactinfo.name], ['___CONTACT_TITLE___', contactinfo.title], ['___CONTACT_COMPANY___', companyinfo.name], ['___CONTACT_ADDRESS___', contactinfo.address1], ['___CONTACT_PREFIX___', contactinfo.prefix], ['___CONTACT_CITY___', contactinfo.city], ['___CONTACT_STATE___', contactinfo.state], ['___CONTACT_ZIP___', contactinfo.zip]];
		RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'letter', 'contact_info', mapping);

		--- Determine which phone number to use for the Personal Contact Info section
		--- If the_phoneorder is null we go with the defaults, which are:
		---    cell_phone first, home_phone second, work_phone third, and alt_phone last
		IF the_phoneorder IS NULL THEN
			phoneorder := ARRAY['cell_phone', 'home_phone', 'work_phone', 'alt_phone'];
		ELSE
			phoneorder := the_phoneorder;
		END IF;

		FOR i IN 1..array_upper(phoneorder, 1) LOOP
			query := 'SELECT ' || quote_ident(phoneorder[i]) || ' FROM get_contactinfo_text(' || contactid || ')';
			EXECUTE query INTO phone_number;
			EXIT WHEN phone_number IS NOT NULL;
		END LOOP;

		--- Personal Contact Info
		mapping := ARRAY[['___NAME___', personalinfo.name], ['___ADDRESS_STREET___', personalinfo.address1], ['___ADDRESS_CITY___', personalinfo.city], ['___ADDRESS_STATE___', personalinfo.state], ['___ADDRESS_ZIP___', personalinfo.zip], ['___ADDRESS_EMAIL___', personalinfo.email], ['___ADDRESS_PHONE___', phone_number]];
		RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'letter', 'personal_info', mapping);

		--- Opening
		mapping := ARRAY[['___CONTACT_PREFIX___', contactinfo.prefix], ['___CONTACT_LASTNAME___', contactinfo.last_name]];
		RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'letter', 'opening', mapping);

		--- needs to be a loop, once i figure out how i'm storing the actual cover letter data
		--- Paragraphs

		SELECT INTO paragraph_list paragraphs FROM cover_letters WHERE name = the_coverlettername;
		IF NOT FOUND THEN
			output.rcode := -1;
			output.message := 'Unknown cover letter: ' || the_coverlettername;
			RETURN NEXT output;
			RETURN;
		END IF;

		FOR i IN 1..array_upper(paragraph_list, 1) LOOP
			mapping := ARRAY[['___PARAGRAPH_CONTENT___', paragraph_list[i]]];
			RETURN QUERY SELECT * FROM gen_latex(the_resumeid, the_template, 'letter', 'paragraph', mapping);
		END LOOP;

		--- Closing
		SELECT INTO output.message closing FROM coverletter_templates WHERE template_name = the_template;
		SELECT INTO output.message * FROM replace(output.message, E'\r', '');
		RETURN NEXT output;

		RETURN;
	END;
$$ LANGUAGE plpgsql;
