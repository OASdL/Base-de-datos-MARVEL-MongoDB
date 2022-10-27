use Marvel_Characters;
SET SQL_SAFE_UPDATES = 0;
drop database if exists Marvel_Characters;
create database if not exists Marvel_Characters;

drop table if exists Temporal;
CREATE TABLE IF NOT EXISTS Temporal (
	info text,
    charname text NOT NULL,
    birthname text NOT NULL,
    category text NOT NULL,
    universes text NOT NULL,
    birthplace text,
    superpowers text NOT NULL,
    religions text,
    gender text,
    occupation text,
    teams text
);

load data infile 'C:/Program Files/MySQL/dataset/Marvel Characters.csv' into table Temporal fields terminated by ',' ENCLOSED BY ';' lines terminated by '\n';
 select * from Temporal;

drop table if exists Characters;
CREATE TABLE IF NOT EXISTS Characters (
	IdCharacter INT AUTO_INCREMENT,
    charname VARCHAR(25) NOT NULL,
    birthname VARCHAR(74) NOT NULL,
    birthplace VARCHAR(15),
    religions VARCHAR(11),
    gender VARCHAR(6),
    primary key PK_IdCharacter (IdCharacter)
);
 insert into Characters(charname, birthname, birthplace, religions, gender) select charname, birthname, birthplace, religions, gender from Temporal ;
 select * from Characters;
 
#////////////////////////////////////////////////////////////////////////////////////// 

DROP TABLE IF EXISTS Superpowers;
CREATE TABLE IF NOT EXISTS Superpowers(
	IdSuperpower INT AUTO_INCREMENT,
    nameSuperpower varchar(30) NOT NULL,
    description varchar(150),
    PRIMARY KEY PK_IdSuperpower (IdSuperpower)
);
delimiter $$
drop procedure if exists pcd_AddSuperpowers $$
create procedure pcd_AddSuperpowers()
begin
	insert into Superpowers(nameSuperpower, description) select distinctrow substring_index(superpowers,",",1), "" from Temporal where superpowers != '';
    insert into Superpowers(nameSuperpower, description) select distinctrow substring_index(substring_index(superpowers,",",2),",",-1), "" from Temporal where superpowers != '';
    insert into Superpowers(nameSuperpower, description) select distinctrow substring_index(substring_index(superpowers,",",3),",",-1), "" from Temporal where superpowers != '';
    insert into Superpowers(nameSuperpower, description) select distinctrow substring_index(substring_index(superpowers,",",4),",",-1), "" from Temporal where superpowers != '';
    insert into Superpowers(nameSuperpower, description) select distinctrow substring_index(substring_index(superpowers,",",5),",",-1), "" from Temporal where superpowers != '';
    insert into Superpowers(nameSuperpower, description) select distinctrow substring_index(substring_index(superpowers,",",6),",",-1), "" from Temporal where superpowers != '';
    UPDATE Superpowers set nameSuperpower = LTRIM(nameSuperpower);
    drop table if exists ss; drop table if exists Character_Power;
    create table if not exists ss like Superpowers;
	INSERT INTO ss SELECT * FROM Superpowers GROUP BY nameSuperpower; 
    DROP TABLE Superpowers;
	ALTER TABLE ss RENAME TO Superpowers;
end $$
delimiter ;
call pcd_AddSuperpowers();
select * from Superpowers;

#/////////////////////////////////////////////////////////////////////////////////////

Select distinct Characters.IdCharacter, Superpowers.IdSuperpower
From Characters, Superpowers, Temporal 
Where trim(Characters.charname) like trim(Temporal.charname) 
and trim(Temporal.superpowers) like CONCAT('%', Superpowers.nameSuperpower  ,'%');

#////////////////////////////////////////////////////////////////////////////////////// 

DROP TABLE IF EXISTS Categories;
CREATE TABLE IF NOT EXISTS Categories(
	IdCategory INT AUTO_INCREMENT,
    nameCategory varchar(25) NOT NULL,
    description varchar(150),
    PRIMARY KEY PK_IdCategory (IdCategory)
);
 insert into Categories(nameCategory, description) select distinctrow trim(substring_index(category,",",1)), "" from Temporal;
 select * from Categories;
 
