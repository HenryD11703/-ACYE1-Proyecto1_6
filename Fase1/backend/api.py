from flask import Flask, request, jsonify
from pymongo import MongoClient
from datetime import datetime
import os

# Crear la aplicación Flask
app = Flask(__name__)

# Conectar con MongoDB
# Reemplaza <CONNECTION_STRING> con tu conexión de MongoDB
client = MongoClient('mongodb+srv://georgealexdlb:5QAwFL1u31UrHytj@cluster0.9bed3.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0')
db = client['datos_tiempo_real']  # Nombre de la base de datos
collection = db['lecturas']       # Nombre de la colección

# Ruta para guardar datos en MongoDB
@app.route('/guardar_datos', methods=['POST'])
def guardar_datos():
    if request.is_json:
        datos = request.get_json()
        datos['timestamp'] = datetime.now()  # Agregar la hora actual
        result = collection.insert_one(datos)   # Guardar en MongoDB
        return jsonify({"message": "Datos guardados", "id": str(result.inserted_id)}), 201
    else:
        return jsonify({"error": "El formato no es JSON"}), 400

# Ruta para obtener todos los datos
@app.route('/obtener_datos', methods=['GET'])
def obtener_datos():
    datos = collection.find_one({}, {"_id": 0}, sort=[('timestamp', -1)])
    return jsonify(datos), 200

@app.route('/ObtenerDatosPorFechas', methods=['POST'])
def getMedicionesPorFechas():
    # Obtener las fechas del cuerpo de la solicitud
    data = request.get_json()
    fechaIni = data.get('fechaInicial')
    fechaFin = data.get('fechaFinal')
    filtro = {}

    # Convertir fechas a formato datetime
    if fechaIni:
        fechaIni = datetime.strptime(fechaIni, '%Y-%m-%d')
        filtro['timestamp'] = {'$gte': fechaIni}
    if fechaFin:
        fechaFin = datetime.strptime(fechaFin, '%Y-%m-%d')
        if 'timestamp' in filtro:
            filtro['timestamp']['$lte'] = fechaFin
        else:
            filtro['timestamp'] = {'$lte': fechaFin}

    # Realizar la consulta y convertir ObjectId a string
    datos = list(collection.find(filtro))
    for dato in datos:
        dato['_id'] = str(dato['_id'])  # Convertir ObjectId a string

    return jsonify(datos), 200


# Iniciar el servidor
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
#{"temperatura": 23, "humedad": 60}
