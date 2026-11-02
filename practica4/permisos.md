# Ejercicio 1.6: Usuarios y Permisos
## 1. Definición de Roles
* **`rol_admin` (Administrador):** Posee control total sobre el esquema (`ALL PRIVILEGES`). Existe para tareas de mantenimiento DDL (creación/modificación de tablas), gestión de usuarios y respaldos de la base de datos.
* **`rol_app` (Aplicación - Lógica de Negocio):** Permisos de lectura (`SELECT`) y escritura (`INSERT`, `UPDATE`) únicamente sobre las tablas operativas que la aplicación requiere para su funcionamiento. Principio de mínimo privilegio.
* **`rol_consulta` (Auditoría / Reportes - Solo Lectura):** Acceso exclusivo de lectura (`SELECT`) sobre las tablas principales. Existe para la generación de reportes y consultas analíticas sin riesgo de modificación o alteración de datos.

---

## 2. Creación de Roles, Usuarios y Asignación de Permisos (`GRANT`)

```sql
-- 1. Creación de roles base
CREATE ROLE rol_admin;
CREATE ROLE rol_app;
CREATE ROLE rol_consulta;

-- 2. Asignación de permisos a Roles
-- Rol Administrador (Control total)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rol_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO rol_admin;

-- Rol Aplicación (Lectura y Escritura en tablas operativas)
GRANT SELECT, INSERT, UPDATE ON DONANTE, DONANTE_PARTICULAR, DONANTE_EMPRESA, RECEPCION_EQUIPO, COMPONENTE, DESPACHO_MATERIAL, DETALLE_DESPACHO TO rol_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO rol_app;

-- Rol Consulta (Solo lectura)
GRANT SELECT ON DONANTE, RECEPCION_EQUIPO, COMPONENTE, DESPACHO_MATERIAL TO rol_consulta;

-- 3. Creación de usuarios de autenticación y asignación a roles
-- Las contraseñas reales se manejan con variables de entorno por ejemplo DB_PASS_ADMIN, DB_PASS_APP, DB_PASS_CONSULTA
CREATE USER usr_admin WITH PASSWORD 'AdminPass123!';
CREATE USER usr_app WITH PASSWORD 'AppPass123!';
CREATE USER usr_consulta WITH PASSWORD 'ConsultaPass123!';

GRANT rol_admin TO usr_admin;
GRANT rol_app TO usr_app;
GRANT rol_consulta TO usr_consulta;


---

## 3. Matriz de Permisos (Control de Acceso)

La tabla resume los privilegios otorgados a cada rol sobre el sistema de gestión de E-Waste con el principio de mínimo privilegio:

| Tabla / Entidad | `rol_admin` (Administrador) | `rol_app` (Aplicación) | `rol_consulta` (Auditoría / Reportes) |
| :--- | :---: | :---: | :---: |
| **componente** | `ALL PRIVILEGES` | `SELECT, INSERT, UPDATE` | `SELECT` |
| **componente_material** | `ALL PRIVILEGES` | `SELECT, INSERT, UPDATE` | `SELECT` |
| **detalle_despacho** | `ALL PRIVILEGES` | `SELECT, INSERT, UPDATE` | `SELECT` |
| **donante** | `ALL PRIVILEGES` | `SELECT, INSERT, UPDATE` | `SELECT` |
| **donante_empresa** | `ALL PRIVILEGES` | `SELECT, INSERT, UPDATE` | `SELECT` |
| **donante_particular** | `ALL PRIVILEGES` | `SELECT, INSERT, UPDATE` | `SELECT` |
| **envio_despacho** | `ALL PRIVILEGES` | `SELECT, INSERT, UPDATE` | `SELECT` |
| **material** | `ALL PRIVILEGES` | `SELECT, INSERT, UPDATE` | `SELECT` |
| **planta_tratamiento** | `ALL PRIVILEGES` | `SELECT, INSERT, UPDATE` | `SELECT` |
| **recepcion_equipo** | `ALL PRIVILEGES` | `SELECT, INSERT, UPDATE` | `SELECT` |

---

## 4. Evidencia de Pruebas y Comprobación con REVOKE
* **Prueba Rol Aplicación (`rol_app`):** Consulta permitida e intento de inserción denegado por el gestor.
* **Prueba Rol Consulta (`rol_consulta`):** Lectura/escritura permitidas e intento de eliminación (`DELETE`) denegado.
* **Prueba de Revocación (`REVOKE`):** Se revocó el privilegio `UPDATE` sobre la tabla `donante` al rol `rol_app` para confirmar que el gestor deniega la actualización inmediatamente.