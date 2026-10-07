/*Examen No. 2
 Motor: MySQL
 Autor: Andres Arroyave Londoño
 ID SIGAA: 000547528
 */
-- 1. Creación de la base de datos
create database seguridad_db;

-- 2. Creación del usuario

create user 'seguridad_andres'@'%' identified by'SeguridadAndres*';

-- 3. Asignación de privilegios mínimos para el usuario en la base de datos

-- Privilegios de conexión, creación de tablas, índices y modificaciones (DDL)
GRANT CREATE, ALTER, DROP, INDEX, REFERENCES, CREATE TEMPORARY TABLES ON seguridad_db.* TO 'seguridad_andres'@'%';
-- Privilegios para manipulación de datos (DML)
GRANT SELECT, INSERT, UPDATE, DELETE ON seguridad_db.* TO 'seguridad_andres'@'%';
-- Privilegios para vistas (requerido para la Etapa 3)
GRANT CREATE VIEW, SHOW VIEW ON seguridad_db.* TO 'seguridad_andres'@'%';
-- Privilegios para lógica almacenada (funciones, procedimientos y triggers)
GRANT CREATE ROUTINE, ALTER ROUTINE, EXECUTE, TRIGGER ON seguridad_db.* TO 'seguridad_andres'@'%';
-- 4. Aplicar cambios de privilegios
FLUSH PRIVILEGES;