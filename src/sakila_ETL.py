import pandas as pd

from sqlalchemy import create_engine
from pathlib import Path

from src.config import (
    DB_USER,
    DB_PASSWORD,
    DB_HOST,
    DB_NAME
)

# -----------------------------
# CONEXIÓN MYSQL
# -----------------------------

engine = create_engine("mysql+pymysql://root:Segovia1991*@127.0.0.1/sakila"
)

# -----------------------------
# RUTAS
# -----------------------------

QUERIES_PATH = Path("queries")
OUTPUT_PATH = Path("output")

OUTPUT_PATH.mkdir(exist_ok=True)

# -----------------------------
# EJECUTAR SQL
# -----------------------------

for sql_file in QUERIES_PATH.glob("*.sql"):

    try:

        print(f"\nEjecutando query: {sql_file.name}")

        content = sql_file.read_text(encoding="utf-8")

        queries = content.split(";")

        query = [q.strip() for q in queries if q.strip()][-1]

        query = query.replace("%", "%%")

        with engine.connect() as connection:

            df = pd.read_sql(query, connection)

        print(f"DataFrame creado: {sql_file.stem}")

        csv_name = sql_file.stem + ".csv"

        output_file = OUTPUT_PATH / csv_name

        df.to_csv(
            output_file,
            index=False,
            encoding="utf-8-sig"
        )

        print(f"CSV generado: {csv_name}")

    except Exception as e:

        print(f"\n❌ Error en {sql_file.name}")
        print(e)

print("\nProceso ETL completado correctamente.")