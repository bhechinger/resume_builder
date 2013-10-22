INSERT INTO resume_templates (template_name, header, name, present_address, permanent_address,
	seperator, objective, education_header, education, experience_header, experience,
	skills_header, skills, certifications_header, certifications, footer, template_order) VALUES
('res1',
E'% LaTeX file for resume
% This file uses the resume document class (res.cls)

\\documentclass{res}
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font
\\setlength{\\textheight}{9.5in} % increase text height to fit on 1-page

\\begin{document}',
E'\\name{___NAME___\\\\[12pt]}     % the \\\\[12pt] adds a blank line after name
',
E'\\address{\\bf  PRESENT ADDRESS\\\\___ADDRESS_STREET___\\\\___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___\\\\___ADDRESS_PHONE___}',
E'\\address{\\bf  PERMANENT ADDRESS\\\\___ADDRESS_STREET___\\\\___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___\\\\___ADDRESS_PHONE___}',
E'
\\begin{resume}
',
E'\\section{JOB OBJECTIVE}
    ___OBJECTIVE___
',
E'\\section{EDUCATION}',
E'    ___EDUCATION_SCHOOL___ \\\\
    ___EDUCATION_DEGREE______EDUCATION_PROGRAM_COMMA______EDUCATION_PROGRAM______EDUCATION_GRAD_DATE_COMMA______EDUCATION_GRAD_DATE___ \\\\
    ___EDUCATION_EXTRA___ \\\\
    ___EDUCATION_GPA___\\\\',
E'
\\section{EXPERIENCE}
\\vspace{-0.1in}',
E'   \\begin{tabbing}
    \\hspace{2.8in}\\= \\hspace{2.0in}\\= \\kill % set up two tab positions
    {\\bf ___EXPERIENCE_TITLE___} \\>___EXPERIENCE_COMPANY___\\>___EXPERIENCE_START_DATE___-___EXPERIENCE_END_DATE___\\\\
    \\>___COMPANY_CITY___, ___COMPANY_STATE___
    \\end{tabbing}\\vspace{-20pt}      % suppress blank line after tabbing
    ___EXPERIENCE_DETAILS___
',
E'\\section{SKILLS}',
E'    {\\it ___SKILL_GROUP___}: {\\it ___SUB_SKILL_GROUP___} ___SKILLS___\\\\',
E'
\\section{CERTIFICATIONS}',
E'    ___CERTIFICATION_NAME___: ___CERTIFICATION_RECEIVE_DATE______CERTIFICATION_DATE_SEPERATOR______CERTIFICATION_EXPIRES_DATE___ ___CERTIFICATION_ID_OPEN______CERTIFICATION_ID______CERTIFICATION_ID_CLOSE___\\\\',
E'
\\end{resume}
\\end{document}',
'{"objective", "education", "experience", "skills", "certifications"}');

INSERT INTO resume_templates (template_name, header, name, present_address, permanent_address,
	seperator, objective, education_header, education, experience_header, experience,
	skills_header, skill_list_header, skill_list_item, skill_list_footer, certifications_header, certifications, footer, template_order) VALUES
('res10',
E'% LaTeX resume using res.cls
\\documentclass{res}

%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font  

\\setlength{\\topmargin}{-0.6in}     % Start text higher on the page 
\\setlength{\\textheight}{9.8in}     % increase textheight to fit more on a page
\\setlength{\\headsep}{0.2in}        % space between header and text
\\setlength{\\headheight}{12pt}      % make room for header
\\usepackage{fancyhdr}               % use fancyhdr package to get 2-line header
\\renewcommand{\\headrulewidth}{0pt} % suppress line drawn by default by fancyhdr
\\lhead{\\hspace*{-\\sectionwidth}___NAME___} % force lhead all the way left
\\rhead{Page \\thepage}              % put page number at right
\\cfoot{}                            % the footer is empty
\\pagestyle{fancy}                   % set pagestyle for the document

\\begin{document} 
\\thispagestyle{empty}               % this page does not have a header
',
E'\\name{___NAME___}',
E'\\address{___ADDRESS_STREET___\\\\
    ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___\\\\
    ___ADDRESS_PHONE___}
', NULL,
E'\\begin{resume}
    \\vspace{0.1in}',
E'\\moveleft.5\\sectionwidth\\centerline{Objective: ___OBJECTIVE___}
',
E'\\section{EDUCATION}
    \\vspace{0.1in}',
E'    ___EDUCATION_SCHOOL______EDUCATION_CITY_COMMA______EDUCATION_CITY______EDUCATION_STATE_COMMA______EDUCATION_STATE______EDUCATION_DEGREE_COMMA______EDUCATION_DEGREE______EDUCATION_PROGRAM_COMMA______EDUCATION_PROGRAM______EDUCATION_GRAD_DATE_COMMA______EDUCATION_GRAD_DATE___', 
E'\\section{EMPLOYMENT}
    \\vspace{0.1in}',