#//////////////////////////////////////////////////////////////////////////////////////

DROP TABLE IF EXISTS Universes;
CREATE TABLE IF NOT EXISTS Universes(
	IdUniverse INT AUTO_INCREMENT,
    nameUniverse varchar(25) NOT NULL,
    PRIMARY KEY PK_IdUniverse (IdUniverse)
);
 insert into Universes(nameUniverse) select distinctrow trim(substring_index(universes,",",1)) from Temporal;
 select * from Universes;
 
#//////////////////////////////////////////////////////////////////////////////////////

#DROP TABLE IF EXISTS Teams;
CREATE TABLE IF NOT EXISTS Teams(
	IdTeam INT AUTO_INCREMENT,
    nameTeam varchar(25) not null,
    PRIMARY KEY PK_IdTeam (IdTeam)
);
delimiter $$
drop procedure if exists pcd_AddTeams $$
create procedure pcd_AddTeams()
begin
	insert into Teams(nameTeam) select distinctrow substring_index(teams,",",1) from Temporal where teams != '';
    insert into Teams(nameTeam) select distinctrow substring_index(substring_index(teams,",",2),",",-1) from Temporal where teams != '';
    insert into Teams(nameTeam) select distinctrow substring_index(substring_index(teams,",",-2),",",1) from Temporal where teams != '';
    insert into Teams(nameTeam) select distinctrow substring_index(teams,",",-1) from Temporal where teams != '';
    UPDATE Teams set nameTeam = LTRIM(nameTeam);
    drop table if exists tt; drop table if exists Character_Team;
    create table if not exists tt like Teams;
	INSERT INTO tt SELECT * FROM Teams where IdTeam GROUP BY nameTeam; 
    DROP TABLE Teams;
	ALTER TABLE tt RENAME TO Teams;
end $$
delimiter ;
call pcd_AddTeams();
select * from Teams;

#//////////////////////////////////////////////////////////////////////////////////////
 
#DROP TABLE IF EXISTS Activities;
CREATE TABLE IF NOT EXISTS Activities(
	IdOccupation INT AUTO_INCREMENT,
    nameOccupation varchar(25) NOT NULL,
    PRIMARY KEY PK_IdOccupation (IdOccupation)
);
 delimiter $$
drop procedure if exists pcd_AddActivities $$
create procedure pcd_AddActivities()
begin
	insert into Activities(nameOccupation) select distinctrow substring_index(occupation,",",1) from Temporal where occupation != '';
    insert into Activities(nameOccupation) select distinctrow substring_index(substring_index(occupation,",",2),",",-1) from Temporal where occupation != '';
    insert into Activities(nameOccupation) select distinctrow substring_index(substring_index(occupation,",",3),",",-1) from Temporal where occupation != '';
    insert into Activities(nameOccupation) select distinctrow substring_index(substring_index(occupation,",",4),",",-1) from Temporal where occupation != '';
    insert into Activities(nameOccupation) select distinctrow substring_index(substring_index(occupation,",",-3),",",1) from Temporal where occupation != '';
    insert into Activities(nameOccupation) select distinctrow substring_index(substring_index(occupation,",",-2),",",1) from Temporal where occupation != '';
    insert into Activities(nameOccupation) select distinctrow substring_index(occupation,",",-1) from Temporal where occupation != '';
    UPDATE Activities set nameOccupation = LTRIM(nameOccupation);
    drop table if exists tt; drop table if exists Character_Occupation;
    create table if not exists tt like Activities;
	INSERT INTO tt SELECT * FROM Activities GROUP BY nameOccupation; 
    DROP TABLE Activities;
	ALTER TABLE tt RENAME TO Activities;
end $$
delimiter ;
call pcd_AddActivities();
select * from Activities;

/*//////////////////////////////////////////////////////////////////////*/
/*//////////////////////////////////////////////////////////////////////*/
/*//////////////////////////////////////////////////////////////////////*/

