import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Menu from "./components/Menu";
import MenuFase2 from "./components/MenuFase2";
import RealTimeChart from "./components/RealTimeChart";
import Estadisticas from "./components/Estadisticas";

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<MenuFase2 />} />
        <Route path="/estadisticas" element={<Estadisticas />} />
      </Routes>
    </Router>
  );
};

export default App;
