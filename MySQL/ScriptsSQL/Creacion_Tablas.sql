/*Examen No. 2
 Motor: MySQL
 Autor: Andres Arroyave Londoño
 ID SIGAA: 000547528
 */


create table organizacion (
    id_organizacion int unsigned not null auto_increment primary key,
    nombre_organizacion varchar(100)  not null unique,
    sector              varchar(50)   not null,
    pais                varchar(50)   not null,
    tamano_empleados    int unsigned  not null,
    constraint ck_organizacion_tamano check (tamano_empleados > 0)
);


create table tipo_dato (
    id_tipo_dato int unsigned auto_increment primary key,
    nombre_tipo_dato varchar(50) not null unique,
    categoria_sensibilidad varchar(10) not null,
    constraint ck_tipo_dato_sensibilidad
        check (categoria_sensibilidad IN ('Baja', 'Media', 'Alta', 'Critica'))
);


create table brecha (
    id_brecha int unsigned not null auto_increment primary key,
    codigo_brecha char(8) not null unique,
    id_organizacion int unsigned not null,
    fecha_ocurrencia date not null,
    fecha_deteccion date not null,
    vector_ataque varchar(60) not null,
    severidad varchar(10) not null,
    registros_afectados int unsigned   not null,
    costo_estimado decimal(15,2)  not null,
    constraint fk_brecha_organizacion
        foreign key (id_organizacion) references organizacion (id_organizacion),
    constraint ck_brecha_severidad
        check (severidad IN ('Baja', 'Media', 'Alta', 'Critica')),
    constraint ck_brecha_fechas
        check (fecha_deteccion >= fecha_ocurrencia),
    constraint ck_brecha_costo check (costo_estimado >= 0)
);


create table usuario (
    id_usuario int unsigned not null auto_increment primary key,
    codigo_usuario    char(9)       not null unique,
    pseudonimo        varchar(50)   not null unique,
    email_hash        char(32)      not null unique,
    pais_residencia   varchar(50)   not null,
    fecha_registro    date          not null,
    id_organizacion   int unsigned  not null,
    constraint fk_usuario_organizacion
    foreign key (id_organizacion) references organizacion (id_organizacion)
);


create table exposicion_dato (
    id_usuario int unsigned not null,
    id_brecha int unsigned not null,
    id_tipo_dato int unsigned not null,
    fecha_notificacion date not null,

    constraint pk_exposicion_dato
        primary key (id_usuario, id_brecha, id_tipo_dato),
    constraint fk_exposicion_usuario
        foreign key (id_usuario) references usuario (id_usuario),
    constraint fk_exposicion_brecha
        foreign key (id_brecha) references brecha (id_brecha),
    constraint fk_exposicion_tipo_dato
        foreign key (id_tipo_dato) references tipo_dato (id_tipo_dato)
);