E'    {\\bf ___EXPERIENCE_TITLE___,} ___EXPERIENCE_COMPANY___, ___COMPANY_CITY___, ___COMPANY_STATE___, ___EXPERIENCE_START_DATE___-___EXPERIENCE_END_DATE___\\\\
    ___EXPERIENCE_DETAILS___
',
E'
\\section{SKILLS}
    \\vspace{0.1in}',
E'  {\\bf ___SKILL_GROUP___}
    \\begin{itemize} % Use \\item[] to prevent a bullet from appearing',
E'        \\item[] {\\bf ___SUB_SKILL_GROUP___} ___SKILLS___',
E'    \\end{itemize}
',
E'\\section{CERTIFICATIONS}
    \\vspace{0.1in}',
E'    ___CERTIFICATION_NAME___: ___CERTIFICATION_RECEIVE_DATE______CERTIFICATION_DATE_SEPERATOR______CERTIFICATION_EXPIRES_DATE___ ___CERTIFICATION_ID_OPEN______CERTIFICATION_ID______CERTIFICATION_ID_CLOSE___\\\\',
E'
\\end{resume}
\\end{document}',
'{"objective", "education", "skills", "experience", "certifications"}');

INSERT INTO resume_templates (template_name, header, name, present_address, permanent_address,
	seperator, objective, education_header, edu_comma_list, education, experience_header, experience,
	skills_header, skills, certifications_header, certifications, footer, template_order) VALUES
('res2',
E'% LaTeX file for resume
% This file uses the resume document class (res.cls)

\\documentclass[margin]{res}
% the margin option causes section titles to appear to the left of body text
\\textwidth=5.2in % increase textwidth to get smaller right margin
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font

\\begin{document}
',
E'\\name{___NAME___\\\\[12pt]} % the \\\\[12pt] adds a blank line after name',
E'\\address{{\\bf Present Address} \\\\ ___ADDRESS_STREET___ \\\\ ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___  ___ADDRESS_PHONE___}',
E'\\address{{\\bf Permanent Address} \\\\ ___ADDRESS_STREET___ \\\\ ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___  ___ADDRESS_PHONE___}',
E'
\\begin{resume}
',
E'\\section{Objective}
___OBJECTIVE___
', 
E'\\section{Education}',
ARRAY[['degree_comma', 'in ']],
E'___EDUCATION_DEGREE___ ___EDUCATION_DEGREE_COMMA______EDUCATION_PROGRAM___, ___EDUCATION_SCHOOL______EDUCATION_CITY_COMMA______EDUCATION_CITY______EDUCATION_STATE_COMMA______EDUCATION_STATE______EDUCATION_GRAD_DATE_COMMA______EDUCATION_GRAD_DATE___\\\\
___EDUCATION_GPA___\\\\',
E'
\\section{Experience}',
E'{\\bf ___EXPERIENCE_TITLE___,} ___EXPERIENCE_COMPANY___, ___COMPANY_CITY___, ___COMPANY_STATE___ \\hfill ___EXPERIENCE_START_DATE___-___EXPERIENCE_END_DATE___
\\begin{itemize} \\itemsep -2pt  % reduce space between items
\\item ___EXPERIENCE_DETAILS___
\\end{itemize}
',
--- The job description isn't stored as a list, so we'll have to add that to do this, which would be neat
--- {\\bf System Consultant,} Fleet Van Lines, Bayridge, NY \\hfill  Summer 1984
--- \\begin{itemize} \\itemsep -2pt %reduce space between items
--- \\item Researched, implemented new computer accounting 
---                  system 
--- \\item Customized existing software for inventory 
---                  management 
--- \\item Trained employees on both accounting and inventory 
---                  systems 
--- \\end{itemize}
E'% Tabulate Computer Skills; p{3in} defines paragraph 3 inches wide
\\section{Skills}
\\begin{tabular}{l p{3in}}
',
E'\\underline{___SKILL_GROUP___:} & {\\it ___SUB_SKILL_GROUP___} ___SKILLS___ \\\\',
E'\\end{tabular}

\\section{Certifications}',
E'{\\bf ___CERTIFICATION_NAME___,} ___CERTIFICATION_RECEIVE_DATE______CERTIFICATION_DATE_SEPERATOR______CERTIFICATION_EXPIRES_DATE___\\hfill ___CERTIFICATION_ID___\\\\',
E'
\\end{resume}
\\end{document}',
'{"objective", "education", "experience", "skills", "certifications"}');

INSERT INTO resume_templates (template_name, header, name, present_address, permanent_address,
	seperator, objective, education_header, education, experience_header, experience,
	skills_header, skills, certifications_header, certifications, footer, template_order) VALUES
