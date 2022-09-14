import React, {useState} from 'react';
import "./dataset.css";
import {BsCloudArrowUp} from 'react-icons/bs';
import * as XLSX from 'xlsx';
import { async } from '@firebase/util';
import auth,{DB} from '../../shared/firebase';
import {ref, set, child, get, push,update } from "firebase/database";


function Dataset(){

    //const [fileName, setFileName] = useState('No File');
    //const [file, setFile] = useState('');
    const [jsonData, setJsonData] = useState('');
    const [data, setData] = useState('');
    const [work, setWork] = useState('');
    
    function writeNewPost() {
    
      
        // A post entry.
        const postData = {
          author: "Reem",
         
        };
      
        // Get a key for a new Post.
        const newPostKey = push(child(ref(DB), 'Store'+auth.currentUser.uid)).key;
      
        // Write the new post's data simultaneously in the posts list and the user's post list.
        const updates = {};
        updates['Store'+auth.currentUser.uid+'/' + newPostKey] = postData;
        updates['Store'+auth.currentUser.uid + '/' + newPostKey] = postData;
      
        return update(ref(DB), updates);
      }
      
    const printData = ()=>{
        var rootRef = ref(DB);
        var storesRef = rootRef.child('Store'+auth.currentUser.uid);
        var newStoreRef = storesRef.push();
        newStoreRef.set({
            name: "Cars",
            "pageId": "23",
            "storeURL": "kk"
        });
    }
 const handleFile = async (e) => {
    let fileType = e.target.files[0].type; 
    let validExtensions = ["application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "text/csv"]; //adding some valid image extensions in array
    if(!validExtensions.includes(fileType)){
        alert("Only .XLSX and .CSV files are allowed");
        e.target.value = "";
    }
    else{
        const file = e.target.files[0];
        const data = await file.arrayBuffer()
        const workbook = XLSX.read(data);
        const worksheet = workbook.Sheets[workbook.SheetNames[0]];
        setWork(worksheet);
        setJsonData(XLSX.utils.sheet_to_json(worksheet));
    }

}



    
    function writeUserData() {
        
            
            if(jsonData.length == 0){
                alert("The uploaded dataset is empty!");
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
                
                //2.Empty Cell & wrong dta type Validation

                
                if(headerLower.includes("barcode") && headerLower.includes("price") && headerLower.includes("product name")){
                   for(var i = 0; i<lowerCaseJsonData.length; i++){
                        if(typeof lowerCaseJsonData[i]["barcode"] == "undefined" || typeof lowerCaseJsonData[i]["price"] == "undefined" || typeof lowerCaseJsonData[i]["productname"] == "undefined")
                            errorMsg += "• Some data is missing! All items should have barcode, product name, and price\n";
                    }
                }
                if(headerLower.includes("price")){
                    for(var i = 0; i<lowerCaseJsonData.length; i++){
                        if(typeof lowerCaseJsonData[i]["price"] != "number")
                            errorMsg += "• Prices values should be numbers only!\n";
                    }
                }

                
                if(errorMsg){
                    alert(errorMsg)
                    return;
                }

            }

            set(ref(DB, 'Store'+auth.currentUser.uid), {
                store: jsonData,
            })
    
           
        
      }
 
     return(  
        <>
        <h1 className="mt-3">Products Dataset</h1>
        <div id="container">  
                <div className="drag-area">
                    <div className="icon">
                        <BsCloudArrowUp/>
                    </div>
                    <p>Drag & Drop to Upload File</p>
                    <span>OR</span>
                    <input className="ml-5" onChange={(e) => {handleFile(e).then(()=>{
                          console.log(jsonData);
                        })}
                    } type="file" accept=".xlsx, .xls, .csv"/>
                </div>
                <button id="upload-btn" onClick={()=>writeNewPost()}>Upload</button>
        </div> 
        </>     
    )

}
export default Dataset;