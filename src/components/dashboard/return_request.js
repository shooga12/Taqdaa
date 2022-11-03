import React, { useState, useEffect } from 'react';
import auth,{DB,db} from '../../shared/firebase';
import { doc,getDoc, collection, getDocs, updateDoc} from "firebase/firestore";
import {BsClockHistory} from 'react-icons/bs';
import {IoIosArrowForward} from 'react-icons/io';
import {RiInboxArchiveLine} from 'react-icons/ri';
import {VscError} from 'react-icons/vsc';
import Recieved from '../dashboard/mdi_package-variant-closed-check.png';
import notRecieved from '../dashboard/mdi_package-variant-closed-remove.png';
import {useNavigate} from 'react-router-dom';
import Popup from 'reactjs-popup';
import Button from 'react-bootstrap/Button';
import { confirmAlert } from 'react-confirm-alert';
import Modal from 'react-bootstrap/Modal';
import { ModalHeader, ModalTitle } from 'react-bootstrap';
import { IoCompassOutline } from 'react-icons/io5';

/***Ready for Pick up***/
function ReadyForPickup({ requests }){
  
  
  const [listOfRequests,setListOfRequests] = useState(requests);
  const[show,setShow] = useState(false);
  const[confShow,setConfShow] = useState(false);
  const [done,setDone] = useState(0);
  const[currentReq,setCurrentReq] = useState();
  const[currentReqDate,setCurrentReqDate] = useState();
  let today = new Date();

  useEffect(() => {
    getData();
  },[done]);
  
  const getData = async ()=>{

    let docRef = collection(db, "ReturnRequests"+'SURodyNHPgXABPsE2GXlq2Lmnyh2');
    getDocs(docRef).then(async (querySnapshot) => {
      const tempArr = []
      querySnapshot.forEach((doc) => {
          console.log("DOC ID")
          console.log(doc.data())
          if(doc.data()['status'] == "ready"){
            tempArr.push({docID : doc.id, Date : doc.data().Date, ID : doc.data().ID, Total : doc.data().Total, status : doc.data().status, 'sub-total' : doc.data()['sub-total'], 'vat-total' : doc.data()['vat-total'], items : doc.data()['items'], acceptDate : doc.data()['acceptDate']});
          }
          else{
            tempArr.push({docID : doc.id, Date : doc.data().Date, ID : doc.data().ID, Total : doc.data().Total, status : doc.data().status, 'sub-total' : doc.data()['sub-total'], 'vat-total' : doc.data()['vat-total'], items : doc.data()['items']});
          }
         
      })
      setListOfRequests(tempArr);
    }).then(()=>{
    })
  }

  const setRequest = async (req)=>{
     await setCurrentReq(req)
     console.log("req");
      console.log(req);

     await setCurrentReqDate(new Date(req['acceptDate']))
  }

  const handleViewDetails = (req)=>{
    setRequest(req).then(()=>{
      setShow(true);
    })
  }

  const handlePick = ()=>{
    setConfShow(true);
  }

  const Pickup = (docID)=>{
    updateDoc(doc(db, "ReturnRequests"+'SURodyNHPgXABPsE2GXlq2Lmnyh2', docID),{
      status : 'received'
    }).then(response => {
      //document.querySelector('#saved-success-alert').innerHTML = '<div class="alert alert-success" role="alert">Changes Saved Successfully</div>'
      setConfShow(false)
      setShow(false);
      getData();
    }).catch(error =>{
      console.log(error.message)
    });
  }

  return (
    listOfRequests && listOfRequests.map?
    <>
    <div className='mt-5'>
      {
        Object.keys(listOfRequests).map(key => {
          if(listOfRequests[key]['status'] == 'ready'){
            return(
              <>
              <div className='requests-card' onClick={()=>{}}>
                  <div className='d-flex p-4 justify-content-between'>
                    <div>
                      <h4>Return Request#: {listOfRequests[key]['ID']}</h4>
                      <h6 className='mt-3 date-text'>Request Date: {listOfRequests[key]['Date']}</h6>
                      <div className='d-flex mt-5 ready'><RiInboxArchiveLine style={{fontSize : '22px'}}/><h5 className='ms-2 align-self-center'>Ready For Pick Up</h5></div>
                    </div>
                    <div className='align-self-center'><IoIosArrowForward style={{fontSize : '26px', }} onClick={()=>handleViewDetails(listOfRequests[key])}/></div>
                  </div> 
                </div>
              <div style={{height : '40px'}}></div> 
              </>
          )}
        })
      }
      <Modal show={show} onHide={()=>{setShow(false)}} style={{marginTop: '1em'}}>
          <ModalHeader closeButton>
            <ModalTitle>Request Details</ModalTitle>
          </ModalHeader>
          <Modal.Body>
            {
              currentReq?
              <>
                <h4>Return Request#: {currentReq['ID']}</h4>
                <h6 className='mt-3 date-text'>Request Date: {currentReq['Date']}</h6>

                <h5 className='mt-5'>Items</h5>
                      <div>
                        { 
                          Object.keys(currentReq['items']).map(itemKey => (
                            <>
                            <div className='item'>
                              <div className='w-100 p-3 mt-3 d-flex justify-content-between align-items-center'>
                                <div className='item-first-part justify-content-between d-flex align-items-center'>
                                    <h6><strong>{parseInt(itemKey)+1}</strong></h6>
                                    <img src={currentReq['items'][itemKey]['img']} height='100'/>
                                    <div>
                                        <p><strong>Item Name: </strong>{currentReq['items'][itemKey]['name']}</p>
                                        <p><strong>Barcode: </strong>{currentReq['items'][itemKey]['barcode']}</p>
                                        <p><strong>Quantity: </strong>{currentReq['items'][itemKey]['quantity']}</p>
                                    </div>
                                </div>
                                <div>
                                  <span>{currentReq['items'][itemKey]['price']} SR</span>
                                </div>
                              </div>
                            </div>
                            
                           </>
                          ))   
                        }
                          <hr className='mt-5'></hr>
                          <div className='total d-flex justify-content-between'>
                              <h6>Vat 15%</h6>
                              <h6>{currentReq['vat-total']} SR</h6>
                          </div>
                          <div className='total d-flex justify-content-between'>
                              <h6>Sub Total</h6>
                              <h6>{currentReq['sub-total']} SR</h6>
                          </div>
                          <div className='total d-flex justify-content-between'>
                              <h6><strong>Total</strong></h6>
                              <h6>{currentReq['Total']} SR</h6>
                          </div>
                      </div>

                <div className='d-flex mt-5 ready'><RiInboxArchiveLine style={{fontSize : '22px'}}/><h5 className='ms-2 align-self-center'>Ready For Pick Up</h5></div>
                <div className='mt-4'>
                    <button className='pick-btn' onClick={()=>{handlePick()}}>Picked Up</button>
                    <p className='mt-3 ms-1' style={{color : '#D08A1B'}}>
                      <strong>
                      {

                        5 - Math.floor((today-currentReqDate)/(24*3600*1000)) 
      
                      }
                      </strong>
                      &nbsp;
                      {'Days left, after that the status of the request will be Closed(Not Recieved)'}
                    </p>
                </div>
              </>
              :
              null
            }
           
          </Modal.Body>
          <Modal.Footer>
              <Button variant="secondary" onClick={()=>{setShow(false)}} style={{color: '#5f5f5f', backgroundColor: '#d5d5d5', border: 'none', borderRadius: '30px'}}>
                  Cancel
              </Button>
          </Modal.Footer>
      </Modal> 
      <Modal show={confShow} onHide={()=>setConfShow(false)} style={{marginLeft: '40%', width: '300px', marginTop: '15em'}}>
        <Modal.Body>Do you want to confirm the pick up?</Modal.Body>
        <Modal.Footer>
          <Button variant="primary" onClick={()=>{Pickup(currentReq['docID'])}} style={{backgroundColor: '#faa213', border: 'none', borderRadius: '30px'}}>
            Confirm
          </Button>
          <Button variant="secondary" onClick={()=>setConfShow(false)} style={{color: '#5f5f5f', backgroundColor: '#d5d5d5', border: 'none', borderRadius: '30px'}}>
            Cancel
          </Button>
        </Modal.Footer>
      </Modal>  
      </div>
    </>
    :
    null
  )
}
/***Pending***/
function Pending({ requests }){

  const [listOfRequests,setListOfRequests] = useState(requests);
  const[show,setShow] = useState(false);
  const[confShow,setConfShow] = useState(false);
  const[currentReq,setCurrentReq] = useState();
  const[action,setAction] = useState("");
  const [done,setDone] = useState(0);

  useEffect(() => {
    getData();
  },[done]);

  const getData = async ()=>{

    let docRef = collection(db, "ReturnRequests"+'SURodyNHPgXABPsE2GXlq2Lmnyh2');
    getDocs(docRef).then(async (querySnapshot) => {
      const tempArr = []
      querySnapshot.forEach((doc) => {
          console.log("DOC ID")
          console.log(doc.data())
          tempArr.push({docID : doc.id, Date : doc.data().Date, ID : doc.data().ID, Total : doc.data().Total, status : doc.data().status, 'sub-total' : doc.data()['sub-total'], 'vat-total' : doc.data()['vat-total'], items : doc.data()['items']});
      })
      setListOfRequests(tempArr);
    }).then(()=>{
    })
  }

  const setRequest = async (req)=>{
     await setCurrentReq(req);
  }

  const handleViewDetails = (req)=>{
    setRequest(req).then(()=>{
      setShow(true);
    })
  }
  
  const declineReq = (docID)=>{
    updateDoc(doc(db, "ReturnRequests"+'SURodyNHPgXABPsE2GXlq2Lmnyh2', docID),{
      status : 'declined'
    } ).then(response => {
      //document.querySelector('#saved-success-alert').innerHTML = '<div class="alert alert-success" role="alert">Changes Saved Successfully</div>'
      setConfShow(false)
      setShow(false);
      getData();
    }).catch(error =>{
      console.log(error.message)
    });
  }

  const handleDecline = ()=>{
    setAction('decline')
    setConfShow(true);
  }

  const handleAccept = ()=>{
    setAction('accept')
    setConfShow(true);
  }

  const acceptReq = (docID)=>{
    let today = new Date();
    today = today.getFullYear() + '-' + (today.getMonth()+1) + '-' + (today.getDate())
    updateDoc(doc(db, "ReturnRequests"+'SURodyNHPgXABPsE2GXlq2Lmnyh2', docID),{
      status : 'ready',
      acceptDate: today
    }).then(response => {
      //document.querySelector('#saved-success-alert').innerHTML = '<div class="alert alert-success" role="alert">Changes Saved Successfully</div>'
      setConfShow(false)
      setShow(false);
      getData();
    }).catch(error =>{
      console.log(error.message)
    });
  }

  return (
    listOfRequests?
    <>
    <div className='mt-5'>
      {
        Object.keys(listOfRequests).map(key => {
          if(listOfRequests[key]['status'] == 'pending'){
            return(
              <>
              <div className='requests-card'>
                <div className='d-flex p-4 justify-content-between'>
                  <div>
                    <h4>Return Request#: {listOfRequests[key]['ID']}</h4>
                    <h6 className='mt-3 date-text'>Request Date: {listOfRequests[key]['Date']}</h6>
                    <div className='d-flex mt-5 pending'><BsClockHistory style={{fontSize : '22px'}}/><h5 className='ms-2 align-self-center'>Pending</h5></div>
                  </div>
                  <div className='align-self-center'><IoIosArrowForward style={{fontSize : '26px'}} onClick={()=>handleViewDetails(listOfRequests[key])}/></div>
                </div>
              </div>
              <div style={{height : '40px'}}></div>
              </>
          )}
         })
      }

        <Modal show={show} onHide={()=>{setShow(false)}} style={{marginTop: '1em'}}>
          <ModalHeader closeButton>
            <ModalTitle>Request Details</ModalTitle>
          </ModalHeader>
          <Modal.Body>
            {
              currentReq?
              <>
                <h4>Return Request#: {currentReq['ID']}</h4>
                <h6 className='mt-3 date-text'>Request Date: {currentReq['Date']}</h6>

                <h5 className='mt-5'>Items</h5>
                      <div>
                        { 
                          Object.keys(currentReq['items']).map(itemKey => (
                            <>
                            <div className='item'>
                              <div className='w-100 p-3 mt-3 d-flex justify-content-between align-items-center'>
                                <div className='item-first-part justify-content-between d-flex align-items-center'>
                                    <h6><strong>{parseInt(itemKey)+1}</strong></h6>
                                    <img src={currentReq['items'][itemKey]['img']} height='100'/>
                                    <div>
                                        <p><strong>Item Name: </strong>{currentReq['items'][itemKey]['name']}</p>
                                        <p><strong>Barcode: </strong>{currentReq['items'][itemKey]['barcode']}</p>
                                        <p><strong>Quantity: </strong>{currentReq['items'][itemKey]['quantity']}</p>
                                    </div>
                                </div>
                                <div>
                                  <span>{currentReq['items'][itemKey]['price']} SR</span>
                                </div>
                              </div>
                            </div>
                            
                           </>
                          ))   
                        }
                          <hr className='mt-5'></hr>
                          <div className='total d-flex justify-content-between'>
                              <h6>Vat 15%</h6>
                              <h6>{currentReq['vat-total']} SR</h6>
                          </div>
                          <div className='total d-flex justify-content-between'>
                              <h6>Sub Total</h6>
                              <h6>{currentReq['sub-total']} SR</h6>
                          </div>
                          <div className='total d-flex justify-content-between'>
                              <h6><strong>Total</strong></h6>
                              <h6>{currentReq['Total']} SR</h6>
                          </div>
                      </div>

                      <div className='d-flex mt-5 pending'><BsClockHistory style={{fontSize : '22px'}}/><h5 className='ms-2 align-self-center'>Pending</h5></div>
                      <div className='mt-4'>
                        <button className='accept-btn' onClick={()=>{handleAccept()}}>Accept</button>
                        <button className='decline-btn' onClick={()=>{handleDecline()}}>Decline</button>
                      </div>
              </>
              :
              null
            }
           
          </Modal.Body>
          <Modal.Footer>
              <Button variant="secondary" onClick={()=>{setShow(false)}} style={{color: '#5f5f5f', backgroundColor: '#d5d5d5', border: 'none', borderRadius: '30px'}}>
                  Cancel
              </Button>
          </Modal.Footer>
        </Modal> 
        
      <Modal show={confShow} onHide={()=>setConfShow(false)} style={{marginLeft: '40%', width: '300px', marginTop: '15em'}}>
        <Modal.Body>Are you sure you want to {action} this request</Modal.Body>
        <Modal.Footer>
          <Button variant="primary" onClick={()=>{ action == 'decline'? declineReq(currentReq['docID']) : acceptReq(currentReq['docID']) }} style={{backgroundColor: '#faa213', border: 'none', borderRadius: '30px'}}>
            Yes
          </Button>
          <Button variant="secondary" onClick={()=>setConfShow(false)} style={{color: '#5f5f5f', backgroundColor: '#d5d5d5', border: 'none', borderRadius: '30px'}}>
            Cancel
          </Button>
        </Modal.Footer>
      </Modal> 
       </div> 
    </>
   :
   null
  )

}
/***Declined***/
function ClosedDeclined({ requests }){

  const [listOfRequests,setListOfRequests] = useState(requests);
  const[show,setShow] = useState(false);
  const [done,setDone] = useState(0);
  const[currentReq,setCurrentReq] = useState(false);

  useEffect(() => {
    getData();
  },[done]);

  const getData = async ()=>{

    let docRef = collection(db, "ReturnRequests"+'SURodyNHPgXABPsE2GXlq2Lmnyh2');
    getDocs(docRef).then(async (querySnapshot) => {
      const tempArr = []
      querySnapshot.forEach((doc) => {
          console.log("DOC ID")
          console.log(doc.data())
          tempArr.push({docID : doc.id, Date : doc.data().Date, ID : doc.data().ID, Total : doc.data().Total, status : doc.data().status, 'sub-total' : doc.data()['sub-total'], 'vat-total' : doc.data()['vat-total'], items : doc.data()['items']});
      })
      setListOfRequests(tempArr);
    }).then(()=>{
    })
  }

  const setRequest = async (req)=>{
     await setCurrentReq(req)
  }

  const handleViewDetails = (req)=>{
    setRequest(req).then(()=>{
      setShow(true);
    })
  }

  return (
    listOfRequests && listOfRequests.map?
    <>
    <div className='mt-5'>
      {
        Object.keys(listOfRequests).map(key => {
          if(listOfRequests[key]['status'] == 'declined'){
            return(
              <>
              <div className='requests-card'>
                <div className='d-flex p-4 justify-content-between'>
                  <div>
                    <h4>Return Request#: {listOfRequests[key]['ID']}</h4>
                    <h6 className='mt-3 date-text'>Request Date: {listOfRequests[key]['Date']}</h6>
                    <div className='d-flex mt-5 closed-failed'><VscError style={{fontSize : '22px'}}/><h5 className='ms-2 align-self-center'>{'Closed (Declined)'}</h5></div>
                  </div>
                  <div className='align-self-center'><IoIosArrowForward style={{fontSize : '26px'}} onClick={()=>handleViewDetails(listOfRequests[key])}/></div>
                </div>
              </div>
              <div style={{height : '40px'}}></div> 
              </>
          )}
        })
      }
      <Modal show={show} onHide={()=>{setShow(false)}} style={{marginTop: '1em'}}>
          <ModalHeader closeButton>
            <ModalTitle>Request Details</ModalTitle>
          </ModalHeader>
          <Modal.Body>
            {
              currentReq?
              <>
                <h4>Return Request#: {currentReq['ID']}</h4>
                <h6 className='mt-3 date-text'>Request Date: {currentReq['Date']}</h6>

                <h5 className='mt-5'>Items</h5>
                      <div>
                        { 
                          Object.keys(currentReq['items']).map(itemKey => (
                            <>
                            <div className='item'>
                              <div className='w-100 p-3 mt-3 d-flex justify-content-between align-items-center'>
                                <div className='item-first-part justify-content-between d-flex align-items-center'>
                                    <h6><strong>{parseInt(itemKey)+1}</strong></h6>
                                    <div>
                                        <p><strong>Item Name: </strong>{currentReq['items'][itemKey]['name']}</p>
                                        <p><strong>Barcode: </strong>{currentReq['items'][itemKey]['barcode']}</p>
                                        <p><strong>Quantity: </strong>{currentReq['items'][itemKey]['quantity']}</p>
                                    </div>
                                </div>
                                <div>
                                  <span>{currentReq['items'][itemKey]['price']} SR</span>
                                </div>
                              </div>
                            </div>
                            
                           </>
                          ))   
                        }
                          <hr className='mt-5'></hr>
                          <div className='total d-flex justify-content-between'>
                              <h6>Vat 15%</h6>
                              <h6>{currentReq['vat-total']} SR</h6>
                          </div>
                          <div className='total d-flex justify-content-between'>
                              <h6>Sub Total</h6>
                              <h6>{currentReq['sub-total']} SR</h6>
                          </div>
                          <div className='total d-flex justify-content-between'>
                              <h6><strong>Total</strong></h6>
                              <h6>{currentReq['Total']} SR</h6>
                          </div>
                      </div>

                      <div className='d-flex mt-5 closed-failed'><VscError style={{fontSize : '22px'}}/><h5 className='ms-2 align-self-center'>{'Closed (Declined)'}</h5></div>
              </>
              :
              null
            }
           
          </Modal.Body>
      </Modal>  
      </div>
    </>
    :
    null
  )

}