('res3',
E'% LaTeX resume using res.cls
\\documentclass[11pt]{res} % default is 10 pt
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font
\\usepackage{latexsym}   % to get the \\Box symbol
\\setlength{\\textheight}{10in} % increase text height to fit resume on 1 page
\\topmargin=-0.5in % start text higher on the page

\\begin{document}
',
E'\\name{___NAME___}',
E'\\address{___ADDRESS_STREET___ \\\\  ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___ \\\\  ___ADDRESS_PHONE___}',
NULL,
E'\\begin{resume}
',
E'\\section{PROFESSIONAL OBJECTIVE}
___OBJECTIVE___
',
E'\\section{EDUCATION}',
E'___EDUCATION_SCHOOL______EDUCATION_DEGREE_COMMA___{\\it ___EDUCATION_DEGREE___}___EDUCATION_PROGRAM_COMMA______EDUCATION_PROGRAM______EDUCATION_GRAD_DATE_COMMA______EDUCATION_GRAD_DATE___\\\\
___EDUCATION_EXTRA___\\\\',
E'\\section{BUSINESS EXPERIENCE}',
E'___EXPERIENCE_COMPANY___, ___COMPANY_CITY___, ___COMPANY_STATE___.
\\begin{itemize} \\itemsep -4pt % reduce space between items
% \\item[$\\Box$] puts a box instead of bullet in front of each item
\\item[$\\Box$]  ___EXPERIENCE_TITLE___ (___EXPERIENCE_START_DATE___ - ___EXPERIENCE_END_DATE___)
\\end{itemize}
___EXPERIENCE_DETAILS___
', 
E'
\\section{SKILLS}',
E'{\\it ___SKILL_GROUP___}: {\\it ___SUB_SKILL_GROUP___} ___SKILLS___\\\\',
E'
\\section{CERTIFICATIONS}',
E'{\\it ___CERTIFICATION_NAME___}: ___CERTIFICATION_RECEIVE_DATE______CERTIFICATION_DATE_SEPERATOR______CERTIFICATION_EXPIRES_DATE___ ___CERTIFICATION_ID_OPEN______CERTIFICATION_ID______CERTIFICATION_ID_CLOSE___\\\\',
E'
\\end{resume}
\\end{document}',
'{"objective", "experience", "education", "skills", "certifications"}');

INSERT INTO resume_templates (template_name, header, name, present_address, permanent_address,
	seperator, objective, education_header, edu_comma_list, education, experience_header, experience,
	skills_header, skills, certifications_header, certifications, footer, template_order) VALUES
('res4',
E'\\documentclass[margin,11pt]{res} % default is 10 pt
% margin option puts section titles to left of text
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font

\\begin{document}',
E'\\name{___NAME___\\\\[12pt]} % the \\\\[12pt] adds a blank line after name',
E'\\address{{\\bf Local Address} \\\\  ___ADDRESS_STREET___  \\\\ ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___\\\\ ___ADDRESS_PHONE___}',
E'\\address{{\\bf Permanent Address} \\\\  ___ADDRESS_STREET___  \\\\ ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___\\\\ ___ADDRESS_PHONE___}',
E'
\\begin{resume}',
E'
\\section{OBJECTIVE}
___OBJECTIVE___
', 
E'\\section{EDUCATION}',
ARRAY[['gpa_comma', 'GPA: '], ['attendence_comma', 'Date of Graduation: ']],
E'___EDUCATION_DEGREE______EDUCATION_PROGRAM_COMMA______EDUCATION_PROGRAM___  \\\\
___EDUCATION_SCHOOL______EDUCATION_CITY_COMMA______EDUCATION_CITY______EDUCATION_STATE_COMMA______EDUCATION_STATE___ \\\\
___EDUCATION_GPA_COMMA______EDUCATION_GPA___ \\\\
___EDUCATION_GRAD_DATE_COMMA______EDUCATION_GRAD_DATE___\\\\', 
E'
\\section{EXPERIENCE}',
E'{\\bf ___EXPERIENCE_COMPANY___, ___COMPANY_CITY___, ___COMPANY_STATE___} \\\\
\\begin{ncolumn}{2} % produces two equally spaced columns
\\underline{___EXPERIENCE_TITLE___}     &      ___EXPERIENCE_START_DATE___-___EXPERIENCE_END_DATE___
\\end{ncolumn}

___EXPERIENCE_DETAILS___
',
E'\\section{SKILLS}',
E'___SKILL_GROUP___: ___SUB_SKILL_GROUP___ ___SKILLS___\\\\',
E'
\\section{CERTIFICATIONS}',
E'___CERTIFICATION_NAME___: ___CERTIFICATION_RECEIVE_DATE______CERTIFICATION_DATE_SEPERATOR______CERTIFICATION_EXPIRES_DATE___ ___CERTIFICATION_ID_OPEN______CERTIFICATION_ID______CERTIFICATION_ID_CLOSE___\\\\',
E'
\\end{resume}
\\end{document}',
'{"objective", "education", "experience", "skills", "certifications"}');

