import { useState } from "react";
import { Link } from "react-router-dom";
import axios from "axios";
import './Menu.css';
import temperaturaExterna from '../img/temperatura.png';
import temperaturaInterna from '../img/temperatura_interna.png';
import humedadSuelo from '../img/humedad_abs.png';
import nivelAgua from '../img/nivel_agua.png';
import periodoAgua from '../img/tanque_agua.png';
import periodoAire from '../img/aire_acondicionado.png';
import estadisticas from '../img/estadisticas.png';
import RealTimeChartFase2 from "./RealTimeChartFase2";

const MenuFase2 = () => {
    const [metric, setMetric] = useState<string | null>(null);

    const mostrarGrafica = (tipo: 'temperaturaInterna' | 'temperaturaExterna' | 'humedadSuelo' | 'nivelAgua'
        | 'humedadSueloTiempo' | 'nivelAguaTiempo' | 'periodoActivacionAgua' | 'periodoActivacionAire') => {
        setMetric(tipo);
    };

    const descargarCSV = async () => {
        try {
            const response = await axios.get('http://localhost:5000/generar_csv', {
                responseType: 'blob', // Asegura que la respuesta sea tratada como un archivo binario
            });

            // Crear un URL para el archivo recibido
            const url = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', 'datos.csv'); // Nombre del archivo
            document.body.appendChild(link);
            link.click();

            // Limpiar el objeto URL para liberar memoria
            document.body.removeChild(link);
            window.URL.revokeObjectURL(url);
        } catch (error) {
            console.error("Error al descargar el archivo CSV:", error);
        }
    };

    return (
        <div className="container">
            <div className="menu">
                <h1>Monitoreo y Riego</h1>
                <div className="grid">
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('temperaturaInterna')}>
                        <img src={temperaturaInterna} alt="Temperatura Interna" />
                        <p>Temperatura Interna °C</p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('temperaturaExterna')}>
                        <img src={temperaturaExterna} alt="Temperatura Externa" />
                        <p>Temperatura Externa °C</p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('humedadSuelo')}>
                        <img src={humedadSuelo} alt="Humedad del Suelo" />
                        <p>Humedad del Suelo</p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('nivelAgua')}>
                        <img src={nivelAgua} alt="Nivel del Tanque de Agua" />
                        <p>Nivel del Tanque de Agua</p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('periodoActivacionAgua')}>
                        <img src={periodoAgua} alt="Período de activación de la bomba de agua" />
                        <p>Activación bomba de agua</p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('periodoActivacionAire')}>
                        <img src={periodoAire} alt="Nivel del Tanque de Agua Por Tiempo" />
                        <p>Activación aire acondicionado</p>
                    </Link>
                    {/* Nuevo enlace para estadísticas */}
                    <Link to="/estadisticas" className="menu-item">
                        <img src={estadisticas} alt="Estadísticas" />
                        <p>Ver Estadísticas</p>
                    </Link>
                </div>
                {/* Botón para descargar el archivo CSV */}
                <button className="menu-item" onClick={descargarCSV} style={{ marginTop: '20px', padding: '10px 20px' }}>
                    Descargar Datos en CSV
                </button>
            </div>

            {metric && (
                <div className="grafica-container">
                    <RealTimeChartFase2 metric={metric} />
                </div>
            )}
        </div>
    );
};

export default MenuFase2;
