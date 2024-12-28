import adafruit_dht
import board
import time
import busio
import requests
from adafruit_bmp280 import Adafruit_BMP280_I2C
import RPi.GPIO as GPIO
import math

# Configuración
pin = board.D17  # Pin físico GPIO4 de la Raspberry Pi
sensor = adafruit_dht.DHT11(pin)

SENSOR_PIN = 24
contador = 0
radio = 0.2
circunferencia = 2 * math.pi * radio

GPIO.setmode(GPIO.BCM)
GPIO.setup(SENSOR_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

def calcular_humedad_absoluta(temperatura, humedad_relativa):
    # Constantes
    R = 461.5  # J/(kg·K)

    # Cálculo de la presión de saturación (Pvs) usando la fórmula de la imagen
    Pvs = 6.112 * math.exp((17.67 * temperatura) / (temperatura + 243.5))  # en hPa

    # Convertir Pvs a Pa
    Pvs = Pvs * 100  # de hPa a Pa

    # Cálculo de la presión parcial del vapor de agua (Pv)
    Pv = (humedad_relativa / 100) * Pvs  # en Pa

    # Convertir la temperatura a Kelvin
    T_kelvin = temperatura + 273.15

    # Cálculo de la humedad absoluta (HA) en g/m³ usando la fórmula de la imagen
    humedad_absoluta = (Pv * 100) / (R * T_kelvin)  # en g/m³

    return humedad_absoluta

# URL del servidor Flask
URL_FLASK = "http://192.168.0.4:5000/guardar_datos"  # Cambia <IP_DEL_SERVIDOR> por la IP de tu servidor Flask

try:
    # Inicializa I2C
    i2c = busio.I2C(board.SCL, board.SDA)
    bmp280 = Adafruit_BMP280_I2C(i2c, address=0x76)

    # Configura parámetros opcionales
    bmp280.sea_level_pressure = 1013.25  # Presión al nivel del mar en hPa
    
    estado_anterior = GPIO.input(SENSOR_PIN)
    ultimo_tiempo = time.time()

    while True:
        tiempo_actual = time.time()

        # Detectar cambios de estado del sensor para contar vueltas
        estado_actual = GPIO.input(SENSOR_PIN)
        if estado_actual == 1 and estado_anterior == 0:
            contador += 1

        # Procesar e imprimir todos los datos cada 2 segundos
        if tiempo_actual - ultimo_tiempo >= 2:
            # Cálculo de velocidad
            rps = contador / 2  # Promedio de RPS en 2 segundos
            ms = rps * circunferencia
            km = ms * 3.6
            print(f"Revoluciones por segundo: {rps:.2f}")
            print(f"Velocidad: {ms:.2f} m/s")

            # Leer temperatura y humedad del DHT11
            try:
                temperature = sensor.temperature
                humidity = sensor.humidity
                
                humedad_absoluta = calcular_humedad_absoluta(temperature, humidity)

                if humidity is not None and temperature is not None:
                    print(f"Humedad del sensor DHT11: {humidity:.1f}%")
                    print(f"Humedad absoluta del sensor DHT11: {humedad_absoluta:.2f} g/m^3")
                else:
                    print("Error al leer el sensor DHT11.")
            except RuntimeError as error:
                print(f"Error temporal en el sensor DHT11: {error}")

            # Leer presión del BMP280
            try:
                presion = bmp280.pressure
                print(f"Presión del sensor BMP280: {presion:.2f} hPa")
            except RuntimeError as error:
                print(f"Error temporal en el sensor BMP280: {error}")

            # Enviar datos al servidor Flask
            datos = {
                "temperatura": temperature,
                "humedadRelativa": humidity,
                "humedadAbsoluta": humedad_absoluta,
                "velocidadViento": ms,
                "presionBarometrica": presion
            }

            try:
                response = requests.post(URL_FLASK, json=datos)
                if response.status_code == 201:
                    print("Datos enviados correctamente a MongoDB.")
                else:
                    print(f"Error al enviar datos: {response.status_code} - {response.text}")
            except requests.exceptions.RequestException as e:
                print(f"Error al conectar con el servidor Flask: {e}")

            print("------"*10)

            # Reiniciar contador y tiempo
            contador = 0
            ultimo_tiempo = tiempo_actual

        estado_anterior = estado_actual

        # Pequeña pausa para reducir carga del CPU
        time.sleep(0.1)

except KeyboardInterrupt:
    print("\nPrograma terminado.")
    GPIO.cleanup()
