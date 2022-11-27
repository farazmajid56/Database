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
	firstName varchar(255) NOT NULL,
	lastName varchar(255) NOT NULL,
	location varchar(255) NOT NULL,
	latitude decimal NOT NULL,
	longitude decimal NOT NULL,
	isAdmin integer NOT NULL DEFAULT '0',
	isDisabled integer NOT NULL DEFAULT '0',
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
	admissionFee int NOT NULL
)
GO


ALTER TABLE [University] WITH CHECK ADD CONSTRAINT [University_fk0] FOREIGN KEY ([idUniversity]) REFERENCES [User]([idUser])
ON UPDATE CASCADE on delete cascade

           -- -------------------------   Must execute these lines below ------------------
alter table [User] drop column firstName
alter table [User] drop column lastName
alter table [User] drop column location
alter table [User] drop column latitude
alter table [User] drop column longitude

alter table Student add firstName varchar(100) not null
alter table Student add lastName varchar(100) not null


alter table University add location varchar(255) not null
alter table University add latitude decimal not null
alter table University add longitude decimal not null

           --------------------------------------------------------------------------------

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
create procedure signup_Check
@uid integer,
@username varchar(30),
@email varchar(100),
@password varchar(255),
@firstname varchar(255),
@lastaname varchar(255),
@location varchar(255),
@latitude decimal,
@longitude decimal,
@type varchar(1),
@success int output
as
begin
		--CHECK NEW USER TYPE AND ADD ACCORDINGLY
		if NOT exists (select * from [User] where  [User].email = @email)
			begin
				--Checkig if Student
				if (@type = 'S')
					begin 
						insert into [User]
						VALUES (@uid,@username,@email,@password,@firstname,@lastaname,@location,@latitude,@longitude,0,0)
					end
				--Checkig if University
				if (@type = 'U')
					begin 
						insert into [User]
						VALUES (@uid,@username,@email,@password,@firstname,@lastaname,@location,@latitude,@longitude,0,0)
						print 'User Inserted'
					end
				set @success = 1
				print 'User Inserted'
			end
		else
			begin
			set @success = 0
			print 'User Already Exists'	
			end
end
go


-- Sign Up Test --
go
declare @message int
EXECUTE signup_Check
@uid = 1,
@username = 'farazmajid',
@email = 'farazmajid56@gmail.com',
@password = '123456',
@firstname = 'faraz',
@lastaname = 'majid',
@location = 'lahore',
@latitude = 123.45,
@longitude = 456.77,
@type = 'student',
@success = @message
SELECT * FROM [User]
go


-- Log In Test --
go
declare @message int
declare @Utype varchar(45)
EXECUTE login_Check
@email = 'farazmajid56@gmail.com',
@password = '123456',
@type = @Utype,
@isSuccess = @message
--select @message
--select @Utype
go

go
insert into [User]
VALUES (2,'root','root@unigrab.com','123456','root','abcd','system','0.0','0.0',1,0)
go


--PROCEDURES FOR Use Case 13 Manage Account--

DROP PROCEDURE IF EXISTS enable_Account
GO
CREATE PROCEDURE enable_Account
@uid int,
@isSuccess int output
AS
BEGIN
	IF EXISTS(SELECT * FROM [User] WHERE @uid = idUser)
		BEGIN
			UPDATE	[User]
			SET		isDisabled = 0
			WHERE	idUser = @uid

			SET @isSuccess = 1
			PRINT 'Account Enabled'
		END	
	ELSE
		BEGIN
			SET @isSuccess = 0
			PRINT 'Record not found'
		END
END
GO


DROP PROCEDURE IF EXISTS disable_Account
GO
CREATE PROCEDURE disable_Account
@uid int,
@isSuccess int output
AS
BEGIN
	IF EXISTS(SELECT * FROM [User] WHERE @uid = idUser)
		BEGIN
			UPDATE	[User]
			SET		isDisabled = 1
			WHERE	idUser = @uid
			SET @isSuccess = 1
			PRINT 'Account Disabled'
		END	
	ELSE
		BEGIN
			SET @isSuccess = 0
			PRINT 'Record not found'
		END
END
GO


DROP PROCEDURE IF EXISTS delete_Account
GO
create procedure delete_Account
@uid int,
@isSuccess int output
AS
BEGIN
	DECLARE @type varchar(1)
		IF EXISTS(SELECT * FROM [User] WHERE @uid = idUser)
			BEGIN
				SET @isSuccess = 1
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
						PRINT 'Deleted from Table STUDENT'
					END
				ELSE IF (@type = 'U')
					BEGIN
						DELETE FROM [University] WHERE idUniversity = @uid
						PRINT 'Deleted from Table UNIVERSITY'
					END

			END
		ELSE
			BEGIN
				SET @isSuccess = 0
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
				if not exists(select * from [Graduate] where [Graduate].idGraduate=@uid)
					begin
						SELECT * 
						FROM [User] join [Student] on idUser=idStudent
						WHERE idUser= @uid
						Print 'User is Graduate'
					end
				else 
					begin
						SELECT * 
						FROM [User] join [Student] on idUser=idStudent join [Graduate] on idStudent=idGraduate
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

exec viewStudentProfile '5'




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

exec viewUniProfile '6'

-- test enable_Account
GO
DECLARE @success int
EXECUTE enable_Account
@uid = 1,
@isSuccess = @success
SELECT * FROM [User]
GO

-- test disable_Account
GO
DECLARE @success int
EXECUTE disable_Account
@uid = 1,
@isSuccess = @success
--SELECT * FROM [User]
GO

-- test delete_Account
GO
DECLARE @success int
EXECUTE delete_Account
@uid = 1,
@isSuccess = @success
SELECT * FROM [User]
GO

SELECT * FROM [Student]

insert into [User]
VALUES (1,'faraz','farazz@unigrab.com','123456','faraz','majid','lahore','0.0','0.0',0,0)
insert into [Student]
VALUES (1,'A Levels',85.70,'2001-2-17','IT')

SELECT  
    SERVERPROPERTY('productversion') as 'Product Version', 
    SERVERPROPERTY('productlevel') as 'Product Level',  
    SERVERPROPERTY('edition') as 'Product Edition',
    SERVERPROPERTY('buildclrversion') as 'CLR Version',
    SERVERPROPERTY('collation') as 'Default Collation',
    SERVERPROPERTY('instancename') as 'Instance',
    SERVERPROPERTY('lcid') as 'LCID',
    SERVERPROPERTY('servername') as 'Server Name'

GO
create procedure getAllUsers
AS
BEGIN
	SELECT * 
	FROM [User]
END
GO

GO
create procedure getUser
@uid int
AS
BEGIN
	SELECT * 
	FROM [User]
	WHERE idUser = @uid
END
GO