DROP TABLE IF EXISTS Character_Power;
CREATE TABLE IF NOT EXISTS Character_Power(
	IdCharacter INT NOT NULL,
    IdSuperpower INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter)
        ON DELETE CASCADE,
		FOREIGN KEY (IdSuperpower)
        REFERENCES Superpowers(IdSuperpower)
        ON DELETE CASCADE
);
insert into Character_Power Select distinct Characters.IdCharacter, Superpowers.IdSuperpower
From Characters, Superpowers, Temporal 
Where trim(Characters.charname) like trim(Temporal.charname) 
and trim(Temporal.superpowers) like CONCAT('%', Superpowers.nameSuperpower  ,'%');
select * from Character_Power;

#//////////////////////////////////////////////////////////////////////////////////////
 
DROP TABLE IF EXISTS Character_Category;
CREATE TABLE IF NOT EXISTS Character_Category(
	IdCharacter INT NOT NULL,
    IdCategory INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter)
        ON DELETE CASCADE,
		FOREIGN KEY (IdCategory)
        REFERENCES Categories(IdCategory)
        ON DELETE CASCADE
);
insert into Character_Category Select distinct Characters.IdCharacter, Categories.IdCategory
From Characters, Categories, Temporal 
Where trim(Characters.charname) like trim(Temporal.charname) 
and trim(Temporal.category) like CONCAT('%', Categories.nameCategory  ,'%');
select * from Character_Category;

#//////////////////////////////////////////////////////////////////////////////////////
 
DROP TABLE IF EXISTS Character_Universe;
CREATE TABLE IF NOT EXISTS Character_Universe(
	IdCharacter INT NOT NULL,
    IdUniverse INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter)
        ON DELETE CASCADE,
		FOREIGN KEY (IdUniverse)
        REFERENCES Universes(IdUniverse)
        ON DELETE CASCADE
);
insert into Character_Universe Select distinct Characters.IdCharacter, Universes.IdUniverse
From Characters, Universes, Temporal 
Where trim(Characters.charname) like trim(Temporal.charname) 
and trim(Temporal.universes) like CONCAT('%', Universes.nameUniverse  ,'%');
select * from Character_Universe;

#//////////////////////////////////////////////////////////////////////////////////////
 
DROP TABLE IF EXISTS Character_Team;
CREATE TABLE IF NOT EXISTS Character_Team(
	IdCharacter INT NOT NULL,
    IdTeam INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter)
        ON DELETE CASCADE,
		FOREIGN KEY (IdTeam)
        REFERENCES Teams(IdTeam)
        ON DELETE CASCADE
);
insert into Character_Team Select distinct Characters.IdCharacter, Teams.IdTeam
From Characters, Teams, Temporal 
Where trim(Characters.charname) like trim(Temporal.charname) 
and trim(Temporal.teams) like CONCAT('%', Teams.nameTeam  ,'%');
select * from Character_Team;

#//////////////////////////////////////////////////////////////////////////////////////
 
DROP TABLE IF EXISTS Character_Occupation;
CREATE TABLE IF NOT EXISTS Character_Occupation(
	IdCharacter INT NOT NULL,
    IdOccupation INT NOT NULL,
		FOREIGN KEY (IdCharacter)
        REFERENCES Characters(IdCharacter)
        ON DELETE CASCADE,
		FOREIGN KEY (IdOccupation)
        REFERENCES Activities(IdOccupation)
        ON DELETE CASCADE
);
insert into Character_Occupation Select distinct Characters.IdCharacter, Activities.IdOccupation
From Characters, Activities, Temporal 
Where trim(Characters.charname) like trim(Temporal.charname) 
and trim(Temporal.occupation) like CONCAT('%', Activities.nameOccupation  ,'%');
select * from Character_Occupation;

/*//////////////////////////////////////////////////////////////////////*/
/*//////////////////////////////////////////////////////////////////////*/
/*//////////////////////////////////////////////////////////////////////*/

/*PROCEDIMINETO ALMACENADO PARA GUARDAR*/
# PENDIENTE A TERMINAR POR COMPLICACIONES CON LOS DATOS :(

/*PROCEDIMIENTO ALMACENADO PARA LIMPIAR*/
delimiter $$
drop procedure if exists pcd_CleanDatabase$$
create procedure pcd_CleanDatabase()
begin
	delete from Character_Occupation;
    delete from Character_Team;
    delete from Character_Universe;
    delete from Character_Category;
    delete from Character_Power;
    delete from Activities;
    delete from Teams;
    delete from Universes;
    delete from Categories;
    delete from Superpowers;
    delete from Characters;
    delete from Temporal;
