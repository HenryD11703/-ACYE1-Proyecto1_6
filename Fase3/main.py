from prettytable import PrettyTable
import re

def leer_archivo(file_path, prefix):
    datos = {}
    with open(file_path, 'r') as file:
        for line in file:
            if line.strip():  # Ignorar líneas vacías
                key, value = line.split(':')
                # Limpiar caracteres no imprimibles
                value = re.sub(r'[^\d.]+', '', value)
                # Remover el prefijo para unificar las claves
                key = key.replace(prefix, '').strip()
                datos[key] = float(value.strip())
    return datos

def mostrar_tabla(medianas, promedios):
    tabla = PrettyTable()
    tabla.field_names = ["Medida", "Mediana", "Promedio"]

    for key in medianas:
        mediana = medianas[key]
        promedio = promedios.get(key, 'N/A')  # Usar 'N/A' si la clave no está en promedios
        tabla.add_row([key, mediana, promedio])

    print(tabla)

if __name__ == "__main__":
    medianas = leer_archivo('medianas.txt', 'Mediana')
    promedios = leer_archivo('promedios.txt', 'Promedio')
    mostrar_tabla(medianas, promedios)