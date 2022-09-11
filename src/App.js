import './App.css';
import './index.css'
import Login from './components/login/login';
import Reset from './components/login/reset';
import Sidebar from './components/dashboard/sidebar';
import {BrowserRouter, Routes, Route} from 'react-router-dom';
function App() {
  
  return (
    <BrowserRouter>
       <Routes>
          <Route path="/dashboard" element={<Sidebar />}/>
          <Route path="/" element={<Login />}/>
          <Route path="/reset" element={<Reset />}/>
       </Routes>
    </BrowserRouter>
  )
}

export default App;
