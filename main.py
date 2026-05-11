from sqlalchemy import create_engine, text
from config import *
import pandas as pd
from pathlib import Path

# 🔹 Configuración
DATA_DIR = Path(__file__).parent.parent / "data"

# 🔹 Conexión
def conection_bd():
    url_db = f"mysql+mysqlconnector://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:3306/{DB_NAME}"
    engine = create_engine (url_db)
    return engine.connect()


# 🔹 Test conexión
def test_connection():
    connection = conection_bd()
    try:
        with connection:
            print("✅ Conexión exitosa")
            result = connection.execute(text("SELECT * FROM customer LIMIT 1;"))
            print(result.fetchone())
    except Exception as e:
        print(f"❌ Error: {e}")


# 🔹 DATAFRAME CLIENTES
def get_customer_activity():
    connection = conection_bd()
    
    with connection:
        query = """
            SELECT
                c.customer_id,
                LOWER(c.first_name) AS first_name,
                LOWER(c.last_name) AS last_name,
                LOWER(c.email) AS email,
                ci.city,
                co.country,
                r.rental_id,
                r.rental_date,
                r.return_date,
                p.payment_id,
                p.amount
            FROM customer c
            JOIN address a ON c.address_id = a.address_id
            JOIN city ci ON a.city_id = ci.city_id
            JOIN country co ON ci.country_id = co.country_id
            JOIN rental r ON c.customer_id = r.customer_id
            JOIN payment p ON r.rental_id = p.rental_id
            WHERE 
                r.return_date IS NOT NULL
                AND p.amount > 0;
        """

        result = connection.execute(text(query))
        rows = result.fetchall()
        columns = result.keys()

        df = pd.DataFrame(rows, columns=columns)

        # Exportar CSV
        df.to_csv(
            DATA_DIR/"customer_activity.csv",
            index=False,
            encoding="utf-8"
        )

        print("✅ CSV creado: data/customer_activity.csv")

        return df


# 🔹 Ejecutar
if __name__ == "__main__":
    test_connection()
    get_customer_activity()