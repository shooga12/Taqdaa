import React,{useEffect,useState, Fragment} from 'react';
import auth,{DB,db} from '../../shared/firebase';
import ReactDOM from "react-dom";
import {reauthenticateWithPopup,reauthenticateWithCredential, fetchSignInMethodsForEmail, deleteUser, EmailAuthProvider} from 'firebase/auth';
import { doc, getDoc, updateDoc,deleteDoc } from "firebase/firestore";
import { async } from '@firebase/util';
import {useNavigate} from 'react-router-dom';
import parse from 'html-react-parser'
import {ref as dRef,child, get, remove} from "firebase/database";
import {validEmail,validName,emptyImage,validPhone, validNameWithDigits} from '../../shared/validations';
import {ref as sRef, getStorage, uploadBytes, getDownloadURL, uploadBytesResumable } from "firebase/storage";
import {MdModeEditOutline} from 'react-icons/md';
import { confirmAlert } from 'react-confirm-alert'; 
import { render } from '@testing-library/react';

function Profile(){
   
   const [data,setData] = useState();
   const [done,setDone] = useState(0);
   const [email, setEmail] = useState("");
   const [currentEmail, setCurrentEmail] = useState("");
   const [firstName, setFirstName] = useState("");
   const [lastName, setLastName] = useState("");
   const [companyName, setCompanyName] = useState("");
   const [storeName, setStoreName] = useState("");
   const [phone, setPhone] = useState("");
   const [StoreLogo, setStoreLogo] = useState("");
   const [isLogoUpdated, setIsLogoUpdated] = useState(false);
   const [logoUpdated, setLogoUpdated] = useState(""); 
   const [logoURL, setLogoURL] = useState("");
   let password = "";
   const [passwordErrorState, setPasswordErrorState] = useState(false);
   let BrandLogoFileName = "";
   const storage = getStorage();
   const navigate = useNavigate();

   useEffect(() => {
    getData();
    console.log("Data:");
    console.log(data);
   },[done]);

   const getData = async ()=>{
    const docRef = doc(db, "Stores", 'Store'+auth.currentUser?.uid);
    const docSnap = await getDoc(docRef);
    if (docSnap.exists()) {
        console.log("Document data:", docSnap.data());
        let myDataArray = {};
        for (var key in docSnap.data()) {
            myDataArray[key] = docSnap.data()[key]
        }
        setData(myDataArray);
        setDone(1);
        setEmail(myDataArray['Email']);
        setCurrentEmail(myDataArray['Email']);
        setFirstName(myDataArray['FirstName']);
        setLastName(myDataArray['LastName']);
        setCompanyName(myDataArray['CompanyName']);
        setStoreName(myDataArray['StoreName']);
        setPhone(myDataArray['Phone']);
        setStoreLogo(myDataArray['StoreLogo']);
        setLogoUpdated(myDataArray['StoreLogo']);
        
      } else {
        console.log("No such document!");
    }
   }

   const generateLogoURL = () => {
    console.log("Logo: "+StoreLogo)
    const imgRef = sRef(storage,"images/"+BrandLogoFileName);
    uploadBytesResumable(imgRef,StoreLogo).then(() => {
          getDownloadURL(imgRef).then((url)=>{
            setLogoURL(url)
            console.log("Logo URL: "+logoURL)
          })
      }) 
   }

  const handleLogo = (e)=>{
    let fileType = e.target.files[0].type; 
    fileType = fileType.toString().toLowerCase();
    let validExtensions = ["image/jpeg","image/png","image/jpg"]; //adding some valid image extensions in array
    if(!validExtensions.includes(fileType)){
        alert("Only .jpeg, jpg, and .png files are allowed");
        e.target.value = "";
    }
    else{
      setStoreLogo(e.target.files[0]);
      BrandLogoFileName = e.target.files[0].name;
      setIsLogoUpdated(true);
      setLogoUpdated(window.URL.createObjectURL(e.target.files[0]));
      generateLogoURL();
    }
  }

   const handleFirstNameChange = (val)=>{
    let error = false;
    val = val.trim();
    setFirstName(val);
    if(val == ''){
      error = true;
      document.querySelector('#error-msg-fn').innerHTML = 'First Name is required<br>';
      document.querySelector('#error-msg-fn').style.visibility = "visible";
    }
    if(val != '' && !validName(val)){
      error = true;
      document.querySelector('#error-msg-fn').innerHTML = 'First name should contain only letters';
      document.querySelector('#error-msg-fn').style.visibility = "visible";
    }
    if(!error){
      document.querySelector('#error-msg-fn').innerHTML = '';
      document.querySelector('#error-msg-fn').style.visibility = "hidden";
    }
  }

  const handleLastNameChange = (val)=>{
    let error = false;
    val = val.trim();
    setLastName(val);
    if(val == ''){
      error = true;
      document.querySelector('#error-msg-ln').innerHTML = 'Last Name is required<br>';
      document.querySelector('#error-msg-ln').style.visibility = "visible";
    }
    if(val != '' && !validName(val)){
      error = true;
      document.querySelector('#error-msg-ln').innerHTML = 'Last name should contain only letters';
      document.querySelector('#error-msg-ln').style.visibility = "visible";
    }
    if(!error){
      document.querySelector('#error-msg-ln').innerHTML = '';
      document.querySelector('#error-msg-ln').style.visibility = "hidden";
    }
  }

  const handleCompanyNameChange = (val)=>{
    console.log(logoUpdated)
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
    setCompanyName(val);

    if(val == ''){
      error = true;
      document.querySelector('#error-msg-cn').innerHTML = 'Company Name is required<br>';
      document.querySelector('#error-msg-cn').style.visibility = "visible";
    }
    if(val != '' && !validNameWithDigits(val)){
      error = true;
      document.querySelector('#error-msg-cn').innerHTML = 'Company name can contain only letters and digits and the following special character: &';
      document.querySelector('#error-msg-cn').style.visibility = "visible";
    }
    if(!error){
      document.querySelector('#error-msg-cn').innerHTML = '';
      document.querySelector('#error-msg-cn').style.visibility = "hidden";
    }
  }

  const handleBrandNameChange = (val)=>{
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
    setStoreName(val);
    if(val == ''){
      error = true;
      document.querySelector('#error-msg-bn').innerHTML = 'Brand Name is required<br>';
      document.querySelector('#error-msg-bn').style.visibility = "visible";
    }
    if(val != '' && !validNameWithDigits(val)){
      error = true;
      document.querySelector('#error-msg-bn').innerHTML = 'Brand name can contain only letters and digits and the following special character: &';
      document.querySelector('#error-msg-bn').style.visibility = "visible";
    }
    if(!error){
      document.querySelector('#error-msg-bn').innerHTML = '';
      document.querySelector('#error-msg-bn').style.visibility = "hidden";
    }
  }

  const handleEmailChange = (val)=>{

    let error = false;
    val = val.trim();
    setEmail(val);
    if(val == ''){
      error = true;
      document.querySelector('#error-msg-email').innerHTML = 'Email is required<br>';
      document.querySelector('#error-msg-email').style.visibility = "visible";
    }
    if(val != '' && !validEmail(val)){
      error = true;
      document.querySelector('#error-msg-email').innerHTML = 'Invalid email';
      document.querySelector('#error-msg-email').style.visibility = "visible";
    }
    if(val != '' && validEmail(val)){
      fetchSignInMethodsForEmail(auth,val)
      .then((signInMethods) => {
        if (signInMethods.length) {
          error = true;
          document.querySelector('#error-msg-email').innerHTML = 'Email Already Exists!';
          document.querySelector('#error-msg-email').style.visibility = "visible";
        } 
      })
    .catch((error) => {});
    }
    if(!error){
      document.querySelector('#error-msg-email').innerHTML = '';
      document.querySelector('#error-msg-email').style.visibility = "hidden";
    }
  }

  const handlePhoneChange = (val)=>{
  
    let error = false;
    val = val.trim();
    let tmp = val;
    val = '';
    for(var i = 0; i<tmp.length; i++){
      if(/^[0-9]$/.test(tmp[i]))
        val += tmp[i];
    }
    setPhone(val)
    if(phone == ''){
      error = true;
      document.querySelector('#error-msg-pn').innerHTML = 'Phone number is required<br>';
      document.querySelector('#error-msg-pn').style.visibility = "visible";
    }
    if(phone != '' && !validPhone(phone.toString())){
      error = true;
      document.querySelector('#error-msg-pn').innerHTML = 'Phone number must be 10 digits';
      document.querySelector('#error-msg-pn').style.visibility = "visible";
    }
    if(!error){
      document.querySelector('#error-msg-pn').innerHTML = '';
      document.querySelector('#error-msg-pn').style.visibility = "hidden";
    }
  }

  const handlePassword = (val) =>{
     let error = false;
     val = val.trim();
     password = val;
     console.log(password);
     //Remove wrong password error msg
     let errorMSG = document.querySelector('#wrong-pass-error-msg');
     errorMSG.innerHTML = '';
     errorMSG.style.visibility = 'hidden';

     if(val == ''){
        error = true;
        setPasswordErrorState(true);
        document.querySelector('#pass-error-msg').innerHTML = 'Password is required';
        document.querySelector('#pass-error-msg').style.visibility = 'visible';
     }
     if(!error){
        setPasswordErrorState(false);
        document.querySelector('#pass-error-msg').innerHTML = '';
        document.querySelector('#pass-error-msg').style.visibility = 'hidden';
     }
  }
  

 
  const showAlert = (msg, func, actionName) => {

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

   const checkIfEmailExists = (email)=>{
    let exists = false;
    fetchSignInMethodsForEmail(auth,email)
    .then((signInMethods) => {
      if (signInMethods.length) {
        exists = true;
      } 
    })
    .catch((error) => { 
      // Some error occurred.
    });
    return exists;
  }


   const addData =  async () =>{
      
    var errorMsgsArr = document.querySelectorAll('.error-msg');
    for(var i = 0; i< errorMsgsArr.length; i++){
      errorMsgsArr[i].innerHTML = "";
    }
    var error = false;
    if(email == ''){
      error = true;
      document.querySelector('#error-msg-email').innerHTML = 'Email is required<br>';
      document.querySelector('#error-msg-email').style.visibility = "visible";
    }
    if(firstName == ''){
      error = true;
      document.querySelector('#error-msg-fn').innerHTML = 'First Name is required<br>';
      document.querySelector('#error-msg-fn').style.visibility = "visible";
    }
    if(lastName == ''){
      error = true;
      document.querySelector('#error-msg-ln').innerHTML = 'Last Name is required<br>';
      document.querySelector('#error-msg-ln').style.visibility = "visible";
    }
    if(phone == ''){
      error = true;
      document.querySelector('#error-msg-pn').innerHTML = 'Phone number is required<br>';
      document.querySelector('#error-msg-pn').style.visibility = "visible";
    }
    if(companyName == ''){
      error = true;
      document.querySelector('#error-msg-cn').innerHTML = 'Company Name is required<br>';
      document.querySelector('#error-msg-cn').style.visibility = "visible";
    }
    if(storeName == ''){
      error = true;
      document.querySelector('#error-msg-bn').innerHTML = 'Brand Name is required<br>';
      document.querySelector('#error-msg-bn').style.visibility = "visible";
    }
    if(emptyImage(StoreLogo)){
      error = true;
      document.querySelector('#error-msg-sl').innerHTML = 'Brand Logo is required<br>';
      document.querySelector('#error-msg-sl').style.visibility = "visible";
    }
    if(firstName != '' && !validName(firstName)){
      error = true;
      document.querySelector('#error-msg-fn').innerHTML = 'First name should contain only letters';
      document.querySelector('#error-msg-fn').style.visibility = "visible";
    }
    if(lastName != '' && !validName(lastName)){
      error = true;
      document.querySelector('#error-msg-ln').innerHTML = 'Last name should contain only letters';
      document.querySelector('#error-msg-ln').style.visibility = "visible";
    }
    if(email != '' && !validEmail(email)){
      error = true;
      document.querySelector('#error-msg-email').innerHTML = 'Invalid email';
      document.querySelector('#error-msg-email').style.visibility = "visible";
    }
    if(email != '' && validEmail(email)){
      error = checkIfEmailExists(email);
      if(error){
        document.querySelector('#error-msg-email').innerHTML = 'Email Already Exists!';
        document.querySelector('#error-msg-email').style.visibility = "visible";
      }
    }
    if(phone != '' && !validPhone(phone.toString())){
      error = true;
      document.querySelector('#error-msg-pn').innerHTML = 'Invalid, phone number must be 10 digits';
      document.querySelector('#error-msg-pn').style.visibility = "visible";
    }
    if(error === false){
        //let store = doc(db, "Stores", 'Store'+auth.currentUser.uid);
        if(isLogoUpdated === false){
          updateDoc(doc(db, "Stores", 'Store'+auth.currentUser?.uid),{
            FirstName: firstName,
            LastName: lastName,
            CompanyName: companyName,
            StoreName: storeName,
            Email: email,
            Phone: phone,
          } ).then(response => {
            document.querySelector('#saved-success-alert').innerHTML = '<div class="alert alert-success" role="alert">Changes Saved Successfully</div>'
        
          }).catch(error =>{
            console.log(error.message)
          });
        }
        else{
            updateDoc(doc(db, "Stores", 'Store'+auth.currentUser?.uid),{
              FirstName: firstName,
              LastName: lastName,
              CompanyName: companyName,
              StoreName: storeName,
              Email: email,
              Phone: phone,
              StoreLogo: logoURL,
          } ).then(response => {
            document.querySelector('#saved-success-alert').innerHTML = '<div class="alert alert-success" role="alert">Changes Saved Successfully</div>'
            
          }).catch(error =>{
            console.log(error.message)
          });
        }

    }
  }
   
   const deleteStore = (password)=>{
     let errorState = false;

     document.querySelector('#password-input').value = '';
     document.querySelector('#pass-error-msg').innerHTML = '';
     document.querySelector('#pass-error-msg').style.visibility = 'hidden';
     //Remove Error MSG
     let errorMSG = document.querySelector('#wrong-pass-error-msg');
     errorMSG.innerHTML = '';
     errorMSG.style.visibility = 'hidden';

     //Display Prompt
     document.querySelector('#password-prompt-container').style.display = 'block';
     document.querySelector('#close-prompt-btn').addEventListener('click', ()=>{
       document.querySelector('#password-prompt-container').style.display = 'none';
     }, false)


     /*
     reauthenticateWithCredential(user, credential).then(() => {
      user.delete().then(async () => {
        const storeSetRef = await dRef(DB, 'Store'+userID)
        await remove(storeSetRef);
       //await deleteDoc(doc(db, "Stores", 'Store'+userID));
        showAlertSuccess();
       }).catch((error) => {
         console.log(error);
       });
      }).catch((error) => {
        // An error ocurred
        // ...
      });
      */
   
  }

  const submitCredentials = ()=>{

    const user = auth.currentUser;
    const userID = user.uid;
    if(passwordErrorState === false){
      console.log("Password: " + password);
      //Assign Credentials
      const credential = EmailAuthProvider.credential(
        user.email, 
        password
      );
      
      reauthenticateWithCredential(user, credential).then(() => {
        // User re-authenticated.
        console.log('authenticated');
        user.delete().then(async () => {
          const storeSetRef = await dRef(DB, 'Store'+userID)
          await remove(storeSetRef);
          await deleteDoc(doc(db, "Stores", 'Store'+userID));
          showAlertSuccess();
         }).catch((error) => {
           console.log(error);
         });
      })
      .catch(function(error) {
        // Credential mismatch or some other error.
        if(error.code == 'auth/wrong-password'){
          let errorMSG = document.querySelector('#wrong-pass-error-msg');
          errorMSG.innerHTML = 'Wrong Password';
          errorMSG.style.visibility = 'visible';
        }
      });
    }
   }



   auth.onAuthStateChanged(function(user) {
    if (user) {
      
    } else {
      navigate('/');
    }
   });

   const showAlertSuccess = () => {
    var msg = parse('<span style="" id="dataset-success-msg">Store Deleted Successfully</span>');
  
    confirmAlert({
    message: msg,
    buttons: [   
        {
        label: 'OK',
        //onClick: () => alert('Click No')
        }
    ]
    });
   }

   const clickFileInput = ()=>{
    let input = document.querySelector("#logo-input");
    input.click();
   }

        return(  
            <>
            <h1 className="mt-3">Profile</h1>
            <span id='saved-success-alert'></span>
            <div id="profile-container">
             <div className='col-8 d-flex justify-content-between'>
              <div className='col-6'>
                <div className='row'>
                  <label htmlFor='f_name'>First Name</label>
                  <input type='text' name='f_name' onChange={(e) => handleFirstNameChange(e.target.value)} value={data? firstName : ''}></input>
                  <p className='error-msg' id="error-msg-fn"></p>
                </div>
                <div className='row'>
                  <label htmlFor='l_name'>Last Name</label>
                  <input type='text' name='l_name' onChange={(e) => handleLastNameChange(e.target.value)} value={data? lastName : ''}></input>
                  <p className='error-msg' id="error-msg-ln"></p>
                </div>
                <div className='row'>
                  <label htmlFor='c_name'>Company Name</label>
                  <input type='text' name='c_name' onChange={(e) => handleCompanyNameChange(e.target.value)} value={data? companyName : ''}></input>
                  <p className='error-msg' id="error-msg-cn"></p>
                </div>
                <div className='row'>
                  <label htmlFor='b_name'>Brand Name</label>
                  <input type='text' name='b_name' onChange={(e) => handleBrandNameChange(e.target.value)} value={data? storeName : ''}></input>
                  <p className='error-msg' id="error-msg-bn"></p>
                </div>
                <div className='row'>
                  <label htmlFor='email'>Email</label>
                  <input type='email' name='email' onChange={(e)=> handleEmailChange(e.target.value)} value={data? email : ''}></input>
                  <p className='error-msg' id="error-msg-email"></p>
                </div>
                <div className='row'>
                  <label htmlFor='phone'>Phone Number</label>
                  <input type='tel' name='phone' onChange={(e) => handlePhoneChange(e.target.value)} value={data? phone : ''} maxLength={10}></input>
                  <p className='error-msg' id="error-msg-pn"></p>
                </div>
              </div>
              <div className='d-flex flex-column align-items-center justify-content-center'>
                <p id="brand-logo-title">Brand Logo</p>
                <div>
                    <div id="logo-container">     
                        <img src={data? logoUpdated : ''} className='p-4' height='180' width='180'></img>
                    </div>
                    <div className='d-flex justify-content-end' id="edit-btn-container">
                        <input type='file' id='logo-input' hidden onChange={(e) => handleLogo(e)}></input>
                        <button id='edit-logo-btn' onClick={clickFileInput}><MdModeEditOutline/></button>
                    </div>
                </div>
              </div>
             </div>
             <div className='mt-2 d-flex justify-content-center'>
              <div className='col-4 d-flex justify-content-around'>
                <button id="save-changes-btn" onClick={()=>showAlert('Do You Want to Save Your Changes?',()=>addData(),'Save')}>Save Changes</button>
                <button id="delete-store-btn" onClick={()=>showAlert('Delete Store?',()=>deleteStore(password),'Delete') }>Delete Store</button>
              </div>
            </div>
            </div> 
            {
            <div className='w-100' id='password-prompt-container'>
              <div id='dark-layer'></div>
                <div id='password-prompt'>
                  <div>
                    <div className='w-100 d-flex justify-content-end'><span id='close-prompt-btn'><button>x</button></span></div>
                    <p id='wrong-pass-error-msg'></p>
                    <div className='mt-3 d-flex flex-column align-items-center'>
                      <div className='d-flex flex-column'>
                        <label htmlFor='password' className='mb-2'>Password</label>
                        <input type={'password'} name='password' id='password-input' onChange={(e)=>handlePassword(e.target.value)}></input>
                        <p id='pass-error-msg' className='mt-1'></p>
                      </div>
                      <button id='submit' onClick={()=>submitCredentials()}>Submit</button>
                    </div>
                  </div>
                </div>
              </div>
            } 
            </>  
              
        )
    
}
export default Profile;