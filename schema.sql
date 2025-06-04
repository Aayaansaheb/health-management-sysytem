-- Active: 1744921430700@@127.0.0.1@3306@hms_vnit
CREATE DATABASE hms_vnit;
USE hms_vnit;

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    dob DATE,
    password VARCHAR(50)
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    specialization VARCHAR(100),
    available BOOLEAN DEFAULT TRUE
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    doctor_id INT,
    appointment_time DATETIME,
    status VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE HealthRecords (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    diagnosis TEXT,
    treatment TEXT,
    record_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE EmergencyAlerts (
    alert_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    alert_message TEXT,
    alert_time DATETIME,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    timestamp DATETIME,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Trigger to update doctor availability when an appointment is made
DELIMITER $$

CREATE TRIGGER simple_trigger
AFTER INSERT ON Appointments
FOR EACH ROW
BEGIN
  UPDATE Doctors SET available = FALSE WHERE doctor_id = NEW.doctor_id;
END$$

DELIMITER ;

-- Insert Updated Students
INSERT INTO Students (student_id, name, email, dob, password) VALUES
(30483, 'DODDI SHIVANAND', 'shiv30483@vnit.ac.in', '2005-06-15', '30483'),
(30493, 'RAGAM ABHINAY', 'abhi30493@vnit.ac.in', '2004-12-03', '30493'),
(30502, 'PRATHAMESH PATIL', 'prath30502@vnit.ac.in', '2005-01-20', '30502'),
(30520, 'AHIRE SARA PRAVIN', 'sara30520@vnit.ac.in', '2006-02-11', '30520'),
(30525, 'NITIN BHATT', 'nitin30525@vnit.ac.in', '2004-08-10', '30525'),
(30543, 'DEEV SHAH', 'deev30543@vnit.ac.in', '2005-07-01', '30543'),
(30555, 'SANKOORU ABHISHEK', 'abhi30555@vnit.ac.in', '2005-03-28', '30555'),
(30559, 'KOTHA MADHAV', 'mad30559@vnit.ac.in', '2006-05-09', '30559'),
(30589, 'NALAGATLA CHARAN KUMAR REDDY', 'charan30589@vnit.ac.in', '2004-09-14', '30589'),
(30592, 'HANCHATE DHANVANSHIKUMAR NAGESHWAR', 'dhan30592@vnit.ac.in', '2005-04-17', '30592'),
(30598, 'YELLETI HARSHITH', 'harsh30598@vnit.ac.in', '2005-11-26', '30598'),
(30612, 'ANNAVARAPU SIRI ESTHER', 'siri30612@vnit.ac.in', '2004-06-30', '30612'),
(30621, 'SUDHA HARSHITHA', 'sudha30621@vnit.ac.in', '2005-08-05', '30621'),
(30679, 'DHAGE UNNATI SANDIP', 'unnati30679@vnit.ac.in', '2006-03-15', '30679'),
(30689, 'LODHA NIDHI PARESH', 'nidhi30689@vnit.ac.in', '2004-11-22', '30689'),
(30692, 'VRAJ NIMESHBHAI BORAD', 'vraj30692@vnit.ac.in', '2005-02-02', '30692'),
(30703, 'TANUSHREE HARISH', 'tanu30703@vnit.ac.in', '2005-09-19', '30703'),
(30720, 'SHAMAKURA HASNIKA REDDY', 'hasnika30720@vnit.ac.in', '2004-07-12', '30720'),
(30725, 'SAHEB AAYAAN ANUJUBER', 'ayaan30725@vnit.ac.in', '2006-01-03', '30725'),
(30030, 'SALIL NILESH PHANSE', 'salil30030@vnit.ac.in', '2005-10-16', '30030'),
(29766, 'MEHTA HARDIK PRAMOD', 'hardik29766@vnit.ac.in', '2004-05-05', '29766'),
(29768, 'RONAK SINGH', 'ronak29768@vnit.ac.in', '2006-04-25', '29768');

-- Sample Doctors
INSERT INTO Doctors (name, specialization, available) VALUES
('DR. PANKAJ S. DHULE', 'Diabetology', TRUE),
('DR. RITESH T. MOTGHARE', 'General Medicine', TRUE),
('DR. ROHINI PATIL', 'Gynaecology', TRUE),
('DR. MUGDHA JUNGARI', 'Gynaecology', TRUE),
('DR. PRACHI DONGRE', 'Physiotherapy', TRUE),
('MRS. SUMITRA CHATTERJEE', 'Psychological Counselling', TRUE),
('MRS. PRIYA ZOTING', 'Counselling & Psychotherapy', TRUE),
('DR. SAILEE JOSHI', 'Dentistry', TRUE),
('DR. KSHITIJ CHAURASIA', 'Dentistry', TRUE),
('DR. VIVEKKUMAR SHIVHARE', 'Paediatrics', TRUE),
('DR. ABHLASH TRIPATHI', 'Homeopathy', TRUE),
('DR. MAKRAND DESHKAR', 'Ophthalmology (Eye Specialist)', TRUE),
('DR. SHRADHA MAHALLE', 'Dermatology (Skin Specialist)', TRUE),
('DR. MADHAV RAJE', 'Psychiatry', TRUE);

INSERT INTO HealthRecords (student_id, diagnosis, treatment, record_date)
VALUES
(30483, 'Routine checkup, all vital signs normal.', 'No treatment required.', '2025-04-18'),
(30493, 'Minor fever treated with medication.', 'Paracetamol 500mg for 3 days.', '2025-04-18'),
(30502, 'Routine checkup, minor cold detected.', 'Cough syrup for 5 days.', '2025-04-18'),
(30520, 'Routine checkup, slight headache reported.', 'Painkiller prescribed.', '2025-04-18'),
(30525, 'Regular checkup, blood pressure within normal limits.', 'No treatment needed.', '2025-04-18');


-- Sample Subquery
SELECT * FROM Students WHERE student_id IN (
  SELECT student_id FROM HealthRecords GROUP BY student_id HAVING COUNT(*) > 2
);