function ClosedNotRecieved({ requests }){

  const [listOfRequests,setListOfRequests] = useState(requests);
  const[show,setShow] = useState(false);
  const [done,setDone] = useState(0);
  const[currentReq,setCurrentReq] = useState(false);

  useEffect(() => {
    getData();
  },[done]);

  const getData = async ()=>{

    let docRef = collection(db, "ReturnRequests"+'SURodyNHPgXABPsE2GXlq2Lmnyh2');
    getDocs(docRef).then(async (querySnapshot) => {
      const tempArr = []
      querySnapshot.forEach((doc) => {
          console.log("DOC ID")
          console.log(doc.data())
          tempArr.push({docID : doc.id, Date : doc.data().Date, ID : doc.data().ID, Total : doc.data().Total, status : doc.data().status, 'sub-total' : doc.data()['sub-total'], 'vat-total' : doc.data()['vat-total'], items : doc.data()['items']});
      })
      setListOfRequests(tempArr);
    }).then(()=>{
    })
  }

  const setRequest = async (req)=>{
     await setCurrentReq(req)
  }

  const handleViewDetails = (req)=>{
    setRequest(req).then(()=>{
      setShow(true);
    })
  }

  return (
    listOfRequests && listOfRequests.map?
    <>
    <div className='mt-5'>
      {
        Object.keys(listOfRequests).map(key => {
          if(listOfRequests[key]['status'] == 'notreceived'){
            return(
              <>
              <div className='requests-card'>
                <div className='d-flex p-4 justify-content-between'>
                  <div>
                    <h4>Return Request#: {listOfRequests[key]['ID']}</h4>
                    <h6 className='mt-3 date-text'>Request Date: {listOfRequests[key]['Date']}</h6>
                    <div className='d-flex mt-5 closed-failed'><img src={notRecieved} style={{height : '25px'}}/><h5 className='ms-2'>{'Closed (Not Recieved)'}</h5></div>
                  </div>
                  <div className='align-self-center'><IoIosArrowForward style={{fontSize : '26px'}} onClick={()=>handleViewDetails(listOfRequests[key])}/></div>
                </div>
              </div>
              <div style={{height : '40px'}}></div> 
              </>
          )}
        })
      }
      <Modal show={show} onHide={()=>{setShow(false)}} style={{marginTop: '1em'}}>
          <ModalHeader closeButton>
            <ModalTitle>Request Details</ModalTitle>
          </ModalHeader>
          <Modal.Body>
            {
              currentReq?
              <>
                <h4>Return Request#: {currentReq['ID']}</h4>
                <h6 className='mt-3 date-text'>Request Date: {currentReq['Date']}</h6>

                <h5 className='mt-5'>Items</h5>
                      <div>
                        { 
                          Object.keys(currentReq['items']).map(itemKey => (
                            <>
                            <div className='item'>
                              <div className='w-100 p-3 mt-3 d-flex justify-content-between align-items-center'>
                                <div className='item-first-part justify-content-between d-flex align-items-center'>
                                    <h6><strong>{parseInt(itemKey)+1}</strong></h6>
                                    <div>
                                        <p><strong>Item Name: </strong>{currentReq['items'][itemKey]['name']}</p>
                                        <p><strong>Barcode: </strong>{currentReq['items'][itemKey]['barcode']}</p>
                                        <p><strong>Quantity: </strong>{currentReq['items'][itemKey]['quantity']}</p>
                                    </div>
                                </div>
                                <div>
                                  <span>{currentReq['items'][itemKey]['price']} SR</span>
                                </div>
                              </div>
                            </div>
                            
                           </>
                          ))   
                        }
                          <hr className='mt-5'></hr>
                          <div className='total d-flex justify-content-between'>
                              <h6>Vat 15%</h6>
                              <h6>{currentReq['vat-total']} SR</h6>
                          </div>
                          <div className='total d-flex justify-content-between'>
                              <h6>Sub Total</h6>
                              <h6>{currentReq['sub-total']} SR</h6>
                          </div>
                          <div className='total d-flex justify-content-between'>
                              <h6><strong>Total</strong></h6>
                              <h6>{currentReq['Total']} SR</h6>
                          </div>
                      </div>

                      <div className='d-flex mt-5 closed-failed'><img src={notRecieved} style={{height : '25px'}}/><h5 className='ms-2'>{'Closed (Not Recieved)'}</h5></div>
              </>
              :
              null
            }
           
          </Modal.Body>
      </Modal>  
      </div>
    </>
    :
    null
  )

}

