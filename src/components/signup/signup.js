import React, { useState } from 'react';
import {createUserWithEmailAndPassword} from 'firebase/auth';
import './style.css';
import Logo from '../../shared/Logo_Light.png';
import auth from '../../shared/firebase';
import {useNavigate} from 'react-router-dom';


function Signup(){
  const [email, setEmail] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [companyName, setCompanyName] = useState("");
  const [storeName, setStoreName] = useState("");
  const [phone, setPhone] = useState("");
  const navigate = useNavigate();
    const generatePass = () => {
      var chars = "0123456789abcdefghijklmnopqrstuvwxyz!@#$%^&*()ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      var passwordLength = 12;
      var password = "";
      for (var i = 0; i <= passwordLength; i++) {
        var randomNumber = Math.floor(Math.random() * chars.length);
        password += chars.substring(randomNumber, randomNumber +1);
      }
      console.log(password);
    }
    const createAccount = ()=>{
      var chars = "0123456789abcdefghijklmnopqrstuvwxyz!@#$%^&*()ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      var passwordLength = 12;
      var password = "";
      for (var i = 0; i <= passwordLength; i++) {
        var randomNumber = Math.floor(Math.random() * chars.length);
        password += chars.substring(randomNumber, randomNumber +1);
      }
      createUserWithEmailAndPassword(auth, email, password)
      .then((userCredential) => {
        // Signed in 
        const user = userCredential.user;
        alert("Registere");
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
    
      return(
        <div class='container w-100 vh-100 d-flex align-items-center'>
        <div id="signup-box" class="col-9">
          <div id="box-content-container" class="col-11">
           <div class="container pt-4 pb-5 pl-5 pr-5 d-flex h-100 flex-column align-items-center justify-content-around">
             <img src={Logo} height="90" class="mb-3" alt="logo"/>
             <h4>Store Registeration</h4><br/>
                <div>
                  <div class="col-12 d-flex justify-content-around" id="g1">
                      <input type="text" placeholder="First Name" class="input-field" required/> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type="text" placeholder="Last Name" class="input-field" required/>
                  </div>

                  <div class="d-flex" id="g2">
                      <input type="text" placeholder="company Name" class="input-field" required/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type="text" placeholder="Store Name" class="input-field" required/>
                  </div>

                  <div class="d-flex" id="g3">
                      <input type="email" placeholder="Email Address" class="input-field" onChange={(e)=>setEmail(e.target.value)} required/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type="phone" placeholder="Phone Number" class="input-field" required/>
                  </div>
                </div>

                <label>
                    <div>
                      <h5>Commercial Register</h5> 
                      <input type="file" accept="png,Pdf,jpeg" class="Upload-btn" id="com-btn" required/> 
                      <p class="only">only:Pdf,jpeg,Png</p>
                    </div>
                </label>
             
                <button onClick={generatePass} id="sendreq-btn" class="btns filled-orange-btn text-center">Send</button>
             
             <p class="end">Already Joined?<a href="#" class="login-end" onClick={() => navigate('/')}> Log In</a></p> 

           </div>
          </div>
        </div>
      </div>
     )    
}

export default Signup;

