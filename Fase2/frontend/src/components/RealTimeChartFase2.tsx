import React, { useEffect, useState } from "react";
import axios from "axios";
import { Line, Pie } from "react-chartjs-2";
import Swal from "sweetalert2"; // Importa SweetAlert2

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
    const [startDateTime, setStartDateTime] = useState("");
    const [endDateTime, setEndDateTime] = useState("");
    const [filterEnabled, setFilterEnabled] = useState(false);

    const handleStartDateTimeChange = (es: React.ChangeEvent<HTMLInputElement>) => {
        setStartDateTime(es.target.value);
    };

    const handleEndDateTimeChange = (ex: React.ChangeEvent<HTMLInputElement>) => {
        setEndDateTime(ex.target.value);
    };

    const handleFilterToggle = () => {
        setData([]);
        setFilterEnabled(!filterEnabled);
    };

    const fetchData = async () => {
        try {
            if (filterEnabled) {
                if (startDateTime && endDateTime) {
                    const response = await axios.post("http://localhost:5000/ObtenerDatosPorFechas", {
                        fechaInicial: startDateTime,
                        fechaFinal: endDateTime,
                    });
                    setData(response.data);
                } else {
                    setLoading(false);
                }
            } else {
                const response = await axios.get("http://localhost:5000/obtener_datos");
                const newData = response.data;
                setData((prevData) => {
                    const updatedData = [...prevData, newData];
                    if (updatedData.length > 10) {
                        updatedData.shift();
                    }
                    return updatedData;
                });
    
                // Mostrar alerta si temperaturaInterna >= 35
                if (metric === "temperaturaInterna" && newData.temperaturaInterna >= 35) {
                    Swal.fire({
                        title: "Alerta de temperatura",
                        text: `La temperatura interna es alta: ${newData.temperaturaInterna}°C`,
                        icon: "warning",
                        confirmButtonText: "Aceptar",
                    });
                }
    
                // Mostrar alerta si humedadSuelo <= 20
                if (metric === "humedadSuelo" && newData.humedadSuelo <= 20) {
                    Swal.fire({
                        title: "Alerta de humedad",
                        text: `La humedad del suelo es baja: ${newData.humedadSuelo}%`,
                        icon: "info",
                        confirmButtonText: "Aceptar",
                    });
                }
            }
            setLoading(false);
        } catch (error) {
            console.error("Error al obtener datos:", error);
            setLoading(false);
        }
    };
    
    useEffect(() => {
        fetchData();
        if (!filterEnabled) {
            const interval = setInterval(fetchData, 3000);
            return () => clearInterval(interval);
        }
    }, [filterEnabled, startDateTime, endDateTime]);

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
        nivelAguaTiempo: { label: "Historico Nivel del Agua", apiKey: "nivel", chartType: "line" },
        humedadSueloTiempo: { label: "Historico Humedad del Suelo", apiKey: "humedadSuelo", chartType: "line" },
    };

    const { label, apiKey, chartType } = metricConfig[metric];

    const chartData = {
        labels: data.map((item) => {
            let date = new Date(item.timestamp);
            const hours = date.getUTCHours().toString().padStart(2, "0");
            const minutes = date.getUTCMinutes().toString().padStart(2, "0");
            const seconds = date.getUTCSeconds().toString().padStart(2, "0");
            const timeString = `${hours}:${minutes}:${seconds}`;
            return timeString;
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

            <div className="date-filters">
                <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
                    <label style={{ display: "flex", alignItems: "center", gap: "5px" }}>
                        <input
                            id="filter"
                            type="checkbox"
                            checked={filterEnabled}
                            onChange={handleFilterToggle}
                        />
                        Aplicar rangos de fecha
                    </label>

                    {filterEnabled && (
                        <div style={{
                            display: "flex",
                            alignItems: "center",
                            gap: "20px",
                            marginTop: "10px",
                        }}>
                            <label style={{ fontSize: "16px" }}>
                                Fecha Inicial:
                                <input
                                    type="datetime-local"
                                    value={startDateTime}
                                    onChange={handleStartDateTimeChange}
                                    style={{
                                        fontSize: "16px",
                                        padding: "5px",
                                        marginLeft: "5px",
                                        width: "auto",
                                    }}
                                />
                            </label>
                            <label style={{ fontSize: "16px" }}>
                                Fecha Final:
                                <input
                                    type="datetime-local"
                                    value={endDateTime}
                                    onChange={handleEndDateTimeChange}
                                    style={{
                                        fontSize: "16px",
                                        padding: "5px",
                                        marginLeft: "5px",
                                        width: "auto",
                                    }}
                                />
                            </label>
                        </div>
                    )}
                </div>
            </div>

            {chartType === "line" ? (
                <Line data={chartData} />
            ) : (
                <Pie data={pieData} />
            )}
        </div>
    );
};

export default RealTimeChartFase2;
