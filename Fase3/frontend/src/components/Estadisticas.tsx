import React, { useState, useRef } from 'react';

interface TableRow {
    measure: string;
    temperature_internal: number;
    temperature_external: number;
    water_level?: number;
}

const Estadisticas = () => {
    const [tableData, setTableData] = useState<TableRow[]>([
        { measure: "Moda", temperature_internal: 0, temperature_external: 0, water_level: 0 },
        { measure: "Promedio", temperature_internal: 0, temperature_external: 0, water_level: 0 },
        { measure: "Máximo", temperature_internal: 0, temperature_external: 0, water_level: 0 },
        { measure: "Mínimo", temperature_internal: 0, temperature_external: 0, water_level: 0 },
        { measure: "Rango", temperature_internal: 0, temperature_external: 0, water_level: 0 },
    ]);

    const [txtTableData, setTxtTableData] = useState<TableRow[]>([]);
    const [fileContentCSV, setFileContentCSV] = useState<string>("");
    const [fileContentTXT, setFileContentTXT] = useState<string>("");
    const [isLoading, setIsLoading] = useState(false);

    const csvFileInputRef = useRef<HTMLInputElement>(null);
    const txtFileInputRef = useRef<HTMLInputElement>(null);

    const handleCSVClick = () => {
        if (csvFileInputRef.current) {
            csvFileInputRef.current.value = '';
            csvFileInputRef.current.click();
        }
    };

    const handleTXTClick = () => {
        if (txtFileInputRef.current) {
            txtFileInputRef.current.value = '';
            txtFileInputRef.current.click();
        }
    };

    const handleFileChangeCSV = async (e: React.ChangeEvent<HTMLInputElement>) => {
        const files = e.target.files;
        if (!files || files.length === 0) return;

        const file = files[0];
        const reader = new FileReader();

        reader.onload = async (event) => {
            if (event.target?.result) {
                const text = event.target.result as string;
                setFileContentCSV(text);

                try {
                    setIsLoading(true);
                    const response = await fetch('http://localhost:5000/analyze', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({ csv_data: text }),
                    });

                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }

                    const data = await response.json();

                    setTableData([
                        {
                            measure: "Moda",
                            temperature_internal: data.mode.temp_internal,
                            temperature_external: data.mode.temp_external,
                            water_level: data.mode.water_level
                        },
                        {
                            measure: "Promedio",
                            temperature_internal: data.mean.temp_internal,
                            temperature_external: data.mean.temp_external,
                            water_level: data.mean.water_level
                        },
                        {
                            measure: "Máximo",
                            temperature_internal: data.max.temp_internal,
                            temperature_external: data.max.temp_external,
                            water_level: data.max.water_level
                        },
                        {
                            measure: "Mínimo",
                            temperature_internal: data.min.temp_internal,
                            temperature_external: data.min.temp_external,
                            water_level: data.min.water_level
                        },
                        {
                            measure: "Rango",
                            temperature_internal: data.range.temp_internal,
                            temperature_external: data.range.temp_external,
                            water_level: data.range.water_level
                        },
                    ]);
                } catch (error) {
                    console.error('Error:', error);
                    alert('Error al procesar el archivo');
                } finally {
                    setIsLoading(false);
                    if (csvFileInputRef.current) {
                        csvFileInputRef.current.value = '';
                    }
                }
            }
        };
        reader.readAsText(file);
    };

    const handleFileChangeTXT = (e: React.ChangeEvent<HTMLInputElement>) => {
        debugger;
        const files = e.target.files;
        if (!files || files.length === 0) return;

        const file = files[0];
        const reader = new FileReader();

        reader.onload = (event) => {
            if (event.target?.result) {
                const text = event.target.result as string;
                setFileContentTXT(text);

                const lines = text.split('\n');
                const parsedData: TableRow[] = [
                    { measure: "Media", temperature_internal: parseFloat(lines[1]?.split(':')[1]?.trim() || "0"), temperature_external: parseFloat(lines[2]?.split(':')[1]?.trim() || "0") },
                    { measure: "Moda", temperature_internal: parseFloat(lines[3]?.split(':')[1]?.trim() || "0"), temperature_external: parseFloat(lines[4]?.split(':')[1]?.trim() || "0") },
                    { measure: "Máximo", temperature_internal: parseFloat(lines[5]?.split(':')[1]?.trim() || "0"), temperature_external: parseFloat(lines[6]?.split(':')[1]?.trim() || "0") },
                    { measure: "Mínimo", temperature_internal: parseFloat(lines[7]?.split(':')[1]?.trim() || "0"), temperature_external: parseFloat(lines[8]?.split(':')[1]?.trim() || "0") },
                    { measure: "Rango", temperature_internal: parseFloat(lines[9]?.split(':')[1]?.trim() || "0"), temperature_external: parseFloat(lines[10]?.split(':')[1]?.trim() || "0") },
                ];

                setTxtTableData(parsedData);
                if (txtFileInputRef.current) {
                    txtFileInputRef.current.value = '';
                }
            }
        };
        reader.readAsText(file);
    };

    return (
        <div style={containerStyle}>
            <h1 style={titleStyle}>Estadísticas</h1>

            <div style={flexContainerStyle}>
                <div style={cardStyle}>
                    <h2 style={subtitleStyle}>Archivo CSV</h2>
                    <button
                        onClick={handleCSVClick}
                        style={{
                            ...buttonStyle,
                            opacity: isLoading ? 0.7 : 1,
                            cursor: isLoading ? 'not-allowed' : 'pointer'
                        }}
                        disabled={isLoading}
                    >
                        {isLoading ? 'Procesando...' : 'Subir CSV'}
                    </button>
                    <input
                        ref={csvFileInputRef}
                        type="file"
                        accept=".csv"
                        style={{ display: 'none' }}
                        onChange={handleFileChangeCSV}
                    />
                    <h3 style={subtitleStyle2}>Contenido de archivo CSV</h3>
                    <pre style={fileContentStyle}>{fileContentCSV}</pre>
                </div>

                <div style={cardStyle}>
                    <h2 style={subtitleStyle}>Archivo TXT</h2>
                    <button onClick={handleTXTClick} style={buttonStyle}>Subir TXT</button>
                    <input
                        ref={txtFileInputRef}
                        type="file"
                        accept=".txt"
                        style={{ display: 'none' }}
                        onChange={handleFileChangeTXT}
                    />
                    <h3 style={subtitleStyle2}>Contenido de archivo TXT</h3>
                    <pre style={fileContentStyle}>{fileContentTXT}</pre>
                </div>
            </div>

            <h2 style={titleStyle}>Tablas de Estadísticas</h2>
            <div style={flexContainerStyle}>
                <div style={cardStyle}>
                    <h3 style={subtitleStyle}>Datos del CSV</h3>
                    <table style={tableStyle}>
                        <thead>
                            <tr>
                                <th style={thStyle}>Medidas</th>
                                <th style={thStyle}>Temp. Interna</th>
                                <th style={thStyle}>Temp. Externa</th>
                                <th style={thStyle}>Nivel Agua</th>
                            </tr>
                        </thead>
                        <tbody>
                            {tableData.map((row, index) => (
                                <tr key={index} style={trStyle}>
                                    <td style={tdStyle}>{row.measure}</td>
                                    <td style={tdStyle}>{row.temperature_internal.toFixed(1)}°C</td>
                                    <td style={tdStyle}>{row.temperature_external.toFixed(1)}°C</td>
                                    <td style={tdStyle}>{row.water_level?.toFixed(1) || '-'}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>

                <div style={cardStyle}>
                    <h3 style={subtitleStyle}>Datos del TXT</h3>
                    <table style={tableStyle}>
                        <thead>
                            <tr>
                                <th style={thStyle}>Medidas</th>
                                <th style={thStyle}>Temp. Interna</th>
                                <th style={thStyle}>Temp. Externa</th>
                            </tr>
                        </thead>
                        <tbody>
                            {txtTableData.map((row, index) => (
                                <tr key={index} style={trStyle}>
                                    <td style={tdStyle}>{row.measure}</td>
                                    <td style={tdStyle}>{row.temperature_internal.toFixed(1)}°C</td>
                                    <td style={tdStyle}>{row.temperature_external.toFixed(1)}°C</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
};


const containerStyle: React.CSSProperties = {
    width: '100%',
    minHeight: '100vh',
    backgroundColor: '#ECEAF3',
    padding: '2rem',
};

const titleStyle: React.CSSProperties = {
    textAlign: 'center',
    color: '#4A3C59',
    marginBottom: '2rem',
    fontSize: '2rem',
};

const flexContainerStyle: React.CSSProperties = {
    display: 'flex',
    justifyContent: 'space-around',
    alignItems: 'flex-start',
    flexWrap: 'wrap',
    width: '100%',
};

const cardStyle: React.CSSProperties = {
    backgroundColor: '#F8F5FC',
    borderRadius: '8px',
    padding: '1.5rem',
    margin: '1rem',
    minWidth: '280px',
    boxShadow: '0 2px 5px rgba(0,0,0,0.1)',
    flex: '1 1 300px',
    maxWidth: '350px',
};

const subtitleStyle: React.CSSProperties = {
    color: '#5D4B71',
    textAlign: 'center',
    marginBottom: '1rem',
};

const subtitleStyle2: React.CSSProperties = {
    color: '#5D4B71',
    margin: '1rem 0 0.5rem',
};

const buttonStyle: React.CSSProperties = {
    backgroundColor: '#CAB8F3',
    border: 'none',
    color: '#3E3168',
    padding: '0.5rem 1rem',
    margin: '0 0.5rem',
    borderRadius: '4px',
    cursor: 'pointer',
    fontWeight: 600,
    boxShadow: '0 1px 3px rgba(0,0,0,0.2)',
};

const fileContentStyle: React.CSSProperties = {
    backgroundColor: '#EFE8FA',
    color: '#333',
    padding: '1rem',
    borderRadius: '4px',
    maxHeight: '200px',
    overflow: 'auto',
};

const tableStyle: React.CSSProperties = {
    borderCollapse: 'collapse',
    width: '100%',
    backgroundColor: '#FFFFFF',
    boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
};

const thStyle: React.CSSProperties = {
    border: '1px solid #DDD6F2',
    padding: '8px',
    textAlign: 'left',
    backgroundColor: '#DDD6F2',
    color: '#4A3C59',
};

const tdStyle: React.CSSProperties = {
    border: '1px solid #DDD6F2',
    padding: '8px',
    textAlign: 'left',
    color: '#333',
};

const trStyle: React.CSSProperties = {
    textAlign: 'left',
};

export default Estadisticas;
