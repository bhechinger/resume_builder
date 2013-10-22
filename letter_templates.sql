INSERT INTO coverletter_templates (template_name, header, signature, contact_info,
personal_info, opening, paragraph, closing) VALUES ('let3',
E'% Cover letter using letter.cls
\\documentclass[11pt]{letter} % default is 10 pt
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
\\usepackage{newcent}   % uses new century schoolbook postscript font 
% the following commands control the margins:
\\topmargin=-1in    % Make letterhead start about 1 inch from top of page
\\textheight=8.5in  % text height can be bigger for a longer letter
\\oddsidemargin=0pt % leftmargin is 1 inch
\\textwidth=6.5in   % textwidth of 6.5in leaves 1 inch for right margin

\\begin{document}
',
E'\\signature{___NAME___}                  % name for signature 
\\longindentation=0pt                       % needed to get closing flush left
\\let\\raggedleft\\raggedright                % needed to get date flush left
', 
E'\\begin{letter}{___CONTACT_PREFIX___ ___CONTACT_NAME___ \\\\
___CONTACT_TITLE___ \\\\
___CONTACT_COMPANY___ \\\\
___CONTACT_ADDRESS___ \\\\
___CONTACT_CITY___, ___CONTACT_STATE___ ___CONTACT_ZIP___} 
',
E'\\begin{center}
\\large\\bf ___NAME___ \\\\
___ADDRESS_STREET___ \\\\ ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___ \\\\ ___ADDRESS_PHONE___
\\end{center} 
\\vfill % forces letterhead to top of page
',
E'\\opening{Dear ___CONTACT_PREFIX___ ___CONTACT_LASTNAME___:} 
', 
E'\\noindent ___PARAGRAPH_CONTENT___
', 
E'\\closing{Sincerely yours,}
 
\\encl{}  				% Enclosures

\\end{letter}

\\end{document}');

INSERT INTO coverletter_templates (template_name, header, signature, contact_info,
personal_info, opening, paragraph, closing) VALUES ('let7',
E'% Cover letter using letter.cls
\\documentclass{letter}
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font 
% the following commands control the margins:
\\topmargin=-1in    % Make letterhead start about 1 inch from top of page
\\textheight=8in    % text height can be bigger for a longer letter
\\oddsidemargin=0pt % leftmargin is 1 inch
\\textwidth=6.5in   % textwidth of 6.5in leaves 1 inch for right margin

\\begin{document}
',
E'\\signature{___NAME___}                  % name for signature 
\\longindentation=0pt                     % needed to get closing flush left
\\let\\raggedleft\\raggedright              % needed to get date flush left
',
E'\\begin{letter}{___CONTACT_PREFIX___ ___CONTACT_NAME___ \\\\
___CONTACT_TITLE___ \\\\
___CONTACT_COMPANY___ \\\\
___CONTACT_ADDRESS___ \\\\
___CONTACT_CITY___, ___CONTACT_STATE___ ___CONTACT_ZIP___} 
',
E'\\begin{center}
{\\large\\bf ___NAME___} \\\\
{___ADDRESS_STREET___ \\\\ ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___  \\\\ ___ADDRESS_PHONE___}
\\end{center}
\\vfill % forces letterhead to top of page
',
E'\\opening{Dear ___CONTACT_PREFIX___ ___CONTACT_LASTNAME___:} 
',
E'\\noindent ___PARAGRAPH_CONTENT___
',
E'\\closing{Sincerely yours,}
 
\\encl{}					% Enclosures

\\end{letter}

\\end{document}');

INSERT INTO coverletter_templates (template_name, header, signature, contact_info,
personal_info, opening, paragraph, closing) VALUES ('let9a',
E'% Cover letter using letter.cls
\\documentclass{letter} % Uses 10pt
%\\usepackage{helvetica} % uses helvetica postscript font (download helvetica.sty)
%\\usepackage{newcent}   % uses new century schoolbook postscript font 
% the following commands control the margins:
\\topmargin=-1in    % Make letterhead start about 1 inch from top of page 
\\textheight=8.5in    % text height can be bigger for a longer letter
\\oddsidemargin=0pt   % leftmargin is 1 inch
\\textwidth=6.5in     % textwidth of 6.5in leaves 1 inch for right margin

\\begin{document}
',
E'\\signature{___NAME___}           % name for signature 
\\longindentation=0pt                       % needed to get closing flush left
\\let\\raggedleft\\raggedright                % needed to get date flush left
', 
E'\\begin{letter}{___CONTACT_PREFIX___ ___CONTACT_NAME___ \\\\
___CONTACT_TITLE___ \\\\
___CONTACT_COMPANY___ \\\\
___CONTACT_ADDRESS___ \\\\
___CONTACT_CITY___, ___CONTACT_STATE___ ___CONTACT_ZIP___}
',
E'\\begin{center}
{\\large\\bf ___NAME___} 
\\end{center}
\\medskip\\hrule height 1pt
\\begin{center}
{___ADDRESS_STREET___ \\\\   ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___ \\\\ ___ADDRESS_PHONE___}
\\end{center}
\\vfill % forces letterhead to top of page
',
E'\\opening{Dear ___CONTACT_PREFIX___ ___CONTACT_LASTNAME___:} 
', 
E'\\noindent ___PARAGRAPH_CONTENT___
',
E'\\closing{Sincerely yours,} 
 
\\encl{}					% Enclosures

\\end{letter}

\\end{document}');

INSERT INTO coverletter_templates (template_name, header, signature, contact_info,
personal_info, opening, paragraph, closing) VALUES ('let9b',
E'% Cover letter using letter.sty
\\documentclass{letter} % Uses 10pt
%Use \\documentstyle[newcent]{letter} for New Century Schoolbook postscript font
% the following commands control the margins:
\\topmargin=-1in    % Make letterhead start about 1 inch from top of page 
\\textheight=8in  % text height can be bigger for a longer letter
\\oddsidemargin=0pt % leftmargin is 1 inch
\\textwidth=6.5in   % textwidth of 6.5in leaves 1 inch for right margin

\\begin{document}
',
E'\\signature{___NAME___}           % name for signature 
\\longindentation=0pt                       % needed to get closing flush left
\\let\\raggedleft\\raggedright                % needed to get date flush left
', 
E'\\begin{letter}{___CONTACT_PREFIX___ ___CONTACT_NAME___ \\\\
___CONTACT_TITLE___ \\\\
___CONTACT_COMPANY___ \\\\
___CONTACT_ADDRESS___ \\\\
___CONTACT_CITY___, ___CONTACT_STATE___ ___CONTACT_ZIP___}
',
E'\\begin{flushleft}
{\\large\\bf ___NAME___}
\\end{flushleft}
\\medskip\\hrule height 1pt
\\begin{flushright}
\\hfill ___ADDRESS_STREET___, ___ADDRESS_CITY___, ___ADDRESS_STATE___ ___ADDRESS_ZIP___ \\\\
\\hfill ___ADDRESS_PHONE___
\\end{flushright} 
\\vfill % forces letterhead to top of page
',
E'\\opening{Dear ___CONTACT_PREFIX___ ___CONTACT_LASTNAME___:}
',
E'\\noindent ___PARAGRAPH_CONTENT___
',
E'\\closing{Sincerely yours,} 
 
\\encl{}  				% Enclosures

\\end{letter}

\\end{document}');