function ClosedRecieved({ requests }){

  const [listOfRequests,setListOfRequests] = useState(requests);
  const[show,setShow] = useState(false);
  const [done,setDone] = useState(0);
  const[currentReq,setCurrentReq] = useState(false);

  useEffect(() => {
    getData();
  },[done]);

  const getData = async ()=>{

    let docRef = collection(db, "ReturnRequests"+'SURodyNHPgXABPsE2GXlq2Lmnyh2');
    getDocs(docRef).then(async (querySnapshot) => {
      const tempArr = []
      querySnapshot.forEach((doc) => {
          console.log("DOC ID")
          console.log(doc.data())
          tempArr.push({docID : doc.id, Date : doc.data().Date, ID : doc.data().ID, Total : doc.data().Total, status : doc.data().status, 'sub-total' : doc.data()['sub-total'], 'vat-total' : doc.data()['vat-total'], items : doc.data()['items']});
      })
      setListOfRequests(tempArr);
    }).then(()=>{
    })
  }

  const setRequest = async (req)=>{
     await setCurrentReq(req)
  }

  const handleViewDetails = (req)=>{
    setRequest(req).then(()=>{
      setShow(true);
    })
  }

  return (
    listOfRequests && listOfRequests.map?
    <>
    <div className='mt-5'>
      {
        Object.keys(listOfRequests).map(key => {
          if(listOfRequests[key]['status'] == 'received'){
            return(
              <>
              <div className='requests-card'>
                <div className='d-flex p-4 justify-content-between'>
                  <div>
                    <h4>Return Request#: {listOfRequests[key]['ID']}</h4>
                    <h6 className='mt-3 date-text'>Request Date: {listOfRequests[key]['Date']}</h6>
                    <div className='d-flex mt-5 closed-success'><img src={Recieved} style={{height : '25px'}}/><h5 className='ms-2'>{'Closed (Recieved)'}</h5></div>
                  </div>
                  <div className='align-self-center'><IoIosArrowForward style={{fontSize : '26px'}} onClick={()=>handleViewDetails(listOfRequests[key])}/></div>
                </div>
              </div>
              <div style={{height : '40px'}}></div> 
              </>
          )}
        })
      }
      <Modal show={show} onHide={()=>{setShow(false)}} style={{marginTop: '1em'}}>
          <ModalHeader closeButton>
            <ModalTitle>Request Details</ModalTitle>
          </ModalHeader>
          <Modal.Body>
            {
              currentReq?
              <>
                <h4>Return Request#: {currentReq['ID']}</h4>
                <h6 className='mt-3 date-text'>Request Date: {currentReq['Date']}</h6>

                <h5 className='mt-5'>Items</h5>
                      <div>
                        { 
                          Object.keys(currentReq['items']).map(itemKey => (
                            <>
                            <div className='item'>
                              <div className='w-100 p-3 mt-3 d-flex justify-content-between align-items-center'>
                                <div className='item-first-part justify-content-between d-flex align-items-center'>
                                    <h6><strong>{parseInt(itemKey)+1}</strong></h6>
                                    <img src={currentReq['items'][itemKey]['img']} height='100'/>
                                    <div>
                                        <p><strong>Item Name: </strong>{currentReq['items'][itemKey]['name']}</p>
                                        <p><strong>Barcode: </strong>{currentReq['items'][itemKey]['barcode']}</p>
                                        <p><strong>Quantity: </strong>{currentReq['items'][itemKey]['quantity']}</p>
                                    </div>
                                </div>
                                <div>
                                  <span>{currentReq['items'][itemKey]['price']} SR</span>
                                </div>
                              </div>
                            </div>
                            
                           </>
                          ))   
                        }
                          <hr className='mt-5'></hr>
                          <div className='total d-flex justify-content-between'>
                              <h6>Vat 15%</h6>
                              <h6>{currentReq['vat-total']} SR</h6>
                          </div>
                          <div className='total d-flex justify-content-between'>
                              <h6>Sub Total</h6>
                              <h6>{currentReq['sub-total']} SR</h6>
                          </div>
                          <div className='total d-flex justify-content-between'>
                              <h6><strong>Total</strong></h6>
                              <h6>{currentReq['Total']} SR</h6>
                          </div>
                      </div>

                      <div className='d-flex mt-5 closed-success'><img src={Recieved} style={{height : '25px'}}/><h5 className='ms-2'>{'Closed (Recieved)'}</h5></div>
            
              </>
              :
              null
            }
           
          </Modal.Body>
      </Modal>  
      </div>
    </>
    :
    null
  )
  
}