INSERT INTO resume_templates (template_name, header, name, present_address, permanent_address,
	seperator, objective, education_header, education, experience_header, experience,
	skills_header, skills, certifications_header, certifications, footer, template_order) VALUES
('res5',
E'% LaTeX file for resume
% This file uses the resume document class (res.cls)

\\documentclass{res}
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font 
\\newsectionwidth{0pt}  % So the text is not indented under section headings
\\setlength{\\textheight}{10.2in} % set text height big enough for box
\\topmargin=-.5in       % to start box .5in from top of page
\\oddsidemargin=-.5in   % to start box .5in from left of page

\\begin{document}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following lines define \\boxaround, used to draw a box on the page.
% The parameter is the entire text of the resume. Must fit on one page!
%
% \\boxaroundhmargin is the left & right margin around the text inside the box.
% \\boxaroundvmargin is the top & bottom margin around the text inside the box.
% \\boxrulethickness controls thickness of line used to draw the box.
% You can change these 3 things in the lines below:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\newdimen\\boxrulethickness\\newdimen\\boxaroundhmargin\\newdimen\\boxaroundvmargin
\\boxrulethickness=.5pt        %controls thickness of line
\\boxaroundhmargin=35pt        % about a half inch
\\boxaroundvmargin=40pt        % to fit more text on page, make this smaller
%%%%%%%%%%%%%%%%%%%%%%%%% Do not read this stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\hsize=7.5in% \\vsize=10.5in             % use bigger dimensions for box
\\newbox\\MACboxA  \\newdimen\\MACdimenA
% \\borderandboxit is used inside \\boxaround:
\\def\\borderandboxit#1#2#3{\\vbox{\\hrule height#2\\hbox{\\vrule width#2\\hskip#1\\hskip-#2%
\\vbox{\\vskip#1\\relax#3\\vskip#1}\\hskip#1\\hskip-#2\\vrule width#2}\\hrule height#2}}
%
\\long\\def\\boxaround#1{\\vskip6pt
{\\MACdimenA=\\hsize \\advance\\MACdimenA by-\\boxaroundhmargin
\\advance\\MACdimenA by-\\boxaroundhmargin   % once for each side
\\setbox\\MACboxA=\\hbox to \\hsize{\\hskip\\boxaroundhmargin%\\hss
\\vbox{\\hsize=\\MACdimenA
\\vskip\\boxaroundvmargin #1
\\vskip\\boxaroundvmargin}\\hss}%
\\borderandboxit{0pt}\\boxrulethickness{\\box\\MACboxA}}%
\\vskip2pt plus0pt minus0pt
}
%%%%%%%%%%%%%%%%%%%  End of \\boxaround macro %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\\boxaround{ % put the text on the page inside a box
',
E'\\name{___NAME___\\\\[12pt]}',
E'\\address{\\bf Present Address\\\\___ADDRESS_STREET___\\\\___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___\\\\ ___ADDRESS_PHONE___}',
E'\\address{\\bf Permanent Address\\\\___ADDRESS_STREET___\\\\___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___\\\\ ___ADDRESS_PHONE___}',
E'\\begin{resume}',
E'
\\section{\\sl  Objective}  % with postscript font \\sl produces bold italic
%                           with default font (CM) \\sl produces slanted type
___OBJECTIVE___
', 
E'\\section{\\sl  Education}',
E'___EDUCATION_SCHOOL______EDUCATION_DEGREE_COMMA______EDUCATION_DEGREE______EDUCATION_PROGRAM_COMMA______EDUCATION_PROGRAM______EDUCATION_GRAD_DATE_COMMA______EDUCATION_GRAD_DATE___\\\\',
E'
\\section{\\sl  Related Experience}',
E'\\begin{ncolumn}{2}
{\\it ___EXPERIENCE_TITLE___}  &   ___EXPERIENCE_START_DATE___-___EXPERIENCE_END_DATE___
\\end{ncolumn}\\\\
___EXPERIENCE_COMPANY___, ___COMPANY_CITY___, ___COMPANY_STATE___ \\\\
___EXPERIENCE_DETAILS___
',
E'\\section{\\sl  Skills}',
E'___SKILL_GROUP___: ___SUB_SKILL_GROUP___ ___SKILLS___\\\\',
E'
\\section{\\sl  Certifications}',
E'___CERTIFICATION_NAME___: ___CERTIFICATION_RECEIVE_DATE______CERTIFICATION_DATE_SEPERATOR______CERTIFICATION_EXPIRES_DATE___ ___CERTIFICATION_ID_OPEN______CERTIFICATION_ID______CERTIFICATION_ID_CLOSE___\\\\',
E'
\\end{resume}
\\vfill} %    end the material being boxed.
\\end{document}',
'{"objective", "education", "experience", "skills", "certifications"}');

