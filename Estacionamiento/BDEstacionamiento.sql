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

--Crear el esquema Estacionamiento
CREATE SCHEMA Estacionamiento
GO

--Crear tabla TipoVehiculo
CREATE TABLE Estacionamiento.TipoVehiculo
(
	id INT IDENTITY(1, 1) NOT NULL UNIQUE,
		CONSTRAINT PK_Vehiculo_TipoVehiculo_id
		PRIMARY KEY CLUSTERED (id),
	tipo NVARCHAR (30) NOT NULL
)
GO

--Crear la tabla Vehiculo
CREATE TABLE Estacionamiento.Vehiculo
(
	id INT IDENTITY (1, 1) NOT NULL
		CONSTRAINT PK_Vehiculo_Estacionamiento_id
		PRIMARY KEY CLUSTERED (id),
	tipoVehiculo INT NOT NULL,
	placa NVARCHAR(8) NOT NULL UNIQUE,
		CONSTRAINT CHK_Formato_Placa_Vehiculo
		CHECK (placa LIKE '[A-Z][A-Z][A-Z]-[0-9][0-9][0-9][0-9]'),
	estado BIT NOT NULL
)
GO

--Crear la tabla PagoVehiculo
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

--Llaves Foraneas
ALTER TABLE Estacionamiento.Vehiculo
	ADD CONSTRAINT FK_Vehiculo$Tiene$TipoVehiculo
	FOREIGN KEY (tipoVehiculo) REFERENCES Estacionamiento.TipoVehiculo(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION
GO

ALTER TABLE Estacionamiento.PagoVehiculo
	ADD CONSTRAINT FK_PagoVehiculo$SeLeHaceAUn$Vehiculo
	FOREIGN KEY (vehiculo) REFERENCES Estacionamiento.Vehiculo(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION
GO

--Insercion de los tipos de vehiculos
INSERT INTO Estacionamiento.TipoVehiculo (tipo)
VALUES ('Turismo'),
	   ('Pick-Up'),
	   ('Camioneta'),
	   ('Camion'),
	   ('Autobus'),
	   ('Rastra'),
	   ('Motocicleta')
GO

--Stored Procedure que controla las entradas y salidas de los vehiculos en el estacionamiento
ALTER PROCEDURE spInsercionVehiculosEntradasSalidas
(
	@placa NVARCHAR(8),
	@tipoVehiculo NVARCHAR(15)
)
AS
	BEGIN TRY
		DECLARE @placaVehiculo INT
		DECLARE @horaEntrada DATETIME
		DECLARE @horaSalida DATETIME
		DECLARE @tipo INT
		
		SET @tipo = (SELECT id FROM Estacionamiento.TipoVehiculo WHERE tipo = @tipoVehiculo)

		IF NOT EXISTS(SELECT * FROM Estacionamiento.Vehiculo WHERE placa = @placa)
		BEGIN
			INSERT INTO Estacionamiento.Vehiculo (placa, tipoVehiculo, estado)
			VALUES (@placa, @tipo, 1)

			SET @placaVehiculo = (SELECT id FROM Estacionamiento.Vehiculo WHERE placa = @placa)

			INSERT INTO Estacionamiento.PagoVehiculo (vehiculo, fechaHoraEntrada, fechaHoraSalida, total)
			VALUES (@placaVehiculo, GETDATE(), GETDATE(), 0)
		END
		ELSE IF EXISTS(SELECT * FROM Estacionamiento.Vehiculo WHERE placa = @placa)
		BEGIN
			SET @placaVehiculo = (SELECT id FROM Estacionamiento.Vehiculo WHERE placa = @placa)

			IF (SELECT estado FROM Estacionamiento.Vehiculo WHERE placa = @placa) = 0
			BEGIN
				INSERT INTO Estacionamiento.PagoVehiculo (vehiculo, fechaHoraEntrada, fechaHoraSalida, total)
				VALUES (@placaVehiculo, GETDATE(), GETDATE(), 0)
				UPDATE Estacionamiento.Vehiculo SET estado = 1 WHERE placa = @placa
			END
			ELSE IF (SELECT estado FROM Estacionamiento.Vehiculo WHERE placa = @placa) = 1
			BEGIN
				UPDATE Estacionamiento.PagoVehiculo SET fechaHoraSalida = GETDATE() WHERE vehiculo = @placaVehiculo AND id = (SELECT MAX(id) 
																															  FROM Estacionamiento.PagoVehiculo
																															  WHERE vehiculo = @placaVehiculo)

				SET @horaEntrada = (SELECT MAX(fechaHoraEntrada) FROM Estacionamiento.PagoVehiculo WHERE vehiculo = @placaVehiculo)
				SET @horaSalida = (SELECT MAX(fechaHoraSalida) FROM Estacionamiento.PagoVehiculo WHERE vehiculo = @placaVehiculo)

				UPDATE Estacionamiento.Vehiculo SET estado = 0 WHERE placa = @placa
				UPDATE Estacionamiento.PagoVehiculo SET total = dbo.Fctn_CalculoPagoVehiculo(@horaEntrada, @horaSalida, @tipo) WHERE vehiculo = @placaVehiculo
																															   AND id = (SELECT MAX(id) 
																															   FROM Estacionamiento.PagoVehiculo
																															   WHERE vehiculo = @placaVehiculo)
			END
		END
		ELSE
		BEGIN
			PRINT('No hizo nada')
		END
	END TRY
	BEGIN CATCH
		DECLARE @error INT

		SET @error = @@ERROR

		RETURN @error
	END CATCH
GO

--Funcion que calculo el pago de los vehiculos que salen del estacionamiento
CREATE FUNCTION Fctn_CalculoPagoVehiculo
(
	@horaEntrada DATETIME,
	@horaSalida DATETIME,
	@tipoVehiculo INT
)
RETURNS DECIMAL  
WITH EXECUTE AS CALLER  
BEGIN
	DECLARE @total DECIMAL
	DECLARE @tiempo DECIMAL

	SET @tiempo = DATEDIFF(ss, @horaEntrada, @horaSalida)
	
	IF @tipoVehiculo > 0 AND @tipoVehiculo <= 3
	BEGIN
		IF @tiempo <= 3600
		BEGIN
			SET @total = 20
		END
		ELSE IF @tiempo > 3600 AND @tiempo <= 7200
		BEGIN
			SET @total = 30
		END
		ELSE IF @tiempo > 7200 AND @tiempo <= 14400
		BEGIN
			SET @total = (3 * 20) + 10
		END
		ELSE IF @tiempo > 14400
		BEGIN
			SET @total = @tiempo * 15
		END
	END
	ELSE IF @tipoVehiculo > 3 AND @tipoVehiculo <= 6
	BEGIN
		IF @tiempo <= 3600
		BEGIN
			SET @total = 40
		END
		ELSE IF @tiempo > 3600 AND @tiempo <= 7200
		BEGIN
			SET @total = 60
		END
		ELSE IF @tiempo > 7200 AND @tiempo <= 14400
		BEGIN
			SET @total = ((3 * 20) + 10) * 2
		END
		ELSE IF @tiempo > 14400
		BEGIN
			SET @total = (@tiempo * 15) * 2
		END
	END
	ELSE IF @tipoVehiculo = 7
	BEGIN
		IF @tiempo <= 3600
		BEGIN
			SET @total = 10
		END
		ELSE IF @tiempo > 3600 AND @tiempo <= 7200
		BEGIN
			SET @total = 15
		END
		ELSE IF @tiempo > 7200 AND @tiempo <= 14400
		BEGIN
			SET @total = ((3 * 20) + 10) / 2
		END
		ELSE IF @tiempo > 14400
		BEGIN
			SET @total = (@tiempo * 15) / 2
		END
	END
	RETURN @total
END
GO

