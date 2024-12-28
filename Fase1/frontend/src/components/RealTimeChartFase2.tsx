import React, { useEffect, useState } from "react";
import axios from "axios";
import { Line, Pie } from "react-chartjs-2";

import {
    Chart as ChartJS,
    LineElement,
    ArcElement,
    PointElement,
    LinearScale,
    CategoryScale,
    Tooltip,
    Legend,
} from "chart.js";

ChartJS.register(
    LineElement,
    ArcElement,
    PointElement,
    LinearScale,
    CategoryScale,
    Tooltip,
    Legend
);

interface RealTimeChartProps {
    metric: string;
}

const RealTimeChartFase2: React.FC<RealTimeChartProps> = ({ metric }) => {
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
        const interval = setInterval(fetchData, 3000);
        return () => clearInterval(interval);
    }, []);

    if (loading) {
        return <p>Cargando datos...</p>;
    }

    // Configuración por métrica
    const metricConfig: Record<
        string,
        { label: string; apiKey: string; chartType: "line" | "pie" }
    > = {
        temperaturaInterna: { label: "Temperatura Interna °C", apiKey: "temperaturaInterna", chartType: "line" },
        temperaturaExterna: { label: "Temperatura Externa °C", apiKey: "temperaturaExterna", chartType: "line" },
        humedadSuelo: { label: "Humedad del Suelo", apiKey: "humedadSuelo", chartType: "pie" },
        nivelAgua: { label: "Nivel del Tanque de Agua", apiKey: "nivel", chartType: "pie" },
        periodoActivacionAgua: { label: "Período activación Agua", apiKey: "periodoActivacionAgua", chartType: "line" },
        periodoActivacionAire: { label: "Período activación Aire Acondicionado", apiKey: "periodoActivacionAire", chartType: "line" },
    };

    const { label, apiKey, chartType } = metricConfig[metric];

    const chartData = {
        labels: data.map((item) => {
            const date = new Date(item.timestamp);
            return `${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;
        }),
        datasets: [
            {
                label,
                data: data.map((item) => item[apiKey]),
                backgroundColor: "rgba(75,192,192,0.4)",
                borderColor: "rgba(75,192,192,1)",
            },
        ],
    };

    const pieData = {
        labels: ["Valor Actual", "Resto"],
        datasets: [
            {
                label,
                data: [data[data.length - 1]?.[apiKey] || 0, 100 - (data[data.length - 1]?.[apiKey] || 0)],
                backgroundColor: ["rgba(75,192,192,0.4)", "rgba(192,75,75,0.4)"],
                borderColor: ["rgba(75,192,192,1)", "rgba(192,75,75,1)"],
            },
        ],
    };

    return (
        <div className="chart-container">
            <h1>{label}</h1>
            {chartType === "line" ? (
                <Line data={chartData} />
            ) : (
                <Pie data={pieData} />
            )}
        </div>
    );
};

export default RealTimeChartFase2;
