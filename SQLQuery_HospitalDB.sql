CREATE DATABASE Hospital
use Hospital

CREATE TABLE Patient (
    Patient_id INT PRIMARY KEY IDENTITY(1,1),
    F_name VARCHAR(50) NOT NULL,
    L_name VARCHAR(50) NOT NULL,
    Phone_no VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(30),
    DOB DATE NOT NULL,
    Blood_group VARCHAR(5),
    Gender VARCHAR (6) CHECK (Gender IN ('Male', 'Female', 'M','F'))
);

CREATE TABLE Department (
    Dept_id INT PRIMARY KEY IDENTITY(1,1),
    Dept_name VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(100),
    Contact_number VARCHAR(15),
    Head_doctor_id INT UNIQUE
);

CREATE TABLE Doctor (
    Doctor_id INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    Phone_no VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    License_no VARCHAR(50) UNIQUE NOT NULL,
    Qualification VARCHAR(100) NOT NULL,
    Years_of_experience INT DEFAULT 0,
    Dept_id INT,

    FOREIGN KEY (Dept_id)
        REFERENCES Department(Dept_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

ALTER TABLE Department
ADD CONSTRAINT fk_department_head
FOREIGN KEY (Head_doctor_id)
REFERENCES Doctor(Doctor_id)
ON DELETE NO ACTION
ON UPDATE  NO ACTION;

CREATE TABLE Appointment (
    Appointment_id INT PRIMARY KEY IDENTITY(1,1),
    Patient_id INT NOT NULL,
    Doctor_id INT NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,

    Status VARCHAR (10) CHECK (Status IN('Scheduled', 'Completed', 'Cancelled')) NOT NULL,

    Appointment_type VARCHAR (20) CHECK(Appointment_type IN ('Consultation', 'Follow-up', 'Emergency')) NOT NULL,
    Reason TEXT,

    FOREIGN KEY (Patient_id)
        REFERENCES Patient(Patient_id),
      

    FOREIGN KEY (Doctor_id)
        REFERENCES Doctor(Doctor_id)
  
);

CREATE TABLE Service (
    Service_id INT PRIMARY KEY IDENTITY(1,1),
    Service_name VARCHAR(100) NOT NULL,

    Service_type VARCHAR (30) CHECK(Service_type IN('Consultation',  'Lab Test', 'X-Ray','Surgery','Treatment'))NOT NULL,

    Unit_price DECIMAL(10,2) NOT NULL,
    Description TEXT,

    Dept_id INT,

    FOREIGN KEY (Dept_id)
        REFERENCES Department(Dept_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Appointment_Service (
    Appointment_id INT,
    Service_id INT,
    Quantity INT NOT NULL DEFAULT 1,

    PRIMARY KEY (Appointment_id, Service_id),

    FOREIGN KEY (Appointment_id)
        REFERENCES Appointment(Appointment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (Service_id)
        REFERENCES Service(Service_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Medical_Record (
    Record_id INT PRIMARY KEY IDENTITY(1,1),

    Appointment_id INT UNIQUE,
    Patient_id INT NOT NULL,
    Doctor_id INT NOT NULL,

    Visit_date DATE NOT NULL,
    Diagnosis TEXT,
    Treatment_plan TEXT,
    Prescribed_medications TEXT,
    Doctor_notes TEXT,

    Follow_up_required BIT DEFAULT 0,

    FOREIGN KEY (Appointment_id)
        REFERENCES Appointment(Appointment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (Patient_id)
        REFERENCES Patient(Patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (Doctor_id)
        REFERENCES Doctor(Doctor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Billing (
    Bill_id INT PRIMARY KEY IDENTITY(1,1),

    Appointment_id INT UNIQUE,
    Patient_id INT NOT NULL,

    Bill_date DATE NOT NULL,

    Total_amount DECIMAL(10,2) DEFAULT 0.00,

    Payment_status VARCHAR(10) CHECK (Payment_status IN('Paid', 'Pending', 'Partial')),

    Payment_method VARCHAR(10) CHECK (Payment_method IN('Cash', 'Card', 'Insurance')),

    Due_date DATE,

    FOREIGN KEY (Appointment_id)
        REFERENCES Appointment(Appointment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (Patient_id)
        REFERENCES Patient(Patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
