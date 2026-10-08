/*Examen No. 2
 Motor: MySQL
 Autor: Andres Arroyave Londoño
 ID SIGAA: 000547528
 */

/*
El orden importa: primero la columna que se filtra con IN (severidad) y después la del rango (fecha).
El plan pasa de un Table scan sobre las 800 brechas a un Index range scan.
*/
CREATE INDEX idx_brecha_severidad_fecha ON brecha (severidad, fecha_deteccion);
SHOW INDEX FROM brecha;

CREATE INDEX idx_exposicion_tipo_brecha ON exposicion_dato (id_tipo_dato, id_brecha);
SHOW INDEX FROM exposicion_dato;


-- =====================================================================
-- PROCEDIMIENTOS ALMACENADOS
-- Nota DataGrip: si DELIMITER da problemas, seleccione cada bloque
-- CREATE PROCEDURE ... END$$ (sin la linea DELIMITER) y ejecutelo.
-- =====================================================================

DELIMITER $$

CREATE PROCEDURE sp_historial_usuario (IN p_codigo_usuario CHAR(9))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM usuario WHERE codigo_usuario = p_codigo_usuario) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no encontrado';
    END IF;

    SELECT b.codigo_brecha,
           t.nombre_tipo_dato,
           t.categoria_sensibilidad,
           o.nombre_organizacion,
           e.fecha_notificacion
    FROM usuario u
             JOIN exposicion_dato e ON e.id_usuario    = u.id_usuario
             JOIN brecha          b ON b.id_brecha     = e.id_brecha
             JOIN tipo_dato       t ON t.id_tipo_dato  = e.id_tipo_dato
             JOIN organizacion    o ON o.id_organizacion = b.id_organizacion
    WHERE u.codigo_usuario = p_codigo_usuario
    ORDER BY e.fecha_notificacion, b.codigo_brecha, t.nombre_tipo_dato;
END$$

DELIMITER $$

CREATE PROCEDURE sp_brechas_criticas (IN p_fecha_inicio DATE, IN p_fecha_fin DATE)
BEGIN
    IF p_fecha_inicio > p_fecha_fin THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de inicio no puede ser posterior a la fecha fin';
    END IF;

    SELECT o.nombre_organizacion,
           b.codigo_brecha,
           b.fecha_deteccion,
           b.vector_ataque,
           COUNT(DISTINCT e.id_usuario) AS usuarios_afectados
    FROM brecha b
             JOIN organizacion    o ON o.id_organizacion = b.id_organizacion
             JOIN exposicion_dato e ON e.id_brecha       = b.id_brecha
             JOIN tipo_dato       t ON t.id_tipo_dato    = e.id_tipo_dato
    WHERE b.fecha_deteccion BETWEEN p_fecha_inicio AND p_fecha_fin
      AND b.severidad IN ('Alta', 'Critica')
      AND t.categoria_sensibilidad = 'Critica'
    GROUP BY b.id_brecha, o.nombre_organizacion, b.codigo_brecha,
             b.fecha_deteccion, b.vector_ataque
    ORDER BY usuarios_afectados DESC, b.codigo_brecha;
END$$

DELIMITER ;