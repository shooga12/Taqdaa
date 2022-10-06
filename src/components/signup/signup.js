import React, { useState, useMemo} from 'react';
import {createUserWithEmailAndPassword,fetchSignInMethodsForEmail} from 'firebase/auth';
import './style.css';
import parse from 'html-react-parser'
import { confirmAlert } from 'react-confirm-alert'; 
import Logo from '../../shared/Logo_Light.png';
import auth, {db} from '../../shared/firebase';
import {validEmail,validName,emptyImage,validPhone, validNameWithDigits} from '../../shared/validations';
import {useNavigate} from 'react-router-dom';
import emailjs from 'emailjs-com';
import { async } from '@firebase/util';
import { collection, doc, setDoc, addDoc }  from 'firebase/firestore';
import {getStorage, ref, uploadBytes, getDownloadURL } from "firebase/storage";
import { parseHTML } from 'jquery';
import { GoogleMap, Marker, useJsApiLoader, MarkerF } from "@react-google-maps/api"
const containerStyle = {
  width: '400px',
  height: '400px'
};

const center = {
  lat: 24.725203,
  lng: 46.623661
};
function Signup(){

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [companyName, setCompanyName] = useState("");
  const [storeName, setStoreName] = useState("");
  const [phone, setPhone] = useState("");
  const [CommercialRegister, setCommercialRegister] = useState("");
  const [CommercialRegisterURL, setCommercialRegisterURL] = useState("");
  const [CommercialRegisterfileName, setCommercialRegisterfileName] = useState("No File Selected");
  const [BrandLogoFileName, setBrandLogoFileName] = useState("No File Selected");
  const [StoreLogo, setStoreLogo] = useState("");
  const [logoURL, setLogoURL] = useState("");
  const storage = getStorage();
  //const [userID, setUserID] = useState("");

  
  const { isLoaded } = useJsApiLoader({
    id: 'google-map-script',
    googleMapsApiKey: "AIzaSyDvPoFbe6MDqYRGifizC34rXPlgGzCd9sE"
  })

  const [map, setMap] = React.useState(null)

  const onLoad = React.useCallback(function callback(map) {
    const bounds = new window.google.maps.LatLngBounds(center);
    map.fitBounds(bounds);
    setMap(map)
  }, [])

  const onUnmount = React.useCallback(function callback(map) {
    setMap(null)
  }, [])

  let userID = "";
  const navigate = useNavigate();
    const generatePass = () => {
      var chars = "0123456789abcdefghijklmnopqrstuvwxyz!@#$%^&*()ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      var passwordLength = 12;
      var password = "";
      for (var i = 0; i <= passwordLength; i++) {
        var randomNumber = Math.floor(Math.random() * chars.length);
        password += chars.substring(randomNumber, randomNumber +1);
      }
      return password;
    }
    const sendEmail = (email,password)=>{
      var templateParams = {
        user_email: email,
        password: password,
      };
     
      emailjs.send('service_vokdjrk', 'template_mc406el', templateParams, '-aRnBceb5BE03lptN')
        .then(function(response) {
           console.log('SUCCESS!', response.status, response.text);
        }, function(error) {
           console.log('FAILED...', error);
      });
    }
    const createAccount = async ()=>{
      
      setPassword(generatePass());
      createUserWithEmailAndPassword(auth, email, password)
      .then(async(userCredential) => {
        // Signed in 
        const user = userCredential.user;
        userID = user.uid;
        auth.signOut();
        showAlert();
        sendEmail(email,password);
        await setDoc(doc(db, "Stores", 'Store'+userID), {
              FirstName: firstName,
              LastName: lastName,
              CompanyName: companyName,
              StoreName: storeName,
              Email: email,
              Phone: phone,
              CommercialRegister: CommercialRegisterURL,
              StoreLogo: logoURL,
              lat: pos["lat"],
              lng: pos["lng"],
              StoreId:'Store'+userID,
              kilometers: "5.8"
        });
        
      })
      .catch((error) => {
        const errorCode = error.code;
        const errorMessage = error.message;
        alert(errorMessage);
      });
    }
     auth.onAuthStateChanged(function(user) {
        if (user) {
          navigate('/dashboard');
        } else {

        }
     });


     const generateLogoURL = () => {
        const imgRef = ref(storage,"images/"+CommercialRegister.name);
        uploadBytes(imgRef,CommercialRegister).then(() => {
            getDownloadURL(imgRef).then((url)=>{
              setCommercialRegisterURL(url)
            })
        })
     }

     const generateCrURL = () => {
        const imgRef = ref(storage,"images/"+StoreLogo.name);
        uploadBytes(imgRef,StoreLogo).then(() => {
            getDownloadURL(imgRef).then((url)=>{
              setLogoURL(url)
            })
        })
    }

    const handleLogo = (e)=>{
      setBrandLogoFileName(e.target.files[0].name)
      let fileType = e.target.files[0].type; 
      fileType = fileType.toString().toLowerCase();
      let validExtensions = ["image/jpeg","image/png","image/jpg"]; //adding some valid image extensions in array
      if(!validExtensions.includes(fileType)){
          alert("Only .jpeg, jpg, and .png files are allowed");
          e.target.value = "";
      }
      else{
        setStoreLogo(e.target.files[0]);
      }
    }
    
    const handleCommercialRegister = (e)=>{
      setCommercialRegisterfileName(e.target.files[0].name)
      let fileType = e.target.files[0].type; 
      let validExtensions = ["application/pdf", "image/jpeg", "image/png", "image/jpg"]; //adding some valid image extensions in array
      if(!validExtensions.includes(fileType)){
          alert("Only .pdf, .jpeg, jpg, and .png files are allowed");
          e.target.value = "";
      }
      else{
        setCommercialRegister(e.target.files[0]);
      }
    }


    const showAlert = () => {
      var msg = parse('<span id="registration-msg">Store Registration Sent Successfully</span> <br><br> you will recieve an email if your registration get accepted')
      confirmAlert({
      message: msg,
      buttons: [
          {
          label: 'Ok',
          //onClick: () => alert('Click No')
          }
      ]
      });
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
        document.querySelector('#error-msg-sn').innerHTML = 'Brand Name is required<br>';
        document.querySelector('#error-msg-sn').style.visibility = "visible";
      }
      if(emptyImage(StoreLogo)){
        error = true;
        document.querySelector('#error-msg-sl').innerHTML = 'Brand Logo is required<br>';
        document.querySelector('#error-msg-sl').style.visibility = "visible";
      }
      if(emptyImage(CommercialRegister)){
        error = true;
        document.querySelector('#error-msg-cr').innerHTML = 'Commercial Register is required<br>';
        document.querySelector('#error-msg-cr').style.visibility = "visible";
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
          generateCrURL();
          generateLogoURL();
          
          try {
            const docRef = await addDoc(collection(db, "Requests"), {
              FirstName: firstName,
              LastName: lastName,
              CompanyName: companyName,
              StoreName: storeName,
              Email: email,
              Phone: phone,
              CommercialRegister: CommercialRegisterURL,
              StoreLogo: logoURL,
              Status: 'Accepted',
            });
            console.log("Document written with ID: ", docRef.id);
            createAccount(email)
            

          } catch (e) {
            console.error("Error adding document: ", e);
          }
      }
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
        .catch((error) => { 
          // Some error occurred.
        });
          /*
          error = checkIfEmailExists(val);
          alert("Error: "+error)
          if(error){
            document.querySelector('#error-msg-email').innerHTML = 'Email Already Exists!';
            document.querySelector('#error-msg-email').style.visibility = "visible";
          }
          */
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
      const [pos, setPos] = useState({
        lat: 24.725203,
        lng: 46.623661
      });
      return(
        <div className='container w-100 d-flex align-items-center signup-cont'>
        <div id="signup-box" className="col-12 col-lg-11 col-xl-9">
          <div id="box-content-container" className="col-11">
           <div className="container pt-4 pb-4 pl-5 pr-5 d-flex h-100 flex-column align-items-center justify-content-around">
             <img src={Logo} height="90" className="mb-3" alt="logo"/>
             <h4 className='mt-4 mb-4'>Store Registeration</h4><br/>
                <div className='col-9'>
                  <div className="col-12 d-flex flex-column flex-lg-row justify-content-between">
                    <div>
                      <label htmlFor='firstname'>First Name</label>
                      <input name="firstname" type="text" placeholder="First Name" className="input-field" onChange={(e) => handleFirstNameChange(e.target.value)} value={firstName} required maxLength={30}/> 
                      <p className='error-msg' id="error-msg-fn"></p>
                    </div>
                    <div>
                      <label htmlFor='lastname'>Last Name</label>
                      <input name="lastname" type="text" placeholder="Last Name" className="input-field" onChange={(e) => handleLastNameChange(e.target.value)} value={lastName} required maxLength={30}/>
                      <p className='error-msg' id="error-msg-ln"></p>
                    </div>
                  </div>

                  <div className="col-12 d-flex flex-column flex-lg-row justify-content-between">
                    <div>
                      <label htmlFor='companyname'>Company Name</label>
                      <input name="companyname" type="text" placeholder="company Name" className="input-field" onChange={(e) => handleCompanyNameChange(e.target.value)} value={companyName} required maxLength={30}/>
                      <p className='error-msg' id="error-msg-cn"></p>
                    </div>
                    <div>
                      <label htmlFor='storename'>Brand Name</label>
                      <input name="storename" type="text" placeholder="Brand Name" className="input-field" onChange={(e) => handleBrandNameChange(e.target.value)} value={storeName} required maxLength={30}/>
                      <p className='error-msg' id="error-msg-bn"></p>
                    </div>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  </div>

                  <div className="col-12 d-flex flex-column flex-lg-row justify-content-between">
                    <div>
                       <label htmlFor='email'>Email</label>
                       <input name="email" type="text" placeholder="example@gmail.com" className="input-field" onChange={(e)=> handleEmailChange(e.target.value)} value={email} required maxLength={60}/>
                       <p className='error-msg' id="error-msg-email"></p>
                    </div>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <div>
                      <label htmlFor='phone'>Phone Number</label>
                      <input name="phone" type="tel" placeholder="05xxxxxxxx" className="input-field" onChange={(e) => handlePhoneChange(e.target.value)} value={phone} required maxLength={10}/>
                      <p className='error-msg' id="error-msg-pn"></p>
                    </div>
                  </div>
                  
                </div>

                <div className="col-9 d-flex flex-column flex-lg-row">
                  <div className='col-6'>
                    <h5 className='mt-3 mb-3'>Commercial Register</h5> 
                    <p className="only mb-3">only:Pdf,jpeg,Png</p>
                    <input type="file" accept="png,Pdf,jpeg" className="Upload-btn" id="com-btn" onChange={(e) => handleCommercialRegister(e)} hidden required/> 
                    <label htmlFor='com-btn' className='select-file-labels'>Select File</label>
                    <p className='mt-4'><strong>File Name: </strong>{CommercialRegisterfileName}</p>
                    <p className='error-msg' id="error-msg-cr"></p>
                  </div>
                  <div className='col-6'>
                    <h5 className='mt-3 mb-3'>Brand Logo</h5> 
                    <p className="only mb-3">only: jpeg,Png</p>
                    <input type="file" accept="png,jpeg" className="Upload-btn" id="brnd-btn" onChange={(e) => handleLogo(e)} hidden required/> 
                    <label htmlFor='brnd-btn' className='select-file-labels'>Select File</label>
                    <p className='mt-4'><strong>File Name: </strong>{BrandLogoFileName}</p>
                    <p className='error-msg' id="error-msg-sl"></p>
                  </div>
                </div>
                <p className='mt-5 fs-4 default-text'>Store Location</p>
                <div className='map'>
                   
                   {isLoaded? <GoogleMap
                        mapContainerStyle={containerStyle}
                        center={center}
                        zoom={10}
                        onLoad={onLoad}
                        onUnmount={onUnmount}
                       >
        
                      <MarkerF position={pos} 
                        draggable={true}
                        onDrag={(e) => {
                          setPos({lat: e.latLng.lat(), lng: e.latLng.lng()})
                          console.log(pos)
                          }
                        }
                      />
  
                    </GoogleMap> : <div>Loading...</div> }
                </div>
                <button onClick={addData} id="sendreq-btn" className="btns filled-orange-btn">Register</button>
             
             <p className="end mt-3">Already Joined?<a href="#" className="login-end" onClick={() => navigate('/')}> Log In</a></p> 

           </div>
          </div>
        </div>
      </div>
     )    
}

export default Signup;

