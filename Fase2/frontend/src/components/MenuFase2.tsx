import { useState } from "react";
import { Link } from "react-router-dom";
import './Menu.css';
import temperaturaExterna from '../img/temperatura.png';
import temperaturaInterna from '../img/temperatura_interna.png';
import humedadSuelo from '../img/humedad_abs.png';
import nivelAgua from '../img/nivel_agua.png';
import periodoAgua from '../img/tanque_agua.png';
import periodoAire from '../img/aire_acondicionado.png';
import RealTimeChartFase2 from "./RealTimeChartFase2";

const MenuFase2 = () => {
    const [metric, setMetric] = useState<string | null>(null);

    const mostrarGrafica = (tipo: 'temperaturaInterna' | 'temperaturaExterna' | 'humedadSuelo' | 'nivelAgua'
        | 'humedadSueloTiempo' | 'nivelAguaTiempo' | 'periodoActivacionAgua' | 'periodoActivacionAire') => {
        setMetric(tipo);
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
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('humedadSueloTiempo')}>
                        <img src={humedadSuelo} alt="Humedad del Suelo Por tiempo" />
                        <p>Humedad del Suelo por Tiempo </p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('nivelAgua')}>
                        <img src={nivelAgua} alt="Nivel del Tanque de Agua" />
                        <p>Nivel del Tanque de Agua</p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('nivelAguaTiempo')}>
                        <img src={nivelAgua} alt="Nivel del Tanque de Agua Por Tiempo" />
                        <p>Nivel del Tanque de Agua por Tiempo</p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('periodoActivacionAgua')}>
                        <img src={periodoAgua} alt="Período de activación de la bomba de agua" />
                        <p>Activación bomba de agua</p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('periodoActivacionAire')}>
                        <img src={periodoAire} alt="Nivel del Tanque de Agua Por Tiempo" />
                        <p>Activación aire acondicionado</p>
                    </Link>
                </div>
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