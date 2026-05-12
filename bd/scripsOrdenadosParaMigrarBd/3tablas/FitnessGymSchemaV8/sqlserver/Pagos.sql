-- =============================================
-- Tabla: Pagos
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.Pagos;

CREATE TABLE FitnessCenterDb.dbo.Pagos (
	PagoID int IDENTITY(1,1) NOT NULL,
	Monto decimal(10,2) NOT NULL,
	FechaPago datetime DEFAULT getdate() NULL,
	MetodoPago nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Estado nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__Pagos__F00B6158C2211D16 PRIMARY KEY (PagoID),
	CONSTRAINT FK_Pagos_AspNetUsers_NewUserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id)
);
ALTER TABLE FitnessCenterDb.dbo.Pagos WITH NOCHECK ADD CONSTRAINT CK__Pagos__MetodoPag__656C112C CHECK (([MetodoPago]='PayPal' OR [MetodoPago]='Efectivo' OR [MetodoPago]='SINPE' OR [MetodoPago]='Transferencia'));
ALTER TABLE FitnessCenterDb.dbo.Pagos WITH NOCHECK ADD CONSTRAINT CK__Pagos__Estado__66603565 CHECK (([Estado]='Fallido' OR [Estado]='Completado' OR [Estado]='Pendiente'));



GO
