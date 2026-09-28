![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.001.png)![ref1]<a name="instituto politécnico nacional"></a><a name="escuela superior de cómputo"></a><a name="práctica 2 | ejercicio 2"></a><a name="funcionamiento local del proyecto asigna"></a><a name="base de datos"></a><a name="profesor: gabriel hurtado avilés"></a><a name="alumnos:"></a><a name="sánchez rodriguez santiago"></a><a name="casasola avalos diana valeria"></a>**INSTITUTO POLITÉCNICO NACIONAL**

**ESCUELA SUPERIOR DE CÓMPUTO**






**PRÁCTICA 2 | EJERCICIO 2**

**FUNCIONAMIENTO LOCAL DEL PROYECTO ASIGNADO**



**BASE DE DATOS**

*Profesor: Gabriel Hurtado Avilés*





*Alumnos:*

*Sánchez Rodriguez Santiago Casasola Avalos Diana Valeria*

**Grupo: 3CV2**

# <a name="índice"></a>**Índice**








[**Requisitos Previos**](#_bookmark0)**	2

[**Paso a Paso Secuencial del Levantamiento del Proyecto**](#_bookmark1)**	2

[Paso 1. Localización y Clonación/Fork del Repositorio](#_bookmark2)	2

[Paso 2: Despliegue del contenedor de base de datos en Docker](#_bookmark3)	4

[Paso 3: Acceso Interactivo a PostgreSQL y creación de la base de datos](#_bookmark4)	5

[Paso 4: Construcción del Data Warehouse y carga del esquema](#_bookmark5)	6

[Paso 5: Abrir la aplicación desde archivos locales](#_bookmark6)	9

[**Bibliografía**](#_bookmark7)**	13

## **Levantamiento del Proyecto: Data Warehouse y Knowledge Graph de Consumo de Agua (CDMX)**

Este documento describe de forma secuencial la instalación, configuración, resolución de problemas y ejecución del proyecto seleccionado en un entorno local.

## <a name="requisitos previos"></a><a name="_bookmark0"></a>**Requisitos Previos**
Antes de iniciar, se verificó y configuró la disponibilidad de las siguientes herramientas en el sistema operativo local (Windows):

- Git Bash: Para el control de versiones y ejecución de comandos bash en Windows.
- Docker Desktop: Entorno de virtualización por contenedores donde se ejecuta el motor de PostgreSQL.
- Visual Studio Code: Editor de código fuente utilizado para editar la documentación, gestionar los archivos del proyecto y levantar el servidor web local.
- Extensión Live Server (en VS Code): Servidor HTTP local para renderizar las interfaces web dinámicas.

## <a name="paso a paso secuencial del levantamiento"></a><a name="_bookmark1"></a>**Paso a Paso Secuencial del Levantamiento del Proyecto**
<a name="paso 1. localización y clonación/fork de"></a><a name="_bookmark2"></a>Paso 1. Localización y Clonación/Fork del Repositorio

- ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.003.jpeg)Se localizó la sección *3.3 Continuous Deployment Methodology* del artículo elegido *“Territorial Information Retrieval from Heterogeneous Open Data through the Construction of a Data Warehouse for Water Management in Mexico City”,* ya que ahí se encuentran los links que se usarán para trabajar con el proyecto.
- En el texto del artículo se identifica el enlace oficial del código fuente: (gabrielhuav/Data\_Warehouse\_static).
- Para crear el fork personal, en la interfaz web de GitHub, se seleccionó la opción *Fork* (arriba a la derecha) para crear una copia exacta e independiente del repositorio dentro de la cuenta personal

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.004.jpeg)

- Esto se dirige al siguiente apartado en donde se debe seleccionar “Create Folder”

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.005.jpeg)

- Se	verifica	que	la	dirección	del	repositorio	Fork	sea: <https://github.com/val0444/Data_Warehouse_static> (ya con dirección de nuestro user)

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.006.jpeg)

- Se accede a la aplicación Git Bash para el clonado local del repositorio

  ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.007.jpeg)


- ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.008.png)Se abrió la terminal de Git Bash en el sistema


- Se debe estar en la carpeta raíz del usuario ejecutando: **cd ~**
- Se escribe el comando de clonación indicando la ruta del usuario:

  **git clone [**https://github.com/val0444/Data_Warehouse_static.git**](https://github.com/val0444/Data_Warehouse_static.git)**

- Así se accede a la carpeta descargada: **cd Data\_Warehouse\_static**

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.009.png)

- De igual forma se clonó el repositorio de soporte que contiene la configuración del contenedor	y	archivos	SQL:	**git	clone [**https://github.com/gabrielhuav/data_warehouse_cdmx.git**](https://github.com/gabrielhuav/data_warehouse_cdmx.git)**
- ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.010.png)

<a name="paso 2: despliegue del contenedor de bas"></a><a name="_bookmark3"></a>Paso 2: Despliegue del contenedor de base de datos en Docker

- Se inició la aplicación Docker Desktop en Windows. ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.011.jpeg)
- Desde la terminal Git Bash, se ingresó a la carpeta de la base de datos: **cd data\_warehouse\_cdmx ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.012.png)**
- Se ejecutaron los comandos para levantar el servicio PostgreSQL mediante el archivo de configuración: **docker-compose up -d**

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.013.png)

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.014.png)