function PreviousRequests({ requests }) {
    const [listOfRequests,setListOfRequests] = useState(requests);
    const [currentPage,setCurrentPage] = useState(1);
    return(
      <>
      <div className='mt-4'>
        <div>
          <button className={(currentPage == 1? 'requests-page-btn-active-sub' : 'requests-page-btn-nonactive-sub')} onClick={()=>setCurrentPage(1)}><img src={Recieved} style={{height : '25px'}}/> Closed Recieved</button>
          <button className={'ms-4 '+(currentPage == 2? 'requests-page-btn-active-sub' : 'requests-page-btn-nonactive-sub')} onClick={()=>setCurrentPage(2)}><img src={notRecieved} style={{height : '25px'}}/> Closed Not Recieved</button>
          <button className={'ms-4 '+(currentPage == 3? 'requests-page-btn-active-sub' : 'requests-page-btn-nonactive-sub')} onClick={()=>setCurrentPage(3)}><VscError style={{fontSize : '22px', color: 'darkred'}}/> Closed Declined</button>
          <div>
            {
              currentPage == 1? <ClosedRecieved requests ={listOfRequests}/> : currentPage == 2? <ClosedNotRecieved requests ={listOfRequests}/> : <ClosedDeclined requests ={requests}/>
            }
          </div>
        </div>
      </div>
      </>
    )
}

