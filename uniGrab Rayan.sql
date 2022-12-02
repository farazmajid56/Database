--use master
-- go
-- drop  database UniGrab
-- go 
--create database UniGrab
--go 
--use UniGrab


CREATE TABLE [User] (
	idUser integer NOT NULL identity(1,1) primary key,
	userName varchar(30) NOT NULL unique,
	email varchar(100) NOT NULL,
	password varchar(255) NOT NULL,
	isAdmin integer NOT NULL DEFAULT '0',
	isDisabled integer NOT NULL DEFAULT '0',
)
GO


CREATE TABLE [Student] (
	idStudent integer NOT NULL primary key,
	educationType varchar(255) NOT NULL,
	DOB date NOT NULL,
    firstName varchar(100) not null,
    lastName varchar(100) not null
)

ALTER TABLE [Student] WITH CHECK ADD CONSTRAINT [Student_fk0] FOREIGN KEY ([idStudent]) REFERENCES [User]([idUser])
ON UPDATE CASCADE on delete cascade



CREATE TABLE [University] (
	phone varchar(11) NOT NULL,
	idUniversity int NOT NULL primary key,
	ranking int NOT NULL,
	campusLife varchar(1000) NOT NULL,
    location varchar(255) not null,
    latitude decimal not null,
    longitude decimal not null,
	admissionFee int NOT NULL
)
GO


ALTER TABLE [University] WITH CHECK ADD CONSTRAINT [University_fk0] FOREIGN KEY ([idUniversity]) REFERENCES [User]([idUser])
ON UPDATE CASCADE on delete cascade


create table Alumni
(
	id int identity(1,1) primary key,
	idUniversity int foreign key references University(idUniversity),
	name varchar(100),
	placementCompany varchar(100),
	batch int
)


create table FinancialAid
(
	id int identity(1,1) primary key,
	idUniversity int foreign key references University(idUniversity),
	name varchar(255),
	detail nvarchar(max)
)



CREATE TABLE [Undergraduate] (
	idStudent int primary key foreign key references Student(idStudent),
	marks int NOT NULL,
	subjectCombo varchar(100) not null,
)


CREATE TABLE [Graduate] (
	idStudent int primary key foreign key references Student(idStudent),
	CGPA int NOT NULL,
	BSDegree varchar(100) not null,
)

CREATE TABLE [Department] (
	idDepartment int NOT NULL identity(1,1) primary key,
	idUniversity int NOT NULL,
	name varchar(45) NOT NULL,

)
GO

ALTER TABLE [Department] WITH CHECK ADD CONSTRAINT [Department_fk0] FOREIGN KEY ([idUniversity]) REFERENCES [University]([idUniversity])
ON UPDATE CASCADE 

CREATE TABLE [Program] (
	idProgram int NOT NULL identity (1,1) primary key,
	idDepartment int NOT NULL,
	name varchar(45) NOT NULL,
	creditHours int NOT NULL,
	feePerCreditHour int NOT NULL,
)
GO

ALTER TABLE [Program] WITH CHECK ADD CONSTRAINT [Program_fk0] FOREIGN KEY ([idDepartment]) REFERENCES [Department]([idDepartment])
ON UPDATE CASCADE on delete cascade

CREATE TABLE [Faculty] (
	idFaculty int NOT NULL identity(1,1) primary key,
	idUniversity int NOT NULL,
	idDepartment int NOT NULL,
	firstName varchar(45) NOT NULL,
	lastName varchar(45) NOT NULL,
	email varchar(45) NOT NULL unique,
	designantion varchar(45) NOT NULL

)
GO


ALTER TABLE [Faculty] WITH CHECK ADD CONSTRAINT [Faculty_fk0] FOREIGN KEY ([idUniversity]) REFERENCES [University]([idUniversity])
ON UPDATE CASCADE on delete cascade

ALTER TABLE [Faculty] WITH CHECK ADD CONSTRAINT [Faculty_fk1] FOREIGN KEY ([idDepartment]) REFERENCES [Department]([idDepartment])


          

CREATE TABLE [GraduateProgram] (
	idGProgram int NOT NULL primary key,
	minCGPA float NOT NULL
)
GO


ALTER TABLE [GraduateProgram] WITH CHECK ADD CONSTRAINT [GraduateProgram_fk0] FOREIGN KEY ([idGProgram]) REFERENCES [Program]([idProgram])
ON UPDATE CASCADE on delete cascade




CREATE TABLE [UndergraduateProgram] (
	idUGProgram int NOT NULL primary key,
	minMarks int NOT NULL
)
GO

ALTER TABLE [UndergraduateProgram] WITH CHECK ADD CONSTRAINT [UndergraduateProgram_fk0] FOREIGN KEY ([idUGProgram]) REFERENCES [Program]([idProgram])
ON UPDATE CASCADE on delete cascade



create Table ugReqBG
(
	name varchar(255),
	bgid int foreign key references UndergraduateProgram(idUGProgram) on update cascade on delete cascade,
	primary key(bgid, name)

)

