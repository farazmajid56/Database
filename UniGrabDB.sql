use master
go
DROP DATABASE IF EXISTS UniGrab
go 
create database UniGrab
go 
use UniGrab


CREATE TABLE [User] (
	idUser integer NOT NULL identity(1,1) primary key,
	userName varchar(30) NOT NULL unique,
	email varchar(100) NOT NULL,
	password varchar(255) NOT NULL,
	--firstName varchar(255) NOT NULL,
	--lastName varchar(255) NOT NULL,
	--location varchar(255) NOT NULL,
	--latitude decimal NOT NULL,
	--longitude decimal NOT NULL,
	isAdmin integer NOT NULL DEFAULT '0',
	isDisabled integer NOT NULL DEFAULT '0',
	type varchar(255) NOT NULL
)
GO


CREATE TABLE [Student] (
	idStudent integer NOT NULL primary key,
	educationType varchar(255) NOT NULL,
	DOB date NOT NULL,
)

ALTER TABLE [Student] WITH CHECK ADD CONSTRAINT [Student_fk0] FOREIGN KEY ([idStudent]) REFERENCES [User]([idUser])
ON UPDATE CASCADE on delete cascade



CREATE TABLE [University] (
	phone varchar(11) NOT NULL,
	idUniversity int NOT NULL primary key,
	ranking int NOT NULL,
	campusLife varchar(1000) NOT NULL,
	[location] varchar(255) not null,
	latitude decimal not null,
	longitude decimal not null,
	admissionFee int NOT NULL
)
GO


ALTER TABLE [University] WITH CHECK ADD CONSTRAINT [University_fk0] FOREIGN KEY ([idUniversity]) REFERENCES [User]([idUser])
ON UPDATE CASCADE on delete cascade

           -- -------------------------   Must execute these lines below ------------------
--alter table [User] drop column firstName
--alter table [User] drop column lastName
--alter table [User] drop column location
--alter table [User] drop column latitude
--alter table [User] drop column longitude

alter table Student add firstName varchar(100) not null
alter table Student add lastName varchar(100) not null


--alter table University add [location] varchar(255) not null
--alter table University add latitude decimal not null
--alter table University add longitude decimal not null

           --------------------------------------------------------------------------------

create table Alumni
(
	id int identity(1,1) primary key,
	idUniversity int foreign key references University(idUniversity) on update cascade on delete cascade,
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
	idStudent int primary key foreign key references Student(idStudent) on update cascade on delete cascade,
	marks int NOT NULL,
	subjectCombo varchar(100) not null,
)


CREATE TABLE [Graduate] (
	idStudent int primary key foreign key references Student(idStudent) on update cascade on delete cascade,
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
	email varchar(45) NOT NULL,
	designantion varchar(45) NOT NULL,

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
	bgid int foreign key references UndergraduateProgram(idUGProgram),
	primary key(bgid, name)

)

create Table gReqBG
(
	name varchar(255),
	bgid int foreign key references GraduateProgram(idGProgram),
	primary key(bgid, name)

)


