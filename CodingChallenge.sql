-- 1. Provide a SQL script that initializes the database for the Job Board scenario “CareerHub”. 
create database CareerHub;
use CareerHub;

-- 2. Create tables for Companies, Jobs, Applicants and Applications
-- 3. Define appropriate primary keys, foreign keys, and constraints. 
-- 4. Ensure the script handles potential errors, such as if the database or tables already exist.
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY,
    CompanyName VARCHAR(255),
    Location VARCHAR(255)
);

CREATE TABLE Jobs (
    JobID INT PRIMARY KEY,
    CompanyID INT,
    JobTitle VARCHAR(255),
    JobDescription TEXT,
    JobLocation VARCHAR(255),
    Salary DECIMAL,
    JobType VARCHAR(50),
    PostedDate DATETIME,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

CREATE TABLE Applicants (
    ApplicantID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    City VARCHAR(100),
    State VARCHAR(100),
    Resume TEXT
);

CREATE TABLE Applications (
    ApplicationID INT PRIMARY KEY,
    JobID INT,
    ApplicantID INT,
    ApplicationDate DATETIME,
    CoverLetter TEXT,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID)
);


INSERT INTO Companies (CompanyID, CompanyName, Location) VALUES
(1, 'Tech Innovations', 'San Francisco'),
(2,'Data Driven Inc', 'New York'),
(3, 'GreenTech Solutions', 'Austin'),
(4,'CodeCrafters', 'Boston'),
(5,'HexaWare Technologies', 'Chennai');


INSERT INTO Jobs (JobID, CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate) VALUES
(1, 1, 'Frontend Developer', 'Develop user-facing features', 'San Francisco', 75000, 'Full-time', '2023-01-10'),
(2, 2, 'Data Analyst', 'Interpret data models', 'New York', 68000, 'Full-time', '2023-02-20'),
(3, 3, 'Environmental Engineer', 'Develop environmental solutions', 'Austin', 85000, 'Full-time', '2023-03-15'),
(4, 1, 'Backend Developer', 'Handle server-side logic', 'Remote', 77000, 'Full-time', '2023-04-05'),
(5, 4, 'Software Engineer', 'Develop and test software systems', 'Boston', 90000, 'Full-time', '2023-01-18'),
(6, 5, 'HR Coordinator', 'Manage hiring processes', 'Chennai', 45000, 'Contract', '2023-04-25'),
(7, 2, 'Senior Data Analyst', 'Lead data strategies', 'New York', 95000, 'Full-time', '2023-01-22');


INSERT INTO Applicants (ApplicantID, FirstName, LastName, Email, Phone, City,State,Resume) VALUES
(1,'John', 'Doe', 'john.doe@example.com', '123-456-7890','Vizag','A.P', 'Experienced web developer with 5 years of experience.'),
(2,'Jane', 'Smith', 'jane.smith@example.com', '234-567-8901','Vadodara','Gujarat', 'Data enthusiast with 3 years of experience in data analysis.'),
(3,'Alice', 'Johnson', 'alice.johnson@example.com', '345-678-9012','Chennai','Tamilnadu', 'Environmental engineer with 4 years of field experience.'),
(4,'Bob', 'Brown', 'bob.brown@example.com', '456-789-0123','Pune','Mumbai', 'Seasoned software engineer with 8 years of experience.');


INSERT INTO Applications (JobID,ApplicationID, ApplicationDate, CoverLetter) VALUES
(1, 201, '2023-04-01', 'I am excited to apply for the Frontend Developer position.'),
(2, 202, '2023-04-02', 'I am interested in the Data Analyst position.'),
(3, 203, '2023-04-03', 'I am eager to bring my expertise to your team as an Environmental Engineer.'),
(4, 204, '2023-04-04', 'I am applying for the Backend Developer role to leverage my skills.'),
(5, 205, '2023-04-05', 'I am also interested in the Software Engineer position at CodeCrafters.');

/* 5.Write an SQL query to count the number of applications received for each job listing in the"Jobs" table.
 Display the job title and the corresponding application count. Ensure that it lists all
 jobs, even if they have no applications */
select j.JobTitle, COUNT(a.ApplicationID) as ApplicationCount
from Jobs j
left join Applications a on j.JobID = a.JobID
group by j.JobID, j.JobTitle;