end $$
delimiter ;
call pcd_CleanDatabase();

/*//////////////////////////////////////////////////////////////////////*/
/*//////////////////////////////////////////////////////////////////////*/
/*//////////////////////////////////////////////////////////////////////*/

/*CONSULTAS DE DATOS*/

/*Mostrar todos los datos*/
select * from Temporal;

/*Mostrar todos los personajes que son mutantes (mutate)*/
select Characters.charname, Categories.nameCategory from Characters,Categories,Character_Category where (Categories.IdCategory = Character_Category.IdCategory) and (Characters.IdCharacter = Character_Category.IdCharacter) and Categories.nameCategory = 'mutate';

/*Mostrar todos los personajes de Marvel Universe*/
select Characters.charname, Universes.nameUniverse from Characters,Universes,Character_Universe where (Universes.IdUniverse = Character_Universe.IdUniverse) and (Characters.IdCharacter = Character_Universe.IdCharacter) and Universes.nameUniverse = 'Marvel Universe';

/*Listar todos los Universos*/
select * from Universes;

/*Listar todos los personajes que tengan el super poder teleportation*/
select Characters.charname, Superpowers.nameSuperpower from Characters,Superpowers,Character_Power where (Superpowers.IdSuperpower = Character_Power.IdSuperpower) and (Characters.IdCharacter = Character_Power.IdCharacter) and Superpowers.nameSuperpower = 'teleportation';

/*Listar todos los personajes que tengan la ocupación de detective*/
select Characters.charname, Activities.nameOccupation from Characters,Activities,Character_Occupation where (Activities.IdOccupation = Character_Occupation.IdOccupation) and (Characters.IdCharacter = Character_Occupation.IdCharacter) and Activities.nameOccupation = 'detective';

/*Listar todos los personajes que sean del Universo Earth-616 y que tengan el super poder retrocognition*/
select Characters.charname, Universes.nameUniverse, Superpowers.nameSuperpower from Characters,Universes,Superpowers,Character_Universe,Character_Power where (Universes.IdUniverse = Character_Universe.IdUniverse) and (Characters.IdCharacter = Character_Universe.IdCharacter) and Universes.nameUniverse = 'Earth-616' and (Superpowers.IdSuperpower = Character_Power.IdSuperpower) and (Characters.IdCharacter = Character_Power.IdCharacter) and Superpowers.nameSuperpower = 'retrocognition';

/*Listar los personajes que tienen religion Catholicism y que son de tipo animated character*/
select Characters.charname, Characters.religions, Categories.nameCategory from Characters,Categories,Character_Category where (Categories.IdCategory = Character_Category.IdCategory) and (Characters.IdCharacter = Character_Category.IdCharacter) and Characters.religions = 'Catholicism' and Categories.nameCategory = 'animated character';

/*//////////////////////////////////////////////////////////////////////*/
/*//////////////////////////////////////////////////////////////////////*/
/*//////////////////////////////////////////////////////////////////////*/

/*EXPORTAR A MONGODB*/
drop table if exists db;
CREATE TABLE IF NOT EXISTS db(
	IdCharacter INT NOT NULL,
	Charname TEXT NOT NULL,
	Birthname TEXT NOT NULL,
	Birthplace TEXT,
	Religion TEXT,
	Gender TEXT,
	Superpowers TEXT NOT NULL,
	Categories TEXT NOT NULL,
	Universes TEXT NOT NULL,
	Teams TEXT NOT NULL,
	Occupation TEXT NOT NULL
);
insert into db select distinctrow 
	Characters.IdCharacter, Characters.charname, Characters.birthname, Characters.birthplace, Characters.religions, Characters.gender,
	Temporal.superpowers, Temporal.category, 
    Temporal.occupation, Temporal.universes, 
    Temporal.teams
	from Characters,Temporal
	where Characters.charname = Temporal.charname;
select * from db;

select * into outfile 'C:/ProgramData/MySQL/dataMongo/Characters.csv' FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' 
from db;