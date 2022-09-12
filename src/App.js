import './App.css';
import './index.css'
import Login from './components/login/login';
import Reset from './components/login/reset';
import Sidebar from './components/dashboard/sidebar';
import Signup from './components/signup/signup';
import {BrowserRouter, Routes, Route} from 'react-router-dom';
function App() {
  
  return (
    <BrowserRouter>
       <Routes>
          <Route path="/dashboard" element={<Sidebar />}/>
          <Route path="/" element={<Login />}/>
          <Route path="/signup" element={<Signup />}/>
          <Route path="/reset" element={<Reset />}/>
       </Routes>
    </BrowserRouter>
  )
}

export default App;