/* 6. Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary
range. Allow parameters for the minimum and maximum salary values. Display the job title,
company name, location, and salary for each matching job. */
select j.JobTitle, c.CompanyName, j.JobLocation, j.Salary
from Jobs j
join Companies c on j.CompanyID = c.CompanyID
where j.Salary between 50000 and 85000;

/* 7. Write an SQL query that retrieves the job application history for a specific applicant. Allow a
parameter for the ApplicantID, and return a result set with the job titles, company names, and
application dates for all the jobs the applicant has applied to */
select j.JobTitle, c.CompanyName, a.ApplicationDate
from Applications a
join Jobs j on a.JobID = j.JobID
join Companies c on j.CompanyID = c.CompanyID
where a.ApplicationID = 202;

/* 8. Create an SQL query that calculates and displays the average salary offered by all companies for
job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero. */
select AVG(Salary) as AverageSalary
from(
    select Salary
    from Jobs
    where Salary > 0
) as FilteredJobs;

/* 9. Write an SQL query to identify the company that has posted the most job listings. Display the
company name along with the count of job listings they have posted. Handle ties if multiple
companies have the same maximum count */
select c.CompanyName, count(j.JobID) as JobCount
from Companies c
join Jobs j on c.CompanyID = j.CompanyID
group by c.CompanyName
having count(j.JobID) = (
    select max(JobCount)
    from (
      select count(JobID) as JobCount
      from Jobs
      group by CompanyID
   ) as MaxJobCounts
);

/* 10.  Find the applicants who have applied for positions in companies located in 'CityX' and have at
least 3 years of experience. */
select a.firstname,a.lastname from Applicants a 
where city='Chennai' and resume like '%4 years%' 

/* 11. Retrieve a list of distinct job titles with salaries between $60,000 and $80,000 */
select distinct JobTitle from Jobs where salary between 60000 and 80000;

/* 12. Find the jobs that have not received any applications. */
select j.JobID, j.JobTitle
from Jobs j
left join Applications a ON j.JobID = a.JobID
where a.JobID IS null;

/* 13. Retrieve a list of job applicants along with the companies they have applied to and the positions
they have applied for */
select a.FirstName, a.LastName, c.CompanyName, j.JobTitle
from Applicants a
join Applications an on a.ApplicantID = an.ApplicantID
join Jobs j on an.JobID = j.JobID
join Companies c on j.CompanyID = c.CompanyID;

/* 14. Retrieve a list of companies along with the count of jobs they have posted, even if they have not
received any applications. */
select c.CompanyName, 
    (select count(*) from Jobs where CompanyID = c.CompanyID) as JobCount
from Companies c;

/* 15. List all applicants along with the companies and positions they have applied for, including those
who have not applied. */
select 
  a.FirstName, 
  a.LastName, 
  (select c.CompanyName 
   from Companies c 
  where j.CompanyID = c.CompanyID) as CompanyName,
 (select j.JobTitle 
 from Jobs j 
 where app.JobID = j.JobID) as JobTitle
from 
Applicants a
left join 
 Applications app on a.ApplicantID = app.ApplicantID
left join 
 Jobs j on app.JobID = j.JobID;

/* 16. Find companies that have posted jobs with a salary higher than the average salary of all jobs. */
select distinct c.companyname 
from companies c 
join jobs j on c.CompanyID = j.companyid 
where j.salary>(select avg(salary) from jobs);

/* 17. Display a list of applicants with their names and a concatenated string of their city and state.*/
select firstname, lastname , CONCAT(city, ',',state) as location from Applicants;

/* 18. . Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'. */
select * from jobs where JobTitle like '%developer%' or jobtitle like '%engineer%';

/* 19. . Retrieve a list of applicants and the jobs they have applied for, including those who have not
applied and jobs without applicants. */ 
select a.FirstName, a.LastName, j.JobTitle as AppliedJob
from Applicants a
left join Applications app on a.ApplicantID = app.ApplicantID
left join Jobs j on app.JobID = j.JobID;

/* 20. . List all combinations of applicants and companies where the company is in a specific city and the
applicant has more than 2 years of experience. For example: city=Chennai */
SELECT 
 a.FirstName,
 a.LastName,
 c.CompanyName
FROM 
  Applicants a
JOIN 
  Companies c ON c.Location = 'Chennai'
join Applications app on app.applicationdate=ApplicationDate
WHERE 
 DATEDIFF(YEAR, app.applicationdate, GETDATE()) > 2;