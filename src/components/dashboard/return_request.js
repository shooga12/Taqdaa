import React, { useState, useEffect } from 'react';
import auth,{DB,db} from '../../shared/firebase';
import { doc,getDoc, collection, getDocs} from "firebase/firestore";
import {BsClockHistory} from 'react-icons/bs';
import {IoIosArrowForward} from 'react-icons/io';
import {RiInboxArchiveLine} from 'react-icons/ri';
import {VscError} from 'react-icons/vsc';
import Recieved from '../dashboard/mdi_package-variant-closed-check.png';
import notRecieved from '../dashboard/mdi_package-variant-closed-remove.png';
function PreviousRequests({ requests }) {

    return(
      <>
       <div className='mt-5'>
        <div className='requests-card'>
          <div className='d-flex p-4 justify-content-between'>
            <div>
              <h4>Return Request#: 789</h4>
              <h6 className='mt-3 date-text'>Request Date: 23/9/2022 7:35 PM</h6>
              <div className='d-flex mt-5 closed-failed'><img src={notRecieved} style={{height : '25px'}}/><h5 className='ms-2'>{'Closed (Not Recieved)'}</h5></div>
            </div>
            <div className='align-self-center'><IoIosArrowForward style={{fontSize : '26px'}}/></div>
          </div>
        </div>
        <div style={{height : '35px'}}></div>
        <div className='requests-card'>
          <div className='d-flex p-4 justify-content-between'>
            <div>
              <h4>Return Request#: 789</h4>
              <h6 className='mt-3 date-text'>Request Date: 23/9/2022 7:35 PM</h6>
              <div className='d-flex mt-5 closed-success'><img src={Recieved} style={{height : '25px'}}/><h5 className='ms-2'>{'Closed (Recieved)'}</h5></div>
            </div>
            <div className='align-self-center'><IoIosArrowForward style={{fontSize : '26px'}}/></div>
          </div>
        </div>
        <div style={{height : '35px'}}></div>
        <div className='requests-card'>
          <div className='d-flex p-4 justify-content-between'>
            <div>
              <h4>Return Request#: 789</h4>
              <h6 className='mt-3 date-text'>Request Date: 23/9/2022 7:35 PM</h6>
              <div className='d-flex mt-5 closed-failed'><VscError style={{fontSize : '22px'}}/><h5 className='ms-2 align-self-center'>{'Closed (Declined)'}</h5></div>
            </div>
            <div className='align-self-center'><IoIosArrowForward style={{fontSize : '26px'}}/></div>
          </div>
        </div>
      </div>
      </>
    )
}

function CurrentRequests({ requests }) {

  return(
      <>
      <div className='mt-5'>
        <div className='requests-card'>
          <div className='d-flex p-4 justify-content-between'>
            <div>
              <h4>Return Request#: 789</h4>
              <h6 className='mt-3 date-text'>Request Date: 23/9/2022 7:35 PM</h6>
              <div className='d-flex mt-5 pending'><BsClockHistory style={{fontSize : '22px'}}/><h5 className='ms-2 align-self-center'>Pending</h5></div>
            </div>
            <div className='align-self-center'><IoIosArrowForward style={{fontSize : '26px'}}/></div>
          </div>
        </div>
        <div style={{height : '35px'}}></div>
        <div className='requests-card'>
          <div className='d-flex p-4 justify-content-between'>
            <div>
              <h4>Return Request#: 789</h4>
              <h6 className='mt-3 date-text'>Request Date: 23/9/2022 7:35 PM</h6>
              <div className='d-flex mt-5 ready'><RiInboxArchiveLine style={{fontSize : '22px'}}/><h5 className='ms-2 align-self-center'>Ready For Pick Up</h5></div>
            </div>
            <div className='align-self-center'><IoIosArrowForward style={{fontSize : '26px'}}/></div>
          </div>
        </div>
      </div>
      </>
  )
}


function Return_Requests(){

    const [done,setDone] = useState(0);
    const [requests,setRequests] = useState();
    const [currentPage,setCurrentPage] = useState(1);

    useEffect(() => {
    getData();
    console.log("Data:");
    },[done]);
    
    //Retrieve Return Requests
    const getData = async ()=>{
        let storeName;
        //Get Store Name
        let docRef = doc(db, "Stores", 'Store'+auth.currentUser?.uid);
        let docSnap = await getDoc(docRef);
        if (docSnap.exists()) {
            storeName = docSnap.data().StoreName;
        } 
        else {
          console.log("No such document!");
        }

        //Get Return Requests of Store          
        docRef = collection(db, "RequestsManager"+storeName);
        getDocs(docRef).then((querySnapshot) => {
          const tempArr = []
          querySnapshot.forEach((doc) => {
            tempArr.push(doc.data());
          }) 
          setRequests(tempArr); 
        })
    }



    const handleFile = (e) => {
       
    }

    return(  
        <>
        <div className='pb-5'>
          <h1 class="mt-3">Return Requests</h1>
        </div>
        <div>
          <div>
            <button className={(currentPage == 1? 'requests-page-btn-active' : 'requests-page-btn-nonactive')} onClick={()=>setCurrentPage(1)}>Current Requests</button>
            <button className={'ms-4 '+(currentPage == 1? 'requests-page-btn-nonactive' : 'requests-page-btn-active')} onClick={()=>setCurrentPage(2)}>Previous Requests</button>
            <div>
              {
                currentPage == 1? <CurrentRequests/> : <PreviousRequests/>
              }
            </div>
          </div>
        </div>
        </>     
    )
    
}
export default Return_Requests;