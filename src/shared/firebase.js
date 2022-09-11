// Import the functions you need from the SDKs you need
// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import {getAuth} from 'firebase/auth';
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyACJwuBHZzQT7oVAlq1cn_26X6HMb1N7_E",
  authDomain: "taqdaa-10e41.firebaseapp.com",
  databaseURL: "https://taqdaa-10e41-default-rtdb.firebaseio.com",
  projectId: "taqdaa-10e41",
  storageBucket: "taqdaa-10e41.appspot.com",
  messagingSenderId: "782203884662",
  appId: "1:782203884662:web:25a264931b063aaf7a7b57"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

export default auth;