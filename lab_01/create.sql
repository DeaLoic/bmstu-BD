DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA IF NOT EXISTS public;
CREATE TABLE IF NOT EXISTS Professors (
	IdProfessor INTEGER NOT NULL PRIMARY KEY,
	Login 	varchar(30) NOT NULL UNIQUE,
	Name 	varchar(20),
	Surname varchar(20),
	Age smallint CHECK (Age > 2)
);

CREATE TABLE IF NOT EXISTS Subjects (
	IdSubject INTEGER NOT NULL PRIMARY KEY,
	Name 	varchar(40) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS StudentGroups (
	IdStudentGroup 	INTEGER NOT NULL PRIMARY KEY,
	Name 		varchar(20) NOT NULL,
	EnrollAcademicSem 	smallInt NOT NULL
);

CREATE TABLE IF NOT EXISTS Students (
	IdStudent INTEGER NOT NULL PRIMARY KEY,
	IdStudentGroup INTEGER REFERENCES StudentGroups(IdStudentGroup),
	Login 	  varchar(20) NOT NULL UNIQUE,
	SName 	  varchar(20) CHECK (SName ~* '^[^0-9]+$'),
	Surname	  varchar(20),
	Age smallint CHECK (Age > 2)
);

CREATE TABLE IF NOT EXISTS SubjectInfos (
	IdSubjectInfo INTEGER NOT NULL PRIMARY KEY,
	IdSubject 	  INTEGER REFERENCES Subjects(IdSubject),
	AcademicSem	  smallint NOT NULL
);

CREATE TABLE IF NOT EXISTS Projects (
	IdProject INTEGER NOT NULL PRIMARY KEY,
	Name 	  varchar(50) NOT NULL,
	IsLab	  bool NOT NULL,
	IdSubjectInfo INTEGER REFERENCES SubjectInfos(IdSubjectInfo)
);

CREATE TABLE IF NOT EXISTS Repositories (
	IdRepository INTEGER NOT NULL PRIMARY KEY,
	Name 	  varchar(100) NOT NULL,
	IdProject INTEGER REFERENCES Projects(IdProject)
);

/* СВЯЗКИ */
CREATE TABLE IF NOT EXISTS ProfessorsSubjects (
	IdProfessor INTEGER REFERENCES Professors(IdProfessor) NOT NULL,
	IdSubject INTEGER REFERENCES Subjects(IdSubject) Not NULL
);

CREATE TABLE IF NOT EXISTS SubjectInfosStudentGroups (
	IdSubjectInfo INTEGER REFERENCES SubjectInfos(IdSubjectInfo) NOT NULL,
	IdStudentGroup INTEGER REFERENCES StudentGroups(IdStudentGroup) NOT NULL
);

CREATE TABLE IF NOT EXISTS StudentsRepositories (
	IdStudent    INTEGER REFERENCES Students(IdStudent) NOT NULL,
	IdRepository INTEGER REFERENCES Repositories(IdRepository) NOT NULL
);
