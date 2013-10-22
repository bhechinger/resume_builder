<?php
$fields = Array(
	'months' => Array(
		'id' => 0,
		'short_name' => 1,
		'long_name' => 2
	),
	'titles' => Array(
		'id' => 0,
		'name' => 1
	),
	'skill_groups' => Array(
		'id' => 0,
		'name' => 1
	),
	'skill_info' => Array(
		'id' => 0,
		'name' => 1
	),
	'dates' => Array(
		'id' => 0,
		'month' => 1,
		'day' => 2,
		'year' => 3
	),
	'phones' => Array(
		'id' => 0,
		'area_code' => 1,
		'prefix' => 2,
		'last' => 3,
		'extention' => 4
	),
	'contact_info' => Array(
		'id' => 0,
		'prefix' => 1,
		'name' => 2,
		'suffix' => 3,
		'title' => 4,
		'address1' => 5,
		'address2' => 6,
		'city' => 7,
		'state' => 8,
		'zip' => 9,
		'zip4' => 10,
		'home_phone' => 11,
		'cell_phone' => 12,
		'work_phone' => 13,
		'alt_phone' => 14,
		'pager' => 15,
		'email' => 16,
		'web_url' => 17
	),
	'schoolco' => Array(
		'id' => 0,
		'schoolco_info' => 1,
		'contact_info' => 2
	),
	'users' => Array(
		'id' => 0,
		'name' => 1,
		'contact_info' => 2
	),
	'objectives' => Array(
		'id' => 0,
		'objective' => 1
	),
	'resumes' => Array(
		'id' => 0,
		'name' => 1,
		'userid' => 2,
		'objective' => 3
	),
	'skillsets' => Array(
		'id' => 0,
		'skill' => 1,
		'skillgroup' => 2,
		'subskillgroup' => 3
	),
	'skills' => Array(
		'id' => 0,
		'resume' => 1,
		'skill' => 2
	),
	'experience_info' => Array(
		'id' => 0,
		'title' => 1,
		'company' => 2,
		'details' => 3
	),
	'experience' => Array(
		'id' => 0,
		'resume' => 1,
		'exp' => 2,
		'start_date' => 3,
		'end_date' => 4
	),
	'education_info' => Array(
		'id' => 0,
		'school' => 1,
		'school_info' => 2,
		'program' => 3,
		'attendence_date' => 4,
		'degree' => 5,
		'gpa' => 6,
		'extra' => 7
	),
	'education' => Array(
		'id' => 0,
		'resume' => 1,
		'edu' => 2
	),
	'certification_info' => Array(
		'id' => 0,
		'name' => 1,
		'receive_date' => 2,
		'expires_date' => 3,
		'certificate_id' => 4
	),
	'certifications' => Array(
		'id' => 0,
		'resume' => 1,
		'cert' => 2
	),
	'resume_templates' => Array(
		'id' => 0,
		'template_name' => 1,
		'header' => 2,
		'name' => 3,
		'permanent_address' => 4,
		'present_address' => 5,
		'seperator' => 6,
		'objective' => 7,
		'education_header' => 8,
		'edu_comma_list' => 9,
		'education' => 10,
		'experience_header' => 11,
		'experience' => 12,
		'skills_header' => 13,
		'skills' => 14,
		'skill_list_header' => 15,
		'skill_list_item' => 16,
		'skill_list_footer' => 17,
		'certifications_header' => 18,
		'certifications' => 19,
		'footer' => 20,
		'template_order' => 21
	),
	'coverletter_templates' => Array(
		'id' => 0,
		'template_name' => 1,
		'header' => 2,
		'signature' => 3,
		'contact_info' => 4,
		'personal_info' => 5,
		'opening' => 6,
		'paragraph' => 7,
		'closing' => 8
	),
	'misc_files' => Array(
		'id' => 0,
		'filename' => 1,
		'filecontent' => 2,
		'used_by' => 3
	),
	'cover_letters' => Array(
		'id' => 0,
		'name' => 1,
		'paragraphs' => 2
	),
	'generic_status' => Array(
		'rcode' => 0,
		'message' => 1
	),
	'multireturn' => Array(
		'which' => 0,
		'id' => 1,
		'name' => 2
	),
	'contact_info_text' => Array(
		'rcode' => 0,
		'id' => 1,
		'prefix' => 2,
		'name' => 3,
		'last_name' => 4,
		'suffix' => 5,
		'title' => 6,
		'address1' => 7,
		'address2' => 8,
		'city' => 9,
		'state' => 10,
		'zip' => 11,
		'home_phone' => 12,
		'cell_phone' => 13,
		'work_phone' => 14,
		'alt_phone' => 15,
		'pager' => 16,
		'email' => 17,
		'web_url' => 18
	),
	'experience_info_text' => Array(
		'rcode' => 0,
		'resume' => 1,
		'title' => 2,
		'start_date' => 3,
		'end_date' => 4,
		'company' => 5,
		'company_city' => 6,
		'company_state' => 7,
		'details' => 8
	),
	'education_info_text' => Array(
		'rcode' => 0,
		'resume' => 1,
		'school' => 2,
		'school_city' => 3,
		'school_state' => 4,
		'program' => 5,
		'attendence_date' => 6,
		'degree' => 7,
		'gpa' => 8,
		'extra' => 9
	),
	'certification_info_text' => Array(
		'rcode' => 0,
		'resume' => 1,
		'name' => 2,
		'receive_date' => 3,
		'expires_date' => 4,
		'certificate_id' => 5
	),
	'formatted_skill_list' => Array(
		'skill_group' => 0,
		'subskill_group' => 1,
		'skills' => 2
	),
	'skillset_pair' => Array(
		'rcode' => 0,
		'message' => 1,
		'id' => 2,
		'skillgroup' => 3,
		'subskillgroup' => 4,
		'skillname' => 5
	)
);
?>
