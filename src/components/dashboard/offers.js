import React, { useState, useEffect } from 'react';
import { doc,getDoc, collection, getDocs} from "firebase/firestore";
import auth,{DB,db} from '../../shared/firebase';
import {MdDelete, MdQuestionAnswer} from 'react-icons/md';
import Popup from 'reactjs-popup';
import {MdModeEditOutline} from 'react-icons/md';
import {BiPurchaseTagAlt} from 'react-icons/bi';
import loading from './loading.gif';
import img2 from './458789.jpeg';
import img1 from './sephora-brightening-hydrating-foundation-original-imaecf3t7vgdk9by.webp';

function OfferBuilder2({offers}){
    const [offersList, setOffersList] = useState(offers);
    const [addOfferPopupIsOpen, setAddOfferPopupIsOpen] = useState(false);
    const [activeOfferExist, setActiveOfferExist] = useState(false);
    const [activeOffer, setActiveOffer] = useState();

    useEffect(() => {
        if(offersList.length != 0 && offersList.map){
            Object.keys(offersList).map(key => {
                if(offersList[key]['Active'] === true){
                    setActiveOfferExist(true);
                    setActiveOffer(offersList[key]);
                    return true;
                }
            })
        }
    },[]);

   

    return(
        activeOfferExist === true?
          <div>
            <h3 className='sub-titles mb-5'>Current Offer</h3>
            <h6 className='mb-4 text-orange'>Only one offer can be activated</h6>
            <div className='col-9 offer-card'>
                <div className='col-12 d-flex p-3 align-items-center'>
                    <div className=''>
                        <img src={img1} height={'200'}></img>
                    </div>
                    <div className='container d-flex justify-content-between'>
                        <div className=''>
                            <div className='d-flex flex-column align-items-start'>
                                <div>
                                    <div className='d-flex'><h5 className='sub-titles'>Offer Name</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{activeOffer['OfferName']}</h5></div>
                                    <div className='d-flex mt-3'><h5 className='sub-titles'>Percentage</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{activeOffer['Percentage']}%</h5></div>
                                </div>
                                <button className='active-offer mt-5'>Deactivate Offer</button>
                            </div>
                        </div>
                        <button className='delete-offer'>
                            <MdDelete/>
                        </button>
                    </div>
                </div>
              </div>
            </div>
        :
        null

    )
}
function OfferBuilder({offers}){

    const [offersList, setOffersList] = useState(offers);
    const [activeOfferExist, setActiveOfferExist] = useState(false);
    const [addOfferPopupIsOpen, setAddOfferPopupIsOpen] = useState(false);
    const [activeOffer, setActiveOffer] = useState();

    useEffect(() => {
        if(offersList.length != 0 && offersList.map){
            Object.keys(offersList).map(key => {
                if(offersList[key]['Active'] === true){
                    setActiveOfferExist(true);
                    setActiveOffer(offersList[key]);
                }
            })
        }
    },[]);
   

    const clickFileInput = ()=>{
        let input = document.querySelector("#photo-input");
        input.click();
    }

    if(offersList.length != 0 && offersList.map){
        if(activeOfferExist === true){
           return(
            <div>
            <h3 className='sub-titles mb-5'>Current Offer</h3>
            <div className='col-9 offer-card'>
                <div className='col-12 d-flex p-3 align-items-center'>
                    <div className=''>
                        <img src={img1} height={'200'}></img>
                    </div>
                    <div className='container d-flex justify-content-between'>
                        <div className=''>
                            <div className='d-flex flex-column align-items-start'>
                                <div>
                                    <div className='d-flex'><h5 className='sub-titles'>Offer Name</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{activeOffer['OfferName']}</h5></div>
                                    <div className='d-flex mt-3'><h5 className='sub-titles'>Percentage</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{activeOffer['Percentage']}%</h5></div>
                                </div>
                                <button className='active-offer mt-5'>Deactivate Offer</button>
                            </div>
                        </div>
                        <button className='delete-offer'>
                            <MdDelete/>
                        </button>
                    </div>
                </div>
              </div>
              <div className='col-9 d-flex justify-content-between align-items-center'>
                    <div>
                        <h3 className='sub-titles mb-2 mt-5'>All Offers</h3>
                        <div className='col-12 mb-5' style={{height : '5px', backgroundColor : '#faa213', borderRadius : '10px'}}></div>
                    </div>
                    <Popup open={addOfferPopupIsOpen} trigger={<button className='add-offer-btn'>+ Add Offer</button>} position="left center" contentStyle={{ width: '500px' }} onOpen={()=>setAddOfferPopupIsOpen(true)}>
                        <div className='container p-4'>
                            <div className='w-100 d-flex p-2 justify-content-end'><button className='close-edit-item-popup' onClick={()=>setAddOfferPopupIsOpen(false)}>x</button></div>
                            <div className='d-flex flex-column align-items-center'>
                               <div className='d-flex flex-column align-items-center justify-content-center'>
                                  <p id="product-photo-title">Offer Photo</p>
                                  <div>
                                      <div id="photo-container" className='d-flex justify-content-center'>     
                                          <img src={img1} className='p-4' height='180' width='180'></img>
                                      </div>
                                      <div className='d-flex justify-content-end' id="edit-btn-container">
                                          <input type='file' id='photo-input' onChange={(e) => {}} hidden></input>
                                          <button id='edit-photo-btn' onClick={clickFileInput}><MdModeEditOutline/></button>
                                      </div>
                                      <p className='error-msg' id="error-msg-photo"></p>
                                  </div>
                                </div>
                                <div className='d-flex flex-column'>
                                    <label htmlFor='offer-name'>Offer Name</label>
                                    <input className='mt-2 input-fields' name='offer-name' maxLength={42}></input>
                                    <p className='error-msg' id="error-msg-br"></p>
                                </div>
                                <div className='d-flex flex-column mt-4'>
                                    <label htmlFor='offer-perc'>Offer Percentage</label>
                                    <div>
                                      <input type='number' className='mt-2 input-fields' id='percentage-field' name='offer-perc' maxLength={3} min={1} max={100}></input><span>%</span>
                                    </div>
                                    <p className='error-msg' id="error-msg-br"></p>
                                </div>
                                <button className='add-offer-btn mt-5'>Add Offer</button>
                            </div>
                        </div>
                    </Popup>
                </div>
                <h6 className='mb-5 text-orange'>Only one offer can be activated</h6>
                <div>
                    {
                    Object.keys(offersList).map(key => ( 
                    <>
                    <div className='col-9 offer-card'>
                        <div className='col-12 d-flex p-3 align-items-center'>
                            <div className=''>
                                <img src={img2} height={'200'}></img>
                            </div>
                            <div className='container d-flex justify-content-between'>
                                <div className=''>
                                    <div className='d-flex flex-column align-items-start'>
                                        <div>
                                            <div className='d-flex'><h5 className='sub-titles'>Offer Name</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{offersList[key]['OfferName']}</h5></div>
                                            <div className='d-flex mt-3'><h5 className='sub-titles'>Percentage</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{offersList[key]['Percentage']}%</h5></div>
                                        </div>
                                        <button className={'mt-5 '+(offersList[key]['Active'] === true? 'active-offer' : 'inactive-offer')}>{offersList[key]['Active'] === true? 'Deactivate' : 'Activate'} Offer</button>
                                    </div>
                                </div>
                                <button className='delete-offer'>
                                    <MdDelete/>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div style={{height : '30px'}}></div>
                    </> 
                ))}
                </div>
            </div>
           )
        }
        else{
            return(
                <div>
                <h3 className='sub-titles mb-4'>Current Offer</h3>
                  <div className='mt-5 d-flex flex-column align-items-center justify-content-center'>
                       <BiPurchaseTagAlt style={{fontSize : '80px', color : '#d2d2d2'}}/>
                       <p style={{fontSize : '30px', color : '#d2d2d2'}} className='mt-2'>No Active Offer</p>
                  </div>
                  <div className='mt-5 col-9 d-flex justify-content-between align-items-center'>
                        <div>
                            <h3 className='sub-titles mb-2 mt-5'>All Offers</h3>
                            <div className='col-12 mb-5' style={{height : '5px', backgroundColor : '#faa213', borderRadius : '10px'}}></div>
                        </div>
                        <Popup open={addOfferPopupIsOpen} trigger={<button className='add-offer-btn'>+ Add Offer</button>} position="left center" contentStyle={{ width: '500px' }} onOpen={()=>setAddOfferPopupIsOpen(true)}>
                            <div className='container p-4'>
                                <div className='w-100 d-flex p-2 justify-content-end'><button className='close-edit-item-popup' onClick={()=>setAddOfferPopupIsOpen(false)}>x</button></div>
                                <div className='d-flex flex-column align-items-center'>
                                   <div className='d-flex flex-column align-items-center justify-content-center'>
                                      <p id="product-photo-title">Offer Photo</p>
                                      <div>
                                          <div id="photo-container" className='d-flex justify-content-center'>     
                                              <img src={img1} className='p-4' height='180' width='180'></img>
                                          </div>
                                          <div className='d-flex justify-content-end' id="edit-btn-container">
                                              <input type='file' id='photo-input' onChange={(e) => {}} hidden></input>
                                              <button id='edit-photo-btn' onClick={clickFileInput}><MdModeEditOutline/></button>
                                          </div>
                                          <p className='error-msg' id="error-msg-photo"></p>
                                      </div>
                                    </div>
                                    <div className='d-flex flex-column'>
                                        <label htmlFor='offer-name'>Offer Name</label>
                                        <input className='mt-2 input-fields' name='offer-name'></input>
                                        <p className='error-msg' id="error-msg-br"></p>
                                    </div>
                                    <div className='d-flex flex-column mt-4'>
                                        <label htmlFor='offer-perc'>Offer Percentage</label>
                                        <div>
                                          <input type='number' className='mt-2 input-fields' id='percentage-field' name='offer-perc'></input><span>%</span>
                                        </div>
                                        <p className='error-msg' id="error-msg-br"></p>
                                    </div>
                                    <button className='add-offer-btn mt-5'>Add Offer</button>
                                </div>
                            </div>
                        </Popup>
                    </div>
                    <h6 className='mb-5 text-orange'>Only one offer can be activated</h6>
                    <div>
                        {
                        Object.keys(offersList).map(key => ( 
                        <>
                        <div className='col-9 offer-card'>
                            <div className='col-12 d-flex p-3 align-items-center'>
                                <div className=''>
                                    <img src={img2} height={'200'}></img>
                                </div>
                                <div className='container d-flex justify-content-between'>
                                    <div className=''>
                                        <div className='d-flex flex-column align-items-start'>
                                            <div>
                                                <div className='d-flex'><h5 className='sub-titles'>Offer Name</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{offersList[key]['OfferName']}</h5></div>
                                                <div className='d-flex mt-3'><h5 className='sub-titles'>Percentage</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{offersList[key]['Percentage']}%</h5></div>
                                            </div>
                                            <button className={'mt-5 '+(offersList[key]['Active'] === true? 'active-offer' : 'inactive-offer')}>{offersList[key]['Active'] === true? 'Deactivate' : 'Activate'} Offer</button>
                                        </div>
                                    </div>
                                    <button className='delete-offer'>
                                        <MdDelete/>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div style={{height : '30px'}}></div>
                        </> 
                    ))}
                    </div>
                </div>
               )
        }
    }
    else{
       return(
        <div className='w-100 h-100 d-flex justify-content-center'>
            <div className='d-flex flex-column p-5 justify-content-center align-items-center'>
                <BiPurchaseTagAlt style={{fontSize: '150px', color: '#d2d2d2'}}/>
                <p style={{fontSize: '40px', color: '#d2d2d2'}}>No Offers</p>
            </div>
        </div> 
       )
    }       
}

function Offers(){
    
    const [addOfferPopupIsOpen, setAddOfferPopupIsOpen] = useState(false);
    const [offers,setOffers] = useState();
    const [done,setDone] = useState(0);

    const handleFile = (e) => {
       
    }
    
    useEffect(() => {
        getData();
    },[done]);

    const getData = async ()=>{
        const docRef = doc(db, "Stores", 'Store'+auth.currentUser?.uid);
        const docSnap = await getDoc(docRef);
        if (docSnap.exists()) {
            console.log("Document data:", docSnap.data().Offers);
            let myDataArray = [];
            for (var key in docSnap.data().Offers) {
                myDataArray[key] = docSnap.data().Offers[key]
            }   
            console.log(myDataArray)
            setOffers(myDataArray);
        } 
        else {
            console.log("No such document!");
        }
    }
    
    const clickFileInput = ()=>{
        let input = document.querySelector("#photo-input");
        input.click();
    }

    return(  
        <>
            <h1 class="mt-3">Offers</h1>
            {
              offers?
              <OfferBuilder offers={offers}/> 
              : <img src={loading} className="loading-img"></img>
            }
        </>     
    )

}
export default Offers;