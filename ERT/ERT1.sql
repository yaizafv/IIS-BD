CREATE TABLE Degree
(
	de_code varchar(8) NOT NULL,    -- redundante ya que al ser pk no hace falta (es para garantizar que no sea null)
	de_name varchar(20) NOT NULL,    -- este not null no se deduce del modelo, proviene de la restricción indicada textualmente
	de_duration decimal(1,0),
    CONSTRAINT pk_degree PRIMARY KEY (de_code)  --el constraint se pone para detectar errores mas fácilmente
)

CREATE TABLE Module
(
	mod_code varchar(8) NOT NULL,
	mod_name varchar(20) NOT NULL,
	mod_academic_year decimal(1,0),
	mod_credits decimal(2,0),
	mod_type varchar(20) NOT NULL,  
    de_code varchar(8) NOT NULL,        --pk de degree
	CONSTRAINT PK_Module PRIMARY KEY (mod_code),
    CONSTRAINT uq_module_mod_name UNIQUE (mod_name),   --clave candidata
	CONSTRAINT ck_module_mod_type CHECK (mod_type IN ('elective', 'free elective', 'mandatory')),	
    -- Check (mod_type = 'mandatory' OR mod_type = 'elective' OR mod_tpe = 'free elective')
    CONSTRAINT FK_Module_Degree FOREIGN KEY(de_code) REFERENCES Degree(de_code)
)

CREATE TABLE Lecturer
(
	le_nif varchar(8) NOT NULL,
	le_name varchar(20) NOT NULL,
	le_surname varchar(20),
	le_address varchar(20),  
	CONSTRAINT PK_Lecturer PRIMARY KEY (le_nif)
)

CREATE TABLE Teaches
(
	mod_code varchar(8) NOT NULL,   -- tienen que ser exactamente del mismo tipo que las tablas originales
	le_nif varchar(8) NOT NULL,
	CONSTRAINT PK_Teaches PRIMARY KEY (mod_code, le_nif),    -- solo una clave primaria formada por los atributos que hagan falta
	CONSTRAINT FK_Teaches_Module FOREIGN KEY (mod_code) REFERENCES Module (mod_code),        --clave externa que verifica que lo que contiene mod_code este en Module
    CONSTRAINT FK_Teaches_Lecturer FOREIGN KEY (le_nif) REFERENCES Lecturer (le_nif)
)

CREATE TABLE Student
(
	st_nif varchar(8) NOT NULL,
	st_name varchar(20) NOT NULL,
	st_surname varchar(20),
	st_address varchar(20),
	date_of_birth date,
	admission_date date,
	CONSTRAINT PK_Student PRIMARY KEY (st_nif),
	CONSTRAINT CK_Student_admission_date CHECK (admission_date > date_of_birth)
)

CREATE TABLE Grades_M1
(
	st_nif varchar(8) NOT NULL,
	mod_code varchar(8) NOT NULL,
	le_nif varchar(8) NOT NULL,
	grade decimal(2,0),
	grading_date date,
	CONSTRAINT PK_Grades_M1 PRIMARY KEY (st_nif,mod_code),
	CONSTRAINT FK_Grades_M1_Student FOREIGN KEY (st_nif) 
          REFERENCES Student (st_nif),
	CONSTRAINT FK_Grades_M1_Module FOREIGN KEY (mod_code) 
          REFERENCES Module (mod_code),
	CONSTRAINT FK_Grades_M1_Lecturer FOREIGN KEY (le_nif) 
            REFERENCES Lecturer (le_nif)
)

CREATE TABLE Grades_M2
(
	st_nif varchar(8) NOT NULL,
	mod_code varchar(8) NOT NULL,
	le_nif varchar(8) NOT NULL,
	grade decimal(2,0),
	grading_date date,
	CONSTRAINT PK_Grades_M2 PRIMARY KEY (st_nif,mod_code,le_nif),
	CONSTRAINT FK_Grades_M2_Student FOREIGN KEY (st_nif) REFERENCES Student (st_nif),
	CONSTRAINT FK_Grades_M2_Teaches FOREIGN KEY (mod_code,le_nif) REFERENCES Teaches (mod_code,le_nif)
)