<a name="paso 3: acceso interactivo a postgresql "></a><a name="_bookmark4"></a>Paso 3: Acceso Interactivo a PostgreSQL y creación de la base de datos

- Se verifica que el contenedor se encuentre corriendo activamente ejecutando: **docker ps** Está confirmado que en la columna NAMES el nombre asignado al contenedor en ejecución era *data\_warehouse\_cdmx*

  ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.015.png)

- En la terminal que se tiene (*~/data\_warehouse\_cdmx)* se conecta a la base de datos por defecto (postgres), ejecutando este comando: **docker exec -it data\_warehouse\_cdmx psql -U postgres**
- Una vez dentro del prompt *postgres=#*, se crea la base de datos requerida para el proyecto y listamos las bases existentes: **CREATE DATABASE cdmx\_water; \l**

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.016.png)

- Se cambia la conexión hacia la base de datos que acabamos de crear: **\c cdmx\_water**
- Lla consola mostrará el mensaje: *You are now connected to database "cdmx\_water" as user "postgres"*
- Ejecutar la consulta SQL para verificar la base conectada y usuario activo: **SELECT current\_database(), current\_user, version();**

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.017.png)

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.018.png)

- Cerrar sesión utilizando: **\q**
- Se verificó mediante Docker Desktop que el contenedor estuviera funcionando:

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.019.png)

<a name="paso 4: construcción del data warehouse "></a><a name="_bookmark5"></a>Paso 4: Construcción del Data Warehouse y carga del esquema

Para construir el Data Warehouse, se utilizó la configuración automatizada dada en el repositorio

*Data\_Warehouse\_static*

- Dirigirse a la carpeta *Data\_Warehouse\_static* para entrar la subcarpeta *warehouse:* **cd**

  **~/Data\_Warehouse\_static/warehouse**

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.020.png)

- Se ejecuta el comando exactamente como lo indica el *README* del repositorio para levantar Docker: **docker compose up -d --build**

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.021.png)
## **Error:**
*Conflict. The container name "/data\_warehouse\_cdmx" is already in use by container "caf8932..."* El contenedor creado manualmente durante los pasos previos (Paso 2 y 3) ya existe con el nombre *data\_warehouse\_cdmx.* Como el nombre ya está reservado por Docker, no se permite levantarlo de nuevo hasta que se libere o elimine ese contenedor.