INSERT INTO resume_templates (template_name, header, name, present_address, permanent_address,
	seperator, objective, education_header, edu_comma_list, education, experience_header, experience,
	skills_header, skills, certifications_header, certifications, footer, template_order) VALUES
('res6',
E'\\documentclass[11pt]{res} % default is 10 pt
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font
\\setlength{\\textheight}{9.5in} % increase text height to fit resume on 1 page
\\newsectionwidth{0pt}  % So the text is not indented under section headings

\\begin{document}
',
E'\\name{___NAME___\\\\[12pt]} % the \\\\[12pt] adds a blank line after name
',
E'\\address{{\\bf PRESENT ADDRESS} \\\\   ___ADDRESS_STREET___ \\\\   ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___   \\\\ ___ADDRESS_PHONE___}',
E'\\address{{\\bf PERMANENT ADDRESS} \\\\   ___ADDRESS_STREET___ \\\\   ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___   \\\\ ___ADDRESS_PHONE___}',
E'\\begin{resume}',
E'
\\section{OBJECTIVE}
___OBJECTIVE___
',
E'\\section{EDUCATION}',
ARRAY[['gpa_comma', 'Q.P.A. '], ['degree_comma', 'in ']],
E'\\noindent ___EDUCATION_SCHOOL______EDUCATION_CITY_COMMA______EDUCATION_CITY______EDUCATION_STATE_COMMA______EDUCATION_STATE___ \\\\
___EDUCATION_DEGREE___ ___EDUCATION_DEGREE_COMMA______EDUCATION_PROGRAM______EDUCATION_GRAD_DATE_COMMA______EDUCATION_GRAD_DATE___ \\\\
___EDUCATION_GPA_COMMA______EDUCATION_GPA___\\\\',
E'
\\section{EXPERIENCE}',
E'___EXPERIENCE_TITLE___ \\\\
___EXPERIENCE_COMPANY___, ___COMPANY_CITY___, ___COMPANY_STATE___ \\\\
___EXPERIENCE_START_DATE___ - ___EXPERIENCE_END_DATE___
\\vspace{0.2in}
\\begin{itemize} \\itemsep -2pt  % reduce space between items
\\item ___EXPERIENCE_DETAILS___
\\end{itemize}
',
E'\\section{SKILLS}',
E'    ___SKILL_GROUP___: ___SUB_SKILL_GROUP___ ___SKILLS___\\\\',
E'
\\section{CERTIFICATIONS}',
E'    ___CERTIFICATION_NAME___: ___CERTIFICATION_RECEIVE_DATE______CERTIFICATION_DATE_SEPERATOR______CERTIFICATION_EXPIRES_DATE___ ___CERTIFICATION_ID_OPEN______CERTIFICATION_ID______CERTIFICATION_ID_CLOSE___\\\\',
E'
\\end{resume}
\\end{document}',
'{"objective", "education", "experience", "skills", "certifications"}');

INSERT INTO resume_templates (template_name, header, name, present_address, permanent_address,
	seperator, objective, education_header, edu_comma_list, education, experience_header, experience,
	skills_header, skill_list_header, skill_list_item, skill_list_footer, certifications_header, certifications, footer, template_order) VALUES
('res7',
E'% LaTeX file for resume
% This file uses the resume document class (res.cls)

\\documentclass[margin]{res}
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font
\\topmargin=-0.5in  % start text higher on the page
\\setlength{\\textheight}{10in} % increase text height to fit resume on 1 page
\\begin{document}',
E'\\name{___NAME___}',
E'\\address{ ___ADDRESS_STREET___ \\\\   ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___ \\\\   ___ADDRESS_PHONE___ }
',
NULL,
E'\\begin{resume}
',
E'\\section{OBJECTIVE}       ___OBJECTIVE___',
E'
\\section{EDUCATION}',
ARRAY[['gpa_comma', 'G.P.A. '], ['degree_comma', 'of ']],
E'___EDUCATION_SCHOOL______EDUCATION_CITY_COMMA______EDUCATION_CITY______EDUCATION_STATE_COMMA______EDUCATION_STATE___ \\\\
___EDUCATION_DEGREE___ ___EDUCATION_DEGREE_COMMA______EDUCATION_PROGRAM______EDUCATION_GRAD_DATE_COMMA______EDUCATION_GRAD_DATE___ \\\\
___EDUCATION_GPA_COMMA______EDUCATION_GPA___\\\\',
E'
\\section{EXPERIENCE}',
E'\\begin{tabular}{p{3in} r} % setup 2 columns, first
% is 3 inches wide
___EXPERIENCE_COMPANY___, ___COMPANY_CITY___, ___COMPANY_STATE___ &  ___EXPERIENCE_START_DATE___ - ___EXPERIENCE_END_DATE___
\\end{tabular}
\\begin{itemize} % \\item[] prevents a bullet from appearing
\\item[] ___EXPERIENCE_DETAILS___
\\end{itemize}
',
E'
\\section{SKILLS}',
E'\\normalsize{\\section{___SKILL_GROUP___}}
\\begin{itemize}',
E'\\item ___SUB_SKILL_GROUP___ ___SKILLS___',
E'\\end{itemize}',
E'\\section{CERTIFICATIONS}',
E'    ___CERTIFICATION_NAME___: ___CERTIFICATION_RECEIVE_DATE______CERTIFICATION_DATE_SEPERATOR______CERTIFICATION_EXPIRES_DATE___ ___CERTIFICATION_ID_OPEN______CERTIFICATION_ID______CERTIFICATION_ID_CLOSE___\\\\',
E'
\\end{resume}
\\end{document}',
'{"objective", "education", "skills", "experience", "certifications"}');

