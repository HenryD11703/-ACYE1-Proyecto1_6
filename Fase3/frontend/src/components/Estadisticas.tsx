import React, { useState, useRef } from 'react';

/** 
 * Interface para cada fila de la tabla.
 * measure: Nombre de la medida (p.ej. "Moda", "Promedio", etc.)
 * python:  Valor para Python
 * assembly: Valor para Assembly
 */
interface TableRow {
    measure: string;
    python: number;
    assembly: number;
}

const Estadisticas: React.FC = () => {
    // Estado para la tabla con valores planos
    const [tableData] = useState<TableRow[]>([
        { measure: "Moda", python: 12, assembly: 10 },
        { measure: "Promedio", python: 20, assembly: 19 },
        { measure: "Máximo", python: 12, assembly: 12 },
        { measure: "Mínimo", python: 1, assembly: 1 },
        { measure: "Rango", python: 12, assembly: 12 }
    ]);

    // Estados para mostrar el contenido de cada archivo
    const [fileContentCSV, setFileContentCSV] = useState<string>("");
    const [fileContentTXT, setFileContentTXT] = useState<string>("");

    // Referencias a los <input type="file"> de CSV y TXT
    const csvFileInputRef = useRef<HTMLInputElement>(null);
    const txtFileInputRef = useRef<HTMLInputElement>(null);

    // Maneja el click en el botón "Subir CSV" y abre el input oculto
    const handleCSVClick = () => {
        if (csvFileInputRef.current) {
            csvFileInputRef.current.click();
        }
    };

    // Maneja el click en el botón "Subir TXT" y abre el input oculto
    const handleTXTClick = () => {
        if (txtFileInputRef.current) {
            txtFileInputRef.current.click();
        }
    };

    // Maneja el cambio de archivo CSV
    const handleFileChangeCSV = (e: React.ChangeEvent<HTMLInputElement>) => {
        const files = e.target.files;
        if (!files || files.length === 0) return;

        const file = files[0];
        const reader = new FileReader();

        reader.onload = (event) => {
            if (event.target?.result) {
                const text = event.target.result as string;
                setFileContentCSV(text);
            }
        };
        reader.readAsText(file);
    };

    // Maneja el cambio de archivo TXT
    const handleFileChangeTXT = (e: React.ChangeEvent<HTMLInputElement>) => {
        const files = e.target.files;
        if (!files || files.length === 0) return;

        const file = files[0];
        const reader = new FileReader();

        reader.onload = (event) => {
            if (event.target?.result) {
                const text = event.target.result as string;
                setFileContentTXT(text);
            }
        };
        reader.readAsText(file);
    };

    return (
        <div style={containerStyle}>
            <h1 style={titleStyle}>Estadísticas</h1>

            {/* Contenedor principal con flexbox para distribuir los bloques */}
            <div style={flexContainerStyle}>
                {/* Sección: SUBIR CSV + Contenido de archivo CSV */}
                <div style={cardStyle}>
                    <h2 style={subtitleStyle}>Archivo CSV</h2>

                    <div style={{ textAlign: 'center', marginBottom: '1rem' }}>
                        <button onClick={handleCSVClick} style={buttonStyle}>
                            Subir CSV
                        </button>
                    </div>

                    {/* Input oculto para cargar archivo CSV */}
                    <input
                        ref={csvFileInputRef}
                        type="file"
                        accept=".csv"
                        style={{ display: 'none' }}
                        onChange={handleFileChangeCSV}
                    />

                    <h3 style={subtitleStyle2}>Contenido de archivo CSV</h3>
                    <pre style={fileContentStyle}>
                        {fileContentCSV}
                    </pre>
                </div>

                {/* Sección: SUBIR TXT + Contenido de archivo TXT */}
                <div style={cardStyle}>
                    <h2 style={subtitleStyle}>Archivo TXT</h2>

                    <div style={{ textAlign: 'center', marginBottom: '1rem' }}>
                        <button onClick={handleTXTClick} style={buttonStyle}>
                            Subir TXT
                        </button>
                    </div>

                    {/* Input oculto para cargar archivo TXT */}
                    <input
                        ref={txtFileInputRef}
                        type="file"
                        accept=".txt"
                        style={{ display: 'none' }}
                        onChange={handleFileChangeTXT}
                    />

                    <h3 style={subtitleStyle2}>Contenido de archivo TXT</h3>
                    <pre style={fileContentStyle}>
                        {fileContentTXT}
                    </pre>
                </div>

                {/* Sección: TABLA DE MEDIDAS */}
                <div style={cardStyle}>
                    <h2 style={subtitleStyle}>Tabla de Medidas</h2>
                    <table style={tableStyle}>
                        <thead>
                            <tr>
                                <th style={thStyle}>Medidas</th>
                                <th style={thStyle}>Python</th>
                                <th style={thStyle}>Assembly</th>
                            </tr>
                        </thead>
                        <tbody>
                            {tableData.map((row, index) => (
                                <tr key={index} style={trStyle}>
                                    <td style={tdStyle}>{row.measure}</td>
                                    <td style={tdStyle}>{row.python}</td>
                                    <td style={tdStyle}>{row.assembly}</td>
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