## **Solución:**
- Se forzó la eliminación del contenedor previo para liberar el nombre, usando el comando:

  **docker rm -f data\_warehouse\_cdmx**

- Se levanta nuevamente el entorno: **docker compose up -d**
- Verificar que ya está activo: **docker ps**

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.022.png)

- Entrar a PostgreSQL usando el comando **docker exec -it data\_warehouse\_cdmx psql -U postgres -d cdmx\_water**

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.023.png)

## **Error:**
Al intentar ingresar a la base de datos con el nombre previo c*dmx\_water*, el sistema devolvió *(psql: error: connection to server... FATAL: database "cdmx\_water" does not exist)*. El contenedor *data\_warehouse\_cdmx* acaba de crearse. Cuando un contenedor de PostgreSQL arranca por primera vez, se ejecuta en segundo plano los scripts que crean las bases de datos e importan los archivos .csv. Si se intenta entrar inmediatamente antes de que termine, la base de datos todavía se está construyendo.
## **Solución:**
- Para verificar el estado de la inicialización, se consultaron los logs del contenedor:

  **docker logs data\_warehouse\_cdmx**

Con esto se confirmó que el contenedor ejecuta automáticamente los scripts de esquema (0\_schema.sql), importación de datos (1\_copy.sql), relaciones geográficas (2\_geo.sql) y hechos (3\_fact.sql).

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.024.png)

- Ejecutar	la	conexión	a	la	base	de	datos	del	contenedor:	**docker	exec	-it data\_warehouse\_cdmx psql -U postgres -d postgres**

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.025.png)

Para verificar, se listaran las bases de datos que SÍ existen

- Escribir este comando y presionar enter: **\l**

Se desplegó una lista con los nombres reales de las bases de datos creadas en la primera columna (columna **Name**), se observa que la base de datos del proyecto se llama *data\_warehouse*.

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.026.png)

- Conectarse a la base de datos *data\_warehouse*: **\c data\_warehouse**
- Una vez dentro, ejecuta la consulta SQL: **SELECT \* FROM fact\_consumo\_agua LIMIT 5;**

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.027.png)

Con este resultado se logró ejecutar la consulta SQL correctamente y se obtuvieron los 5 registros requeridos con todos sus campos (id\_fact, id\_tiempo, id\_ubicacion, consumo\_total\_mixto, etc.).

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.028.png)<a name="paso 5: abrir la aplicación desde archiv"></a><a name="_bookmark6"></a>Paso 5: Abrir la aplicación desde archivos locales




- Se abre el administrador de archivos de nuestro equipo

- Dirigirse al apartado de Windows (C:)
- En donde se despliegan varias carpetas, y ahi seleccionar “User” > “valer” (usuario propio)

  >	“Data\_Warehouse\_static”	(la	carpeta	que	se	creó	con	el	proyecto)

  ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.029.png)

- En	esa	ventana	de	carpetas,	acceder	al	archivo	de	*index.html	y	mapa.html*

  ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.030.png)

- Se abrirá en el navegador web (en este caso Google Chrome).

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.031.png)

## **Error:**
Al hacer esto se observa que se ejecutó el programa pero con un error en ambos archivos.

*index.html*: *Could not load consumo.json (Failed to fetch) / alcaldias.geojson.*

Los navegadores web bloquean por seguridad las peticiones de archivos de datos (fetch/AJAX) cuando se abre un HTML directamente usando el protocolo *file:///C:/Users/*  Por eso los mapas y

las gráficas intentan leer los archivos .json o .geojson y el navegador les niega el acceso local.

*mapa.html: Access blocked 403 en las mallas del mapa:* Es una restricción de política de uso pública del servidor de mapas OpenStreetMap al recibir peticiones directas fuera de un servidor web estándar
## **Solución**:
Para que el navegador pueda cargar los archivos sin bloqueos de segurida, se deberá abrir la carpeta mediante un servidor local simulado.

