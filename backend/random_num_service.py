from flask import Flask, jsonify
import random
import mysql.connector

app = Flask(__name__)

mydb = mysql.connector.connect(
    host="34.78.222.122",
    user="number-generator",
    password="Test1234!",
    database="db-instance"
)
print("sql config done")
cursor = mydb.cursor()

@app.route('/generate_number')
def generate_random_numbers():
    print("generating numbe")
    number = random.randint(1, 100000)
    instance_name = "instance1"  
    insert_query = "INSERT INTO instances (number, instance_name) VALUES (%s, %s)"
    cursor.execute(insert_query, (number, instance_name))
    mydb.commit()  
    return jsonify({"number": number})

@app.route('/return_numbers')
def return_random_numbers():
    cursor.execute("SELECT MIN(number), MAX(number) FROM generated_numbers")
    min_max = cursor.fetchone()
    cursor.execute("SELECT COUNT(*) FROM instances GROUP BY generated_numbers")
    counts = cursor.fetchall()
    cursor.execute("SELECT number FROM generated_numbers")
    numbers = cursor.fetchall()
    return jsonify({"min_max": min_max, "counts": counts, "numbers": numbers})

@app.route('/restart', methods=['GET'])
def restart():
    print("restart called")
    cursor.execute("TRUNCATE TABLE generated_numbers")
    mydb.commit()
    return "Table reset successful."

if __name__ == '__main__':
    app.run()