INSERT INTO resume_templates (template_name, header, name, present_address, permanent_address,
	seperator, objective, education_header, edu_comma_list, education, experience_header, experience,
	skills_header, skills, certifications_header, certifications, footer, template_order) VALUES
('res8',
E'% LaTeX file for resume 
% This file uses the resume document class (res.cls)

\\documentclass{res}
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font
\\newsectionwidth{0pt}  % So the text is not indented under section headings
\\usepackage{fancyhdr}  % use this package to get a 2 line header
\\renewcommand{\\headrulewidth}{0pt} % suppress line drawn by default by fancyhdr
\\setlength{\\headheight}{24pt} % allow room for 2-line header
\\setlength{\\headsep}{24pt}  % space between header and text
\\setlength{\\headheight}{24pt} % allow room for 2-line header
\\pagestyle{fancy}     % set pagestyle for document', 
E'\\rhead{ {\\it ___NAME___}\\\\{\\it p. \\thepage} } % put text in header (right side)
\\cfoot{}                                     % the foot is empty
\\topmargin=-0.5in % start text higher on the page

\\begin{document}
\\thispagestyle{empty} % this page has no header
\\name{___NAME___\\\\[12pt]}% the \\\\[12pt] adds a blank line after name
',
E'\\address{{\\bf Present Address} \\\\ ___ADDRESS_STREET___ \\\\ ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___\\\\ ___ADDRESS_PHONE___ }',
E'\\address{{\\bf Permanent Address} \\\\ ___ADDRESS_STREET___ \\\\ ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___\\\\ ___ADDRESS_PHONE___ }',
E'
\\begin{resume}',
E'\\section{\\centerline{OBJECTIVE}}
\\vspace{8pt} % provide vertical space between section title and contents
___OBJECTIVE___
',
E'\\vspace{0.2in}
\\section{\\centerline{EDUCATION}}
\\vspace{8pt}',
ARRAY[['gpa_comma', E'\\hspace{0.2in} GPA '], ['attendence_comma', E'\\hfill ']],
E'{\\sl ___EDUCATION_DEGREE___}___EDUCATION_DEGREE_COMMA______EDUCATION_PROGRAM___ \\\\
___EDUCATION_SCHOOL______EDUCATION_CITY_COMMA______EDUCATION_CITY______EDUCATION_STATE_COMMA______EDUCATION_STATE___ ___EDUCATION_GPA_COMMA______EDUCATION_GPA___ ___EDUCATION_GRAD_DATE_COMMA______EDUCATION_GRAD_DATE___ \\\\',
E'
\\vspace{0.2in}
\\section{\\centerline{PROFESSIONAL EXPERIENCE}}
\\vspace{8pt}',
E'{\\sl ___EXPERIENCE_COMPANY___} \\hfill        ___EXPERIENCE_START_DATE___ - ___EXPERIENCE_END_DATE___ \\\\___COMPANY_CITY___, ___COMPANY_STATE___

\\begin{itemize} \\itemsep -2pt % reduce space between items
\\item ___EXPERIENCE_DETAILS___
\\end{itemize}
',
E'\\vspace{0.2in}
\\section{\\centerline{ SKILLS }}
\\vspace{8pt}',
E'___SKILL_GROUP___: ___SUB_SKILL_GROUP___ ___SKILLS___\\\\',
E'
\\vspace{0.2in}
\\section{\\centerline{CERTIFICATIONS}}
\\vspace{15pt}
\\begin{itemize}',
E'\\item "___CERTIFICATION_NAME___" ___CERTIFICATION_RECEIVE_DATE______CERTIFICATION_DATE_SEPERATOR______CERTIFICATION_EXPIRES_DATE___ ___CERTIFICATION_ID_OPEN______CERTIFICATION_ID______CERTIFICATION_ID_CLOSE___',
E'\\end{itemize}

\\end{resume}
\\end{document}',
'{"objective", "education", "experience", "skills", "certifications"}');

