import requests
import random
from datetime import datetime, timedelta

def generar_datos_meteorologicos():
    """
    Genera datos meteorológicos simulados
    """
    return {
        "fechaHora": datetime.utcnow().isoformat() + "Z",
        "temperatura": round(random.uniform(15.0, 35.0), 1),
        "humedadRelativa": round(random.uniform(30.0, 90.0), 1),
        "humedadAbsoluta": round(random.uniform(0.005, 0.025), 3),
        "velocidadViento": round(random.uniform(0.0, 10.0), 1),
        "presionBarometrica": round(random.uniform(1000.0, 1030.0), 2)
    }

def enviar_datos_api(url, datos):
    """
    Envía datos a la API
    """
    try:
        response = requests.post(url, json=datos)
        response.raise_for_status()  # Lanza una excepción para códigos de error
        print(f"Datos enviados con éxito: {response.json()}")
    except requests.exceptions.RequestException as e:
        print(f"Error al enviar datos: {e}")

def main():
    # URL de tu API (ajusta según sea necesario)
    api_url = 'http://localhost:5000/guardar_datos'
    
    # Enviar 10 conjuntos de datos de ejemplo
    for _ in range(10):
        datos = generar_datos_meteorologicos()
        enviar_datos_api(api_url, datos)

if __name__ == '__main__':
    main()