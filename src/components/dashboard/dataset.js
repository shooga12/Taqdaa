import React, {useState} from 'react';
import "./dataset.css";
import {BsCloudArrowUp} from 'react-icons/bs';
import * as XLSX from 'xlsx';
import { async } from '@firebase/util';
import auth,{DB} from '../../shared/firebase';
import {ref, set } from "firebase/database";
function Dataset(){
    const clickInput = () =>{
        document.querySelector("input").click();
    }
    const [fileName, setFileName] = useState('No File');
    //const [file, setFile] = useState('');
    const [jsonData, setJsonData] = useState('');
    const handleFile = async (e) => {
        const file = e.target.files[0];
        setFileName(file.name);
        const data = await file.arrayBuffer();
        const workbook = XLSX.read(data);
        const worksheet = workbook.Sheets[workbook.SheetNames[0]];
        setJsonData(XLSX.utils.sheet_to_json(worksheet));
    }
    function writeUserData() {
        
       
            console.log(jsonData);
            set(ref(DB, 'Store'+auth.currentUser.uid), {
            store: jsonData,
            })
        
      }
 
     return(  
        <>
        <h1 class="mt-3">Products Dataset</h1>
        <div id="container">  
            <form>
                <div class="drag-area">
                    <div class="icon">
                        <BsCloudArrowUp/>
                    </div>
                    <header>Drag & Drop to Upload File</header>
                    <span>OR</span>
                    <button onClick={clickInput}>Browse File</button>
                    <input onChange={(e) => handleFile(e)} type="file" hidden accept=".xlsx, .xls, .csv"/>
                </div>
                <div id="file-name" class="mt-5">File Name: <span>{fileName}</span></div>
                <button id="upload-btn" onClick={()=>writeUserData()}>Upload</button>
            </form>
        </div> 
        </>     
    )

}
export default Dataset;