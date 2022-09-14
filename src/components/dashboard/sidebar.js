import React, { useState, Component } from 'react';
import "./sidebar_style.css";
import Logo from '../../shared/Logo.png';
import {BrowserRouter, Routes, Route} from 'react-router-dom';
import { BiBarcode, BiReceipt, BiPackage, BiPurchaseTagAlt } from 'react-icons/bi';
import {IoIosArrowBack} from 'react-icons/io';
import {CgLogOut} from 'react-icons/cg';
import Dataset from './dataset';
import Invoices from './invoices';
import {useAuthState} from 'react-firebase-hooks/auth';
import auth from '../../shared/firebase';
import {useNavigate} from 'react-router-dom';


function Sidebar() {

    const navigate = useNavigate();
    auth.onAuthStateChanged(function(user) {
        if (user) {
          
        } else {
          navigate('/');
        }
    });
    
    const [currentTab, setCurrentTab] = useState(1);

    return(
      <div id="main-div"><nav>
        <div className="sidebar-top">
          <span className="shrink-btn">
            <IoIosArrowBack />
          </span>
          <img src={Logo} className="logo" alt="" />
        </div>

        <div className="search"></div>

        <div className="sidebar-links">
          <ul>
            
            <li className="tooltip-element" data-tooltip="0">
              <a href="#" className={currentTab == 1? "active-tab" : "non-active"} data-active="0" id="tab-1" onClick={()=>setCurrentTab(1)}>
                <div className="icon">
                  <BiBarcode />
                </div>
                <span className="link hide">Products Dataset</span>
              </a>
            </li>
            <li className="tooltip-element" data-tooltip="1" id="tab-2" onClick={()=>setCurrentTab(2)}>
              <a href="#" className={currentTab == 2? "active-tab" : "non-active"} data-active="1">
                <div className="icon">
                  <BiReceipt />
                </div>
                <span className="link hide">Invoices</span>
              </a>
            </li>
            <li className="tooltip-element" data-tooltip="2" id="tab-3" onClick={()=>setCurrentTab(3)}>
              <a href="#" className={currentTab == 3? "active-tab" : "non-active"} data-active="2">
                <div className="icon">
                  <BiPackage />
                </div>
                <span className="link hide">Return Requests</span>
              </a>
            </li>
            <li className="tooltip-element" data-tooltip="3" id="tab-4" onClick={()=>setCurrentTab(4)}>
              <a href="#" className={currentTab == 4? "active-tab" : "non-active"} data-active="3">
                <div className="icon">
                  <BiPurchaseTagAlt />
                </div>
                <span className="link hide">Exchange Requests</span>
              </a>
            </li>
          </ul>
        </div>

        <div className="sidebar-footer">
          <div className="admin-user tooltip-element" data-tooltip="1">
            <a href="#" className="log-out" onClick={() => {auth.signOut(); navigate('/');}}>
              <CgLogOut />
            </a>
          </div>
        </div>
      </nav>
      <main>
        {currentTab == 1? <Dataset /> : currentTab == 2? <Invoices /> : currentTab == 3? <Invoices /> : <Invoices />}
      </main>
   
  
      </div>

    )
    
}
export default Sidebar;
