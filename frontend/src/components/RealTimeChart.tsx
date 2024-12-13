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
            const newData = response.data;

            setData((prevData) => {
                const updatedData = [...prevData, newData];
                if (updatedData.length > 10) {
                    updatedData.shift();
                }
                return updatedData;
            });

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

    const metricConfig: Record<string, { label: string; apiKey: string }> = {
        temperatura: { label: "Temperatura", apiKey: "temperatura" },
        humedad: { label: "Humedad Relativa", apiKey: "humedadRelativa" },
        humedadAbs: { label: "Humedad Absoluta", apiKey: "humedadAbsoluta" },
        velocidadViento: { label: "Velocidad del Viento", apiKey: "velocidadViento" },
        presionBarometrica: { label: "Presión Barométrica", apiKey: "presionBarometrica" },
    };

    const { label, apiKey } = metricConfig[metric];

    const chartData = {
        labels: data.map((item) => {
            let date = new Date(item.timestamp);
            const hours = date.getUTCHours().toString().padStart(2, '0');
            const minutes = date.getUTCMinutes().toString().padStart(2, '0');
            const seconds = date.getUTCSeconds().toString().padStart(2, '0');
            const timeString = `${hours}:${minutes}:${seconds}`;
            return timeString;
        }),
        datasets: [
            {
                label: label,
                data: data.map((item) => item[apiKey]),
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