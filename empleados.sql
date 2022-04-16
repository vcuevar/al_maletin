

CREATE TABLE `empleados` (

      `EMP_USER_Id` VARCHAR(7) NOT NULL COLLATE 'utf8_general_ci',

      `EMP_Nombre` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_PrimerApellido` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_SegundoApellido` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_Clave` VARCHAR(100) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',

      `EMP_Permiso` VARCHAR(5) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',

      `EMP_Calle` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_NoExterior` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_NoInterior` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_Colonia` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_CIU_CiudadId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_EST_EstadoId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_PAI_PaisId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_CodigoPostal` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_TelefonoCasa` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_CorreoElectronico` VARCHAR(150) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_FechaNacimiento` DATETIME NULL DEFAULT NULL,

      `EMP_NSS` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_ContactoEmergencias` VARCHAR(200) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_TelefonoContacto` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_RelacionContacto` VARCHAR(30) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_TelefonoOficina` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_ExtensionOficina` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_TelefonoCelular` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_RegistradoPor` VARCHAR(7) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_Activo` BIT(1) NOT NULL,

      `EMP_FechaIngreso` DATETIME NULL DEFAULT NULL,

      `EMP_FechaRegistro` DATETIME NULL DEFAULT NULL,

      `EMP_FechaUltimaModificacion` DATETIME NULL DEFAULT NULL,

      `EMP_ModificadoPor` VARCHAR(7) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_Fotografia` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_FechaEgreso` DATETIME NULL DEFAULT NULL,

      `EMP_RFC` VARCHAR(15) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_CURP` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_Comentarios` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_Eliminado` BIT(1) NOT NULL,

      `EMP_CMM_EstadoCivilId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_CMM_PuestoId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_CMM_TurnoId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_CMM_TipoEmpleadoId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_CMM_TasaPagoId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_CMM_CalifHabilidadesId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_CMM_TipoSanguineoId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_SueldoBase` DECIMAL(28,10) NULL DEFAULT NULL,

      `EMP_CMM_SexoId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_CMM_DeptoId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_CMM_LineaProduccionId` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',

      `EMP_PresupuestoAutorizado` DECIMAL(28,10) NULL DEFAULT NULL,

      `EMP_FechaRevision` DATETIME NULL DEFAULT NULL,

      PRIMARY KEY (`EMP_USER_Id`) USING BTREE

)

COLLATE='latin1_swedish_ci'

ENGINE=INNODB;