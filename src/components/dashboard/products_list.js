import React, {useState, useLayoutEffect,useEffect, Component} from 'react';
import auth,{DB} from '../../shared/firebase';
import "./products.css";
import {FiEdit} from 'react-icons/fi';
import {MdDelete} from 'react-icons/md';
import {ref, set, child, get, push,update } from "firebase/database";
import { async } from '@firebase/util';
import img1 from'./243280_swatch.jpeg'
import img2 from './sephora-brightening-hydrating-foundation-original-imaecf3t7vgdk9by.webp';
import img3 from './458789.jpeg';
import img4 from './s2497212-main-zoom.jpeg';
import loading from './loading.gif';
import { confirmAlert } from 'react-confirm-alert'; 


function Child({ datum }) {
  // Problem:
  // This will error if `items` is null/undefined
  return (
    <>
     <div id="products-container">
      <table id="products-box" className='col-12'>
          <thead>
            <tr>
            <th>Photo</th>
            <th>Barcode</th>
            <th>Product Name</th>
            <th>Price</th>
            <th>RFID UID</th>
            </tr>
          </thead>
          <tbody>
            {
            datum && datum.map ?
            datum.map(item => (
              <tr>
                   <td>
                    <img src={img1} className="product-img"></img>
                   </td>
                   <td>2275849844</td>
                   <td><div  className="second-col">item9</div></td>
                   <td>{item["Price"]}</td>
                   <td>53rjenwn</td>
                   <td><span className='edit-icons'><FiEdit /></span><span className='delete-icons'><MdDelete /></span></td>
              </tr>
            )) : null
            }
          </tbody>         
      </table>
     </div>
    </>
  );
}


function Products_List(){


     const showAlert = ()=>{
      
        confirmAlert({
        message: 'Delete This Item?',
        buttons: [
            {
              label: 'Delete',
              //onClick: () => alert('Click No')
            },
            {
              label: 'Cancel',
              //onClick: () => alert('Click No')
            }
        ]
        });
      }
         
      
        const [done,setDone] = useState(0);
        const [items,setItems] = useState();

        useEffect(() => {
          getList();
          
          
         },[done]);

        const getList =  ()=> {

          const dbRef = ref(DB);
          
          get(child(dbRef, 'Store'+auth.currentUser?.uid)).then(snapshot  => {
            if (snapshot.exists()) {
              var pro = snapshot.val();
          
              let myDataArray = []
             
              let store = pro["store"];
              store.map(doc =>{
                myDataArray.push({"Price" : doc.Price, "Name" : doc["Product Name"] })
                }
              )

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
     
            <h1 className="mt-3">Products List</h1>
            

             {
              items?
              
              <Child datum={items}/> 
             
              : <img src={loading} className="loading-img"></img>
             }
            
            </>     
        )
     
}
export default Products_List;