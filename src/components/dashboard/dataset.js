import React, {useState} from 'react';
import "./dataset.css";

import { confirmAlert } from 'react-confirm-alert'; // Import
import 'react-confirm-alert/src/react-confirm-alert.css'; // Import css

import {BsCloudArrowUp} from 'react-icons/bs';
import * as XLSX from 'xlsx';
import { async } from '@firebase/util';
import auth,{DB} from '../../shared/firebase';
import "bootstrap/dist/css/bootstrap.min.css";
import {ref, set, child, get, push,update } from "firebase/database";


function Dataset(){

    //const [fileName, setFileName] = useState('No File');
    const [file, setFile] = useState('');
    const [jsonData, setJsonData] = useState('');
    const [data, setData] = useState('');
    const [work, setWork] = useState('');
    const [done, setDone] = useState(0);
    const [fileName, setFileName] = useState('No File Selected');
    
   
 const handleFile = async (e) => {
    setFile(e.files[0]);
    let fileType = e.files[0].type; 
    let validExtensions = ["application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "text/csv"]; //adding some valid image extensions in array
    if(!validExtensions.includes(fileType)){
        alert("Only .XLSX and .CSV files are allowed");
        e.value = "";
    }
    else{
        const file = e.files[0];
        setFile(file);
        const data = await file.arrayBuffer();
        const workbook = XLSX.read(data);
        const worksheet = workbook.Sheets[workbook.SheetNames[0]];
        setWork(worksheet);
        setJsonData(XLSX.utils.sheet_to_json(worksheet));
       
    }
    

}

    const showAlert = () => {

        confirmAlert({
        message: 'Replace The Current Dataset?',
        buttons: [
            {
            label: 'Replace',
            onClick: () => {set(ref(DB, 'Store'+auth.currentUser.uid), {
                            store: jsonData,
                            })}
            },
            {
            label: 'Cancel',
            //onClick: () => alert('Click No')
            }
        ]
        });
    }

    const handleDatasetFileChange = (file)=>{
        alert("Here in handle")
        if(file.length == 0){
            alert("No File Selected!");
            return;
        }
       
        if(jsonData.length == 0){
            alert("Dataset is empty!");
            document.querySelector('#file-input').value = "";
            setFileName('No File Selected')
            return;
        }
        else{
            let errorMsg = "";
            
            const header = XLSX.utils.sheet_to_json(work,{header:1})[0];
            const headerLower = header.map(element => {
                return element.toLowerCase();
            });
            
            const jcc = require('json-case-convertor')
           
            const lowerCaseJsonData = jcc.lowerCaseKeys(jsonData)

            
         
            //1.columns validation
            if(!headerLower.includes("price"))
              errorMsg += "• Price column is missing!\n"
            if(!headerLower.includes("barcode"))
              errorMsg += "• Barcode column is missing!\n"
            if(!headerLower.includes("product name"))
              errorMsg += "• Product Name column is missing!\n"
            if(!headerLower.includes("Photo"))
              errorMsg += "• Photo column is missing!\n"
            if(!headerLower.includes("UID"))
              errorMsg += "• UID column is missing!\n"
            //2.Empty Cell & wrong dta type Validation

            
            if(headerLower.includes("barcode") && headerLower.includes("price") && headerLower.includes("product name")){
               for(var i = 0; i<lowerCaseJsonData.length; i++){
                    if(typeof lowerCaseJsonData[i]["barcode"] == "undefined" || typeof lowerCaseJsonData[i]["price"] == "undefined" || typeof lowerCaseJsonData[i]["productname"] == "undefined")
                        errorMsg += "• Some data is missing! All items should have barcode, product name, price, Photo, UID\n";
                }
            }
            if(headerLower.includes("price")){
                for(var i = 0; i<lowerCaseJsonData.length; i++){
                    if(typeof lowerCaseJsonData[i]["price"] != "number")
                        errorMsg += "• Prices values should be numbers only!\n";
                }
            }

            
            if(errorMsg){
                document.querySelector('#file-input').value = "";
                setFileName('No File Selected')
                alert(errorMsg)
                return;
            }
            
        }
        setDone(1);
        setFileName(file["name"]);
        alert(done)
    }
    
    function writeUserData() {

            
            const dbRef = ref(DB);
            get(child(dbRef, 'Store'+auth.currentUser.uid)).then((snapshot) => {
              if (snapshot.exists()) {
                showAlert();
              } else {
                console.log("No data available");
                set(ref(DB, 'Store'+auth.currentUser.uid), {
                    store: jsonData,
                }).then(()=>{
                    alert("Dataset Uploaded Sucessfully");
                })
                
              }
            }).catch((error) => {
              console.error(error);
            });
       
      }
     
     return(  
        <>
        <h1 className="mt-3">Products Dataset</h1>
        <p id="warning">Uploading a new dataset will replace the current one<br></br>
         <span>Dataset must contain the following feilds with the same names: <strong>Barcode</strong>, <strong>Product Name</strong>, <strong>Price</strong>, <strong>Photo</strong>, <strong>UID</strong></span><br></br>
         <span>Only .xlsx and .csv files are acceptable</span>
        </p>
        <div id="container">  
                <div className="drag-area">
                    {done == 0?
                    <div>
                        <div className="cloud-icon">
                            <BsCloudArrowUp/>
                        </div>
                        <p>Upload File</p>
                    </div> 
                     :
                     <div>Done</div>
                    }
                    <input id="file-input" className="ml-5 mb-3 mt-3" onClick={(e) =>  e.target.value = ''} onChange={(e) => {handleFile(e.target).then(()=>{
                       
                           handleDatasetFileChange(e.target.files[0]);
            
                          
                        })}
                    } type="file" accept=".xlsx, .xls, .csv" hidden/>
                    <label htmlFor="file-input" id="select-file">Select file</label>
                    <p id="file-name"><strong>File Name:</strong> {fileName}</p>
                </div>
                <button id="upload-btn" onClick={()=>writeUserData()}>Upload</button>
        </div> 
       
        </>     
    )

}
export default Dataset;