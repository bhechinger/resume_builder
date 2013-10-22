---
--- Stored Procedures for Resume Builder
---
--- Certification Handling
---

CREATE OR REPLACE FUNCTION get_cert_info(INTEGER) RETURNS SETOF certification_info AS $$
	DECLARE
		the_certid ALIAS FOR $1;
		output certification_info%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM certification_info WHERE id = the_certid;
		IF NOT FOUND THEN
			output.id := -1;
		ELSE
			output.id := 1;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_cert_info_text(INTEGER) RETURNS SETOF certification_info_text AS $$
	DECLARE
		the_certid ALIAS FOR $1;
		cert_info certification_info%ROWTYPE;
		output certification_info_text%ROWTYPE;
	BEGIN
		SELECT INTO cert_info * FROM get_cert_info(the_certid);
		output.rcode := cert_info.id;
		IF (cert_info.id = -1) THEN
			output.name := 'certfication information not found';
		ELSE
			output.name := cert_info.name;
			SELECT INTO output.receive_date name FROM get_date(cert_info.receive_date);
			SELECT INTO output.expires_date name FROM get_date(cert_info.expires_date);
			output.certificate_id := cert_info.certificate_id;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_cert_info(VARCHAR, VARCHAR, VARCHAR, VARCHAR) RETURNS SETOF certification_info AS $$
	DECLARE
		the_name ALIAS FOR $1;
		the_receive_date ALIAS FOR $2;
		the_expires_date ALIAS FOR $3;
		the_certification_id ALIAS FOR $4;
		receive_dateid INTEGER;
		expires_dateid INTEGER;
		output certification_info%ROWTYPE;
	BEGIN
		SELECT INTO receive_dateid id FROM get_date(the_receive_date);
		SELECT INTO expires_dateid id FROM get_date(the_expires_date);
		SELECT INTO output.id id FROM certification_info WHERE name = the_name AND receive_date = receive_dateid AND expires_date = expires_dateid AND certificate_id = the_certificate_id;

		IF NOT FOUND THEN
			output.id := -1;
			output.name := 'certification info not found';
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_cert_info(INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_certid ALIAS FOR $1;
		the_name ALIAS FOR $2;
		the_receive_date ALIAS FOR $3;
		the_expires_date ALIAS FOR $4;
		the_certificate_id ALIAS FOR $5;
		output generic_status%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM add_cert_info(the_certid, the_name, (SELECT id FROM get_date(the_receive_date)), (SELECT id FROM get_date(the_expires_date)), the_certificate_id);

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_cert_info(INTEGER, VARCHAR, INTEGER, VARCHAR, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_certid ALIAS FOR $1;
		the_name ALIAS FOR $2;
		the_receive_date ALIAS FOR $3;
		the_expires_date ALIAS FOR $4;
		the_certificate_id ALIAS FOR $5;
		output generic_status%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM add_cert_info(the_certid, the_name, the_receive_date, (SELECT id FROM get_date(the_expires_date)), the_certificate_id);

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_cert_info(INTEGER, VARCHAR, VARCHAR, INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_certid ALIAS FOR $1;
		the_name ALIAS FOR $2;
		the_receive_date ALIAS FOR $3;
		the_expires_date ALIAS FOR $4;
		the_certificate_id ALIAS FOR $5;
		output generic_status%ROWTYPE;
	BEGIN
		SELECT INTO output * FROM add_cert_info(the_certid, the_name, (SELECT id FROM get_date(the_receive_date)), the_expires_date, the_certificate_id);

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_cert_info(INTEGER, VARCHAR, INTEGER, INTEGER, VARCHAR) RETURNS SETOF generic_status AS $$
	DECLARE
		the_certid ALIAS FOR $1;
		the_name ALIAS FOR $2;
		the_receive_date ALIAS FOR $3;
		the_expires_date ALIAS FOR $4;
		the_certificate_id ALIAS FOR $5;
		output generic_status%ROWTYPE;
	BEGIN
		output.rcode := 0;

		IF the_certid = 0 THEN
			--- add (unless exists)
			PERFORM * FROM certification_info WHERE name = the_name AND receive_date = the_receive_date AND expires_date = the_expires_date AND certificate_id = the_certificate_id;
			IF FOUND THEN
				output.rcode := -1;
				output.message := 'attempted to add a record that already exists. name=' || quote_literal(the_name) || ' receive date=' || quote_literal(the_receive_date) || ' expires date=' || quote_literal(the_expires_date) || ' certificate id=' || quote_literal(the_certificate_id);
			ELSE
				INSERT INTO certification_info (name, receive_date, expires_date, certificate_id) VALUES (the_name, the_receive_date, the_expires_date, the_certificate_id);
				SELECT INTO output.rcode id FROM certification_info WHERE name = the_name AND receive_date = the_receive_date AND expires_date = the_expires_date AND certificate_id = the_certificate_id;
				output.message := 'certification info added';
			END IF;
		ELSE
			--- update (unless does not exist)
			PERFORM * FROM certification_info WHERE id = the_certid;
			IF FOUND THEN
				UPDATE certification_info SET name = the_name, receive_date = the_receive_date, expires_date = the_expires_date, certificate_id = the_certificate_id WHERE id = the_certid;
				output.message := 'certification info updated';
			ELSE
				output.rcode := -2;
				output.message := 'attempted to update non-existant record: ' || the_eduid;
			END IF;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_cert(INTEGER) RETURNS SETOF certification_info_text AS $$
	DECLARE
		the_certid ALIAS FOR $1;
		cert certifications%ROWTYPE;
		output certification_info_text%ROWTYPE;
	BEGIN
		SELECT INTO cert * FROM certifications WHERE id = the_certid;
		IF NOT FOUND THEN
			output.rcode := -1;
		ELSE
			SELECT INTO output * FROM get_cert_info_text(cert.cert);
			SELECT INTO output.resume name FROM get_resume(cert.resume);
			output.rcode := 0;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_resume_cert(VARCHAR) RETURNS SETOF certification_info_text AS $$
	DECLARE
		the_resume ALIAS FOR $1;
		output certification_info_text%ROWTYPE;
	BEGIN
		FOR output IN SELECT * FROM get_resume_cert((SELECT id FROM get_resume(the_resume))) LOOP
			RETURN NEXT output;
		END LOOP;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_resume_cert(INTEGER) RETURNS SETOF certification_info_text AS $$
	DECLARE
		the_resumeid ALIAS FOR $1;
		cert certifications%ROWTYPE;
		output certification_info_text%ROWTYPE;
	BEGIN
		PERFORM * FROM certifications WHERE resume = the_resumeid;
		IF NOT FOUND THEN
			output.rcode := -1;
			RETURN NEXT output;
		ELSE
			FOR cert IN SELECT * FROM certifications WHERE resume = the_resumeid LOOP
				SELECT INTO output * FROM get_cert_info_text(cert.cert);
				SELECT INTO output.resume name FROM get_resume(cert.resume);
				output.rcode := 0;
				RETURN NEXT output;
			END LOOP;
		END IF;

		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_cert(INTEGER, INTEGER, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_certid ALIAS FOR $1;
		the_resume ALIAS FOR $2;
		the_certinfoid ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_cert(the_certid, the_resume, (SELECT id FROM certification_info WHERE name = the_certinfoid));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_cert(INTEGER, VARCHAR, VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_certid ALIAS FOR $1;
		the_resume ALIAS FOR $2;
		the_certinfoid ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_cert(the_certid, (SELECT id FROM get_resume(the_resume)), (SELECT id FROM certification_info WHERE name = the_certinfoid));
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_cert(INTEGER, VARCHAR, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_certid ALIAS FOR $1;
		the_resume ALIAS FOR $2;
		the_certinfoid ALIAS FOR $3;
	BEGIN
		RETURN QUERY SELECT * FROM add_resume_cert(the_certid, (SELECT id FROM get_resume(the_resume)), the_certinfoid);
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_resume_cert(INTEGER, INTEGER, INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_certid ALIAS FOR $1;
		the_resumeid ALIAS FOR $2;
		the_certinfoid ALIAS FOR $3;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		PERFORM * FROM resumes WHERE id = the_resumeid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'resume not found';
		END IF;

		PERFORM * FROM certification_info WHERE id = the_certinfoid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'certification info not found';
		END IF;

		IF (output.which <> -1) THEN
			IF (the_certid = 0) THEN
				--- add
				SELECT INTO output.id id FROM certifications WHERE resume = the_resumeid AND cert = the_certinfoid;
				IF NOT FOUND THEN
					INSERT INTO certifications (resume, cert) VALUES (the_resumeid, the_certinfoid);
					SELECT INTO output.id id FROM certifications WHERE resume = the_resumeid AND cert = the_certinfoid;
					output.name := 'added certification ' || output.id || ' to have resume ' || the_resumeid || ' and certification info ' || the_certinfoid;
				END IF;
			ELSE
				--- update
				UPDATE certifications SET resume = the_resumeid, cert = the_certinfoid WHERE id = the_certid;
				output.name := 'updated certification ' || the_certid || ' to have resume ' || the_resumeid || ' and certification info ' || the_certinfoid;
			END IF;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
