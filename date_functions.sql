---
--- Date related Stored Procedures for Resume Builder
---

---
--- Date format is one of:
---     Month/Year
---     Month/Day/Year
---
--- Year may be one of either YYYY or YY
---

CREATE OR REPLACE FUNCTION get_date(VARCHAR) RETURNS SETOF multireturn AS $$
	DECLARE
		the_date ALIAS FOR $1;
		lday INTEGER DEFAULT 0;
		lmonth INTEGER DEFAULT 0;
		lyear INTEGER DEFAULT 0;
		tmp_year VARCHAR;
		century VARCHAR;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 0;

		IF the_date IS NULL THEN
			output.id := 0;
			RETURN NEXT output;
			RETURN;
		END IF;

		IF (lower(the_date) = 'present') THEN
			lyear := 9999;
			lmonth := 0;
			lday := 0;
		ELSE
			--- If this exists we have M/D/Y
			IF (split_part(the_date, '/', 3) = '') THEN
				tmp_year := split_part(the_date, '/', 2);
				lmonth := split_part(the_date, '/', 1);
			ELSE
				tmp_year := split_part(the_date, '/', 3);
				lmonth := split_part(the_date, '/', 2);
				lday := split_part(the_date, '/', 1);
			END IF;

			lyear := tmp_year;

			IF (lyear < 100) THEN
				--- I'm not sure how best to handle this really.  This'll do for the next
				--- 36 years though, by which time, I hope to not need to update my resume
				--- again.  Still, this is an inelegant solution, and I'm not a fan of the
				--- inelegant solution at all.  I'll think of something, just need to make
				--- this work at all for now.
				IF (lyear > 40) THEN
					century := '19';
				ELSE
					century := '20';
				END IF;
				lyear := century || tmp_year;
			END IF;
		END IF;

		SELECT INTO output.id id FROM dates WHERE month = lmonth AND day = lday AND year = lyear;

		IF NOT FOUND THEN
			INSERT INTO dates (month, day, year) VALUES (lmonth, lday, lyear);
			SELECT INTO output.id id FROM dates WHERE month = lmonth AND day = lday AND year = lyear;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_date(INTEGER) RETURNS SETOF multireturn AS $$
	DECLARE
		the_dateid ALIAS FOR $1;
		lday INTEGER;
		lmonth INTEGER;
		lyear INTEGER;
		month_string VARCHAR;
		output multireturn%ROWTYPE;
	BEGIN
		--- Set which type: 0 for id return, 1 for name return, 2 for both and 3 for update
		output.which := 1;

		SELECT day, month, year FROM dates INTO lday, lmonth, lyear WHERE id = the_dateid;
		IF NOT FOUND THEN
			output.which := -1;
			output.name := 'date not found';
			RETURN NEXT output;
			RETURN;
		END IF;
		
		IF (lmonth = 0) THEN
			output.name := 'Present';
		ELSE
			SELECT long_name INTO month_string FROM months WHERE id = lmonth;
			IF (lday = 0) THEN
				output.name := month_string || ' ' || lyear;
			ELSE
				output.name := month_string || ' ' || lday || ' ' || lyear;
			END IF;
		END IF;

		RETURN NEXT output;
		RETURN;
	END;
$$ LANGUAGE plpgsql;
