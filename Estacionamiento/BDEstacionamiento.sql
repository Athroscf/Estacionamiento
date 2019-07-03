/*
	Objetivo: Crear la base de datos Estacionamiento para el desarrollo del proyecto
			  del segundo parcial de la clase Programacion de Negocios.
	Autor: Christopher Fiallos y Norman Altamirano
	Fecha: 2/Julio/2019
*/

--Seleccionar la BD por defecto
USE tempdb
GO

--Crear la BD
IF NOT EXISTS(SELECT * FROM sys.databases WHERE [name]='Estacionamiento')
	BEGIN
		CREATE DATABASE Estacionamiento
	END
GO

--Seleccionar la BD Estacionamiento
USE Estacionamiento
GO

--Crear el esquema Vehiculos
CREATE SCHEMA Estacionamiento
GO

--Crear tabla TipoVehiculo
CREATE TABLE Estacionamiento.TipoVehiculo
(
	id INT IDENTITY(1, 1) NOT NULL
		CONSTRAINT PK_Vehiculo_TipoVehiculo_id
		PRIMARY KEY CLUSTERED (id),
	tipo NVARCHAR (30) NOT NULL
)
GO

CREATE TABLE Estacionamiento.Vehiculo
(
	id INT IDENTITY (1, 1) NOT NULL
		CONSTRAINT PK_Vehiculo_Estacionamiento_id
		PRIMARY KEY CLUSTERED (id),
	tipoVehiculo INT NOT NULL,
	placa NVARCHAR(8) NOT NULL
		CONSTRAINT UC_placa
		UNIQUE (placa),
		CONSTRAINT CHK_Formato_Placa_Vehiculo
		CHECK (placa LIKE '[A-Z][A-Z][A-Z]-[0-9][0-9][0-9][0-9]'),
	estado BIT NOT NULL
)
GO

CREATE TABLE Estacionamiento.PagoVehiculo
(
	id INT IDENTITY(1, 1) NOT NULL
		CONSTRAINT PK_Vehiculo_PagoVehiculo_id
		PRIMARY KEY CLUSTERED (id),
	vehiculo INT NOT NULL,
	fechaHoraEntrada DATETIME NOT NULL,
	fechaHoraSalida DATETIME NOT NULL,
	total DECIMAL NOT NULL
)
GO

ALTER TABLE Estacionamiento.Vehiculo
	ADD CONSTRAINT FK_Vehiculo$Tiene$TipoVehiculo
	FOREIGN KEY (tipoVehiculo) REFERENCES Estacionamiento.TipoVehiculo(id)
GO

ALTER TABLE Estacionamiento.PagoVehiculo
	ADD CONSTRAINT FK_PagoVehiculo$SeLeHaceAUn$Vehiculo
	FOREIGN KEY (vehiculo) REFERENCES Estacionamiento.Vehiculo(id)
GO

INSERT INTO Estacionamiento.TipoVehiculo (tipo)
VALUES ('Turismo'),
	   ('Pick-Up'),
	   ('Camioneta'),
	   ('Camion'),
	   ('Autobus'),
	   ('Rastra'),
	   ('Motocicleta')
