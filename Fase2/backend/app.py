from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
from datetime import datetime
import random
import os
import python_weather
import asyncio

# Crear la aplicación Flask
app = Flask(__name__)

# Configurar CORS
CORS(app)

# Conectar con MongoDB
client = MongoClient('mongodb+srv://georgealexdlb:5QAwFL1u31UrHytj@cluster0.9bed3.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0')
db = client['datos_tiempo_real']
collection = db['lecturas']

async def getweather() -> None:
    # declare the client. the measuring unit used defaults to the metric system (celcius, km/h, etc.)
    async with python_weather.Client(unit=python_weather.METRIC) as client:
        # fetch a weather forecast from a city
        weather = await client.get('Guatemala')
        
        # returns the current day's forecast temperature (int)
        return weather.temperature
      

# Ruta para obtener todos los datos
@app.route('/obtener_datos', methods=['GET'])
def obtener_datos():
    datos = collection.find_one({}, {"_id": 0}, sort=[('timestamp', -1)])
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
    temperaturaExterna = asyncio.run(getweather())
    datos['temperaturaExterna'] = temperaturaExterna
    # ------------------ ESTO ES PARA PRUEBAS ------------------
    # datos = {
    #         "timestamp": datetime.now(),
    #         "temperaturaInterna": random.randint(10,80) * 100,
    #         "temperaturaExterna": temperaturaExterna,
    #         "humedadSuelo": random.random() * 10,
    #         "nivel": random.random() * 10,
    #         "periodoActivacionAgua": random.randint(0,1),
    #         "periodoActivacionAire": random.randint(0,1)
    #     }
    # datos['temperaturaExterna'] = temperaturaExterna
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
