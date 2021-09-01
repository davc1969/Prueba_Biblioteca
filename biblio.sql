-- Parte 2 de la Prueba del módulo 5
-- La creación de la base de datos y sus tablas está basada en el diseño realizado previamente
-- Se hizo un diseño conceptual, lógico y físico y se puede ver en el archiv biblioteca.drawio
-- Este diseño se hico en la plataforma  app.diagrams.net

-- 1. Crear la base de datos y las tablas

-- Creación de la base de datos llamada BIBLIOTECA
CREATE DATABASE biblioteca;

-- Definición de la tabla SOCIO
CREATE TABLE "socio" (
	"rut" varchar(12) NOT NULL,
	"nombre" varchar(50) NOT NULL,
	"calle" varchar(20) NOT NULL,
	"numero" SMALLINT not null,
	"ciudad" VARCHAR(50) NOT NULL,
	"telefono" varchar(20) NOT NULL,
	CONSTRAINT "socio_pk" PRIMARY KEY ("rut")
);
 

-- Definición de la tabla LIBRO
CREATE TABLE "libro" (
	"isbn" varchar(15) NOT NULL,
	"titulo" varchar(100) NOT NULL,
	"paginas" integer NOT NULL,
	"dias_prestamo" SMALLINT,
	CONSTRAINT "libro_pk" PRIMARY KEY ("isbn")
);

-- Definición de la tabla AUTOR
CREATE TABLE "autor" (
	"id" serial NOT NULL,
	"nombre" varchar(30) NOT NULL,
	"apellido" VARCHAR(30) NOT NULL,
	"fecha_nacimiento" SMALLINT NOT NULL,
	"fecha_muerte" SMALLINT,
	"tipo" varchar(10) NOT NULL,
	CONSTRAINT "autor_pk" PRIMARY KEY ("id")
);


--Definición de la tabla AUTORXLIBRO
CREATE TABLE "autorxlibro" (
	"id" serial NOT NULL,
	"isbn" varchar(15),
	"id_autor" SMALLINT,
	PRIMARY KEY (id),
	FOREIGN KEY (isbn) REFERENCES libro(isbn),
	FOREIGN KEY (id_autor) REFERENCES autor(id)
);


-- Definición de la tabla PRESTAMO
CREATE TABLE "prestamo" (
	"id" serial NOT NULL,
	"rut_socio" varchar(12) NOT NULL,
	"isbn_libro" varchar(15) NOT NULL,
	"fecha_prestamo" DATE,
	"fecha_devolucion_real" DATE,
	PRIMARY KEY (id),
	FOREIGN KEY (rut_socio) REFERENCES socio(rut),
	FOREIGN KEY (isbn_libro) REFERENCES libro(isbn)
);


-- 2. Inlcuir los registros en las tablas correspondientes

-- Inclusión de registros en la tabla socios
-- (se ejecuta desde la cónsola)
\copy socio from socios.csv csv HEADER

-- Inclusión de registros en la tabla libros
-- (se ejecuta desde la cónsola)
\copy libro from libros.csv csv HEADER

-- Inclusión de registros en la tabla autor
-- (se ejecuta desde la cónsola)
\copy autor from autores.csv csv header

-- Inclusión de registros en la tabla autorxlibro
-- (se ejecuta desde la cónsola)
\copy autorxlibro from librosxautor.csv csv header

-- Inclusión de registros en la tabla prestamo
-- (se ejecuta desde la cónsola)
\copy prestamo from prestamos.csv csv header



-- 3. Hacer las consultas requeridas


-- a) Mostrar libros con menos de 300 paginas
SELECT * FROM libro
WHERE paginas < 300;

-- b) Mostrar autores nacidos dspues de 1-1-1970
SELECT * FROM autor 
WHERE fecha_nacimiento >= 1970;

-- c) Mostrar el Libro mas solicitado
SELECT libro.titulo, prestamo.isbn_libro, count(prestamo.id) AS "veces prestado" 
FROM prestamo
INNER JOIN libro ON libro.isbn = prestamo.isbn_libro 
GROUP BY prestamo.isbn_libro, libro.titulo
ORDER BY prestamo.isbn_libro DESC
LIMIT 1;

-- d) Calculo de multa para libros entregados con retraso respecto a los días de preéstamo de cada libro
SELECT	socio.nombre, socio.rut, libro.titulo, 
		(prestamo.fecha_devolucion_real - prestamo.fecha_prestamo) - libro.dias_prestamo as "Dias de retraso",
		(prestamo.fecha_devolucion_real - prestamo.fecha_prestamo) * 100 as "Multa"
FROM socio 
INNER JOIN prestamo 
	ON socio.rut = prestamo.rut_socio
INNER JOIN libro 
	ON prestamo.isbn_libro = libro.isbn 
WHERE (prestamo.fecha_devolucion_real - prestamo.fecha_prestamo) > libro.dias_prestamo
ORDER BY (prestamo.fecha_devolucion_real - prestamo.fecha_prestamo) desc;


