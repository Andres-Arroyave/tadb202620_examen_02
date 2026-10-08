/*Examen No. 2
 Motor: MySQL
 Autor: Andres Arroyave Londoño
 ID SIGAA: 000547528
 */
-- Indices Para la etapa 3


-- Consulta para etapa 3 sin indice propio (linea base)

DROP INDEX idx_brecha_severidad_fecha ON brecha;
DROP INDEX idx_exposicion_tipo_brecha ON exposicion_dato;

ANALYZE TABLE brecha, exposicion_dato, tipo_dato, organizacion;
EXPLAIN ANALYZE
SELECT o.nombre_organizacion,
       b.codigo_brecha,
       b.fecha_deteccion,
       b.vector_ataque,
       COUNT(DISTINCT e.id_usuario) AS usuarios_afectados
FROM brecha b
         JOIN organizacion o ON o.id_organizacion = b.id_organizacion
         JOIN exposicion_dato e ON e.id_brecha = b.id_brecha
         JOIN tipo_dato t ON t.id_tipo_dato = e.id_tipo_dato
WHERE b.fecha_deteccion BETWEEN '2025-10-07' AND '2026-10-07'
  AND b.severidad IN ('Alta', 'Critica')
  AND t.categoria_sensibilidad = 'Critica'
GROUP BY b.id_brecha,
         o.nombre_organizacion,
         b.codigo_brecha,
         b.fecha_deteccion,
         b.vector_ataque
ORDER BY usuarios_afectados DESC;

-- Consulta para etapa 3 con indice propio

-- Optimiza el filtro WHERE en la tabla brecha
CREATE INDEX idx_brecha_severidad_fecha ON brecha (severidad, fecha_deteccion);
-- Optimiza el JOIN en la tabla intermedia exposicion_dato
CREATE INDEX idx_exposicion_tipo_brecha ON exposicion_dato (id_tipo_dato, id_brecha);

ANALYZE TABLE brecha, exposicion_dato, tipo_dato, organizacion;
EXPLAIN ANALYZE
SELECT o.nombre_organizacion,
       b.codigo_brecha,
       b.fecha_deteccion,
       b.vector_ataque,
       COUNT(DISTINCT e.id_usuario) AS usuarios_afectados
FROM brecha b
         JOIN organizacion o ON o.id_organizacion = b.id_organizacion
         JOIN exposicion_dato e ON e.id_brecha = b.id_brecha
         JOIN tipo_dato t ON t.id_tipo_dato = e.id_tipo_dato
WHERE b.fecha_deteccion BETWEEN '2025-10-07' AND '2026-10-07'
  AND b.severidad IN ('Alta', 'Critica')
  AND t.categoria_sensibilidad = 'Critica'
GROUP BY b.id_brecha,
         o.nombre_organizacion,
         b.codigo_brecha,
         b.fecha_deteccion,
         b.vector_ataque
ORDER BY usuarios_afectados DESC;


-- Consulta para etapa 4

-- ---------------------------------------------------------------------
EXPLAIN ANALYZE
SELECT b.codigo_brecha, t.nombre_tipo_dato, t.categoria_sensibilidad,
       o.nombre_organizacion, e.fecha_notificacion
FROM usuario u
         JOIN exposicion_dato e ON e.id_usuario    = u.id_usuario
         JOIN brecha          b ON b.id_brecha     = e.id_brecha
         JOIN tipo_dato       t ON t.id_tipo_dato  = e.id_tipo_dato
         JOIN organizacion    o ON o.id_organizacion = b.id_organizacion
WHERE u.codigo_usuario = 'US-006809'
ORDER BY e.fecha_notificacion, b.codigo_brecha, t.nombre_tipo_dato;

-- Indice que evitar el ordenamiento por fecha de notificacion.
CREATE INDEX idx_exposicion_usuario_fecha ON exposicion_dato (id_usuario, fecha_notificacion);
ANALYZE TABLE exposicion_dato;

EXPLAIN ANALYZE
SELECT b.codigo_brecha, t.nombre_tipo_dato, t.categoria_sensibilidad,
       o.nombre_organizacion, e.fecha_notificacion
FROM usuario u
         JOIN exposicion_dato e FORCE INDEX (idx_exposicion_usuario_fecha) ON e.id_usuario    = u.id_usuario
         JOIN brecha          b ON b.id_brecha     = e.id_brecha
         JOIN tipo_dato       t ON t.id_tipo_dato  = e.id_tipo_dato
         JOIN organizacion    o ON o.id_organizacion = b.id_organizacion
WHERE u.codigo_usuario = 'US-006809'
ORDER BY e.fecha_notificacion, b.codigo_brecha, t.nombre_tipo_dato;



