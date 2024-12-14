import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Menu from "./components/Menu";
import RealTimeChart from "./components/RealTimeChart";

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Menu />} />
        <Route path="/temperatura" element={<RealTimeChart metric="temperatura" />} />
        <Route path="/humedad-relativa" element={<RealTimeChart metric="humedadRelativa" />} />
        <Route path="/humedad-absoluta" element={<RealTimeChart metric="humedadAbsoluta" />} />
        <Route path="/velocidad-viento" element={<RealTimeChart metric="velocidadViento" />} />
        <Route path="/presion-barometrica" element={<RealTimeChart metric="presionBarometrica" />} />
      </Routes>
    </Router>
  );
};

export default App;