CREATE TABLE [Review] (
	idReview integer identity(1,1) primary key,
	idStudent integer foreign key references Student(idStudent),
	idUniversity integer foreign key references University(idUniversity),
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



-----------------------------------------------------------------------------------------
--PROCEDURE FOR Use Case 2--

DROP PROCEDURE IF EXISTS login_Check
go
create procedure login_Check
@email varchar(45),
@password varchar(45),
@type varchar(45) output,
@isSuccess int output
as
begin
	declare @uid int
	-- Checking if user Exists
	if exists ( select idUser = @uid from [User] where  [User].email = @email and [User].[password] = @password)
	 begin
	 	if exists (SELECT * FROM [User] WHERE [User].email = @email AND isDisabled = 1)
			BEGIN
				PRINT 'Your is Account Disabled'
				SET @isSuccess = 0
				RETURN @isSuccess
			END
		print 'User Found & Log In Success'
	 --Checkig if Student
		if exists (select * from [Student] where idStudent=@uid)
			begin 
				set @type = 'student'
				print 'Logged In as Student'
			end
	 --Checkig if University
		if exists (select * from [University] where idUniversity=@uid)
			begin 
				set @type = 'university'
				print 'Logged In as University'
			end
	----Checkig if Admin
			if exists (select * from [User] where @uid = idUser AND isAdmin = 1)
			begin 
				set @type = 'admin'
				print 'Logged In as Admin'
			end
		set @isSuccess = 1
	 end
	-- User Not Found
	else
	 begin
		set @isSuccess = 0
		print 'Invalid Email or Passward'
	 end
end
go

--PROCEDURE FOR Use Case 1--

DROP PROCEDURE IF EXISTS signup_Check
go
--create procedure signup_Check
--@uid integer,
--@username varchar(30),
--@email varchar(100),
--@password varchar(255),
--@firstname varchar(255),
--@lastaname varchar(255),
--@location varchar(255),
--@latitude decimal,
--@longitude decimal,
--@type varchar(1),
--@success int output
--as
--begin
--		--CHECK NEW USER TYPE AND ADD ACCORDINGLY
--		if NOT exists (select * from [User] where  [User].email = @email)
--			begin
--				--Checkig if Student
--				if (@type = 'S')
--					begin 
--						insert into [User]
--						VALUES (@uid,@username,@email,@password,@firstname,@lastaname,@location,@latitude,@longitude,0,0)
--					end
--				--Checkig if University
--				if (@type = 'U')
--					begin 
--						insert into [User]
--						VALUES (@uid,@username,@email,@password,@firstname,@lastaname,@location,@latitude,@longitude,0,0)
--						print 'User Inserted'
--					end
--				set @success = 1
--				print 'User Inserted'
--			end
--		else
--			begin
--			set @success = 0
--			print 'User Already Exists'	
--			end
--end
--go
--PROCEDURES FOR Use Case 13 Manage Account--

DROP PROCEDURE IF EXISTS enable_Account
GO
CREATE PROCEDURE enable_Account
@uid int
AS
BEGIN
	IF EXISTS(SELECT * FROM [User] WHERE @uid = idUser)
		BEGIN
			UPDATE	[User]
			SET		isDisabled = 0
			WHERE	idUser = @uid

			SELECT 1 as result
			PRINT 'Successfuly Enabled'
		END	
	ELSE
		BEGIN
			SELECT 0 as result
			PRINT 'Record not found'
		END
END
GO

DROP PROCEDURE IF EXISTS disable_Account
GO
CREATE PROCEDURE disable_Account
@uid int
AS
BEGIN
	IF EXISTS(SELECT * FROM [User] WHERE @uid = idUser)
		BEGIN
			UPDATE	[User]
			SET		isDisabled = 1
			WHERE	idUser = @uid

			SELECT 1 as result
			PRINT 'Successfuly Disabled'
		END	
	ELSE
		BEGIN
			SELECT 0 as result
			PRINT 'Record not found'
		END
END
GO

DROP PROCEDURE IF EXISTS delete_Account
GO
create procedure delete_Account
@uid int
AS
BEGIN
	DECLARE @type varchar(1)
		IF EXISTS(SELECT * FROM [User] WHERE @uid = idUser)
			BEGIN
				--SET @isSuccess = 1
				--Check if Student
				IF EXISTS(SELECT * FROM [Student] WHERE @uid = idStudent)
					BEGIN
						SET @type = 'S'
					END
				--Check if University
				IF EXISTS(SELECT * FROM [University] WHERE @uid = idUniversity)
					BEGIN
						SET @type = 'U'
					END

				DELETE FROM [User] WHERE idUser = @uid
				PRINT 'Deleted from Table USER'
				IF (@type = 'S')
					BEGIN
						DELETE FROM [Student] WHERE idStudent = @uid
						-- Check if on delete cascade enabled
						SELECT 1 as result
						PRINT 'Deleted from Table STUDENT'
					END
				ELSE IF (@type = 'U')
					BEGIN
						DELETE FROM [University] WHERE idUniversity = @uid
						SELECT 1 as result
						PRINT 'Deleted from Table UNIVERSITY'
					END

			END
		ELSE
			BEGIN
				SELECT 0 as result
				PRINT 'Error Record Not Found'
			END
END
GO

-----usecase 9------

DROP PROCEDURE IF EXISTS viewStudentProfile
GO
create procedure viewStudentProfile
@uid int 
as 
BEGIN
	if exists (select * from [User] where  [User].idUser = @uid)
	 begin
		if exists(select * from [Student] where [Student].idStudent=@uid)
			begin
				if not exists(select * from [Graduate] where [Graduate].idStudent=@uid)
					begin
						SELECT * 
						FROM [User] join [Student] on idUser=idStudent
						WHERE idUser= @uid
						Print 'User is Graduate'
					end
				else 
					begin
						SELECT * 
						FROM [User] join [Student] on idUser=idStudent join [Graduate] on [Student].idStudent = [Graduate].idStudent
						WHERE idUser= @uid
						Print 'User is Graduate'
					end
			end
		else
		BEGIN
			Print 'User is not Student type'
		end
	 end
	else
		begin
			Print 'User not Found'
		end
END
GO

-------usecase 10--------
DROP PROCEDURE IF EXISTS viewUniProfile
GO
create procedure viewUniProfile
@uid int 
as
BEGIN
if exists (select * from [User] where  [User].idUser = @uid)
begin
		  if exists(select * from [University] where [University].idUniversity=@uid)
			    begin
				     SELECT * 
					 FROM [User] join [University] on idUser=idUniversity
                       WHERE idUser= @uid
					   end
	     else 
			  begin
					  Print 'User is not University Type'
			  end
			  end

		else
		    begin
		              Print 'User not Found'
			end

END
GO

DROP PROCEDURE IF EXISTS getAllUsers
GO
create procedure getAllUsers
AS
BEGIN
	SELECT * 
	FROM [User]
END
GO
--(select *, 'University' as type from [User] as ttk where idUser = 1) 
DROP PROCEDURE IF EXISTS getUser
GO
create procedure getUser
@uid int
AS
BEGIN
	IF EXISTS(SELECT * FROM [Student] WHERE idStudent=@uid)
		BEGIN
			SELECT * 
			FROM [User] join [Student] on [Student].[idStudent] = [User].idUser
			WHERE idUser = @uid
		END
	ELSE
			SELECT * 
			FROM [User] join [University] on [University].[idUniversity] = [User].idUser
			WHERE idUser = @uid
END
GO
--------------------------------------------------------------------------------------------------
SELECT * FROM [User]
SELECT * FROM [Student]
SELECT * FROM [University]
SELECT * FROM [Graduate]
SELECT * FROM [Undergraduate]

---- Sign Up Test --
--go
--declare @message int
--EXECUTE signup_Check
--@uid = 1,
--@username = 'farazmajid',
--@email = 'farazmajid56@gmail.com',
--@password = '123456',
--@firstname = 'faraz',
--@lastaname = 'majid',
--@location = 'lahore',
--@latitude = 123.45,
--@longitude = 456.77,
--@type = 'student',
--@success = @message
--SELECT * FROM [User]
--go


---- Log In Test --
--go
--declare @message int
--declare @Utype varchar(45)
--EXECUTE login_Check
--@email = 'farazmajid56@gmail.com',
--@password = '123456',
--@type = @Utype,
--@isSuccess = @message
----select @message
----select @Utype
--go

--go
--insert into [User]
--VALUES (2,'root','root@unigrab.com','123456','root','abcd','system','0.0','0.0',1,0)
--go

exec viewStudentProfile '7'
--exec viewUniProfile '6'
exec getUser '3'

exec delete_Account '2'

-- test enable_Account
-- GO
-- DECLARE @success int
-- EXECUTE enable_Account
-- @uid = 7
-- SELECT * FROM [User]
-- GO

-- test disable_Account
-- GO
-- EXECUTE disable_Account
-- @uid = 7
-- SELECT * FROM [User]
-- GO

---- test delete_Account
--GO
--DECLARE @success int
--EXECUTE delete_Account
--@uid = 1,
--@isSuccess = @success
--SELECT * FROM [User]
--GO

--SELECT * FROM [Student]

--insert into [User]
--VALUES (1,'faraz','farazz@unigrab.com','123456','faraz','majid','lahore','0.0','0.0',0,0)
--insert into [Student]
--VALUES (1,'A Levels',85.70,'2001-2-17','IT')

--SELECT  
--    SERVERPROPERTY('productversion') as 'Product Version', 
--    SERVERPROPERTY('productlevel') as 'Product Level',  
--    SERVERPROPERTY('edition') as 'Product Edition',
--    SERVERPROPERTY('buildclrversion') as 'CLR Version',
--    SERVERPROPERTY('collation') as 'Default Collation',
--    SERVERPROPERTY('instancename') as 'Instance',
--    SERVERPROPERTY('lcid') as 'LCID',
--    SERVERPROPERTY('servername') as 'Server Name'

---------------------------------INSERTION FOR TESTING -----------------------------------------------
----note:ID ATTRIBUTES WITH "identity(1,1)" in create table statements dont need to be inserted manually as it means ids are automatically inserted with an increment of 1 starting from 1------------------



insert into [User] values( 'a', 'fast@gmail.com', 'fast123', 0, 0,'University')
insert into [User] values( 'b', 'fast@gmail.com', 'fast123', 0, 0,'University')
insert into [User] values( 'fast', 'fast@gmail.com', 'fast123', 0, 0,'University')
insert into [User] values( 'lums', 'lums@gmail.com', 'lums123', 0, 0,'University')
insert into [User] values( 'giki', 'giki@gmail.com', 'giki123', 0, 0,'University')
insert into [User] values( 'nust', 'nust@gmail.com', 'nust123', 0, 0,'University')
insert into [User] values( 'faraz', 'faraz@gmail.com', 'faraz123', 0, 0,'Student')
insert into [User] values( 'aemon', 'aemon@gmail.com', 'aemon123', 0, 0,'Student')
insert into [User] values( 'momin', 'momin@gmail.com', 'momin123', 0, 0,'Student')
insert into [User] values( 'zain', 'zain@gmail.com', 'zain123', 0, 0,'Student')
insert into [User] values( 'rayan', 'rayan@gmail.com', 'rayan123', 0, 0,'Student')
insert into [User] values( 'awais', 'awais@gmail.com', 'awais123', 0, 0,'Student')
insert into [User] values( 'mujahid', 'mujahid@gmail.com', 'mujahid123', 0, 0,'Student')
insert into [User] values( 'ali', 'ali@gmail.com', 'ali123', 0, 0,'Student')

SELECT * FROM [User]

INSERT into [Student] values(7,'A-Level','2000-01-01','faraz','majid')
INSERT into [Student] values(8,'Fsc','2000-01-01','aemon','fatima')
INSERT into [Student] values(9,'A-Level','2000-01-01','momnin','imran')
INSERT into [Student] values(14,'A-Level','2000-01-01','ali','khan')

SELECT * FROM [Student]

INSERT INTO [Undergraduate] values(7,100,'Science')
INSERT INTO [Undergraduate] values(8,100,'Science')
INSERT INTO [Undergraduate] values(9,100,'Science')

SELECT * FROM [Undergraduate]

INSERT INTO [Graduate] values(14,3.98,'CS')

SELECT * FROM [Graduate]

insert into [University] values('03003333333', 3, 3, 'v good', 'lahore', 0, 0, 25000)
insert into [University] values('03004444444', 4, 4, 'v good', 'lahore', 0, 0, 24000)
insert into [University] values('03005555555', 5, 5, 'v good', 'lahore', 0, 0, 23000)
insert into [University] values('03006666666', 6, 6, 'v good', 'lahore', 0, 0, 22000)

select * from University


--------------------Student table insertions not made (Do yourself for testing)-----------------------------

insert into Department values(3, 'FastComputingDept')
insert into Department values(4, 'LumsComputingDept')
insert into Department values(5, 'GikiComputingDept')
insert into Department values(6, 'NustComputingDept')
insert into Department values(3, 'FastEngDept')

select * from Department


insert into Program values( 1, 'BSCS', 110, 8500)
insert into Program values( 1, 'BSSE', 110, 8500)
insert into Program values( 1, 'BSDS', 110, 8500)
insert into Program values( 2, 'BSCS', 110, 8500)
insert into Program values( 2, 'BSSE', 110, 8500)
insert into Program values( 2, 'BSDS', 110, 8500)
insert into Program values( 3, 'BSCS', 110, 8500)
insert into Program values( 3, 'BSSE', 110, 8500)
insert into Program values( 3, 'BSDS', 110, 8500)
insert into Program values( 4, 'BSCS', 110, 8500)
insert into Program values( 4, 'BSSE', 110, 8500)
insert into Program values( 5, 'BSEE', 110, 8500)
insert into Program values( 5, 'BSCV', 110, 8500)

select * from Program


insert into UndergraduateProgram values(1, 920)
insert into UndergraduateProgram values(2, 900)
insert into UndergraduateProgram values(3, 850)
insert into UndergraduateProgram values(4, 940)
insert into UndergraduateProgram values(5, 920)
insert into UndergraduateProgram values(6, 870)
insert into UndergraduateProgram values(7, 890)
insert into UndergraduateProgram values(8, 850)
insert into UndergraduateProgram values(9, 800)
insert into UndergraduateProgram values(10, 860)
insert into UndergraduateProgram values(11, 900)
insert into UndergraduateProgram values(12, 600)
insert into UndergraduateProgram values(13, 620)

select * from UndergraduateProgram

insert into ugReqBG values('Pre Engineering', 1)
insert into ugReqBG values('Pre Medical', 1)
insert into ugReqBG values('ICS', 1)
insert into ugReqBG values('Pre Engineering', 2)
insert into ugReqBG values('Pre Medical', 2)
insert into ugReqBG values('Pre Engineering', 3)
insert into ugReqBG values('Pre Medical', 3)
insert into ugReqBG values('ICS', 3)
insert into ugReqBG values('Pre Engineering', 4)
insert into ugReqBG values('Pre Medical', 4)
insert into ugReqBG values('ICS', 4)
insert into ugReqBG values('Pre Engineering', 5)
insert into ugReqBG values('Pre Medical', 5)
insert into ugReqBG values('Pre Engineering', 6)
insert into ugReqBG values('Pre Medical', 6)
insert into ugReqBG values('ICS', 6)
insert into ugReqBG values('Pre Engineering', 7)
insert into ugReqBG values('Pre Medical', 7)
insert into ugReqBG values('ICS', 7)
insert into ugReqBG values('Pre Engineering', 8)
insert into ugReqBG values('Pre Medical', 8)
insert into ugReqBG values('Pre Engineering', 9)
insert into ugReqBG values('Pre Medical', 9)
insert into ugReqBG values('ICS', 9)
insert into ugReqBG values('Pre Engineering', 10)
insert into ugReqBG values('Pre Medical', 10)
insert into ugReqBG values('ICS', 10)
insert into ugReqBG values('Pre Engineering', 11)
insert into ugReqBG values('Pre Medical', 11)
insert into ugReqBG values('Pre Engineering', 12)
insert into ugReqBG values('Pre Engineering', 13)


select * from ugReqBG



insert into Faculty values( 3, 1, 'Saira', 'Karim', 'saira@nu.pk', 'Professor')
insert into Faculty values( 3, 1, 'Abida', 'Akram', 'abida@nu.pk', 'Professor')
insert into Faculty values( 3, 1, 'Kashif', 'Zafar', 'kashif@nu.pk', 'HOD')
insert into Faculty values( 3, 5, 'Akhlaq', 'Bhatti', 'akhlaq@nu.pk', 'Professor')
insert into Faculty values( 3, 5, 'Tauseef', 'Shah', 'tauseef@nu.pk', 'Assistant Professor')

select * from Faculty


insert into Alumni values(3, 'Raza Haider', 'a Company', 2020)
insert into Alumni values(3, 'Rayan Siddique', 'b Company', 2020)
insert into Alumni values(3, 'Arez Shahid', 'c Company', 2020)
insert into Alumni values(3, 'Huzaifa Faruqi', 'd Company', 2020)
insert into Alumni values(3, 'Arslan Waqar', 'e Company', 2020)
insert into Alumni values(3, 'Faizan', 'f Company', 2020)

select * from Alumni


insert into FinancialAid values(3, 'PEEF Scolarship', 'The Government of Punjab gives 42 scholarships to indigent students having domicile of Punjab. Newly admitted students in any campus of the university can apply for this scholarship.
The scholarship is for 4-year undergraduate studies and covers some portion of the tuition fee. The remaining tuition fee can be given by the University as Qarz-e-Hasna.')

insert into FinancialAid values(3, 'OSAF Scolarship', 'OSAF (Old Students Association of FAST) arranges financial assistance for those students who cannot afford to pay their full fee.')
insert into FinancialAid values(6, 'Sindh Government Endowment Board Scholarships', 'The Sindh Government offers scholarships to students of Karachi campus on need-cum-merit for both under-graduate and graduate studies. The scholarship covers full tuition fee for entire duration of the program, renewable every year. The quota for students from rural sector is 60%, and the remaining 40% is for the students from urban sector. About 25 new scholarships are offered every year under this scheme.')
insert into FinancialAid values(6, 'Study Loan', 'Realizing that the fees may not be affordable for some of its students, FAST arranges financial assistance in the form of interest-free study loans for bright indigent students. This assistance is subject to renewal every semester in light of the student�s academic performance. Financial assistance is limited to tuition fee only and is discontinued if the student�s CGPA falls below the minimum specified to avoid warning. Loan recipients MUST take full load of courses offered.')



select * from FinancialAid

insert into Review values(14, 3, 3, 'avg')
insert into Review values(15, 3, 3, 'good')
insert into Review values(16, 3, 3, 'labs farig heen')
insert into Review values(14, 4, 3, 'v good')
insert into Review values(15, 4, 3, 'bht aala')
insert into Review values(18, 4, 3, 'mazedar uni')
insert into Review values(18, 5, 3, 'giki bht door he')
insert into Review values(15, 5, 3, 'giki giki he')
insert into Review values(18, 5, 3, 'mazedar uni giki')
insert into Review values(19, 6, 3, 'mazedar uni nust')

select * from Review

SELECT * FROM [User]
SELECT * FROM [Student]
SELECT * FROM [Graduate]
SELECT * FROM [Undergraduate]

SELECT * FROM [User]
select * from [University]

exec delete_Account '9'
exec getUser '3'