create Table gReqBG
(
	name varchar(255),
	bgid int foreign key references GraduateProgram(idGProgram) on update cascade on delete cascade,
	primary key(bgid, name)

)


CREATE TABLE [Review] (
	idReview integer identity(1,1) primary key,
	idStudent integer foreign key references Student(idStudent) on update cascade,
	idUniversity integer foreign key references University(idUniversity) on update cascade on delete cascade, 
	stars integer,
	review varchar(500) NOT NULL,
)


CREATE TABLE [text] (
	idtxt int identity(1,1) primary key,
	idUniversity int foreign key references University(idUniversity) on update cascade on delete cascade,
	description varchar(500) NOT NULL
)


CREATE TABLE [Image] (
	idimg int identity(1,1) primary key,
	idUniversity int foreign key references University(idUniversity) on update cascade on delete cascade,
	imgBin Nvarchar(max) NOT NULL,
	description varchar(255)
)

CREATE TABLE [Video] (
	idText integer identity(1,1) primary key,
	idUniversity int foreign key references University(idUniversity) on update cascade on delete cascade,
	link nvarchar(max) NOT NULL
)

CREATE TABLE Feedback (
	idFeedback integer identity(1,1) primary key,
	idUser integer foreign key references [User](idUser) on update cascade on delete cascade,
	feedback varchar(1000) NOT NULL
)


CREATE TABLE FAQs (
	idFAQ integer identity(1,1) primary key,
	question varchar(500) NOT NULL,
	answer varchar(500) NOT NULL
)




--drop table ugReqBG
--drop table gReqBG
--drop table UndergraduateProgram
--drop table GraduateProgram
--drop table Program
--drop table Faculty
--drop table Department
--drop table Alumni
--drop table Review
--drop table University






-----------------------------------INSERTION FOR TESTING -----------------------------------------------
------note:ID ATTRIBUTES WITH "identity(1,1)" in create table statements dont need to be inserted manually as it means ids are automatically inserted with an increment of 1 starting from 1------------------



--insert into [User] values( 'a', 'fast@gmail.com', 'fast123', 0, 0)
--insert into [User] values( 'b', 'fast@gmail.com', 'fast123', 0, 0)
--insert into [User] values( 'fast', 'fast@gmail.com', 'fast123', 0, 0)
--insert into [User] values( 'lums', 'lums@gmail.com', 'lums123', 0, 0)
--insert into [User] values( 'giki', 'giki@gmail.com', 'giki123', 0, 0)
--insert into [User] values( 'nust', 'nust@gmail.com', 'nust123', 0, 0)


--select * from [User]



--insert into [University] values('03003333333', 3, 3, 'v good', 'lahore', 0, 0, 25000)
--insert into [University] values('03004444444', 4, 4, 'v good', 'lahore', 0, 0, 24000)
--insert into [University] values('03005555555', 5, 5, 'v good', 'lahore', 0, 0, 23000)
--insert into [University] values('03006666666', 6, 6, 'v good', 'lahore', 0, 0, 22000)

--select * from University


----------------------Student table insertions not made (Do yourself for testing)-----------------------------

--insert into Department values(3, 'FastComputingDept')
--insert into Department values(4, 'LumsComputingDept')
--insert into Department values(5, 'GikiComputingDept')
--insert into Department values(6, 'NustComputingDept')
--insert into Department values(3, 'FastEngDept')

--select * from Department


--insert into Program values( 1, 'BSCS', 110, 8500)
--insert into Program values( 1, 'BSSE', 110, 8500)
--insert into Program values( 1, 'BSDS', 110, 8500)
--insert into Program values( 2, 'BSCS', 110, 8500)
--insert into Program values( 2, 'BSSE', 110, 8500)
--insert into Program values( 2, 'BSDS', 110, 8500)
--insert into Program values( 3, 'BSCS', 110, 8500)
--insert into Program values( 3, 'BSSE', 110, 8500)
--insert into Program values( 3, 'BSDS', 110, 8500)
--insert into Program values( 4, 'BSCS', 110, 8500)
--insert into Program values( 4, 'BSSE', 110, 8500)
--insert into Program values( 5, 'BSEE', 110, 8500)
--insert into Program values( 5, 'BSCV', 110, 8500)

--select * from Program


--insert into UndergraduateProgram values(1, 920)
--insert into UndergraduateProgram values(2, 900)
--insert into UndergraduateProgram values(3, 850)
--insert into UndergraduateProgram values(4, 940)
--insert into UndergraduateProgram values(5, 920)
--insert into UndergraduateProgram values(6, 870)
--insert into UndergraduateProgram values(7, 890)
--insert into UndergraduateProgram values(8, 850)
--insert into UndergraduateProgram values(9, 800)
--insert into UndergraduateProgram values(10, 860)
--insert into UndergraduateProgram values(11, 900)
--insert into UndergraduateProgram values(12, 600)
--insert into UndergraduateProgram values(13, 620)

--select * from UndergraduateProgram

