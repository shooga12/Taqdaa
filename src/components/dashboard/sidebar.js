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
        <div class="sidebar-top">
          <span class="shrink-btn">
            <IoIosArrowBack />
          </span>
          <img src={Logo} class="logo" alt="" />
        </div>

        <div class="search"></div>

        <div class="sidebar-links">
          <ul>
            
            <li class="tooltip-element" data-tooltip="0">
              <a href="#" className={currentTab == 1? "active-tab" : "non-active"} data-active="0" id="tab-1" onClick={()=>setCurrentTab(1)}>
                <div class="icon">
                  <BiBarcode />
                </div>
                <span class="link hide">Products Dataset</span>
              </a>
            </li>
            <li class="tooltip-element" data-tooltip="1" id="tab-2" onclick="navigate(2)">
              <a href="#" className={currentTab == 2? "active-tab" : "non-active"} data-active="1" onClick={()=>setCurrentTab(2)}>
                <div class="icon">
                  <BiReceipt />
                </div>
                <span class="link hide">Invoices</span>
              </a>
            </li>
            <li class="tooltip-element" data-tooltip="2" id="tab-3" onClick={()=>setCurrentTab(3)}>
              <a href="#" className={currentTab == 3? "active-tab" : "non-active"} data-active="2">
                <div class="icon">
                  <BiPackage />
                </div>
                <span class="link hide">Return Requests</span>
              </a>
            </li>
            <li class="tooltip-element" data-tooltip="3" id="tab-4" onClick={()=>setCurrentTab(4)}>
              <a href="#" className={currentTab == 4? "active-tab" : "non-active"} data-active="3">
                <div class="icon">
                  <BiPurchaseTagAlt />
                </div>
                <span class="link hide">Exchange Requests</span>
              </a>
            </li>
          </ul>
        </div>

        <div class="sidebar-footer">
          <div class="admin-user tooltip-element" data-tooltip="1">
            <a href="#" class="log-out" onClick={() => {auth.signOut(); navigate('/');}}>
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
