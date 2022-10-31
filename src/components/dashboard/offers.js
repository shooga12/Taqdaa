import React, { useState, useEffect } from 'react';
import {doc,getDoc, collection, getDocs, updateDoc, deleteField} from "firebase/firestore";
import auth,{DB,db} from '../../shared/firebase';
import {MdDelete, MdQuestionAnswer} from 'react-icons/md';
import Popup from 'reactjs-popup';
import {MdModeEditOutline} from 'react-icons/md';
import {BiPurchaseTagAlt} from 'react-icons/bi';
import { confirmAlert } from 'react-confirm-alert';
import {ref as sRef, getStorage, uploadBytes, getDownloadURL } from "firebase/storage";
import loading from './loading.gif';
import offerImg1 from './offer.png';
import img1 from './sephora-brightening-hydrating-foundation-original-imaecf3t7vgdk9by.webp';

function OfferBuilder({offers}){
    
    const [offersList, setOffersList] = useState(offers);
    const [activeOfferExist, setActiveOfferExist] = useState(false);
    const [addOfferPopupIsOpen, setAddOfferPopupIsOpen] = useState(false);
    const [activeOffer, setActiveOffer] = useState();

    useEffect(() => {
        checkCurrentOffer();
    },[]);
   
    useEffect(() => {
        checkCurrentOffer();
    },[offersList]);

    const checkCurrentOffer = ()=>{
        if(offersList.length != 0 && offersList.map){
            Object.keys(offersList).map(key => {
                if(offersList[key]['Active'] === true){
                    setActiveOfferExist(true);
                    setActiveOffer({"Key" : key, "OfferName" : offersList[key]['OfferName'], "Percentage" : offersList[key]['Percentage'], "Active" : offersList[key]['Active']});
                    return;
                }
                else{
                    setActiveOfferExist(false);
                }
            })
        }
    }

    const getData = async ()=>{
        const docRef = doc(db, "Stores", 'Store'+auth.currentUser?.uid);
        const docSnap = await getDoc(docRef);
            if (docSnap.exists()) {
                console.log("Document data:", docSnap.data().Offers);
                let myDataArray = [];
                for (var key in docSnap.data().Offers) {
                    myDataArray[key] = docSnap.data().Offers[key]
                }   
                setOffersList(myDataArray);
                //checkCurrentOffer()
            } 
            else {
                console.log("No such document!");
            }
    }

    const changeOfferStatus = (key,status)=>{
        updateDoc(doc(db, "Stores", 'Store'+auth.currentUser?.uid),{
          ['Offers.'+key+'.Active'] : status == 1? true : false,
          }).then(response => {
            //document.querySelector('#saved-success-alert').innerHTML = '<div class="alert alert-success" role="alert">Changes Saved Successfully</div>'
            getData();
          }).catch(error =>{
            console.log(error.message)
          });
    }
    
    const deleteOffer = (key)=>{
        updateDoc(doc(db, "Stores", 'Store'+auth.currentUser?.uid),{
            ['Offers.'+key] : deleteField(),
            }).then(response => {
              //document.querySelector('#saved-success-alert').innerHTML = '<div class="alert alert-success" role="alert">Changes Saved Successfully</div>'
              getData();
            }).catch(error =>{
              console.log(error.message)
            });
    }

    const deleteOfferAlert = (key)=>{   
        confirmAlert({
        message: 'Are you sure you want to delete this offer?',
        buttons: [
            {
              label: 'Delete',
              onClick: ()=>deleteOffer(key)  
            },                   
            {
              label: 'Cancel',
              //onClick: () => alert('Click No')
            }
         ]
        });
    }

    const clickFileInput = ()=>{
        let input = document.querySelector("#photo-input");
        input.click();
    }
    
    

    if(offersList && offersList.length != 0 && offersList.map){
        let activeExists = false;
        let activeOfferObject = {};
        Object.keys(offersList).map(key => {
            if(offersList[key]['Active'] === true){
                activeExists = true;
                activeOfferObject = {"Key" : key, Photo : offersList[key]['Photo'], "OfferName" : offersList[key]['OfferName'], "Percentage" : offersList[key]['Percentage'], "Active" : offersList[key]['Active']};
            }
        })
        //if(activeOffer && activeOfferExist === true){
        if(activeExists){ 
           return(
            <div>
            <h3 className='sub-titles mb-5'>Active Offer</h3>
            <div className='col-9 offer-card'>
                <div className='col-12 d-flex p-3 align-items-center'>
                    <div className=''>
                        <img src={activeOfferObject['Photo']} height={'200'} width={'250'}></img>
                    </div>
                    <div className='container d-flex justify-content-between'>
                        <div className=''>
                            <div className='d-flex flex-column align-items-start'>
                                <div>
                                    <div className='d-flex'><h5 className='sub-titles'>Offer Name</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{activeOfferObject['OfferName']}</h5></div>
                                    <div className='d-flex mt-3'><h5 className='sub-titles'>Percentage</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{activeOfferObject['Percentage']}%</h5></div>
                                </div>
                                <button className='active-offer mt-5' onClick={()=>changeOfferStatus(activeOffer['Key'], 0)}>Deactivate Offer</button>
                            </div>
                        </div>
                        <button className='delete-offer' onClick={()=>deleteOfferAlert(activeOffer['Key'])}>
                            <MdDelete/>
                        </button>
                    </div>
                </div>
              </div>
              <div className='col-9 d-flex justify-content-between align-items-center'>
                    <div>
                        <h3 className='sub-titles mb-2 mt-5'>Inactive Offers</h3>
                        <div className='col-12 mb-5' style={{height : '5px', backgroundColor : '#faa213', borderRadius : '10px'}}></div>
                    </div>
                </div>
                <h6 className='mb-5 text-orange'>Only one offer can be activated</h6>
                <div>
                    {   
                    Object.keys(offersList).map(key => {
                     if(offersList[key]['Active'] === false) {
                        return(
                    <>
                    <div className='col-9 offer-card'>
                        <div className='col-12 d-flex p-3 align-items-center'>
                            <div className=''>
                                <img src={offersList[key]['Photo']} height={'200'} width={'250'}></img>
                            </div>
                            <div className='container d-flex justify-content-between'>
                                <div className=''>
                                    <div className='d-flex flex-column align-items-start'>
                                        <div>
                                            <div className='d-flex'><h5 className='sub-titles'>Offer Name</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{offersList[key]['OfferName']}</h5></div>
                                            <div className='d-flex mt-3'><h5 className='sub-titles'>Percentage</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{offersList[key]['Percentage']}%</h5></div>
                                        </div>
                                        <button className={'mt-5 '+(offersList[key]['Active'] === true? 'active-offer' : 'inactive-offer')} onClick={()=>changeOfferStatus(key, offersList[key]['Active'] === true? 0 : 1)}>{offersList[key]['Active'] === true? 'Deactivate' : 'Activate'} Offer</button>
                                    </div>
                                </div>
                                <button className='delete-offer' onClick={()=>deleteOfferAlert(key)}>
                                    <MdDelete/>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div style={{height : '30px'}}></div>
                    </> 
                    )}
                 })}
                </div>
            </div>
           )
        }
        else{
            return(
                <div>
                <h3 className='sub-titles mb-4'>Active Offer</h3>
                  <div className='mt-5 d-flex flex-column align-items-center justify-content-center'>
                       <BiPurchaseTagAlt style={{fontSize : '80px', color : '#d2d2d2'}}/>
                       <p style={{fontSize : '30px', color : '#d2d2d2'}} className='mt-2'>No Active Offer</p>
                  </div>
                  <div className='mt-5 col-9 d-flex justify-content-between align-items-center'>
                        <div>
                            <h3 className='sub-titles mb-2 mt-5'>Inactive Offers</h3>
                            <div className='col-12 mb-5' style={{height : '5px', backgroundColor : '#faa213', borderRadius : '10px'}}></div>
                        </div>
                  </div>
                    <h6 className='mb-5 text-orange'>Only one offer can be activated</h6>
                    <div>
                        {
                        Object.keys(offersList).map(key => ( 
                        <>
                        <div className='col-9 offer-card'>
                            <div className='col-12 d-flex p-3 align-items-center'>
                                <div className=''>
                                    <img src={offersList[key]['Photo']} height={'200'} width={'250'}></img>
                                </div>
                                <div className='container d-flex justify-content-between'>
                                    <div className=''>
                                        <div className='d-flex flex-column align-items-start'>
                                            <div>
                                                <div className='d-flex'><h5 className='sub-titles'>Offer Name</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{offersList[key]['OfferName']}</h5></div>
                                                <div className='d-flex mt-3'><h5 className='sub-titles'>Percentage</h5><span style={{width : '30px'}}></span><h5 className='text-orange'>{offersList[key]['Percentage']}%</h5></div>
                                            </div>
                                            <button className={'mt-5 '+(offersList[key]['Active'] === true? 'active-offer' : 'inactive-offer')} onClick={()=>changeOfferStatus(key, offersList[key]['Active'] === true? 0 : 1)}>{offersList[key]['Active'] === true? 'Deactivate' : 'Activate'} Offer</button>
                                        </div>
                                    </div>
                                    <button className='delete-offer' onClick={()=>deleteOfferAlert(key)}>
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
    const [newDataAdded,setNewDataAdded] = useState(0);
    const [done,setDone] = useState(0);
    const [offerName,setOfferName] = useState("");
    const [percentage,setPercentage] = useState("");
    const [isActive,setIsActive] = useState(false);
    const [percInErrorState, setPercInErrorState] = useState(false);
    const [nameInErrorState, setNameInErrorState] = useState(false);
    const [photoInErrorState, setPhotoInErrorState] = useState(false);
    const [isPhotoUpdated, setIsPhotoUpdated] = useState(false);
    const [photoUpdated, setPhotoUpdated] = useState(""); 
    const [photoURL, setPhotoURL] = useState("");
    const [photo, setPhoto] = useState("");
    const storage = getStorage();
    let PhotoFileName = "";

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

    const generatePhotoURL = () => {
        const imgRef = sRef(storage,"images/"+PhotoFileName);
          uploadBytes(imgRef,photo).then(() => {
              getDownloadURL(imgRef).then((url)=>{
                setPhotoURL(url)
            })
        })
    }
    
    const clickFileInput = ()=>{
        let input = document.querySelector("#photo-input");
        input.click();
    }

    const handlePhotoChange = (e)=>{
        let fileType = e.target.files[0].type; 
        fileType = fileType.toString().toLowerCase();
        let validExtensions = ["image/jpeg","image/png","image/jpg"]; //adding some valid image extensions in array
        if(!validExtensions.includes(fileType)){
            //alert("Only .jpeg, jpg, and .png files are allowed");
            document.querySelector('#error-msg-photo').innerHTML = 'Only .jpeg, jpg, and .png files are allowed<br>';
            document.querySelector('#error-msg-photo').style.visibility = "visible";
            e.target.value = "";
            setPhotoInErrorState(true);
        }
        else{
          setPhoto(e.target.files[0]);
          PhotoFileName = e.target.files[0].name;
          setPhotoInErrorState(false);
          setIsPhotoUpdated(true);
          setPhotoUpdated(window.URL.createObjectURL(e.target.files[0]));
          generatePhotoURL();
          document.querySelector('#error-msg-photo').innerHTML = '';
          document.querySelector('#error-msg-photo').style.visibility = "hidden";
        }
    }

    const handleOfferNameChange = (val)=>{
        let error = false;
        val = val.trimStart();
        let tmp = val;
        val = '';
        for(var i = 0; i<tmp.length; i++){
          if(tmp[i] == ' ' && tmp[i-1] !== ' ')
            val += tmp[i];
          else if(tmp[i] !== ' ' && tmp[i] !== '.')
            val += tmp[i];
        }
        setOfferName(val)
        if(val == ''){
          error = true;
          setNameInErrorState(true);
          document.querySelector('#error-msg-on').innerHTML = 'Product name is required<br>';
          document.querySelector('#error-msg-on').style.visibility = "visible";
        }
        if(!error){
          setNameInErrorState(false);
          document.querySelector('#error-msg-on').innerHTML = '';
          document.querySelector('#error-msg-on').style.visibility = "hidden";
        }
    }  

    const toFixedWithoutZeros = (num, precision) =>
     `${1 * num.toFixed(precision)}`;

    const handlePercChange = (val)=>{
        let error = false;
        let perc = ''+val
        if(perc.length > 5){
            perc = perc.substring(0,5);
        }

        perc = perc.replace(/^0+/, '');
        perc = toFixedWithoutZeros(parseFloat(perc),2)
        setPercentage(perc);

        if(val == ''){
          error = true;
          setPercInErrorState(true);
          document.querySelector('#error-msg-op').innerHTML = 'Percentage is required<br>';
          document.querySelector('#error-msg-op').style.visibility = "visible";
        }
        if(val < 0){
          error = true;
          setPercInErrorState(true);
          document.querySelector('#error-msg-op').innerHTML = "Percentage can't be negative<br>";
          document.querySelector('#error-msg-op').style.visibility = "visible";
        }
        if(val > 100){
          error = true;
          setPercInErrorState(true);
          document.querySelector('#error-msg-op').innerHTML = "Maximium percentage is 100<br>";
          document.querySelector('#error-msg-op').style.visibility = "visible";
        }
        if(!error){
          setPercInErrorState(false);
          document.querySelector('#error-msg-op').innerHTML = '';
          document.querySelector('#error-msg-op').style.visibility = "hidden";
        }
    }
    

    return(  
        <>
            <div className='pb-5 col-10 mt-3 d-flex align-items-center justify-content-between'>
              <h1>Offers</h1>
              <Popup open={addOfferPopupIsOpen} trigger={<button className='add-offer-btn'>+ Add Offer</button>} position="bottom right" contentStyle={{ width: '300px' }} onOpen={()=>setAddOfferPopupIsOpen(true)}>
                <div className='container p-4'>
                    <div className='w-100 d-flex p-2 justify-content-end'><button className='close-edit-item-popup' onClick={()=>setAddOfferPopupIsOpen(false)}>x</button></div>
                    <div className='d-flex flex-column align-items-center'>
                        <div className='d-flex flex-column align-items-center justify-content-center'>
                            <p id="product-photo-title">Offer Photo</p>
                            <div>
                                <div id="photo-container" className='d-flex justify-content-center'>     
                                    <img src={photoUpdated} className='p-4' height='200' width='250'></img>
                                </div>
                                <div className='d-flex justify-content-end' id="edit-btn-container">
                                    <input type='file' id='photo-input' onChange={(e) => handlePhotoChange(e)} hidden></input>
                                    <button id='edit-photo-btn' onClick={clickFileInput}><MdModeEditOutline/></button>
                                </div>
                                <p className='error-msg' id="error-msg-photo"></p>
                            </div>
                        </div>
                        <div className='d-flex flex-column'>
                            <label htmlFor='offer-name'>Offer Name</label>
                            <input value={offerName} className='mt-2 input-fields' name='offer-name' maxLength={42} onChange={(e)=>handleOfferNameChange(e.target.value)}></input>
                            <p className='error-msg' id="error-msg-on"></p>
                        </div>
                        <div className='d-flex flex-column mt-4'>
                            <label htmlFor='offer-perc'>Offer Percentage</label>
                            <div>
                                <input value={percentage} onChange={(e)=>handlePercChange(e.target.value)} type='number' className='mt-2 input-fields' id='percentage-field' name='offer-perc' maxLength={3} min={1} max={100}></input><span>%</span>
                            </div>
                            <p className='error-msg' id="error-msg-op"></p>
                        </div>
                        <div className='d-flex mt-3' style={{width : '380px'}}>
                            <input type='checkbox' className='align-self-center' name='offer-active' style={{height : '20px', width: '20px'}} onChange={(e)=>setIsActive(e.target.checked)}></input>
                            <label htmlFor='offer-active' className='ms-2'>Make it the active offer</label>
                            <p className='error-msg' id="error-msg-br"></p>
                        </div>
                        <button className='add-offer-btn mt-5'>Add Offer</button>
                    </div>
                </div>
              </Popup>  
            </div>
            {
              offers?
              <OfferBuilder offers={offers}/> 
              : <img src={loading} className="loading-img"></img>
            }
        </>     
    )

}
export default Offers;

