SELECT * FROM get_skill('Wrenches', 'Big Ones');
SELECT * FROM get_skill('Wrenches', 'Little Ones');
SELECT * FROM get_skill('Brooms', 'Straight Brooms');
SELECT * FROM get_skill('Brooms', 'Kitchen Brooms');
SELECT * FROM get_skill('Brooms', 'Desk Brooms');
SELECT * FROM get_skill('Brooms', 'Crooked Brooms');
SELECT * FROM set_contactinfo('Bob Has A Garage', 'address1', '4242 Nowhere Street');
SELECT * FROM set_contactinfo('Bob Has A Garage', 'city', 'Philadelphia');
SELECT * FROM set_contactinfo('Bob Has A Garage', 'state', 'PA');
SELECT * FROM set_contactinfo('Bob Has A Garage', 'zip', '19326-2312');
SELECT * FROM set_contactinfo('Bob Has A Garage', 'work_phone', '215-555-5500');
SELECT * FROM set_contactinfo('Bob Bobson', 'prefix', 'Mr.');
SELECT * FROM set_contactinfo('Bob Bobson', 'suffix', 'Sr.');
SELECT * FROM set_contactinfo('Bob Bobson', 'address1', '4242 Nowhere Street');
SELECT * FROM set_contactinfo('Bob Bobson', 'city', 'Philadelphia');
SELECT * FROM set_contactinfo('Bob Bobson', 'state', 'PA');
SELECT * FROM set_contactinfo('Bob Bobson', 'zip', '19326-2312');
SELECT * FROM set_contactinfo('Bob Bobson', 'home_phone', '215-555-4321');
SELECT * FROM set_contactinfo('Bob Bobson', 'work_phone', '215-555-5500 x100');
SELECT * FROM set_contact('Bob Bobson', 'Bob Has A Garage');
SELECT * FROM set_contactinfo('Frank Grimes', 'prefix', 'Mr.');
SELECT * FROM set_contactinfo('Frank Grimes', 'suffix', 'Jr.');
SELECT * FROM set_contactinfo('Frank Grimes', 'address1', '123 Wherever Street');
SELECT * FROM set_contactinfo('Frank Grimes', 'address2', 'Apartment J2');
SELECT * FROM set_contactinfo('Frank Grimes', 'city', 'Philadelphia');
SELECT * FROM set_contactinfo('Frank Grimes', 'state', 'PA');
SELECT * FROM set_contactinfo('Frank Grimes', 'zip', '19026-3487');
SELECT * FROM set_contactinfo('Frank Grimes', 'home_phone', '215-555-1234');
SELECT * FROM set_contactinfo('Frank Grimes', 'work_phone', '215-555-5500 x5678');
SELECT * FROM set_userinfo('frank', 'Frank Grimes');
SELECT * FROM set_resume_owner('Mechanic Resume', 'frank');
SELECT * FROM set_resume_objective('Mechanic Resume', 'A promising career as a mechanic');
SELECT * FROM add_exp_info(0, 'Assistant Mechanic', 'Bob Has A Garage', 'Primary responsibilities included fetching coffee and sweeping the floor');
SELECT * FROM add_exp_info(0, 'Mechanic', 'Bob Has A Garage');
SELECT * FROM add_exp_details(2, 'Primary responsibilities included sleeping');
SELECT * FROM add_resume_exp(0, 'Mechanic Resume', '02/2002', '02/2008', 'Assistant Mechanic', 'Bob Has A Garage');
SELECT * FROM add_resume_exp(0, 'Mechanic Resume', '02/2008', '02/2018',  'Mechanic', 'Bob Has A Garage');
SELECT * FROM set_contactinfo('You Have Never Heard Of It High School', 'address1', '11 School Lane');
SELECT * FROM set_contactinfo('You Have Never Heard Of It High School', 'city', 'Philadelphia');
SELECT * FROM set_contactinfo('You Have Never Heard Of It High School', 'state', 'PA');
SELECT * FROM set_contactinfo('You Have Never Heard Of It High School', 'zip', '19326-2312');
SELECT * FROM set_contactinfo('You Have Never Heard Of It High School', 'work_phone', '215-555-6600');
SELECT * FROM set_contactinfo('Tom Has A Tech School', 'address1', '12 School Lane');
SELECT * FROM set_contactinfo('Tom Has A Tech School', 'city', 'Philadelphia');
SELECT * FROM set_contactinfo('Tom Has A Tech School', 'state', 'PA');
SELECT * FROM set_contactinfo('Tom Has A Tech School', 'zip', '19326-2312');
SELECT * FROM set_contactinfo('Tom Has A Tech School', 'work_phone', '215-555-4400');
SELECT * FROM add_edu_info(0, 'Tom Has A Tech School', 'Small Engine Repair', '02/2002', 'BS', '{"3.5"}');
SELECT * FROM add_edu_info(0, 'You Have Never Heard Of It High School', 'General Studies', '02/2000', 'HS Diploma', '{"2.2","3.1"}');
SELECT * FROM add_resume_edu(0, 'Mechanic Resume', 1);
SELECT * FROM add_resume_edu(0, 'Mechanic Resume', 2);
SELECT * FROM add_cert_info(0, 'Certified Floor Sweeper', '02/2002', '02/2022', 'CFS094855');
SELECT * FROM add_cert_info(0, 'Certified Coffee Retriever', '02/2001', '02/2031', 'CCR98234982');
SELECT * FROM add_resume_cert(0, 'Mechanic Resume', 1);
SELECT * FROM add_resume_cert(0, 'Mechanic Resume', 2);
SELECT * FROM add_resume_skill('Mechanic Resume', 'Big Ones');
SELECT * FROM add_resume_skill('Mechanic Resume', 'Little Ones');
SELECT * FROM add_resume_skill('Mechanic Resume', 'Straight Brooms');
SELECT * FROM add_resume_skill('Mechanic Resume', 'Kitchen Brooms');
SELECT * FROM add_resume_skill('Mechanic Resume', 'Desk Brooms');
SELECT * FROM add_resume_skill('Mechanic Resume', 'Crooked Brooms');

INSERT INTO cover_letters (name, paragraphs) VALUES ('example_letter',
ARRAY['PARAGRAPH ONE: State reason for letter, name the position or type of work you are applying for and identify source from which you learned of the opening. (i.e. Career Development Center, newspaper, employment service, personal contact).', 

'PARAGRAPH TWO: Indicate why you are interested in the position, the company, its products, services - above all, stress what you can do for the employer. If you are a recent graduate, explain how your academic background makes you a qualified candidate for the position. If you have practical work experience, point out specific achievements or unique qualifications. Try not to repeat the same information the reader will find in the resume. Refer the reader to the enclosed resume or application which summarizes your qualifications, training, and experiences. The purpose of this section is to strengthen your resume by providing details which bring your experiences to life.',

'PARAGRAPH THREE: Request a personal interview and indicate your flexibility as to the time and place. Repeat your phone number in the letter and offer assistance to help in a speedy response. For example, state that you will be in the city where the company is located on a certain date and would like to set up an interview. Or, state that you will call on a certain date to set up an interview. End the letter by thanking the employer for taking time to consider your credentials.']);
