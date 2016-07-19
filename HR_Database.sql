use master
go

use human_resources

CREATE TABLE User_Registration		
	(
		   Registration_ID	int  PRIMARY KEY NOT NULL,  		              
           Passwords	varchar(20)	NOT NULL,	
           Roles	     varchar(20),
           Active      char(1)
	);

	INSERT INTO User_Registration		
	VALUES
		(1, '234awd', 'Developer','y'),
		(2, '345erd','Tester', 'n' ), 
		(3, 'dgsh2','Program manager','y'),
		(4, '3ujh', 'Analyst','y'),
		(5, 'hjhf','Marketing','y'),
		(6, 'hsuwh7','Business Development','y'),
		(7, 'fhjfh','DBA','y');
	GO						


CREATE TABLE Applicant		
	(
		   Applicant_ID	int  PRIMARY KEY NOT NULL, 
		  fk_Applicant int,
		  FOREIGN KEY ( fk_Applicant) REFERENCES  User_Registration(Registration_ID),
           First_Name  	char(25)	NOT NULL,	
           Last_Name       char(20),
           Address         char(50),
           City            char(25),
           State           char(10),
           Zip             int  ,
           Contact_No      int  ,
           Email_id        char(20),
           Gender          char(10),
           Date_of_Birth   date
	);  

	GO	

CREATE TABLE Applicant_Skills		
	(
        Applicant_ID int,  
        Skill_ID     int, 
	   CONSTRAINT pk_AppSkillID PRIMARY KEY (Applicant_ID, Skill_ID)
	);


CREATE TABLE Degree		
	(
        Degree           varchar(100),  
        Applicant_ID     int , 
	   CONSTRAINT pk_Degree PRIMARY KEY (Degree,Applicant_ID),
        Passing_Year    int
	);



CREATE TABLE Work_Experience		
	(
        Experience_ID        varchar(100)   PRIMARY KEY,
        fk_Applicant      int 
		FOREIGN KEY (fk_Applicant) REFERENCES  Applicant(Applicant_ID),
	    Department          char(50),
         Level                char(20),
         Start_Date          Date,
         End_Date            Date,
	);

CREATE TABLE Skills		
	(
        Skill_ID          int   PRIMARY KEY,
        Skill_Name        char(25)   ,
	    Skill_Type_Name   char(25)
         
	);

CREATE TABLE Employee_Admin		
	(
        Administrator_ID     int   PRIMARY KEY,
        fk_employee_Admin int,
		FOREIGN KEY ( fk_employee_Admin) REFERENCES  User_Registration(Registration_ID),
        First_Name         char(25)   ,
	  Last_Name        char(25),
        Address          char(50),
        City           char(50),
        State        char(10),
        Zip             int,
        Contact_No     int,
        Email        char(40),
        Gender        char(10),
        Date_of_birth    date     
	);

CREATE TABLE Employee_Contact		
	(
        Employer_ID     int   PRIMARY KEY,
        fk_employe_cont  int,
		FOREIGN KEY ( fk_employe_cont) REFERENCES  User_Registration(Registration_ID),
        Client_ID         int,
        First_Name       char(25) ,  
	  Last_Name        char(25),
        Designation     char(50),
        Contact_No       int,
        Email        varchar(40)
       );

CREATE TABLE Employee_Client		
	(
        Client_ID     int   PRIMARY KEY,
        Company_Name     char(25),    
       Address          char(50),
        City           char(50),
        State        char(10),
        Zip             int
         
	);

CREATE TABLE Job		
	(
        Job_ID     int   PRIMARY KEY,
       fk_Job    int,
	   FOREIGN KEY ( fk_job) REFERENCES  Employee_Contact(Employer_ID),
       Start_Date          date,
       End_Date          date,
        Job_Open           char(3),
        Job_Description    char(200),
        No_of_Vacancy             int
         
	);


CREATE TABLE Job_Skills_Requirement		
	(
        Job_ID       int, 
        Skill_ID     int,
	CONSTRAINT pk_Job_Skills_ID PRIMARY KEY (Job_ID,Skill_ID)
	);

CREATE TABLE Job_Exp_Requirement		
	(
        Experience_ID       int,  
        Job_ID     int,
	CONSTRAINT pk_Job_Exp_ID PRIMARY KEY (Experience_ID,Job_ID)
	);

CREATE TABLE Interview_Schedule		
	(
        Inteiewr_ID     int   PRIMARY KEY,
		fk_Applicant   int,
		FOREIGN KEY ( fk_Applicant) REFERENCES Applicant(Applicant_ID),
		fk_Job int,
		FOREIGN KEY (fk_job) REFERENCES Job(Job_ID),
		Interview_Type        char(25),
        Interview_Date        Date,
        Interview_Time        Time,
        Review_Comments       char(50),
        Result                char(3) 
       );


CREATE TABLE Work_Contact		
	(
        Applicant_ID     int,  
        Job_ID     int,
CONSTRAINT pk_Work_Contact_ID PRIMARY KEY (Applicant_ID,Job_ID),  
        Start_Date        date,
        End_Date       date   ,
	  Active        char(3),
        Comments     char(50),
       );


