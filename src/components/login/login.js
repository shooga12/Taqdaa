import React, { useState } from 'react';
import {signInWithEmailAndPassword} from 'firebase/auth';
import './style.css';
import Logo from '../../shared/Logo_Light.png';
import auth from '../../shared/firebase';
import {useNavigate} from 'react-router-dom';


function Login(){
  
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const login = () => {

    if(email == "" && password == ""){
        alert("Please enter email and password");
    }
    else if(email == ""){
        alert("Please enter email");
    }
    else if(password == ""){
        alert("Please enter password");
    }
    else{
        signInWithEmailAndPassword(auth, email, password)
        .then((userCredential) => {
          // Signed in 
          const user = userCredential.user;
          navigate('/dashboard');
          // ...
        })
        .catch((error) => {
          const errorCode = error.code;
          const errorMessage = error.message;
          alert(errorMessage);
        });
      }
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
        <div id="box" class="col-11 col-md-10 col-lg-7">
          <div id="box-content-container" class="col-11">
           <div class="pt-4 pb-5 pl-5 pr-5 d-flex h-100 flex-column align-items-center justify-content-around">
             <img src={Logo} height="90" class="mb-3 mt-4" alt="logo"/>
             <h4 class="mb-5 mt-5">Store Manager Log In</h4>
               <input type="email" placeholder="Email" class="input-field" onChange={(e) => setEmail(e.target.value)}/>
               <input type="password" placeholder="Password" class="input-field mt-3" onChange={(e) => setPassword(e.target.value)}/>
               <button onClick={login} class="mt-5 btns filled-blue-btn" id="login-btn">Log In</button>
               <p class="mt-4 mb-4"><a href="#" onClick={()=>navigate('/reset')}>Forgot your password?</a></p>
               <p class="mt-4">Don't have an account?<a href="#"> Register</a></p>
           </div>
          </div>
        </div>
      </div> 
     )

       
    
}

export default Login;

