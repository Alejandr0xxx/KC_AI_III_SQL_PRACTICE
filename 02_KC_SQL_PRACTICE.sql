-- Creacion del esquema keepcoding para las tablas
CREATE SCHEMA IF NOT EXISTS keepcoding;

-- Creacion de la tabla usuarios
CREATE TABLE IF NOT EXISTS keepcoding.usuarios (
  usuario_id SERIAL PRIMARY KEY,
  correo VARCHAR(255) UNIQUE NOT NULL,
  contrasena TEXT NOT NULL
);

-- Creacion de la tabla alumnos
CREATE TABLE IF NOT EXISTS keepcoding.alumnos(
  alumno_id SERIAL PRIMARY KEY,
  nombre_1 VARCHAR(100) NOT NULL,
  nombre_2 VARCHAR(100),
  apellido_2 VARCHAR(100),
  usuario_id INT UNIQUE NOT NULL,
  fecha_inscripcion DATE NOT NULL,
  FOREIGN KEY (usuario_id) REFERENCES keepcoding.usuarios(usuario_id) ON DELETE CASCADE
);

-- Creacion de la tabla bootcamps
CREATE TABLE IF NOT EXISTS keepcoding.bootcamps(
  bootcamp_id SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT NOT NULL
);

-- Creacion de la tabla intermedia para relacionar alumnos con bootcamps
CREATE TABLE IF NOT EXISTS keepcoding.alumnos_bootcamps(
  alumno_id INT NOT NULL,
  bootcamp_id INT NOT NULL,
  PRIMARY KEY(alumno_id, bootcamp_id),
  FOREIGN KEY (alumno_id) REFERENCES keepcoding.alumnos(alumno_id) ON DELETE CASCADE,
  FOREIGN KEY (bootcamp_id) REFERENCES keepcoding.bootcamps(bootcamp_id) ON DELETE CASCADE
);

-- Creacion de la tabla profesores
CREATE TABLE IF NOT EXISTS keepcoding.profesores(
  profesor_id SERIAL PRIMARY KEY,
  nombre_1 VARCHAR(100) NOT NULL,
  nombre_2 VARCHAR(100),
  apellido_1 VARCHAR(100) NOT NULL,
  apellido_2 VARCHAR(100),
  usuario_id INT UNIQUE NOT NULL,
  FOREIGN KEY (usuario_id) REFERENCES keepcoding.usuarios(usuario_id) ON DELETE CASCADE
);

-- Creacion de la tabla modulos
CREATE TABLE IF NOT EXISTS keepcoding.modulos(
  modulo_id SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT NOT NULL,
  profesor_id INT UNIQUE NOT NULL,
  FOREIGN KEY (profesor_id) REFERENCES keepcoding.profesores(profesor_id) ON DELETE CASCADE
  );

-- Creacion de la tabla intermedia para relacionar bootcamps con sus modulos
CREATE TABLE IF NOT EXISTS keepcoding.bootcamps_modulos(
  bootcamp_id INT NOT NULL,
  modulo_id INT NOT NULL,
  PRIMARY KEY(bootcamp_id, modulo_id),
  FOREIGN KEY (bootcamp_id) REFERENCES keepcoding.bootcamps(bootcamp_id) ON DELETE CASCADE,
  FOREIGN KEY (modulo_id) REFERENCES keepcoding.modulos(modulo_id) ON DELETE CASCADE
);