function CurrentRequests({ requests }) {
  const [listOfRequests,setListOfRequests] = useState(requests);
  const [currentPage,setCurrentPage] = useState(1);
  return(
    <>
    <div className='mt-4'>
      <div>
        <button className={(currentPage == 1? 'requests-page-btn-active-sub' : 'requests-page-btn-nonactive-sub')} onClick={()=>setCurrentPage(1)}><BsClockHistory style={{fontSize : '22px'}}/> Pending</button>
        <button className={'ms-4 '+(currentPage == 2? 'requests-page-btn-active-sub' : 'requests-page-btn-nonactive-sub')} onClick={()=>setCurrentPage(2)}><RiInboxArchiveLine style={{fontSize : '22px'}}/> Ready for Pick Up</button>
        <div>
          {
            currentPage == 1? <Pending requests ={listOfRequests}/> : <ReadyForPickup requests ={listOfRequests}/>
          }
        </div>
      </div>
    </div>
    </>
  )

}


function Return_Requests(){

    const [done,setDone] = useState(0);
    const [requests,setRequests] = useState();
    let reqs;
    const [currentPage,setCurrentPage] = useState(1);

    useEffect(() => {
      getData();
    },[done]);
    
    const chnageStatus = async (docID)=>{
      await updateDoc(doc(db, "ReturnRequests"+'SURodyNHPgXABPsE2GXlq2Lmnyh2', docID),{
        status : 'notreceived',
      }).then(response => {
         //after updating status
      }).catch(error =>{
        console.log(error.message)
      });
    }

    //Retrieve Return Requests
    const getData = async ()=>{

      let docRef = collection(db, "ReturnRequests"+'SURodyNHPgXABPsE2GXlq2Lmnyh2');
      getDocs(docRef).then(async (querySnapshot) => {
        const tempArr = []
        querySnapshot.forEach((doc) => {
            
            if(doc.data().acceptDate != ''){
              if(doc.data().status == 'ready'){
                let docID = doc.id;
                let tmpDate = doc.data().acceptDate;
                tmpDate = new Date(tmpDate)
                let today = new Date();
                if(Math.floor((today-tmpDate)/(24*3600*1000)) > 5){
                  chnageStatus(docID) 
                }
              }
            }
        })
      }).then(()=>{
        let docRef = collection(db, "ReturnRequests"+'SURodyNHPgXABPsE2GXlq2Lmnyh2');
        getDocs(docRef).then(async (querySnapshot) => {
          const tempArr = []
          querySnapshot.forEach((doc) => {
              console.log("DOC ID")
              console.log(doc.data())
              if(doc.data().status == 'ready'){
                tempArr.push({docID : doc.id, Date : doc.data().Date, ID : doc.data().ID, Total : doc.data().Total, status : doc.data().status, 'sub-total' : doc.data()['sub-total'], 'vat-total' : doc.data()['vat-total'], items : doc.data()['items'], acceptDate : doc.data()['acceptDate']});
              }
              else{
                tempArr.push({docID : doc.id, Date : doc.data().Date, ID : doc.data().ID, Total : doc.data().Total, status : doc.data().status, 'sub-total' : doc.data()['sub-total'], 'vat-total' : doc.data()['vat-total'], items : doc.data()['items']});
              }
              
          })
          console.log("tmp: ")
          console.log(tempArr)
          setRequests(tempArr);
        }).then(()=>{
        })
      })
      
    }

    return( 
        <>
        <div id="main-container-return-requests">
          <div className='pb-5'>
            <h1 class="mt-3">Return Requests</h1>
          </div>
          {
          requests?
            <div>
              <div>
                <button className={(currentPage == 1? 'requests-page-btn-active' : 'requests-page-btn-nonactive')} onClick={()=>setCurrentPage(1)}>Current Requests</button>
                <button className={'ms-4 '+(currentPage == 1? 'requests-page-btn-nonactive' : 'requests-page-btn-active')} onClick={()=>setCurrentPage(2)}>Previous Requests</button>
                <div>
                  {
                    currentPage == 1? <CurrentRequests requests={requests}/> : <PreviousRequests requests ={requests}/>
                  }
                </div>
              </div>
            </div>
            :
            null
          }
        </div>
        </>  
  
    )
    
}
export default Return_Requests;