INSERT INTO resume_templates (template_name, header, name, present_address, permanent_address,
	seperator, objective, education_header, education, experience_header, experience,
	skills_header, skills, certifications_header, certifications, footer, template_order) VALUES
('res9a',
E'% LaTeX resume using res.cls
\\documentclass[margin]{res}
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font 
\\setlength{\\textwidth}{5.1in} % set width of text portion

\\begin{document}
',
E'% Center the name over the entire width of resume:
\\moveleft.5\\hoffset\\centerline{\\large\\bf ___NAME___}
% Draw a horizontal line the whole width of resume:
\\moveleft\\hoffset\\vbox{\\hrule width\\resumewidth height 1pt}\\smallskip',
E'% address begins here
% Again, the address lines must be centered over entire width of resume:
\\moveleft.5\\hoffset\\centerline{___ADDRESS_STREET___}
\\moveleft.5\\hoffset\\centerline{___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___}
\\moveleft.5\\hoffset\\centerline{___ADDRESS_PHONE___}
',
NULL,
E'\\begin{resume}',
E'\\section{OBJECTIVE}  ___OBJECTIVE___',
E'
\\section{EDUCATION}',
E'{\\sl ___EDUCATION_DEGREE___}___EDUCATION_DEGREE_COMMA______EDUCATION_PROGRAM___ \\\\
% \\sl will be bold italic in New Century Schoolbook (or
% any postscript font) and just slanted in
%	Computer Modern (default) font
___EDUCATION_SCHOOL______EDUCATION_CITY_COMMA______EDUCATION_CITY______EDUCATION_STATE_COMMA______EDUCATION_STATE______EDUCATION_GRAD_DATE_COMMA______EDUCATION_GRAD_DATE___ \\\\',
E'
\\section{EXPERIENCE}',
E'{\\sl ___EXPERIENCE_TITLE___} \\hfill ___EXPERIENCE_START_DATE___-___EXPERIENCE_END_DATE___ \\\\
___EXPERIENCE_COMPANY___ ___COMPANY_CITY___, ___COMPANY_STATE___
\\begin{itemize}  \\itemsep -2pt %reduce space between items
\\item ___EXPERIENCE_DETAILS___
\\end{itemize}
',
E'
\\section{SKILLS}',
E'{\\sl ___SKILL_GROUP___:} {\\sl ___SUB_SKILL_GROUP___} ___SKILLS___ \\\\',
E'\\section{CERTIFICATIONS}',
E'{\\it ___CERTIFICATION_NAME___}, ___CERTIFICATION_RECEIVE_DATE______CERTIFICATION_DATE_SEPERATOR______CERTIFICATION_EXPIRES_DATE___ ___CERTIFICATION_ID_OPEN______CERTIFICATION_ID______CERTIFICATION_ID_CLOSE___\\\\',
E'
\\end{resume}
\\end{document}',
'{"objective", "education", "skills", "experience", "certifications"}');

INSERT INTO resume_templates (template_name, header, name, present_address, permanent_address,
	seperator, objective, education_header, education, experience_header, experience,
	skills_header, skills, certifications_header, certifications, footer, template_order) VALUES
('res9b',
E'% LaTeX resume using res.cls
\\documentclass[line,margin]{res}
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font

\\begin{document}
',
E'\\name{___NAME___}',
E'% \\address used twice to have two lines of address
\\address{___ADDRESS_STREET___, ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___}
\\address{___ADDRESS_PHONE___}
',
NULL,
E'\\begin{resume}',
E'\\section{OBJECTIVE} ___OBJECTIVE___
',
E'\\section{EDUCATION}',
E'{\\sl ___EDUCATION_DEGREE___}___EDUCATION_DEGREE_COMMA______EDUCATION_PROGRAM___ \\\\
% \\sl will be bold italic in New Century Schoolbook (or
% any postscript font) and just slanted in
% Computer Modern (default) font
___EDUCATION_SCHOOL______EDUCATION_CITY_COMMA______EDUCATION_CITY______EDUCATION_STATE_COMMA______EDUCATION_STATE______EDUCATION_GRAD_DATE_COMMA______EDUCATION_GRAD_DATE___ \\\\',
E'
\\section{EXPERIENCE}',
E'{\\sl ___EXPERIENCE_TITLE___} \\hfill ___EXPERIENCE_START_DATE___-___EXPERIENCE_END_DATE___ \\\\
___COMPANY_CITY___, ___COMPANY_STATE___
\\begin{itemize}  \\itemsep -2pt % reduce space between items
\\item ___EXPERIENCE_DETAILS___
\\end{itemize}
',
E'
\\section{SKILLS}',
E'{\\sl ___SKILL_GROUP___:} {\\sl ___SUB_SKILL_GROUP___} ___SKILLS___ \\\\',
E'\\section{CERTIFICATIONS}',
E'{\\it ___CERTIFICATION_NAME___}, ___CERTIFICATION_RECEIVE_DATE______CERTIFICATION_DATE_SEPERATOR______CERTIFICATION_EXPIRES_DATE___ ___CERTIFICATION_ID_OPEN______CERTIFICATION_ID______CERTIFICATION_ID_CLOSE___\\\\',
E'
\\end{resume}
\\end{document}',
'{"objective", "education", "skills", "experience", "certifications"}');