- Ingresar a Visual Studio Code ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.032.jpeg)
- Seleccionar la opción File > Open Folder... y navegar a la ruta del repositorio local:

  *C:\Users\valer\Data\_Warehouse\_static*










- ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.033.png)Se ingresó al apartado de extensiones	y se realizó la instalación de la extensión Live




Server

- Ubicar el archivo *index.html* en el explorador de archivos de VS Code.
- Se hizo clic derecho sobre el archivo y se debe abrir mediante la extensión previamente instalada

  ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.034.jpeg)

Sin embargo, no aparece la opción requerida para abrir el proyecto con Live Server.
## **Error:**
El aviso*(This extension has been disabled because the current workspace is not trusted.)* es la razón por la que no aparece la opción en el menú desplegable.

Ya que VS Code bloquea automáticamente ciertas extensiones cuando se abre una carpeta en la que no se ha confirmado que los archivos son seguros.
## **Solución:**
- En la parte superior de VS Code se usó *(Ctrl + Shift + P)* y ahí colocar
  ## **Workspaces: Manage Workspace Trust**
  ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.035.png)

- Se dirige a esta pantalla, en donde se debe seleccionar la opción de *“Add Folder”* y adjuntar la carpeta del proyecto, la cual se añadirá en la pestaña de *“Trusted Folders & Workspace”*

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.036.png)

Gracias a esta modificación, al regresar al archivo de *index.html,* ya estará disponible la opción de *“Open with Live Server”*, la cual se debe seleccionar ![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.037.png) Esto permitirá que se abra automáticamente una pestaña en el navegador Chrome apuntando al servidor HTTP local en la dirección *([*http://127.0.0.1:5500/index.html*](http://127.0.0.1:5500/index.html))*

- Se verificó el renderizado completo de las métricas (10,641 registros, sumatoria de consumo y gráficas interactivas) operando 100% de manera local

![](Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.038.jpeg)

# <a name="bibliografía"></a><a name="_bookmark7"></a>**Bibliografía**


*Velázquez Arrieta, E. U., Pulido Morales, O. F., García López, E., Hernández Martínez,*

*C. A., y Hurtado Avilés, G. (en prensa). Territorial information retrieval from heterogeneous open data through the construction of a data warehouse for water management in Mexico City. En Advances in Computer Science Applications and Research. Springer.*

*Hurtado Avilés, G. (2024). Data Warehouse Static: Base de datos y visualización de consumo	de	agua	CDMX	(Versión	1.5).	GitHub[*.*](https://github.com/gabrielhuav/Data_Warehouse_static?utm_source=gemini) [*https://github.com/gabrielhuav/Data_Warehouse_static*](https://github.com/gabrielhuav/Data_Warehouse_static)*

*Docker Inc. (2024). Docker compose overview and container isolation (Versión 2.x). Docker Docs[*.*](https://docs.docker.com/?utm_source=gemini) [*https://docs.docker.com/*](https://docs.docker.com/)*

*Microsoft. (2024). Visual Studio Code: Workspace trust and local web server execution. VS Code Docs[*.*](https://code.visualstudio.com/docs?utm_source=gemini) [*https://code.visualstudio.com/docs*](https://code.visualstudio.com/docs)*

*Programando en JAVA. (2024, 19 enero). GitHub y Git: Crear Fork - tutorial completo y fácil. YouTube. [*https://www.youtube.com/watch?v=t1Ym6BzTH_M*](https://www.youtube.com/watch?v=t1Ym6BzTH_M)*

*Pablo Asensi, AI Developer. (2024, 28 mayo). Usar LIVE SERVER en VISUAL STUDIO CODE. YouTube. [*https://www.youtube.com/watch?v=EjRGkMbSFa8*](https://www.youtube.com/watch?v=EjRGkMbSFa8)*

[ref1]: Aspose.Words.d4f2c4e7-b243-46ba-9e6a-9d9f92d1d39d.002.png
