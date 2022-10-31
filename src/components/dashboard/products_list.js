import React, {useState, useLayoutEffect,useEffect, Component} from 'react';
import auth,{DB} from '../../shared/firebase';
import "./products.css";
import {FiEdit} from 'react-icons/fi';
import {MdDelete} from 'react-icons/md';
import {ref as dRef, set, get, push, child, remove, update} from "firebase/database";
import {ref as sRef, getStorage, uploadBytes, getDownloadURL } from "firebase/storage";
import { async } from '@firebase/util';
import loading from './loading.gif';
import { confirmAlert } from 'react-confirm-alert';
import Sidebar from './sidebar'; 
import Popup from 'reactjs-popup';
import 'reactjs-popup/dist/index.css';
import {MdModeEditOutline} from 'react-icons/md';
import { extend } from 'jquery';
import img2 from './458789.jpeg';



function Child({ datum }) {
  
  const [itemsSet, setItemsSet] = useState(datum);
  const [barcode, setBarcode] = useState("");
  const [pname, setPName] = useState("");
  const [price, setPrice] = useState("");
  const [uid, setUID] = useState("");
  const [returnable, setReturnable] = useState("");
  const [photo, setPhoto] = useState("");
  const [isPhotoUpdated, setIsPhotoUpdated] = useState(false);
  const [photoUpdated, setPhotoUpdated] = useState(""); 
  const [photoURL, setPhotoURL] = useState("");
  const [barcodeInErrorState, setBarcodeInErrorState] = useState(false);
  const [pnameInErrorState, setPNameInErrorState] = useState(false);
  const [priceInErrorState, setPriceInErrorState] = useState(false);
  const [uidInErrorState, setUidInErrorState] = useState(false);
  const [photoInErrorState, setPhotoInErrorState] = useState(false);
  const [popupIsOpen, setPopupIsOpen] = useState(false);
  const storage = getStorage();
  let PhotoFileName = "";
  

  const deleteItem = (itemKey) => {
    let Ref = dRef(DB)
    let item = child(Ref, 'Store'+auth.currentUser.uid+'/store/'+itemKey);
    remove(item);
    updateDateSet();
    document.querySelector('#saved-success-alert').innerHTML = '<div class="alert alert-success" role="alert">Item Deleted Successfully</div>';
  }
  
  const saveChanges = async (itemKey) =>{
      
    var error = false;
    if(barcodeInErrorState === true || pnameInErrorState === true || photoInErrorState === true || priceInErrorState === true || uidInErrorState === true)
      error = true
    else{
      var errorMsgsArr = document.querySelectorAll('.error-msg');
      for(var i = 0; i< errorMsgsArr.length; i++){
        errorMsgsArr[i].innerHTML = "";
      }
    }

    if(error === false){

        let Ref = dRef(DB);
        let item = child(Ref, 'Store'+auth.currentUser.uid+'/store/'+itemKey);

        if(isPhotoUpdated === false){
          update(item,{
            Barcode: barcode,
            'Product Name': pname,
            Price: price,
            UID: uid,
            Returnable: returnable === 'true'? true : false,
          }).then(response => {
            document.querySelector('#saved-success-alert').innerHTML = '<div class="alert alert-success" role="alert">Changes Saved Successfully</div>';
            updateDateSet();
          }).catch(error =>{
            console.log(error.message)
          });

        }

        else{
            update(item,{
              Barcode: barcode,
              'Product Name': pname,
              Price: price,
              UID: uid,
              Returnable: returnable === 'true'? true : false,
              Photo: photoURL
          }).then(response => {
            document.querySelector('#saved-success-alert').innerHTML = '<div class="alert alert-success" role="alert">Changes Saved Successfully</div>'; 
            updateDateSet();
          }).catch(error =>{
            console.log(error.message)
          });
        }
    }
  }
  
  const updateDateSet = ()=>{
    const dbRef = dRef(DB);
    get(child(dbRef, 'Store'+auth.currentUser?.uid)).then(snapshot  => {
      if (snapshot.exists()) {
        var pro = snapshot.val();
    
        let myDataArray = []
        let store = pro["store"];

        Object.keys(store).map(key => {
          console.log(key); 
          console.log(store[key]); 
          myDataArray.push({"Key" : key, "Barcode" : store[key]["Barcode"], "Price" : store[key]['Price'], "Name" : store[key]["Product Name"], "UID" : store[key]["RFID"], "Photo" : store[key]["ProductImage"], "Returnable" : store[key]["Returnable"] == true? "True" : "False"})
        });
        setItemsSet(myDataArray);

      } else {
          console.log("No data available");       
      }
     }).catch((error) => {
      console.error(error);
     }); 
  }
  
  const setItemData = (photo, barcode, name, price, uid, returnable)=>{
     setBarcode(barcode);
     setPName(name);
     setPrice(price);
     setUID(uid);
     setReturnable(returnable);
     setPhotoUpdated(photo);
     document.querySelector('#saved-success-alert').innerHTML = '';
  }

  const showAlert = (msg, func, actionName)=>{   
    confirmAlert({
    message: msg,
    buttons: [
        {
          label: actionName,
          onClick: func  
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
  
  const generatePhotoURL = () => {
    const imgRef = sRef(storage,"images/"+PhotoFileName);
      uploadBytes(imgRef,photo).then(() => {
          getDownloadURL(imgRef).then((url)=>{
            setPhotoURL(url)
          })
      })
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
 
  const handleBarcodeChange = (val, originalBarcode)=>{ 
    let error = false;
    val = val.trim();
    setBarcode(val)
    datum.map(item=>{
      if(item['Barcode'] == val && item['Barcode'] != originalBarcode){
        error = true;
        setBarcodeInErrorState(true);
        document.querySelector('#error-msg-br').innerHTML = 'Barcode is already exists<br>';
        document.querySelector('#error-msg-br').style.visibility = "visible";
      }
    })
    if(val == ''){
      error = true;
      setBarcodeInErrorState(true);
      document.querySelector('#error-msg-br').innerHTML = 'Barcode is required<br>';
      document.querySelector('#error-msg-br').style.visibility = "visible";
    }
    if(!error){
      setBarcodeInErrorState(false);
      document.querySelector('#error-msg-br').innerHTML = '';
      document.querySelector('#error-msg-br').style.visibility = "hidden";
    }
  }
  
  const handleProductNameChange = (val)=>{
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
    setPName(val)
    if(val == ''){
      error = true;
      setPNameInErrorState(true);
      document.querySelector('#error-msg-pn').innerHTML = 'Product name is required<br>';
      document.querySelector('#error-msg-pn').style.visibility = "visible";
    }
    if(!error){
      setPNameInErrorState(false);
      document.querySelector('#error-msg-pn').innerHTML = '';
      document.querySelector('#error-msg-pn').style.visibility = "hidden";
    }
  }

  const handlePriceChange = (val)=>{
    let error = false;
    setPrice(val)
    if(val == ''){
      error = true;
      setPriceInErrorState(true);
      document.querySelector('#error-msg-pr').innerHTML = 'Price is required<br>';
      document.querySelector('#error-msg-pr').style.visibility = "visible";
    }
    if(val < 0){
      error = true;
      setPriceInErrorState(true);
      document.querySelector('#error-msg-pr').innerHTML = "Price can't be negative<br>";
      document.querySelector('#error-msg-pr').style.visibility = "visible";
    }
    if(val > 1000000){
      error = true;
      setPriceInErrorState(true);
      document.querySelector('#error-msg-pr').innerHTML = "Maximium price is 1000000<br>";
      document.querySelector('#error-msg-pr').style.visibility = "visible";
    }
    if(!error){
      setPriceInErrorState(false);
      document.querySelector('#error-msg-pr').innerHTML = '';
      document.querySelector('#error-msg-pr').style.visibility = "hidden";
    }
  }

  const handleUIDChange = (val, originalUID)=>{
    let error = false;
    val = val.trim();
    setUID(val)
    datum.map(item=>{
      if(item['UID'] == val && item['UID'] != originalUID){
        error = true;
        setUidInErrorState(true);
        document.querySelector('#error-msg-uid').innerHTML = 'UID is already exists<br>';
        document.querySelector('#error-msg-uid').style.visibility = "visible";
      }
    })
    if(val == ''){
      error = true;
      setUidInErrorState(true);
      document.querySelector('#error-msg-uid').innerHTML = 'UID is required<br>';
      document.querySelector('#error-msg-uid').style.visibility = "visible";
    }
    if(!error){
      setUidInErrorState(false);
      document.querySelector('#error-msg-uid').innerHTML = '';
      document.querySelector('#error-msg-uid').style.visibility = "hidden";
    }
  }
  
  const handleReturnableChange = (val)=>{setReturnable(val.toLowerCase());}
    

  return (
    itemsSet?
    <>
     <div id="products-container">
      <table id="products-box" className='col-12'>
          <thead>
            <tr>
            <th>Photo</th>
            <th>Barcode</th>
            <th id="name-col">Product Name</th>
            <th>Price</th>
            <th>RFID UID</th>
            <th>Returnable</th>
            <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {
            itemsSet && itemsSet.map ?
            itemsSet.map(item => (
              <tr>
                   <td>
                    <img src={item["Photo"]} className="product-img"></img>
                   </td>
                   <td>{item["Barcode"]}</td>
                   <td><div className="second-col">{item["Name"]}</div></td>
                   <td>{item["Price"]}</td>
                   <td>{item["UID"]}</td>
                   <td>{item["Returnable"]}</td>
                   <td>
                    <Popup open={popupIsOpen} trigger={<span className='edit-icons'><FiEdit /></span>} position="left center" contentStyle={{ width: '800px' }} onOpen={()=>setItemData(item["Photo"],item["Barcode"],item["Name"],item["Price"],item["UID"],item["Returnable"])}>
                      <div id='prompt-back-layer'>
                        <div id='edit-item-prompt'>
                          <div className='w-100 d-flex p-3 justify-content-end'><button className='close-edit-item-popup'>x</button></div>
                          <div className='p-4'>
                            <div className='w-100 d-flex justify-content-around'>
                              <div className=''>
                                <div className='d-flex flex-column'>
                                  <label htmlFor='Barcode' className='edit-item-label'>Barcode</label>
                                  <input name='Barcode' maxLength={30} size={41} className='mt-2 edit-item-input' value={barcode} onChange={(e)=>{handleBarcodeChange(e.target.value, item['Barcode'])}}></input>
                                  <p className='error-msg' id="error-msg-br"></p>
                                </div>
                                <div className='d-flex flex-column mt-3'>
                                  <label htmlFor='PName' className='edit-item-label'>Product Name</label>
                                  <input name='PName' maxLength={40} size={41} className='mt-2 edit-item-input' value={pname} onChange={(e)=>{handleProductNameChange(e.target.value)}}></input>
                                  <p className='error-msg' id="error-msg-pn"></p>
                                </div>
                                <div className='d-flex flex-column mt-3'>
                                  <label htmlFor='Price' className='edit-item-label'>Price</label>
                                  <input name='Price' type='number' min={0} max={1000000} className='mt-2 edit-item-input' value={price} onChange={(e)=>{handlePriceChange(e.target.value)}}></input>
                                  <p className='error-msg' id="error-msg-pr"></p>
                                </div>
                                <div className='d-flex flex-column mt-3'>
                                  <label htmlFor='UID' className='edit-item-label'>RFID UID</label>
                                  <input name='UID' maxLength={30} size={31} className='mt-2 edit-item-input' value={uid} onChange={(e)=>{handleUIDChange(e.target.value, item['UID'])}}></input>
                                  <p className='error-msg' id="error-msg-uid"></p>
                                </div>
                                <div className='d-flex flex-column mt-3'>
                                  <label htmlFor='Returnable' className='edit-item-label'>Returnable</label>
                                  <select name='Returnable' className='mt-2 edit-item-input' onChange={(e)=>{handleReturnableChange(e.target.value)}}>
                                    {
                                      item["Returnable"] == "True"? 
                                      <>
                                      <option selected={true}>True</option>
                                      <option>False</option>
                                      </>
                                      :
                                      <>
                                      <option>True</option>
                                      <option selected={true}>False</option>
                                      </>
                                    } 
                                  </select>
                                </div>
                              </div>
                              <div className='d-flex align-items-center justify-content-center'>
                                <div className='d-flex flex-column align-items-center justify-content-center'>
                                  <p id="product-photo-title">Product Photo</p>
                                  <div>
                                      <div id="photo-container" className='d-flex justify-content-center'>     
                                          <img src={photoUpdated} className='p-4' height='180' width='180'></img>
                                      </div>
                                      <div className='d-flex justify-content-end' id="edit-btn-container">
                                          <input type='file' id='photo-input' onChange={(e) => {handlePhotoChange(e)}} hidden></input>
                                          <button id='edit-photo-btn' onClick={clickFileInput}><MdModeEditOutline/></button>
                                      </div>
                                      <p className='error-msg' id="error-msg-photo"></p>
                                  </div>
                                </div>
                              </div>
                            </div>
                            <div className='container mt-5 d-flex justify-content-center'>
                              <button id="save-changes-btn" onClick={()=>saveChanges(item["Key"])}>Save Changes</button>
                            </div>
                          </div>
                        </div>
                      </div>
                    </Popup>
                    <span className='delete-icons' onClick={()=>showAlert('Delete this item?',() => {deleteItem(item["Key"])}, 'Delete')}><MdDelete /></span>
                  </td>
              </tr>
            )) : null
            //<span className='edit-icons' onClick={()=>editItem(item["Key"])}><FiEdit /></span>
            }

          </tbody>         
      </table>
     </div>
    </>
    :
    null
  );
}

function Products_List(){


        const [done,setDone] = useState(0);
        const [items,setItems] = useState();
        
        
        useEffect(() => {
          getList(); 
        },[done]);
        
        const getList =  ()=> {

          const dbRef = dRef(DB);
          
          get(child(dbRef, 'Store'+auth.currentUser?.uid)).then(snapshot  => {
            if (snapshot.exists()) {
              var pro = snapshot.val();
          
              let myDataArray = []
              let store = pro["store"];

              console.log(store.length)
              Object.keys(store).map(key => {
                console.log(key); 
                console.log(store[key]); 
                myDataArray.push({"Key" : key, "Barcode" : store[key]["Barcode"], "Price" : store[key]['Price'], "Name" : store[key]["Product Name"], "UID" : store[key]["RFID"], "Photo" : store[key]["ProductImage"], "Returnable" : store[key]["Returnable"] == true? "True" : "False"})
              });
              /*
              store.map(doc =>{
                myDataArray.push({"Key" : store.indexOf(doc), "Barcode" : doc["Barcode"], "Price" : doc.Price, "Name" : doc["Product Name"], "UID" : doc["UID"], "Photo" : doc["Photo"]})
                }
              )
              */

              setItems(myDataArray);
              setDone(1);
     
            } else {
                console.log("No data available");       
            }
           }).catch((error) => {
            console.error(error);
           }); 
           
        }
    
        
        return(   
            <>
            <h1 className="mt-3 pb-4" id='l'>Products List</h1>
            <span id='saved-success-alert'></span>
             {
              items?
              <Child datum={items}/> 
              : <img src={loading} className="loading-img"></img>
             }  
            </>     
        )    
}
export default Products_List;
