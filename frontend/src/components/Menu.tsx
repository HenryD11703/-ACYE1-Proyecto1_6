import React, { useState } from "react";
import { Link } from "react-router-dom";
import './Menu.css';
import temperatura from '../img/temperatura.png';
import humedad from '../img/humedad.png';
import humedadAbs from '../img/humedad_abs.png';
import velocidadViento from '../img/velocidad_viento.png';
import presionBarometrica from '../img/presion_barometrica.png';
import RealTimeChart from './RealTimeChart';

const Menu = () => {
    const [metric, setMetric] = useState<string | null>(null);

    const mostrarGrafica = (tipo: 'temperatura' | 'humedad' | 'humedadAbs' | 'velocidadViento' | 'presionBarometrica') => {
        setMetric(tipo);
    };

    return (
        <div className="container">
            <div className="menu">
                <h1>Monitor Climático</h1>
                <div className="grid">
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('temperatura')}>
                        <img src={temperatura} alt="Temperatura" />
                        <p>Temperatura °C VS Tiempo</p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('humedad')}>
                        <img src={humedad} alt="Humedad Relativa" />
                        <p>Humedad Relativa % VS Tiempo</p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('humedadAbs')}>
                        <img src={humedadAbs} alt="Humedad Absoluta" />
                        <p>Humedad Absoluta kg/m³ VS Tiempo</p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('velocidadViento')}>
                        <img src={velocidadViento} alt="Velocidad del Viento" />
                        <p>Velocidad del Viento m/s VS Tiempo</p>
                    </Link>
                    <Link to="#" className="menu-item" onClick={() => mostrarGrafica('presionBarometrica')}>
                        <img src={presionBarometrica} alt="Presión Barométrica" />
                        <p>Presión Barométrica Pa VS Tiempo</p>
                    </Link>
                </div>
            </div>

            {metric && (
                <div className="grafica-container">
                    <RealTimeChart metric={metric} />
                </div>
            )}
        </div>
    );
};

export default Menu;