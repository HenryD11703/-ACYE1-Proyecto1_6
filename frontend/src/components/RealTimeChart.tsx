import React, { useEffect, useState } from "react";
import axios from "axios";
import { Line } from "react-chartjs-2";
import {
    Chart as ChartJS,
    LineElement,
    PointElement,
    LinearScale,
    TimeScale,
    CategoryScale,
    Tooltip,
    Legend,
} from "chart.js";

ChartJS.register(LineElement, PointElement, LinearScale, TimeScale, CategoryScale, Tooltip, Legend);

interface RealTimeChartProps {
    metric: string;
}

const RealTimeChart: React.FC<RealTimeChartProps> = ({ metric }) => {
    const [data, setData] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    const fetchData = async () => {
        try {
            const response = await axios.get("http://localhost:5000/obtener_datos");
            setData(response.data);
            setLoading(false);
        } catch (error) {
            console.error("Error al obtener datos:", error);
            setLoading(false);
        }
    };
    useEffect(() => {
        fetchData();
        const interval = setInterval(fetchData, 1000);
        return () => clearInterval(interval);
    }, []);

    if (loading) {
        return <p>Cargando datos...</p>;
    }

    if (!data.length) {
        return <p>No se encontraron datos</p>;
    }

    const metricConfig: Record<string, { label: string }> = {
        temperatura: { label: "Temperatura" },
        humedad: { label: "Humedad Relativa" },
        humedadAbs: { label: "Humedad Absoluta" },
        velocidadViento: { label: "Velocidad del Viento" },
        presionBarometrica: { label: "Presión Barométrica" },
    };

    const { label } = metricConfig[metric];

    const chartData = {
        labels: data.map((item) => {
            let date = new Date(item.timestamp)
            const hours = date.getUTCHours().toString().padStart(2, '0');
            const minutes = date.getUTCMinutes().toString().padStart(2, '0');
            const seconds = date.getUTCSeconds().toString().padStart(2, '0');
            const timeString = `${hours}:${minutes}:${seconds}`;
            return timeString;
        }),
        //labels: data.map((item) => new Date(item.timestamp).toLocaleTimeString()),
        datasets: [
            {
                label: label,
                data: data.map((item) => item[metric]),
                fill: false,
                backgroundColor: "rgba(75,192,192,0.4)",
                borderColor: "rgba(75,192,192,1)",
            },
        ],
    };

    return (
        <div className="chart-container">
            <h1>{label}</h1>
            <Line data={chartData} />
        </div>
    );
};

export default RealTimeChart;