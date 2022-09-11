import React, { useState } from 'react';
import './style.css';
import {sendPasswordResetEmail} from 'firebase/auth';
import Logo from '../../shared/Logo_Light.png';
import auth from '../../shared/firebase';
import {useNavigate} from 'react-router-dom';


function Reset(){
  
  const navigate = useNavigate();
  const [emailField, setEmailField] = useState("");

  
     auth.onAuthStateChanged(function(user) {
        if (user) {
          navigate('/dashboard');
        } else {
          // No user is signed in.
        }
     });
     const reset = () => {sendPasswordResetEmail(auth, emailField)
        .then(() => {
            alert("Email sent");
        })
        .catch((error) => {
          const errorCode = error.code;
          const errorMessage = error.message;
          if(errorCode == "auth/user-not-found")
            alert("No User With The Enetered Email");
          else
            alert(errorMessage);
          // ..
        });
     }
      return(
        <div class='container w-100 vh-100 d-flex align-items-center'>
          <div id="box" class="col-11 col-md-10 col-lg-7">
            <div id="box-content-container" class="col-11">
            <div class="pt-4 pb-5 pl-5 pr-5 d-flex h-100 flex-column align-items-center justify-content-around">
              <img src={Logo} height="90" class="mb-3 mt-4" alt="logo"/>
              <h4 class="mb-5 mt-5">Reset Password</h4>
                <input type={"email"} placeholder="Email" class="input-field" onChange={(e) => setEmailField(e.target.value)}/>
                <button class="mt-5 btns filled-blue-btn" onClick={reset} id="login-btn">Send Link</button>
            </div>
            </div>
          </div>
        </div> 
     )

       
    
}

export default Reset;

