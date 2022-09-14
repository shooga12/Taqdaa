import React, { useState } from 'react';
import {createUserWithEmailAndPassword} from 'firebase/auth';
import './style.css';
import Logo from '../../shared/Logo_Light.png';
import auth, {db} from '../../shared/firebase';
import {validEmail,validName,emptyImage,validPhone} from '../../shared/validations';
import {useNavigate} from 'react-router-dom';
import emailjs from 'emailjs-com';
import { async } from '@firebase/util';
import { collection, doc, setDoc, addDoc }  from 'firebase/firestore';
import {getStorage, ref, uploadBytes, getDownloadURL } from "firebase/storage";

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
  const [StoreLogo, setStoreLogo] = useState("");
  const [logoURL, setLogoURL] = useState("");
  const storage = getStorage();

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
    const createAccount = ()=>{
      
      setPassword(generatePass());
      createUserWithEmailAndPassword(auth, email, password)
      .then((userCredential) => {
        // Signed in 
        const user = userCredential.user;
        alert("Registered");
        auth.signOut();
        sendEmail(email,password);
        // ...
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
          // No user is signed in.
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


    const addData =  async() =>{
      
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
        document.querySelector('#error-msg-sn').innerHTML = 'Store Name is required<br>';
        document.querySelector('#error-msg-sn').style.visibility = "visible";
      }
      if(emptyImage(StoreLogo)){
        error = true;
        document.querySelector('#error-msg-sl').innerHTML = 'Store Logo is required<br>';
        document.querySelector('#error-msg-sl').style.visibility = "visible";
      }
      if(emptyImage(CommercialRegister)){
        error = true;
        document.querySelector('#error-msg-cr').innerHTML = 'Commercial Register is required<br>';
        document.querySelector('#error-msg-cr').style.visibility = "visible";
      }
      if(email != '' && !validEmail(email)){
        error = true;
        document.querySelector('#error-msg-email').innerHTML = 'Invalid email';
        document.querySelector('#error-msg-email').style.visibility = "visible";
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
            createAccount(email);

          } catch (e) {
            console.error("Error adding document: ", e);
          }
      }
    }



      return(
        <div className='container w-100 vh-100 d-flex align-items-center'>
        <div id="signup-box" className="col-12 col-lg-9">
          <div id="box-content-container" className="col-11">
           <div className="container pt-4 pb-5 pl-5 pr-5 d-flex h-100 flex-column align-items-center justify-content-around">
             <img src={Logo} height="90" className="mb-3" alt="logo"/>
             <h4>Store Registeration</h4><br/>
                <div>
                  <div className="col-12 d-flex flex-column flex-lg-row justify-content-around" id="g1">
                    <div>
                      <input type="text" placeholder="First Name" className="input-field" onChange={(e) => setFirstName(e.target.value)} required/> 
                      <p className='error-msg' id="error-msg-fn"></p>
                    </div>
                    <div>
                      <input type="text" placeholder="Last Name" className="input-field" onChange={(e) => setLastName(e.target.value)} required/>
                      <p className='error-msg' id="error-msg-ln"></p>
                    </div>
                  </div>

                  <div className="d-flex flex-column flex-lg-row" id="g2">
                    <div>
                      <input type="text" placeholder="company Name" className="input-field" onChange={(e) => setCompanyName(e.target.value)} required/>
                      <p className='error-msg' id="error-msg-cn"></p>
                    </div>
                    <div>
                      <input type="text" placeholder="Store Name" className="input-field" onChange={(e) => setStoreName(e.target.value)} required/>
                      <p className='error-msg' id="error-msg-sn"></p>
                    </div>
                  </div>

                  <div className="d-flex flex-column flex-lg-row" id="g3">
                    <div>
                       <input type="email" placeholder="Email Address" className="input-field" onChange={(e)=>setEmail(e.target.value)} required/>
                       <p className='error-msg' id="error-msg-email"></p>
                    </div>
                    <div>
                      <input type="phone" placeholder="Phone Number" className="input-field" onChange={(e) => setPhone(e.target.value)} required/>
                      <p className='error-msg' id="error-msg-pn"></p>
                    </div>
                  </div>
                </div>

                <div className="d-flex flex-column flex-lg-row">
                  <div>
                    <h5>Commercial Register</h5> 
                    <input type="file" accept="png,Pdf,jpeg" className="Upload-btn" id="com-btn" onChange={(e) => handleCommercialRegister(e)} required/> 
                    <p className="only">only:Pdf,jpeg,Png</p>
                    <p className='error-msg' id="error-msg-cr">Commercial Register is Required</p>
                  </div>
                  <div>
                    <h5>Store Logo </h5> 
                    <input type="file" accept="png,jpeg" className="Upload-btn" id="com-btn" onChange={(e) => handleLogo(e)} required/> 
                    <p className="only">only: jpeg,Png</p>
                    <p className='error-msg' id="error-msg-sl">Store Logo is Required</p>
                  </div>
                </div>

                <button onClick={addData} id="sendreq-btn" className="btns filled-orange-btn text-center">Send</button>
             
             <p className="end">Already Joined?<a href="#" className="login-end" onClick={() => navigate('/')}> Log In</a></p> 

           </div>
          </div>
        </div>
      </div>
     )    
}

export default Signup;

