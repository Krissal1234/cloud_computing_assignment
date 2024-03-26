from flask import Flask, jsonify
import random
import sqlalchemy
from google.cloud.sql.connector import Connector
import os
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  

connector = Connector()

def getconn():
    conn= connector.connect(
        "loyal-saga-418216:europe-west1:db-instance",
        "pymysql",
        user="number-generator",
        password= 'Test1234!',
        db="number-generator"
    )
    return conn

pool = sqlalchemy.create_engine(
    "mysql+pymysql://",
    creator=getconn,
)
print("sql config done")

@app.route('/')
def home():
    return jsonify({"message": "test"})

@app.route('/generate_number')
def generate_random_number():
    print("generating number")
    number = random.randint(1, 100000)
    instance_name = os.getenv('GAE_INSTANCE', 'default_instance') 
    insert_query = sqlalchemy.text("INSERT INTO generated_numbers (number, instance_name) VALUES (:number, :instance_name)")
    with pool.connect() as db_connection:
        db_connection.execute(insert_query, {'number': number, 'instance_name': instance_name})
        db_connection.commit()
    return jsonify({"number": number})

@app.route('/return_numbers')
def return_random_numbers():
    min_query = sqlalchemy.text("SELECT number, instance_name FROM generated_numbers ORDER BY number ASC LIMIT 1")
    max_query = sqlalchemy.text("SELECT number, instance_name FROM generated_numbers ORDER BY number DESC LIMIT 1")
    count_query = sqlalchemy.text("SELECT COUNT(*) FROM generated_numbers")
    numbers_query = sqlalchemy.text("SELECT number FROM generated_numbers")
    with pool.connect() as db_connection:
        min_result = db_connection.execute(min_query).fetchone()
        max_result = db_connection.execute(max_query).fetchone()

        total_count = db_connection.execute(count_query).scalar()
        numbers = [row[0] for row in db_connection.execute(numbers_query).fetchall()]

        min_number, min_instance = min_result if min_result else (None, None)
        max_number, max_instance = max_result if max_result else (None, None)
    return jsonify({ "min": {"number": min_number, "instance_name": min_instance},
        "max": {"number": max_number, "instance_name": max_instance}, "count": total_count, "numbers": numbers})

@app.route('/restart', methods=['GET'])
def restart():
    print("restart called")
    query = sqlalchemy.text("TRUNCATE TABLE generated_numbers")
    with pool.connect() as db_connection:
        db_connection.execute(query)
        db_connection.commit()
    return jsonify({"message": "Table reset successful."})  

if __name__ == '__main__':
    app.run(host='0.0.0.0', port = 8080)

