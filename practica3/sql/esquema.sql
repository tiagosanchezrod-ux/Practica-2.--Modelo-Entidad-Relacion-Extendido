---- TABLAS ESQUEMA

CREATE TABLE PLANTA_TRATAMIENTO (
    id_planta INT PRIMARY KEY NOT NULL,
    nombre_planta VARCHAR(100) NOT NULL,
    licencia_ambiental VARCHAR(50) NOT NULL UNIQUE,
    contacto_telefono VARCHAR(20)
);

CREATE TABLE DONANTE (
    id_donante INT PRIMARY KEY NOT NULL,
    nombre_pila VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50),
    correo VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    tipo_donante VARCHAR(20) NOT NULL CHECK (tipo_donante IN ('Particular', 'Empresa'))
);

CREATE TABLE DONANTE_PARTICULAR (
    id_donante INT PRIMARY KEY NOT NULL REFERENCES DONANTE(id_donante) ON DELETE CASCADE ON UPDATE CASCADE,
    fecha_nacimiento DATE NOT NULL,
    curp VARCHAR(18) NOT NULL UNIQUE
);

CREATE TABLE DONANTE_EMPRESA (
    id_donante INT PRIMARY KEY NOT NULL REFERENCES DONANTE(id_donante) ON DELETE CASCADE ON UPDATE CASCADE,
    representante_legal VARCHAR(100) NOT NULL,
    rfc VARCHAR(13) NOT NULL UNIQUE
);

CREATE TABLE RECEPCION_EQUIPO (
    id_recepcion INT PRIMARY KEY NOT NULL,
    id_donante INT NOT NULL REFERENCES DONANTE(id_donante) ON DELETE RESTRICT ON UPDATE CASCADE,
    fecha_ingreso DATE NOT NULL,
    tipo_aparato VARCHAR(50) NOT NULL,
    peso_total DECIMAL(10,2) CHECK (peso_total > 0),
    costo_recepcion DECIMAL(10,2)
);

CREATE TABLE COMPONENTE (
    id_recepcion INT NOT NULL REFERENCES RECEPCION_EQUIPO(id_recepcion) ON DELETE CASCADE ON UPDATE CASCADE,
    id_componente INT NOT NULL,
    estado_funcional VARCHAR(50) NOT NULL,
    peso_kg DECIMAL(10,2) NOT NULL CHECK (peso_kg > 0),
    tipo_componente VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_recepcion, id_componente)
);

CREATE TABLE MATERIAL (
    id_material INT PRIMARY KEY NOT NULL,
    nombre_material VARCHAR(50) NOT NULL UNIQUE,
    valormercado_kg DECIMAL(10,2) NOT NULL CHECK (valormercado_kg >= 0),
    es_peligroso BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE ENVIO_DESPACHO (
    id_envio INT PRIMARY KEY NOT NULL,
    id_planta INT NOT NULL REFERENCES PLANTA_TRATAMIENTO(id_planta) ON DELETE RESTRICT ON UPDATE CASCADE,
    fecha_envio DATE NOT NULL,
    codigo_manifiesto VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE DETALLE_DESPACHO (
    id_envio INT NOT NULL REFERENCES ENVIO_DESPACHO(id_envio) ON DELETE CASCADE ON UPDATE CASCADE,
    id_material INT NOT NULL REFERENCES MATERIAL(id_material) ON DELETE RESTRICT ON UPDATE CASCADE,
    cantidad_kg DECIMAL(10,2) NOT NULL CHECK (cantidad_kg > 0),
    PRIMARY KEY (id_envio, id_material)
);

CREATE TABLE COMPONENTE_MATERIAL (
    id_recepcion INT NOT NULL,
    id_componente INT NOT NULL,
    id_material INT NOT NULL REFERENCES MATERIAL(id_material) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_recepcion, id_componente, id_material),
    FOREIGN KEY (id_recepcion, id_componente)
        REFERENCES COMPONENTE(id_recepcion, id_componente)
        ON DELETE CASCADE ON UPDATE CASCADE
);