INSERT INTO resume_templates (template_name, header, name, present_address, permanent_address,
	seperator, objective, education_header, education, experience_header, experience,
	skills_header, skill_list_header, skill_list_item, skill_list_footer, certifications_header, certifications, footer, template_order) VALUES
('res42',
E'% LaTeX resume using res.cls
\\documentclass[line]{res}

%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font  

% I would really like to put \\date{\today} somewhere

\\setlength{\\topmargin}{-0.6in}     % Start text higher on the page 
\\setlength{\\textheight}{9.8in}     % increase textheight to fit more on a page
\\setlength{\\headsep}{0.2in}        % space between header and text
\\setlength{\\headheight}{12pt}      % make room for header
\\usepackage{fancyhdr}               % use fancyhdr package to get 2-line header
\\renewcommand{\\headrulewidth}{0pt} % suppress line drawn by default by fancyhdr
\\lhead{\\hspace*{-\\sectionwidth}___NAME___} % force lhead all the way left
\\rhead{Page \\thepage}              % put page number at right
\\cfoot{}                            % the footer is empty
\\pagestyle{fancy}                   % set pagestyle for the document

\\begin{document} 
\\thispagestyle{empty}               % this page does not have a header
',
E'\\name{___NAME___}',
E'\\address{___ADDRESS_STREET___, ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___}
\\address{___ADDRESS_PHONE___ -- ___ADDRESS_EMAIL___}
',
NULL,
E'\\begin{resume}
\\vspace{0.1in}',
---
--- Objective needs to be made so that it can wrap if too long.
---
--- E'  {\\bf Objective}
E'
\\section{OBJECTIVE}
  ___OBJECTIVE___
',
--- E'\\moveleft.5\\sectionwidth\\centerline{{\\bf Objective:} ___OBJECTIVE___}
--- E'{\\bf Objective:} ___OBJECTIVE___
--- ',
E'\\section{EDUCATION}
\\vspace{0.1in}',
E'  {\\it ___EDUCATION_SCHOOL___}___EDUCATION_CITY_COMMA______EDUCATION_CITY______EDUCATION_STATE_COMMA______EDUCATION_STATE______EDUCATION_DEGREE_COMMA______EDUCATION_DEGREE______EDUCATION_PROGRAM_COMMA______EDUCATION_PROGRAM______EDUCATION_GRAD_DATE_COMMA______EDUCATION_GRAD_DATE___ \\\\', 
E'\\section{EMPLOYMENT}
\\vspace{0.1in}',
---
--- I need to figure out how to get experience to do line continuations but without hyphens
---
E'  {\\bf ___EXPERIENCE_TITLE___} \\\\
  {\\it ___EXPERIENCE_COMPANY___}, ___COMPANY_CITY___, ___COMPANY_STATE___, ___EXPERIENCE_START_DATE___-___EXPERIENCE_END_DATE___\\\\
    \\begin{itemize} % \\item[] prevents a bullet from appearing
      \\item[] ___EXPERIENCE_DETAILS___
    \\end{itemize}
',
E'\\section{SKILLS}
\\vspace{0.1in}',
E'  {\\bf ___SKILL_GROUP___}
    \\begin{itemize} % Use \\item[] to prevent a bullet from appearing',
E'      \\item[] {\\bf ___SUB_SKILL_GROUP___} ___SKILLS___',
E'    \\end{itemize}
',
E'
\\section{CERTIFICATIONS}
\\vspace{0.1in}',
E'  {\\bf ___CERTIFICATION_NAME___:} ___CERTIFICATION_RECEIVE_DATE______CERTIFICATION_DATE_SEPERATOR______CERTIFICATION_EXPIRES_DATE___ ___CERTIFICATION_ID_OPEN______CERTIFICATION_ID______CERTIFICATION_ID_CLOSE___\\\\',
E'
\\end{resume}
\\end{document}',
'{"objective", "skills", "experience", "education", "certifications"}');
