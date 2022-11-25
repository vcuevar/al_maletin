# al_maletin
Portafolio de Archivos recientes.

Para antes de apagar las computadoras, cerrar todo lo que este en al_maletin
despues abrir consola

En la maquina Linux

git status
git pull
git add .
git commit -m "Actual LIN 220414"
git push

usuario: vcuevar
token: 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

git pull


En la maquina Windows

git status
git pull
git add .
git commit -m "Actual WIN 220414"
git push

git pull


--- Otros Comandos.

git clone origin

git fetch    es para actualiar de la red parte que hace pull
git merge    es para fusionar ramas segunda parte que hace el pull

git reset -- hard  (abandona cambios en local)

Algunos editores se puede operar con

	i (escribes mensaje) Ctrl + c luego wq
otros
i (escribes mensaje) Esc luego x!

Tratar de configurar por omision editor en los Windows el NotePad

git config core.editor notepad
 






---------------------------------------------------------------------------------------------
| Conecxion a Base de Datos de MariaDB                                                      |
---------------------------------------------------------------------------------------------

Maquina HP LocalHost (http://127.0.0.1/)
Port: 3306

En la consola Command Promt (MariaDB 10.5 (x64)) tecleamos el siguiente comando: 
																		mysql -u sa -p
		Enter password: victoria

Algunos comandos
CREATE DATABASE VPHDB_KD; (Crear Base de Datos)
SHOW DATABASES; (Mostrar las Bases de Datos)
DROP DATABASES; (Borrar una Bases de Datos)
USE Laravel; (Se utiliza Base Laravel)
QUIT; (Cerrar la conexion)
SHOW TABLES; (Ver las tablas que contiene)
DESCRIBE nombre_tabla; (Ver contenido de la Tabla)
DESC nombre_tabla; (Ver contenido de la Tabla)
ALTER TABLE employees ADD COLUMN first_name VARCHAR(100); (Agregar una Columna)


ALTER TABLE employees CHANGE COLUMN name last_name VARCHAR(150); (Cambio de Nombre de la columna)
ALTER TABLE employees MODIFY COLUMN last_name VARCHAR(100); (Cambiar de tipos de datos)
ALTER TABLE employees MODIFY COLUMN first_name VARCHAR(100) AFTER dni; (Modificar el acomodo de la columna)
ALTER TABLE employees DROP COLUMN email; (Para Para eliminar un campo)
ALTER TABLE employees ADD FOREIGN KEY (branch_id) REFERENCES branches (id); (Para asignar una llave primaria)
ALTER TABLE employees DROP PRIMARY KEY (Branch_id); (Para quitar una llave primaria existente)





