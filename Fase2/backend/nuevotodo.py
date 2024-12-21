import RPi.GPIO as GPIO
import time
from RPLCD.i2c import CharLCD
import adafruit_dht
import board

# Configuración del sensor DHT11
dht_sensor = adafruit_dht.DHT11(board.D4)  # Configura el pin conectado al DHT11

# Configuración de la pantalla LCD
lcd = CharLCD('PCF8574', 0x27, cols=16, rows=2)  # Dirección I2C de la pantalla

# Configuración de los pines
GPIO_TRIGGER = 11  # Pin GPIO conectado al Trig del ultrasónico
GPIO_ECHO = 8      # Pin GPIO conectado al Echo del ultrasónico
GPIO_BOMBA = 18    # Pin GPIO para la bomba
GPIO_SENSOR_SUELO = 27  # Pin GPIO para el sensor de humedad
GPIO_VENTILADOR = 21  # Pin GPIO para el ventilador

# Configuración de la Raspberry Pi
GPIO.setmode(GPIO.BCM)
GPIO.setup(GPIO_TRIGGER, GPIO.OUT)
GPIO.setup(GPIO_ECHO, GPIO.IN)
GPIO.setup(GPIO_BOMBA, GPIO.OUT)
GPIO.setup(GPIO_SENSOR_SUELO, GPIO.IN)
GPIO.setup(GPIO_VENTILADOR, GPIO.OUT)

GPIO.output(GPIO_BOMBA, False)
GPIO.output(GPIO_VENTILADOR, False)

def medir_distancia():
    # Enviar pulso de inicio
    GPIO.output(GPIO_TRIGGER, True)
    time.sleep(0.00001)  # Pulso de 10 microsegundos
    GPIO.output(GPIO_TRIGGER, False)

    # Medir el tiempo de ida y vuelta
    inicio = time.time()
    while GPIO.input(GPIO_ECHO) == 0:
        inicio = time.time()

    while GPIO.input(GPIO_ECHO) == 1:
        fin = time.time()

    # Calcular la duración del pulso
    duracion = fin - inicio

    # Convertir tiempo a distancia
    distancia = (duracion * 34300) / 2  # Velocidad del sonido: 34300 cm/s
    return distancia

def mostrar_deslizando(mensaje, linea):
    """
    Desliza un mensaje más largo que la pantalla en una línea específica.
    :param mensaje: Texto a mostrar.
    :param linea: Línea de la pantalla (1 o 2).
    """
    if len(mensaje) <= 16:
        lcd.cursor_pos = (linea - 1, 0)
        lcd.write_string(mensaje.ljust(16))
    else:
        for i in range(len(mensaje) - 15):
            lcd.cursor_pos = (linea - 1, 0)
            lcd.write_string(mensaje[i:i+16])
            time.sleep(0.3)  # Velocidad del desplazamiento

try:
    while True:
        # Medir la distancia del sensor ultrasónico
        distancia = medir_distancia()

        # Calcular el porcentaje ocupado
        if distancia <= 13 and distancia >= 3:
            porcentaje_ocupado = ((13 - distancia) / 10) * 100
            mensaje_agua = f"Nivel del agua: {porcentaje_ocupado:.1f}%"
        else:
            if distancia > 13:
                mensaje_agua = "Nivel del agua: 0% (Vacío)"
            elif distancia < 3:
                mensaje_agua = "Nivel del agua: 100% (Lleno)"
        
        print(mensaje_agua)

        # Leer el estado del sensor de humedad
        estado_suelo = GPIO.input(GPIO_SENSOR_SUELO)
        if estado_suelo == GPIO.HIGH:
            mensaje_suelo = "Suelo seco. Bomba ON"
            GPIO.output(GPIO_BOMBA, True)  # Encender la bomba
            time.sleep(20)  # Mantener la bomba encendida por 20 segundos
            GPIO.output(GPIO_BOMBA, False)  # Apagar la bomba
        else:
            mensaje_suelo = "Suelo húmedo. Bomba OFF"
            GPIO.output(GPIO_BOMBA, False)

        print(mensaje_suelo)

        # Leer datos del sensor DHT11
        try:
            temperatura = dht_sensor.temperature
            humedad = dht_sensor.humidity
            if temperatura is not None and humedad is not None:
                print(f"Temp: {temperatura:.1f}C  Hum: {humedad:.1f}%")

                # Controlar el ventilador según la temperatura
                if temperatura > 35:
                    GPIO.output(GPIO_VENTILADOR, True)
                    mensaje_temp = "Ventilador ON"
                else:
                    GPIO.output(GPIO_VENTILADOR, False)
                    mensaje_temp = "Ventilador OFF"

                # Mostrar advertencia si la temperatura es >25
                if temperatura > 25:
                    mensaje_advertencia = "Temp alta! <25"
                else:
                    mensaje_advertencia = "Temp normal"
            else:
                print("No se pudieron leer los datos del DHT11")
                mensaje_temp = "Error sensor"
                mensaje_advertencia = "----"
        except RuntimeError as error:
            print(f"Error en DHT11: {error}")
            mensaje_temp = "Error sensor"
            mensaje_advertencia = "----"
        except OverflowError as error:
            print(f"Error de buffer en DHT11: {error}")
            mensaje_temp = "Error sensor"
            mensaje_advertencia = "----"

        # Mostrar los mensajes en la pantalla LCD
        lcd.clear()
        mostrar_deslizando(mensaje_agua, 1)  # Línea 1
        mostrar_deslizando(mensaje_suelo, 2)  # Línea 2
        time.sleep(2)

        lcd.clear()
        mostrar_deslizando(mensaje_temp, 1)  # Línea 1
        mostrar_deslizando(mensaje_advertencia, 2)  # Línea 2

        # Pausa entre lecturas
        time.sleep(2)  # Ajustado a 2 segundos para evitar problemas con el sensor

except KeyboardInterrupt:
    print("Programa detenido por el usuario")
    lcd.clear()
    lcd.write_string("Programa detenido")
    time.sleep(2)
finally:
    lcd.clear()
    lcd.close()
    GPIO.cleanup()
