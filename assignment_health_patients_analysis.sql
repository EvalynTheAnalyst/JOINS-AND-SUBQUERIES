create schema health_records;
set search_path to health_records;
CREATE TABLE mental_health_patients ( 
    patient_id SERIAL PRIMARY KEY, 
    first_name VARCHAR(50), 
    last_name VARCHAR(50), 
    age INT, 
    gender VARCHAR(10), 
    phone_number VARCHAR(15), 
    email VARCHAR(100), 
    address VARCHAR(255), 
    diagnosis VARCHAR(100) 
); 
 
-- Insert 15 rows into the mental_health_patients table 
INSERT INTO mental_health_patients (first_name, last_name, age, gender, phone_number, 
email, address, diagnosis) 
VALUES 
('John', 'Doe', 29, 'Male', '0712345678', 'john.doe@example.com', '123 Main St, Nairobi', 
'Depression'), 
('Jane', 'Smith', 34, 'Female', '0723456789', 'jane.smith@example.com', '456 Oak Rd, Mombasa', 
'Anxiety'), 
('Paul', 'Otieno', 40, 'Male', '0734567890', 'paul.otieno@example.com', '789 Pine Ave, Kisumu', 
'Bipolar Disorder'), 
('Mary', 'Okello', 27, 'Female', '0745678901', 'mary.okello@example.com', '321 Cedar Blvd, 
Nairobi', 'Schizophrenia'), 
('Susan', 'Njeri', 50, 'Female', '0756789012', 'susan.njeri@example.com', '654 Maple Dr, 
Mombasa', 'PTSD'), 
('James', 'Mwangi', 60, 'Male', '0767890123', 'james.mwangi@example.com', '987 Elm St, 
Kisumu', 'OCD'), 
('Rebecca', 'Karanja', 23, 'Female', '0778901234', 'rebecca.karanja@example.com', '123 Birch Ln, 
Nairobi', 'Depression'), 
('Samuel', 'Kimani', 32, 'Male', '0789012345', 'samuel.kimani@example.com', '432 Willow Rd, 
Mombasa', 'Generalized Anxiety Disorder'), 
('Grace', 'Achieng', 45, 'Female', '0790123456', 'grace.achieng@example.com', '789 Cedar St, 
Kisumu', 'Bipolar Disorder'), 
('Peter', 'Juma', 28, 'Male', '0801234567', 'peter.juma@example.com', '654 Oak Blvd, Nairobi', 
'Post-traumatic Stress Disorder'); 
 
-- Create the mental_health_doctors table 
CREATE TABLE mental_health_doctors ( 
    doctor_id SERIAL PRIMARY KEY, 
    doctor_name VARCHAR(100), 
    specialization VARCHAR(50) 
); 
 
-- Insert 5 rows into the mental_health_doctors table 
INSERT INTO mental_health_doctors (doctor_name, specialization) 
VALUES 
('Dr. Wilson', 'Psychiatrist'), 
('Dr. Smith', 'Psychologist'), 
('Dr. Allen', 'Psychiatrist'), 
('Dr. White', 'Therapist'), 
('Dr. Johnson', 'Psychologist'); 
 
-- Create the mental_health_visits table 
CREATE TABLE mental_health_visits ( 
    visit_id SERIAL PRIMARY KEY, 
    patient_id INT REFERENCES mental_health_patients(patient_id), 
    doctor_id INT REFERENCES mental_health_doctors(doctor_id), 
    visit_date DATE, 
    visit_type VARCHAR(50), 
    notes TEXT 
); 
 
-- Insert 10 rows into the mental_health_visits table 
INSERT INTO mental_health_visits (patient_id, doctor_id, visit_date, visit_type, notes) 
VALUES 
(1, 1, '2024-01-15', 'Consultation', 'Initial consultation for depression'), 
(2, 2, '2024-01-16', 'Follow-up', 'Ongoing treatment for anxiety'), 
(3, 1, '2024-02-01', 'Consultation', 'Assessment for bipolar disorder'), 
(4, 3, '2024-02-02', 'Emergency', 'Schizophrenia crisis intervention'), 
(5, 4, '2024-02-10', 'Follow-up', 'Ongoing therapy for PTSD'), 
(6, 5, '2024-02-15', 'Consultation', 'Initial session for OCD'), 
(7, 1, '2024-03-01', 'Follow-up', 'Follow-up on depression treatment'), 
(8, 2, '2024-03-05', 'Consultation', 'Generalized anxiety disorder diagnosis'), 
(9, 3, '2024-03-10', 'Emergency', 'Emergency care for bipolar disorder'), 
(10, 4, '2024-03-12', 'Follow-up', 'PTSD recovery follow-up'); 



-- 1 List all patients and the names of the doctors they saw during their last visit. 
select 
	patient_id,
	concat(first_name, ' ', last_name) as full_name,
	doctor_name
from health_records.mental_health_patients p
left join health_records.mental_health_visits v
using(patient_id)
left join health_records.mental_health_doctors
using(doctor_id);
	
-- 2.List all employees in the “Psychiatrist” specialty and the patients they are treating. 
select 
	doctor_id,
	doctor_name,
	concat(first_name, ' ', last_name) as patient_name
from health_records.mental_health_patients p
join health_records.mental_health_visits v
using(patient_id)
join health_records.mental_health_doctors d
using(doctor_id)
where d.specialization = 'Psychiatrist';

-- 3.Show all patients and the doctors they’ve visited, including patients who haven’t seen any doctor.
select 
	patient_id,
	concat(first_name, ' ', last_name) as full_name,
	doctor_name
from health_records.mental_health_patients p
left join health_records.mental_health_visits v
using(patient_id)
join health_records.mental_health_doctors
using(doctor_id);
	 
--5.List all visits and the patients associated with them, including projects that have no 
--associated patient (use RIGHT JOIN). 
select 
	visit_date,
	concat(first_name, ' ', last_name) as patient_name
from health_records.mental_health_patients p
right join health_records.mental_health_visits v
using(patient_id);
	
-- 6.Show all patients and their doctors, including patients who have not seen a doctor and 
-- doctors with no assigned patients. 
select 
	patient_id,
	concat(first_name, ' ', last_name) as patient_name,
	doctor_id,
	doctor_name
from health_records.mental_health_patients p
left join health_records.mental_health_visits v
using(patient_id)
right join health_records.mental_health_doctors
using(doctor_id);
	 	 
-- 7.Find all patients who had a follow-up visit in January 2024.
select 
	visit_date,
	concat(first_name, ' ', last_name) as patient_name,
	visit_type
from health_records.mental_health_patients p
right join health_records.mental_health_visits v
using(patient_id)
where visit_type = 'Follow-up'; 


--8.List all patients who have visited a doctor and are suffering from “Anxiety.” 
select 
	visit_id,
	concat(first_name, ' ', last_name) as patient_name,
	diagnosis
from health_records.mental_health_patients p
right join health_records.mental_health_visits v
using(patient_id)
where diagnosis = 'Anxiety';

-- 9.Find all patients who have visited more than 2 doctors.
select 
	p.patient_id,
	concat(first_name, ' ', last_name) as patient_name,
	d.doctor_name
from health_records.mental_health_patients p
right join health_records.mental_health_visits v
using(patient_id)
left join health_records.mental_health_doctors d
using(doctor_id)
group by doctor_name ,p.patient_id
having Count(patient_id)>1; 

select *
from health_records.mental_health_patients;
select *
from health_records.mental_health_doctors;

-- 10.List all patients who visited a doctor with a specialty that matches their diagnosis. 
select 
	visit_id,
	concat(first_name, ' ', last_name) as patient_name,
	doctor_name,
	diagnosis
from health_records.mental_health_patients p
right join health_records.mental_health_visits v
using(patient_id)
left join health_records.mental_health_doctors d
using(doctor_id)
where  (p.diagnosis LIKE '%Anxiety%' OR p.diagnosis = 'Depression') AND d.specialization = 'Psychologist'
    OR p.diagnosis IN ('Bipolar Disorder', 'Schizophrenia') AND d.specialization = 'Psychiatrist'
    OR p.diagnosis  IN ('PSTD', 'OCD', 'Post-traumatic Stress Disorder') AND d.specialization = 'Therapist';

-- 11.Show the average age of patients who visited a psychiatrist.
select 
	(AVG(age)):: numeric(12,0) as average_age
from 
	health_records.mental_health_patients p
right join health_records.mental_health_visits v
using(patient_id)
left join health_records.mental_health_doctors d
using(doctor_id)
where specialization= 'Psychiatrist';

--12.Count the total number of visits for each patient. 
select 
	p.patient_id,
	concat(first_name, ' ', last_name) as patient_name,
	count(visit_id) as Number_of_visit
from 
	health_records.mental_health_patients p
right join health_records.mental_health_visits v
using(patient_id)
group by p.patient_id


--13.Show employees with the doctors they’ve visited  
select 
	patient_id,
	concat(first_name, ' ', last_name) as patient_name,
	doctor_name 
from 
	health_records.mental_health_patients p
right join health_records.mental_health_visits v
using(patient_id)
left join health_records.mental_health_doctors d
using(doctor_id)


--Subqueries
--1.Show the total number of visits for each patient in the result set, using a subquery in 
--the SELECT clause. 
select 
	patient_id,
	concat(first_name, ' ', last_name) as patient_name,
	(select count(visit_id) from mental_health_visits v
	where mental_health_patients.patient_id = v.patient_id) as Number_of_visit
from 
	health_records.mental_health_patients 
group by patient_id; 


-- 2.Display each department and the highest salary within that department using a 
-- subquery in the SELECT clause. 
-- not applicaple to this scipt

--3.Use a subquery in the FROM clause to show all patients with their total number of 
-- visits. 
select 
	h.patient_id,
	concat(first_name, ' ', last_name) as patient_name,
	total_visit 
from 
	(select patient_id,
	count(*) as Total_visit
	from  health_records.mental_health_visits v
	group by patient_id) as visits
join 
	health_records.mental_health_patients h
on visits.patient_id  = h.patient_id;
 

--5.Find all employees who have a salary greater than the average salary in the 
-- company. Use a subquery in the WHERE clause. 
-- not applicaple

-- 7.Find all patients who have had at least one visit in the past year (2024) using a 
-- subquery in the WHERE clause. 
select 
	patient_id,
	concat(first_name, ' ', last_name) as patient_name
from mental_health_patients mhp 
where 1 >= (
select count (visit_date )  number_of_visit
from health_records.mental_health_visits v
 where mhp.patient_id = v.patient_id);

-- 8.Find all patients who have a diagnosis of depression and have seen a doctor 
-- specializing in therapy (subquery in WHERE).
select 
 concat(first_name, ' ', last_name) as patient_name,
 diagnosis
from mental_health_patients mhp 
right join mental_health_visits mhv  
on mhp.patient_id = mhv.patient_id
left join mental_health_doctors mhd 
using(doctor_id)
where diagnosis = 'Depression' and specialization  = 
(select specialization  from mental_health_doctors
where specialization = 'Therapist')

select *
from mental_health_patients mhp;
-- 9.List the total number of visits made by each patient, and show only patients with 
-- more than 5 visits. Use a subquery in the FROM clause. 
select 
	h.patient_id,
	concat(first_name, ' ', last_name) as patient_name,
	total_visit 
from 
	(select patient_id,
	count(*) as Total_visit
	from  health_records.mental_health_visits v
	group by patient_id) as visits
join 
	health_records.mental_health_patients h
on visits.patient_id  = h.patient_id
where total_visit > 5;
 