--insert into ugReqBG values('Pre Engineering', 1)
--insert into ugReqBG values('Pre Medical', 1)
--insert into ugReqBG values('ICS', 1)
--insert into ugReqBG values('Pre Engineering', 2)
--insert into ugReqBG values('Pre Medical', 2)
--insert into ugReqBG values('Pre Engineering', 3)
--insert into ugReqBG values('Pre Medical', 3)
--insert into ugReqBG values('ICS', 3)
--insert into ugReqBG values('Pre Engineering', 4)
--insert into ugReqBG values('Pre Medical', 4)
--insert into ugReqBG values('ICS', 4)
--insert into ugReqBG values('Pre Engineering', 5)
--insert into ugReqBG values('Pre Medical', 5)
--insert into ugReqBG values('Pre Engineering', 6)
--insert into ugReqBG values('Pre Medical', 6)
--insert into ugReqBG values('ICS', 6)
--insert into ugReqBG values('Pre Engineering', 7)
--insert into ugReqBG values('Pre Medical', 7)
--insert into ugReqBG values('ICS', 7)
--insert into ugReqBG values('Pre Engineering', 8)
--insert into ugReqBG values('Pre Medical', 8)
--insert into ugReqBG values('Pre Engineering', 9)
--insert into ugReqBG values('Pre Medical', 9)
--insert into ugReqBG values('ICS', 9)
--insert into ugReqBG values('Pre Engineering', 10)
--insert into ugReqBG values('Pre Medical', 10)
--insert into ugReqBG values('ICS', 10)
--insert into ugReqBG values('Pre Engineering', 11)
--insert into ugReqBG values('Pre Medical', 11)
--insert into ugReqBG values('Pre Engineering', 12)
--insert into ugReqBG values('Pre Engineering', 13)


--select * from ugReqBG



--insert into Faculty values( 3, 1, 'Saira', 'Karim', 'saira@nu.pk', 'Professor')
--insert into Faculty values( 3, 1, 'Abida', 'Akram', 'abida@nu.pk', 'Professor')
--insert into Faculty values( 3, 1, 'Kashif', 'Zafar', 'kashif@nu.pk', 'HOD')
--insert into Faculty values( 3, 5, 'Akhlaq', 'Bhatti', 'akhlaq@nu.pk', 'Professor')
--insert into Faculty values( 3, 5, 'Tauseef', 'Shah', 'tauseef@nu.pk', 'Assistant Professor')

--select * from Faculty


--insert into Alumni values(3, 'Raza Haider', 'a Company', 2020)
--insert into Alumni values(3, 'Rayan Siddique', 'b Company', 2020)
--insert into Alumni values(3, 'Arez Shahid', 'c Company', 2020)
--insert into Alumni values(3, 'Huzaifa Faruqi', 'd Company', 2020)
--insert into Alumni values(3, 'Arslan Waqar', 'e Company', 2020)
--insert into Alumni values(3, 'Faizan', 'f Company', 2020)

--select * from Alumni


--insert into FinancialAid values(3, 'PEEF Scolarship', 'The Government of Punjab gives 42 scholarships to indigent students having domicile of Punjab. Newly admitted students in any campus of the university can apply for this scholarship.
--The scholarship is for 4-year undergraduate studies and covers some portion of the tuition fee. The remaining tuition fee can be given by the University as Qarz-e-Hasna.')

--insert into FinancialAid values(3, 'OSAF Scolarship', 'OSAF (Old Students Association of FAST) arranges financial assistance for those students who cannot afford to pay their full fee.')
--insert into FinancialAid values(6, 'Sindh Government Endowment Board Scholarships', 'The Sindh Government offers scholarships to students of Karachi campus on need-cum-merit for both under-graduate and graduate studies. The scholarship covers full tuition fee for entire duration of the program, renewable every year. The quota for students from rural sector is 60%, and the remaining 40% is for the students from urban sector. About 25 new scholarships are offered every year under this scheme.')
--insert into FinancialAid values(6, 'Study Loan', 'Realizing that the fees may not be affordable for some of its students, FAST arranges financial assistance in the form of interest-free study loans for bright indigent students. This assistance is subject to renewal every semester in light of the student’s academic performance. Financial assistance is limited to tuition fee only and is discontinued if the student’s CGPA falls below the minimum specified to avoid warning. Loan recipients MUST take full load of courses offered.')



--select * from FinancialAid

--insert into Review values(14, 3, 3, 'avg')
--insert into Review values(15, 3, 3, 'good')
--insert into Review values(16, 3, 3, 'labs farig heen')
--insert into Review values(14, 4, 3, 'v good')
--insert into Review values(15, 4, 3, 'bht aala')
--insert into Review values(18, 4, 3, 'mazedar uni')
--insert into Review values(18, 5, 3, 'giki bht door he')
--insert into Review values(15, 5, 3, 'giki giki he')
--insert into Review values(18, 5, 3, 'mazedar uni giki')
--insert into Review values(19, 6, 3, 'mazedar uni nust')

--select * from Review




