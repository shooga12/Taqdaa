import React,{useEffect,useState} from 'react';
import auth,{DB,db} from '../../shared/firebase';
import { doc,getDoc } from "firebase/firestore";
import {ref, set, child, get, push,update } from "firebase/database";
import { async } from '@firebase/util';
import {MdModeEditOutline} from 'react-icons/md';

function Profile(){
   
   const [data,setData] = useState();
   const [done,setDone] = useState(0);

   useEffect(() => {
    getData();
    console.log("Data:");
    console.log(data);
   },[done]);

   const getData = async ()=>{
    const docRef = doc(db, "Requests", "APVleUPzQlCkOfzQU1e0");
    const docSnap = await getDoc(docRef);
    if (docSnap.exists()) {
        console.log("Document data:", docSnap.data());
        let myDataArray = {};
        for (var key in docSnap.data()) {
            myDataArray[key] = docSnap.data()[key]
        }
        setData(myDataArray);
        setDone(1);
          
      } else {
        console.log("No such document!");
    }
   }

   const clickFileInput = ()=>{
    let input = document.querySelector("#logo-input");
    input.click();
   }

        return(  
            <>
            <h1 className="mt-3">Profile</h1>
            <div id="profile-container">
             <div className='col-8 d-flex justify-content-between'>
              <div className='col-6'>
                <div className='row'>
                  <label htmlFor='f_name'>First Name</label>
                  <input type='text' name='f_name' value={data? data["FirstName"] : ''}></input>
                </div>
                <div className='row'>
                  <label htmlFor='l_name'>Last Name</label>
                  <input type='text' name='l_name' value={data? data["LastName"] : ''}></input>
                </div>
                <div className='row'>
                  <label htmlFor='c_name'>Company Name</label>
                  <input type='text' name='c_name' value={data? data["CompanyName"] : ''}></input>
                </div>
                <div className='row'>
                  <label htmlFor='b_name'>Brand Name</label>
                  <input type='text' name='b_name' value={data? data["StoreName"] : ''}></input>
                </div>
                <div className='row'>
                  <label htmlFor='email'>Email</label>
                  <input type='email' name='email' value={data? data["Email"] : ''}></input>
                </div>
                <div className='row'>
                  <label htmlFor='phone'>Phone Number</label>
                  <input type='tel' name='phone' value={data? data["Phone"] : ''}></input>
                </div>
              </div>
              <div className='d-flex flex-column align-items-center justify-content-center'>
                <p id="brand-logo-title">Brand Logo</p>
                <div>
                    <div id="logo-container">     
                        <img src={data? data["StoreLogo"] : ''} className='p-4' height='180' width='180'></img>
                    </div>
                    <div className='d-flex justify-content-end' id="edit-btn-container">
                        <input type='file' id='logo-input' hidden></input>
                        <button id='edit-logo-btn' onClick={clickFileInput}><MdModeEditOutline/></button>
                    </div>
                </div>
              </div>
             </div>
             <div className='mt-4 d-flex justify-content-center'>
                <button id="save-changes-btn">Save Changes</button>
            </div>
            </div>
            </>     
        )
    
}
export default Profile;