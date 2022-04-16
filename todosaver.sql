-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.2.37-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Volcando estructura para tabla vmadb_kd.alumnos
CREATE TABLE IF NOT EXISTS `alumnos` (
  `EMP_AlumnoId` varchar(7) CHARACTER SET utf8 NOT NULL,
  `EMP_USER_Id` int(11) NOT NULL DEFAULT 0,
  `EMP_Nombre` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_PrimerApellido` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_SegundoApellido` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_Clave` varchar(100) DEFAULT NULL,
  `EMP_Permiso` varchar(5) DEFAULT NULL,
  `EMP_Calle` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_NoExterior` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_NoInterior` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_Colonia` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CIU_CiudadId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_EST_EstadoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_PAI_PaisId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CodigoPostal` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_TelefonoCasa` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CorreoElectronico` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_FechaNacimiento` datetime DEFAULT NULL,
  `EMP_NSS` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_ContactoEmergencias` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_TelefonoContacto` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_RelacionContacto` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_TelefonoOficina` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_ExtensionOficina` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_TelefonoCelular` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_RegistradoPor` varchar(7) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_Activo` bit(1) NOT NULL,
  `EMP_FechaIngreso` datetime DEFAULT NULL,
  `EMP_FechaRegistro` datetime DEFAULT NULL,
  `EMP_FechaUltimaModificacion` datetime DEFAULT NULL,
  `EMP_ModificadoPor` varchar(7) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_Fotografia` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_FechaEgreso` datetime DEFAULT NULL,
  `EMP_RFC` varchar(15) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CURP` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_Comentarios` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_Eliminado` bit(1) NOT NULL,
  `EMP_CMM_EstadoCivilId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_PuestoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_TurnoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_TipoAlumnoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_TipoSanguineoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_SexoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_FechaRevision` datetime DEFAULT NULL,
  PRIMARY KEY (`EMP_AlumnoId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- Volcando datos para la tabla vmadb_kd.alumnos: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `alumnos` DISABLE KEYS */;
/*!40000 ALTER TABLE `alumnos` ENABLE KEYS */;

-- Volcando estructura para tabla vmadb_kd.empleados
CREATE TABLE IF NOT EXISTS `empleados` (
  `EMP_EmpleadoId` int(11) NOT NULL AUTO_INCREMENT,
  `EMP_USER_Id` int(11) NOT NULL DEFAULT 0,
  `EMP_Nombre` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_PrimerApellido` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_SegundoApellido` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_Clave` varchar(100) DEFAULT NULL,
  `EMP_Permiso` varchar(5) DEFAULT NULL,
  `EMP_Calle` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_NoExterior` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_NoInterior` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_Colonia` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CIU_CiudadId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_EST_EstadoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_PAI_PaisId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CodigoPostal` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_TelefonoCasa` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CorreoElectronico` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_FechaNacimiento` datetime DEFAULT NULL,
  `EMP_NSS` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_ContactoEmergencias` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_TelefonoContacto` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_RelacionContacto` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_TelefonoOficina` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_ExtensionOficina` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_TelefonoCelular` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_RegistradoPor` varchar(7) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_Activo` bit(1) DEFAULT NULL,
  `EMP_FechaIngreso` datetime DEFAULT NULL,
  `EMP_FechaRegistro` datetime DEFAULT NULL,
  `EMP_FechaUltimaModificacion` datetime DEFAULT NULL,
  `EMP_ModificadoPor` varchar(7) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_Fotografia` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_FechaEgreso` datetime DEFAULT NULL,
  `EMP_RFC` varchar(15) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CURP` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_Comentarios` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_Eliminado` bit(1) DEFAULT NULL,
  `EMP_CMM_EstadoCivilId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_PuestoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_TurnoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_TipoEmpleadoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_TasaPagoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_CalifHabilidadesId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_TipoSanguineoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_SueldoBase` decimal(28,10) DEFAULT NULL,
  `EMP_CMM_SexoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_DeptoId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_CMM_LineaProduccionId` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `EMP_PresupuestoAutorizado` decimal(28,10) DEFAULT NULL,
  `EMP_FechaRevision` datetime DEFAULT NULL,
  PRIMARY KEY (`EMP_EmpleadoId`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla vmadb_kd.empleados: ~1 rows (aproximadamente)
/*!40000 ALTER TABLE `empleados` DISABLE KEYS */;
REPLACE INTO `empleados` (`EMP_EmpleadoId`, `EMP_USER_Id`, `EMP_Nombre`, `EMP_PrimerApellido`, `EMP_SegundoApellido`, `EMP_Clave`, `EMP_Permiso`, `EMP_Calle`, `EMP_NoExterior`, `EMP_NoInterior`, `EMP_Colonia`, `EMP_CIU_CiudadId`, `EMP_EST_EstadoId`, `EMP_PAI_PaisId`, `EMP_CodigoPostal`, `EMP_TelefonoCasa`, `EMP_CorreoElectronico`, `EMP_FechaNacimiento`, `EMP_NSS`, `EMP_ContactoEmergencias`, `EMP_TelefonoContacto`, `EMP_RelacionContacto`, `EMP_TelefonoOficina`, `EMP_ExtensionOficina`, `EMP_TelefonoCelular`, `EMP_RegistradoPor`, `EMP_Activo`, `EMP_FechaIngreso`, `EMP_FechaRegistro`, `EMP_FechaUltimaModificacion`, `EMP_ModificadoPor`, `EMP_Fotografia`, `EMP_FechaEgreso`, `EMP_RFC`, `EMP_CURP`, `EMP_Comentarios`, `EMP_Eliminado`, `EMP_CMM_EstadoCivilId`, `EMP_CMM_PuestoId`, `EMP_CMM_TurnoId`, `EMP_CMM_TipoEmpleadoId`, `EMP_CMM_TasaPagoId`, `EMP_CMM_CalifHabilidadesId`, `EMP_CMM_TipoSanguineoId`, `EMP_SueldoBase`, `EMP_CMM_SexoId`, `EMP_CMM_DeptoId`, `EMP_CMM_LineaProduccionId`, `EMP_PresupuestoAutorizado`, `EMP_FechaRevision`) VALUES
	(1, 1, 'Beto', 'Jimenez', 'Medina', '790', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, b'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, b'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(2, 7, 'Vicente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(3, 7, 'JOSE EMANUEL CUEVA SANCHEZ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, b'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, b'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
/*!40000 ALTER TABLE `empleados` ENABLE KEYS */;

-- Volcando estructura para tabla vmadb_kd.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla vmadb_kd.migrations: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
REPLACE INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '2014_10_12_000000_create_users_table', 1),
	(2, '2014_10_12_100000_create_password_resets_table', 1),
	(3, '2021_11_01_051253_create_permission_tables', 1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;

-- Volcando estructura para tabla vmadb_kd.model_has_permissions
CREATE TABLE IF NOT EXISTS `model_has_permissions` (
  `permission_id` int(10) unsigned NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla vmadb_kd.model_has_permissions: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `model_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `model_has_permissions` ENABLE KEYS */;

-- Volcando estructura para tabla vmadb_kd.model_has_roles
CREATE TABLE IF NOT EXISTS `model_has_roles` (
  `role_id` int(10) unsigned NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla vmadb_kd.model_has_roles: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `model_has_roles` DISABLE KEYS */;
REPLACE INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
	(1, 'App\\User', 1),
	(1, 'App\\User', 7);
/*!40000 ALTER TABLE `model_has_roles` ENABLE KEYS */;

-- Volcando estructura para tabla vmadb_kd.password_resets
CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla vmadb_kd.password_resets: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;

-- Volcando estructura para tabla vmadb_kd.permissions
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla vmadb_kd.permissions: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
REPLACE INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
	(1, 'role-list', 'web', '2021-11-11 00:16:22', '2021-11-11 00:16:22'),
	(2, 'role-create', 'web', '2021-11-11 00:16:22', '2021-11-11 00:16:22'),
	(3, 'role-edit', 'web', '2021-11-11 00:16:22', '2021-11-11 00:16:22'),
	(4, 'role-delete', 'web', '2021-11-11 00:16:22', '2021-11-11 00:16:22');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;

-- Volcando estructura para tabla vmadb_kd.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla vmadb_kd.roles: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
REPLACE INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
	(1, 'empleado', 'web', '2021-11-11 02:56:41', '2021-11-11 02:56:41'),
	(2, 'alumno', 'web', '2021-11-19 23:06:13', '2021-11-19 23:06:13');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;

-- Volcando estructura para tabla vmadb_kd.role_has_permissions
CREATE TABLE IF NOT EXISTS `role_has_permissions` (
  `permission_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `role_has_permissions_role_id_foreign` (`role_id`),
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla vmadb_kd.role_has_permissions: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `role_has_permissions` DISABLE KEYS */;
REPLACE INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
	(1, 1);
/*!40000 ALTER TABLE `role_has_permissions` ENABLE KEYS */;

-- Volcando estructura para tabla vmadb_kd.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `usuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla vmadb_kd.users: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
REPLACE INTO `users` (`id`, `usuario`, `email`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
	(1, '790', 'alberto.medina@zarkin.com', '$2y$10$plL3pflItX5ZUZfyND8HHOlMEduNB7VEfoAPdax/DDth5mSEDhEu2', 'src0PGrvx57ODW06O6cTSQVLk6m393lMq2IZdXxh0mRrpZHex2Ud7Y9t0nP2', '2021-11-11 00:32:17', '2021-11-12 08:23:12'),
	(7, '7', 'vicente.cueva@zarkin.com', '$2y$10$n9.bgynaLapqrgHF1xVgPOd8Rlr1hSwRE7TzdY9psz4nolBeSdn0m', 'PJc7gkaKUdQkzQmBqKp1RMOr1Yt3bd68qForotw7e8gSRpHRBq4mqhTKtqrr', '2021-11-13 01:14:23', '2021-11-24 23:31:34');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
