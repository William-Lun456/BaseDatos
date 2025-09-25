create database mi_BaseDatos
use mi_BaseDatos
create table Datos_Personas(
	IdPersona int primary key identity(1,1),
	Nombre varchar(100),
	Apellidos varchar(100),
	Fecha date
);
Insert into Datos_Personas(Nombre,Apellidos,Fecha)
Values('William','Luna','08-16-2025');
Insert into Datos_Personas 
	values('Nataly','Ramos','08-16-2025'),
	('Mauricio','Condori','08-16-2025'),
	('Diego','Arce','08-16-2025');
Update Datos_Personas set Nombre='Jose',Apellidos='Roberto' where IdPersona=3;