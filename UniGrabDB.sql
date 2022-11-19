use master
-- go
-- drop  database UniGrab
-- go 
create database UniGrab
go 
use UniGrab

CREATE TABLE [Student] (
	idStudent integer NOT NULL,
	firstName varchar(255) NOT NULL,
	latName varchar(255) NOT NULL,
	educationType varchar(255) NOT NULL,
	equivalence decimal NOT NULL,
	DOB date NOT NULL,
	subjectCombo varchar(255) NOT NULL,
  CONSTRAINT [PK_STUDENT] PRIMARY KEY CLUSTERED
  (
  [idStudent] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
CREATE TABLE [University] (
    name varchar(255) NOT NULL,
	phone varchar(11) NOT NULL,
	idUniversity int NOT NULL,
	ranking int NOT NULL,
	campusLife varchar(1000) NOT NULL,
	--
	name varchar(100) NOT NULL,
  CONSTRAINT [PK_UNIVERSITY] PRIMARY KEY CLUSTERED
  (
  [idUniversity] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [User] (
	idUser integer NOT NULL,
	userName varchar(30) NOT NULL,
	email varchar(100) NOT NULL,
	password varchar(255) NOT NULL,
	location varchar(255) NOT NULL,
	latitude decimal NOT NULL,
	longitude decimal NOT NULL,
	isAdmin integer NOT NULL DEFAULT '0',
	isDisabled integer NOT NULL DEFAULT '0',
  CONSTRAINT [PK_USER] PRIMARY KEY CLUSTERED
  (
  [idUser] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Graduate] (
	idGraduate integer NOT NULL,
	CGPA float NOT NULL,
  CONSTRAINT [PK_GRADUATE] PRIMARY KEY CLUSTERED
  (
  [idGraduate] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Review] (
	idReview integer NOT NULL,
	idStudent integer NOT NULL,
	idUniversity integer NOT NULL,
	stars integer NOT NULL,
	review varchar(500) NOT NULL,
  CONSTRAINT [PK_REVIEW] PRIMARY KEY CLUSTERED
  (
  [idReview] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Post] (
	idPost integer NOT NULL,
	idUniversity integer NOT NULL,
	type varchar(255) NOT NULL,
  CONSTRAINT [PK_POST] PRIMARY KEY CLUSTERED
  (
  [idPost] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [text] (
	idText integer NOT NULL,
	description varchar(500) NOT NULL,
  CONSTRAINT [PK_TEXT] PRIMARY KEY CLUSTERED
  (
  [idText] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Image] (
	idText integer NOT NULL,
	description varchar(500) NOT NULL,
	imagePath varchar(500) NOT NULL,
  CONSTRAINT [PK_IMAGE] PRIMARY KEY CLUSTERED
  (
  [idText] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Video] (
	idText integer NOT NULL,
	description varchar(500) NOT NULL,
	videoPath varchar(500) NOT NULL,
  CONSTRAINT [PK_VIDEO] PRIMARY KEY CLUSTERED
  (
  [idText] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)

GO
CREATE TABLE [Department] (
	idDepartment int NOT NULL,
	idUniversity int NOT NULL,
	name varchar(45) NOT NULL,
  CONSTRAINT [PK_DEPARTMENT] PRIMARY KEY CLUSTERED
  (
  [idDepartment] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Program] (
	idProgram int NOT NULL,
	idDepartment int NOT NULL,
	name varchar(45) NOT NULL,
	creditHours int NOT NULL,
	feePerCreditHour int NOT NULL,
	admissionFee int NOT NULL,
	--
	subjectCombo VARCHAR(100) NOT NULL,
  CONSTRAINT [PK_PROGRAM] PRIMARY KEY CLUSTERED
  (
  [idProgram] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Faculty] (
	idFaculty int NOT NULL,
	idUniversity int NOT NULL,
	idDepartment int NOT NULL,
	firstName varchar(45) NOT NULL,
	lastName varchar(45) NOT NULL,
	email varchar(45) NOT NULL,
	designantion varchar(45) NOT NULL,
  CONSTRAINT [PK_FACULTY] PRIMARY KEY CLUSTERED
  (
  [idFaculty] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [GraduateProgram] (
	idGProgram int NOT NULL,
	minCGPA float NOT NULL
)
GO
CREATE TABLE [UndergraduateProgram] (
	idUGProgram int NOT NULL,
	minMarks int NOT NULL
)
GO

ALTER TABLE [Department] WITH CHECK ADD CONSTRAINT [Department_fk0] FOREIGN KEY ([idUniversity]) REFERENCES [University]([idUniversity])
ON UPDATE CASCADE
GO
ALTER TABLE [Department] CHECK CONSTRAINT [Department_fk0]
GO

ALTER TABLE [Program] WITH CHECK ADD CONSTRAINT [Program_fk0] FOREIGN KEY ([idDepartment]) REFERENCES [Department]([idDepartment])
ON UPDATE CASCADE
GO
ALTER TABLE [Program] CHECK CONSTRAINT [Program_fk0]
GO

ALTER TABLE [Faculty] WITH CHECK ADD CONSTRAINT [Faculty_fk0] FOREIGN KEY ([idUniversity]) REFERENCES [University]([idUniversity])
ON UPDATE CASCADE
GO
ALTER TABLE [Faculty] CHECK CONSTRAINT [Faculty_fk0]
GO
ALTER TABLE [Faculty] WITH CHECK ADD CONSTRAINT [Faculty_fk1] FOREIGN KEY ([idDepartment]) REFERENCES [Department]([idDepartment])
--ON UPDATE CASCADE
GO
ALTER TABLE [Faculty] CHECK CONSTRAINT [Faculty_fk1]
GO

ALTER TABLE [GraduateProgram] WITH CHECK ADD CONSTRAINT [GraduateProgram_fk0] FOREIGN KEY ([idGProgram]) REFERENCES [Program]([idProgram])
ON UPDATE CASCADE
GO
ALTER TABLE [GraduateProgram] CHECK CONSTRAINT [GraduateProgram_fk0]
GO

ALTER TABLE [UndergraduateProgram] WITH CHECK ADD CONSTRAINT [UndergraduateProgram_fk0] FOREIGN KEY ([idUGProgram]) REFERENCES [Program]([idProgram])
ON UPDATE CASCADE
GO
ALTER TABLE [UndergraduateProgram] CHECK CONSTRAINT [UndergraduateProgram_fk0]
GO

GO
ALTER TABLE [Student] WITH CHECK ADD CONSTRAINT [Student_fk0] FOREIGN KEY ([idStudent]) REFERENCES [User]([idUser])
ON UPDATE CASCADE
GO
ALTER TABLE [Student] CHECK CONSTRAINT [Student_fk0]
GO

ALTER TABLE [University] WITH CHECK ADD CONSTRAINT [University_fk0] FOREIGN KEY ([idUniversity]) REFERENCES [User]([idUser])
GO
ALTER TABLE [University] CHECK CONSTRAINT [University_fk0]
GO


ALTER TABLE [Graduate] WITH CHECK ADD CONSTRAINT [Graduate_fk0] FOREIGN KEY ([idGraduate]) REFERENCES [Student]([idStudent])
ON UPDATE CASCADE
GO
ALTER TABLE [Graduate] CHECK CONSTRAINT [Graduate_fk0]
GO

ALTER TABLE [Review] WITH CHECK ADD CONSTRAINT [Review_fk0] FOREIGN KEY ([idStudent]) REFERENCES [Student]([idStudent])
ON UPDATE CASCADE
GO
ALTER TABLE [Review] CHECK CONSTRAINT [Review_fk0]
GO

ALTER TABLE [Review] WITH CHECK ADD CONSTRAINT [Review_fk1] FOREIGN KEY ([idUniversity]) REFERENCES [University]([idUniversity])
ON UPDATE CASCADE
GO
ALTER TABLE [Review] CHECK CONSTRAINT [Review_fk1]
GO

ALTER TABLE [Post] WITH CHECK ADD CONSTRAINT [Post_fk0] FOREIGN KEY ([idPost]) REFERENCES [University]([idUniversity])
ON UPDATE CASCADE
GO
ALTER TABLE [Post] CHECK CONSTRAINT [Post_fk0]
GO

ALTER TABLE [text] WITH CHECK ADD CONSTRAINT [text_fk0] FOREIGN KEY ([idText]) REFERENCES [Post]([idPost])
ON UPDATE CASCADE
GO
ALTER TABLE [text] CHECK CONSTRAINT [text_fk0]
GO

ALTER TABLE [Image] WITH CHECK ADD CONSTRAINT [Image_fk0] FOREIGN KEY ([idText]) REFERENCES [Post]([idPost])
ON UPDATE CASCADE
GO
ALTER TABLE [Image] CHECK CONSTRAINT [Image_fk0]
GO

ALTER TABLE [Video] WITH CHECK ADD CONSTRAINT [Video_fk0] FOREIGN KEY ([idText]) REFERENCES [Post]([idPost])
ON UPDATE CASCADE
GO
ALTER TABLE [Video] CHECK CONSTRAINT [Video_fk0]
GO

--PROCEDURE FOR Use Case 2--
--drop procedure Login_Check
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
--drop procedure Signup_Check
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

go
insert into [User]
VALUES (2,'aemon','aemon@unigrab.com','123456','aemon','fatima','user','0.0','0.0',0,0)
go

--PROCEDURES FOR Use Case 13 Manage Account--
--drop procedure enable_Account
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

--drop procedure disable_Account
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

--drop procedure delete_Account
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
SELECT * FROM [User]
GO

-- test delete_Account
GO
DECLARE @success int
EXECUTE delete_Account
@uid = 1,
@isSuccess = @success
SELECT * FROM [User]
GO

create procedure viewStudentProfile
@uid integer,
@firstname varchar(255),
@lastname varchar(255),
@location varchar(255),
@latitude decimal,
@longitude decimal,
@DOB date,
@equivalence decimal,
@subjectCombo varchar(255),
@success int output

as 
begin
if exists (select * from [User] where  [User].idUser = @uid)
    begin

     select @firstname=firstName,@lastname=latName,@location=location,@latitude=latitude,@longitude=longitude from [User] where [User].idUser=@uid
    
  if exists(select * from [Student] where [Student].idStudent=@uid)
      begin

   select @DOB=DOB,@subjectCombo=subjectCombo,@equivalence=equivalence from [Student] where [Student].idStudent=@uid
        set @success=1
		end
else 
   begin
    Print 'User is not Student it is University'
    end
	end
else
   begin
     Print 'User not Found'
	 end
	 end

-----usecase 9------
create procedure viewStudentProfile
@uid int, 
@success int output,
@firstname varchar(255) output ,
@lastName varchar(255) output,
@location varchar(255) output,
@latitude decimal output,
@longitude decimal output ,
@equivalence decimal output,
@DOB date output,
@subjectCombo varchar(255) output,
@cgpa float output
as 
BEGIN
	if exists (select * from [User] where  [User].idUser = @uid)
	 begin
		if exists(select * from [Student] where [Student].idStudent=@uid)
			begin
				if not exists(select * from [Graduate] where [Graduate].idGraduate=@uid)
					begin
						select @firstname=firstName,@lastname=latName,@location=location,@latitude=latitude,@longitude=longitude, @DOB=DOB,@subjectCombo=subjectCombo,@equivalence=equivalence from [User] join [Student] on [User].idUser=[Student].idStudent
						set @success=1
						Print 'User is UnderGraduate'
					end
				else 
					begin
						select @firstname=firstName,@lastname=latName,@location=location,@latitude=latitude,@longitude=longitude, @DOB=DOB,@subjectCombo=subjectCombo,@equivalence=equivalence, @cgpa=CGPA from [User] join [Student] on [User].idUser=[Student].idStudent join [Graduate] on [Student].idStudent=[Graduate].idGraduate
						set @success=1
						Print 'User is Graduate'
					end
			end
		else
		BEGIN
			set @success=0
			Print 'User is not Student type'
		end
	 end
	else
		begin
			set @success=0 
			Print 'User not Found'
		end
END
	go
	declare @stat int,@firstnamee varchar,@lastnamee varchar, @loc varchar, @lat decimal,@long decimal,@equi decimal,@dateofb date,@subj varchar,@CumGPA float, @success int
	exec viewStudentProfile '1', @success=@stat ,@firstname=@firstnamee ,@lastName=@lastnamee,@location=@loc ,@latitude=@lat ,@longitude=@long,@equivalence=@equi,@DOB=@dateofb ,@subjectCombo=@subj ,@cgpa=@CumGPA
	select @success as Statuss
	go



	-------usecase 10--------
create procedure viewUniProfile
