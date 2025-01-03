import io
from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
from pymongo import MongoClient
from datetime import datetime
import random
import os
import python_weather
import asyncio
import csv
from io import StringIO, BytesIO
import csv

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

@app.route('/obtener_todos_datos', methods=['GET'])
def obtener_todos_datos():
    try:
        datos = list(collection.find({}))
        
        # Convertir ObjectId a string y formatear timestamp
        for dato in datos:
            dato['_id'] = str(dato['_id'])
            if 'timestamp' in dato:
                dato['timestamp'] = dato['timestamp'].isoformat()  # Convertir a formato ISO
        
        return jsonify(datos), 200
    except Exception as e:
        return jsonify({"error": "Ocurrió un error al obtener los datos", "detalles": str(e)}), 500

# Ruta para obtener todos los datos
@app.route('/obtener_datos', methods=['GET'])
def obtener_datos():
    datos = collection.find_one({}, {"_id": 0}, sort=[('timestamp', -1)])
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
    temperaturaExterna = asyncio.run(getweather())
    datos['temperaturaExterna'] = temperaturaExterna
    if (datos['humedadSuelo'] == 0 ):
        datos['humedadSuelo'] = 80 # Húmedo
    else:
        datos['humedadSuelo'] = 20 # Seco

    print(datos)
    return jsonify(datos), 200
    
@app.route('/ObtenerDatosPorFechas', methods=['POST'])
def getMedicionesPorFechas():
    # Obtener las fechas del cuerpo de la solicitud
    data = request.get_json()
    fechaIni = data.get('fechaInicial')
    fechaFin = data.get('fechaFinal')
    filtro = {}

    # Convertir fechas a formato datetime incluyendo la hora
    if fechaIni:
        fechaIni = datetime.strptime(fechaIni, '%Y-%m-%dT%H:%M')
        filtro['timestamp'] = {'$gte': fechaIni}
    if fechaFin:
        fechaFin = datetime.strptime(fechaFin, '%Y-%m-%dT%H:%M')
        if 'timestamp' in filtro:
            filtro['timestamp']['$lte'] = fechaFin
        else:
            filtro['timestamp'] = {'$lte': fechaFin}

    # Realizar la consulta y convertir ObjectId a string
    datos = list(collection.find(filtro))
    for dato in datos:
        dato['_id'] = str(dato['_id'])  # Convertir ObjectId a string
        # Asegurar que el timestamp se envíe en formato ISO
        if 'timestamp' in dato:
            dato['timestamp'] = dato['timestamp']

    return jsonify(datos), 200

@app.route('/generar_csv', methods=['GET'])
def generar_csv():
    try:
        datos = list(collection.find({}, {"_id": 0}).limit(5))
        
        output_text = StringIO()
        writer = csv.writer(output_text)

        if datos:
            #encabezados = datos[0].keys()
            #Fecha y Hora,Temperatura Interna (Â°C),Temperatura Externa (Â°C),Estado del Suelo,Nivel de Agua,Sistema de Riego,Sistema de VentilaciÃ³n
            encabezados = [
                "timestamp",
                "temperaturaInterna",
                "temperaturaExterna",
                "humedadSuelo",
                "nivel",
                "periodoActivacionAgua",
                "periodoActivacionAire"
            ]

            writer.writerow(encabezados)

            for dato in datos:
                fila = []
                fila.append(dato.get("timestamp", ''))
                fila.append(dato.get("temperaturaInterna", ''))
                fila.append(dato.get("temperaturaExterna", ''))

                humedad = dato.get("humedadSuelo", 0)
                humedo = "Húmedo" if humedad >= 80 else "Seco"

                fila.append(humedo)
                fila.append(int(dato.get("nivel", 0)))

                activacionAgua = "Activado" if dato.get("periodoActivacionAgua", 0) == 1 else "Desactivado"
                fila.append(activacionAgua)

                activacionVentilador = "Activado" if dato.get("periodoActivacionAire", 0) == 1 else "Desactivado"
                fila.append(activacionVentilador)

                #writer.writerow([str(dato.get(key, '')) for key in encabezados])}
                writer.writerow(fila)

        output = BytesIO(output_text.getvalue().encode('utf-8'))

        output.seek(0)

        return send_file(
            output,
            mimetype='text/csv',
            as_attachment=True,
            download_name='datos.csv'
        )
    except Exception as e:
        return jsonify({"error": "Ocurrió un error al generar el archivo CSV", "detalles": str(e)}), 500
    
    
def calculate_statistics(numbers):
    """Calcula estadísticas básicas para una lista de números"""
    if not numbers:
        return {
            'mode': 0,
            'mean': 0,
            'max': 0,
            'min': 0,
            'range': 0
        }
    
    # Convertir todos los valores a float
    numbers = [float(x) for x in numbers]
    
    # Calcular moda
    freq = {}
    for num in numbers:
        freq[num] = freq.get(num, 0) + 1
    mode = max(freq.items(), key=lambda x: x[1])[0]
    
    # Calcular resto de estadísticas
    mean = sum(numbers) / len(numbers)
    max_val = max(numbers)
    min_val = min(numbers)
    range_val = max_val - min_val
    
    return {
        'mode': round(mode, 2),
        'mean': round(mean, 2),
        'max': round(max_val, 2),
        'min': round(min_val, 2),
        'range': round(range_val, 2)
    }

@app.route('/analyze', methods=['POST'])
def analyze_data():
    try:
        # Obtener datos CSV del request
        csv_data = request.json['csv_data']
        
        # Preparar listas para almacenar los datos
        temp_internal = []
        temp_external = []
        water_level = []
        
        # Procesar el CSV
        csv_reader = csv.DictReader(io.StringIO(csv_data))
        for row in csv_reader:
            # Limpiar y extraer datos
            temp_int = row['temperaturaInterna']
            temp_ext = row['temperaturaExterna']
            water = row['nivel'].strip()
            
            # Agregar a las listas correspondientes
            temp_internal.append(float(temp_int))
            temp_external.append(float(temp_ext))
            water_level.append(float(water))
        
        # Calcular estadísticas para cada métrica
        result = {
            'temp_internal': calculate_statistics(temp_internal),
            'temp_external': calculate_statistics(temp_external),
            'water_level': calculate_statistics(water_level)
        }
        
        # Formatear resultado final
        final_result = {
            'mode': {
                'temp_internal': result['temp_internal']['mode'],
                'temp_external': result['temp_external']['mode'],
                'water_level': result['water_level']['mode']
            },
            'mean': {
                'temp_internal': result['temp_internal']['mean'],
                'temp_external': result['temp_external']['mean'],
                'water_level': result['water_level']['mean']
            },
            'max': {
                'temp_internal': result['temp_internal']['max'],
                'temp_external': result['temp_external']['max'],
                'water_level': result['water_level']['max']
            },
            'min': {
                'temp_internal': result['temp_internal']['min'],
                'temp_external': result['temp_external']['min'],
                'water_level': result['water_level']['min']
            },
            'range': {
                'temp_internal': result['temp_internal']['range'],
                'temp_external': result['temp_external']['range'],
                'water_level': result['water_level']['range']
            }
        }
        
        return jsonify(final_result)

    except Exception as e:
        print(f"Error: {str(e)}")  # Para debuggear
        return jsonify({'error': str(e)}), 400

# Iniciar el servidor
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
