CREATE TABLE stg_sabana
(
    nombre_organizacion           varchar(100),
    sector_organizacion           varchar(50),
    pais_organizacion             varchar(50),
    tamano_empleados_organizacion int,
    codigo_brecha                 char(8),
    fecha_ocurrencia              date,
    fecha_deteccion               date,
    vector_ataque                 varchar(60),
    severidad_incidente           varchar(10),
    registros_afectados_total     int,
    costo_estimado_total          decimal(15, 2),
    codigo_usuario                char(9),
    pseudonimo_usuario            varchar(50),
    email_hash_usuario            char(32),
    pais_residencia_usuario       varchar(50),
    fecha_registro_usuario        date,
    tipo_dato_expuesto            varchar(50),
    categoria_sensibilidad_dato   varchar(10),
    fecha_notificacion_usuario    date
);


-- Orden obligatorio por las FK
INSERT intO organizacion (nombre_organizacion, sector, pais, tamano_empleados)
SELECT DISTINCT nombre_organizacion, sector_organizacion, pais_organizacion, tamano_empleados_organizacion
FROM stg_sabana;

INSERT intO tipo_dato (nombre_tipo_dato, categoria_sensibilidad)
SELECT DISTINCT tipo_dato_expuesto, categoria_sensibilidad_dato
FROM stg_sabana;

INSERT intO brecha (codigo_brecha, id_organizacion, fecha_ocurrencia, fecha_deteccion, vector_ataque, severidad,
                    registros_afectados, costo_estimado)
SELECT DISTINCT s.codigo_brecha,
                o.id_organizacion,
                s.fecha_ocurrencia,
                s.fecha_deteccion,
                s.vector_ataque,
                s.severidad_incidente,
                s.registros_afectados_total,
                s.costo_estimado_total
FROM stg_sabana s
         JOIN organizacion o ON o.nombre_organizacion = s.nombre_organizacion;

INSERT intO usuario (codigo_usuario, pseudonimo, email_hash, pais_residencia, fecha_registro, id_organizacion)
SELECT DISTINCT s.codigo_usuario,
                s.pseudonimo_usuario,
                s.email_hash_usuario,
                s.pais_residencia_usuario,
                s.fecha_registro_usuario,
                o.id_organizacion
FROM stg_sabana s
         JOIN organizacion o ON o.nombre_organizacion = s.nombre_organizacion;

INSERT intO exposicion_dato (id_usuario, id_brecha, id_tipo_dato, fecha_notificacion)
SELECT u.id_usuario, b.id_brecha, t.id_tipo_dato, s.fecha_notificacion_usuario
FROM stg_sabana s
         JOIN usuario u ON u.codigo_usuario = s.codigo_usuario
         JOIN brecha b ON b.codigo_brecha = s.codigo_brecha
         JOIN tipo_dato t ON t.nombre_tipo_dato = s.tipo_dato_expuesto;

DROP TABLE stg_sabana;
