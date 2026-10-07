/*Examen No. 2
 Motor: MySQL
 Autor: Andres Arroyave Londoño
 ID SIGAA: 000547528
 */

-- =====================================================================
-- ETAPA 3: Brechas criticas del ultimo anio con mayor impacto en usuarios
-- =====================================================================
SELECT o.nombre_organizacion,
       b.codigo_brecha,
       b.fecha_deteccion,
       b.vector_ataque,
       COUNT(DISTINCT e.id_usuario) AS usuarios_afectados
FROM brecha b
JOIN organizacion    o ON o.id_organizacion = b.id_organizacion
JOIN exposicion_dato e ON e.id_brecha       = b.id_brecha
JOIN tipo_dato       t ON t.id_tipo_dato    = e.id_tipo_dato
WHERE b.fecha_deteccion BETWEEN '2025-10-07' AND '2026-10-07'
  AND b.severidad IN ('Alta', 'Critica')
  AND t.categoria_sensibilidad = 'Critica'
GROUP BY b.id_brecha, o.nombre_organizacion, b.codigo_brecha,
         b.fecha_deteccion, b.vector_ataque
ORDER BY usuarios_afectados DESC, b.codigo_brecha;

-- =====================================================================
-- ETAPA 4: Historial de exposicion de un usuario especifico
-- (usuario de ejemplo: US-006809; ordenado cronologicamente por
--  fecha de notificacion, con desempate estable)
-- =====================================================================
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
WHERE u.codigo_usuario = 'US-006809'
ORDER BY e.fecha_notificacion, b.codigo_brecha, t.nombre_tipo_dato;

-- Ejemplos de invocacion:
-- CALL sp_historial_usuario('US-006809');

CALL sp_brechas_criticas('2025-10-07', '2026-10-07');
