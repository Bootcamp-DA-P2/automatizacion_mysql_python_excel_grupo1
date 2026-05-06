# 📊 Flujo de Datos SQL - Grupo 1
## Proyecto: Database Sakila - Análisis de Clientes (DF1)

Este proyecto se enfoca en la extracción, limpieza y preprocesamiento de datos utilizando la base de datos **Sakila**. El flujo de trabajo combina la potencia de **SQL** para la gestión relacional y **Python** para el análisis avanzado.

---

## 📑 Resumen del Proyecto
El flujo integra `Joins` complejos entre múltiples tablas, validación de integridad, normalización y generación de un dataset depurado. Nos centramos específicamente en la gestión de **alquileres y pagos de clientes** para garantizar datos listos para modelos analíticos.

> **¿Por qué este Dataset?** 💡  
> Elegimos el **DataFrame de Clientes** debido a su alta dimensionalidad y potencial estratégico. Es el eje central que permite conectar el comportamiento del usuario con las métricas de negocio.

---

## 🛠️ Tecnologías Utilizadas

![SQL](https://img.shields.io/badge/SQL-MySQL-orange) ![Python](https://img.shields.io/badge/Python-Data%20Analysis-blue) ![Pandas](https://img.shields.io/badge/Pandas-Data%20Processing-green)

El stack técnico seleccionado para este proyecto incluye:
*   **SQL (MySQL):** Extracción y estructuración de datos relacionales.
*   **Python 3.x:** Lenguaje principal para el procesamiento de datos.
*   **Pandas:** Manipulación, limpieza y análisis de DataFrames.
*   **Matplotlib / Seaborn:** Visualización de tendencias y distribuciones.
*   **Missingno:** Análisis visual de la integridad de los datos (nulos).
*   **Python-dotenv:** Gestión segura de credenciales mediante variables de entorno.

---

## 🧼 Proceso de Limpieza y Transformación

### Fase 1: SQL (MySQL Workbench) 🗄️
En la etapa inicial, preparamos la estructura desde la base de datos:
*   **Estandarización:** Se transformaron todos los nombres de campos a minúsculas para evitar conflictos de sintaxis:
    > `first_name`, `last_name`, `email`, `active`, `address`, `district`, `postal_code`, `city`, `country`, `rental_date`, `return_date`, `amount`, `payment_date`.

### Fase 2: Python (Google Colab / Local) 🐍
Tras exportar los datos, aplicamos técnicas de limpieza profunda:
*   **Tipado de Datos:** Conversión de columnas a formato `datetime` para análisis temporal.
*   **Depuración de Duplicados:** Identificación y eliminación de registros repetidos.
*   **Gestión de Nulos:** 
    *   Conversión de celdas vacías o con espacios en blanco a `NaN`.
    *   Eliminación sistemática de valores nulos para asegurar la calidad.
*   **Normalización de Texto:** Conversión de strings a minúsculas y eliminación de espacios residuales (*stripping*).

  ### 📈 Visualización del dataset tras pre-limpieza en SQL
  

![dataset prelimpieza](assets/pre-cleaning.png)



---

## 🧠 ¿Por qué hemos tomado estas decisiones técnicas?

La arquitectura de este proyecto se seleccionó para maximizar la eficiencia en cada etapa:

*   **SQL para el filtrado inicial:** Realizar los `JOINs` en **MySQL** reduce drásticamente el volumen de datos transferidos, optimizando el uso de memoria.
*   **Python para la limpieza lógica:** **Pandas** es superior para la limpieza semántica (detección de nulos complejos y gestión de duplicados) gracias a su flexibilidad.
*   **Variables de Entorno (.env):** Implementamos seguridad mediante archivos `.env` para evitar que información sensible sea expuesta en el repositorio.
*   **Normalización a minúsculas:** Elimina errores de duplicidad "falsa" (ej. 'Madrid' vs 'madrid') y facilita las consultas posteriores.
*   **Formato Datetime:** Permite realizar cálculos temporales, como la duración media de los alquileres.

---

## 🚀 Guía de Ejecución

Sigue estos pasos para replicar el entorno localmente:

1.  **Entorno Virtual:** Crea y activa tu entorno virtual para aislar las dependencias del proyecto.
2.  **Dependencias:** Instala las librerías necesarias ejecutando:
    ```bash
    pip install -r requirements.txt
    ```
3.  **Extracción de Datos (SQL a CSV):** Ejecuta el script principal para conectar con la base de datos y generar el archivo de intercambio:
    ```bash
    python main.py
    ```
    > **Nota:** Este paso procesa los datos de MySQL y los exporta automáticamente a un archivo `.csv` en la carpeta raíz.
4.  **Visualización y Análisis:** Abre el entorno de Jupyter Notebook y ejecuta el archivo de análisis:
    ```bash
    jupyter notebook
    ```
    * El notebook cargará el `.csv` generado.
    * Se mostrarán las tablas de datos procesadas y los gráficos estadísticos resultantes.
