import React, { useEffect, useRef, useState } from "react";
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

ChartJS.register(
  LineElement,
  PointElement,
  LinearScale,
  TimeScale,
  CategoryScale,
  Tooltip,
  Legend
);

interface RealTimeChartProps {
  metric: string;
}

const RealTimeChart: React.FC<RealTimeChartProps> = ({ metric }) => {
  const [data, setData] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [filterEnabled, setFilterEnabled] = useState(false);

  const handleStartDateChange = (es: React.ChangeEvent<HTMLInputElement>) => {
    setStartDate(es.target.value);
  };

  const handleEndDateChange = (ex: React.ChangeEvent<HTMLInputElement>) => {
    setEndDate(ex.target.value);
  };

  const handleFilterToggle = () => {
    setData([])
    setFilterEnabled(!filterEnabled);
  };

  const fetchData = async () => {
    try {
      if (filterEnabled) {
        if (startDate && endDate) {
          const response = await axios.post("http://localhost:5000/ObtenerDatosPorFechas", {
            fechaInicial: startDate,
            fechaFinal: endDate
          });
          setData(response.data);
        } else {
          setLoading(false);
        }
      } else {
        // Petición sin filtros
        const response = await axios.get("http://localhost:5000/obtener_datos");
        const newData = response.data;
        setData((prevData) => {
          const updatedData = [...prevData, newData];
          if (updatedData.length > 10) {
            updatedData.shift();
          }
          return updatedData;
        });
      }
      setLoading(false);
    } catch (error) {
      console.error("Error al obtener datos:", error);
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
    // Solo establecer el intervalo si no está activado el filtro
    if (!filterEnabled) {
      const interval = setInterval(fetchData, 3000);
      return () => clearInterval(interval);
    }
  }, [filterEnabled, startDate, endDate]); // Agregamos las dependencias

  if (loading) {
    return <p>Cargando datos...</p>;
  }

  // if (!data.length) {
  //   setFilterEnabled(false);
  //   return <p>No se encontraron datos</p>;
  // }

  const metricConfig: Record<string, { label: string; apiKey: string }> = {
    temperatura: { label: "Temperatura °C vs Tiempo", apiKey: "temperatura" },
    humedad: {
      label: "Humedad Relativa % vs Tiempo",
      apiKey: "humedadRelativa",
    },
    humedadAbs: {
      label: "Humedad Absoluta kg/m³ vs Tiempo",
      apiKey: "humedadAbsoluta",
    },
    velocidadViento: {
      label: "Velocidad del Viento m/s vs Tiempo",
      apiKey: "velocidadViento",
    },
    presionBarometrica: {
      label: "Presión Barométrica hPa vs Tiempo",
      apiKey: "presionBarometrica",
    },
  };

  const { label, apiKey } = metricConfig[metric];

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
              gap: "10px",
              marginTop: "10px",
            }}>
              <label style={{ fontSize: "16px" }}>
                Inicio:
                <input
                  type="date"
                  value={startDate}
                  onChange={handleStartDateChange}
                  style={{
                    fontSize: "16px",
                    padding: "5px",
                    marginLeft: "5px",
                    width: "150px",
                  }}
                />
              </label>
              <label style={{ fontSize: "16px" }}>
                Fin:
                <input
                  type="date"
                  value={endDate}
                  onChange={handleEndDateChange}
                  style={{
                    fontSize: "16px",
                    padding: "5px",
                    marginLeft: "5px",
                    width: "150px",
                  }}
                />
              </label>
            </div>
          )}
        </div>
      </div>

      <Line data={chartData} />
    </div>
  );
};

export default RealTimeChart;