ALTER TABLE dbo.Datos_Personas
ADD Genero VARCHAR(10);
select * from Datos_Personas;
update Datos_Personas set Genero ='Masculino' where IdPersona=1;
update Datos_Personas set Genero ='Masculino' where IdPersona=4;
update Datos_Personas set Genero ='Masculino' where IdPersona=3;
update Datos_Personas set Genero ='Femenino' where IdPersona=2;