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
import { confirmAlert } from 'react-confirm-alert'; 
class  Products_List extends Component{

   
  constructor(props) {
    super(props)
    this.state = {
      products: {},
   }
  }
/*
    useLayoutEffect(() => {
        const dbRef = ref(DB);
        get(child(dbRef, 'Store'+auth.currentUser.uid)).then(snapshot  => {
              if (snapshot.exists()) {
                var data = snapshot.val()
                pro = data;
                console(pro)
              } else {
                  console.log("No data available");       
              }
          }).catch((error) => {
              console.error(error);
          });


    }, []);


   */ 
    
     showAlert = ()=>{
      
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
         
     
          
         
      render(){
        const componentWillMount = ()=> {

          const dbRef = ref(DB);
          get(child(dbRef, 'Store'+auth.currentUser.uid)).then(snapshot  => {
            if (snapshot.exists()) {
              var pro = snapshot.val();
              this.setState({products: pro});
            } else {
                console.log("No data available");       
            }
           }).catch((error) => {
            console.error(error);
           }); 
        }
    
        const j = ()=>{
          console.log(this.setState["products"]);
        }
        return(  
            <>
            <h1 className="mt-3">Products List</h1>
     
             
             <div id="products-container">
              <table id="products-box" className='col-11'>
                 <thead>
                    <tr>
                    <th>Photo</th>
                    <th>Barcode</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    </tr>
                 </thead>
                 <tbody>
                
                 <tr>
                 <td>
                    <img src={img1} className="product-img"></img>
                   </td>
                   <td>6375849830</td>
                   <td>item1</td>
                   <td>120</td>
                   <td><span className='edit-icons'><FiEdit /></span><span className='delete-icons'><MdDelete /></span></td>
                 </tr>
                 <tr>
                 <td>
                    <img src={img2} className="product-img"></img>
                   </td>
                   <td>9375849866</td>
                   <td>item2</td>
                   <td>95</td>
                   <td><span className='edit-icons'><FiEdit /></span><span className='delete-icons'><MdDelete /></span></td>
                 </tr>
                 <tr>
                 <td>
                    <img src={img3} className="product-img"></img>
                   </td>
                   <td>7775887879</td>
                   <td><div className="second-col">item3</div></td>
                   <td>160</td>
                   <td><span className='edit-icons'><FiEdit /></span><span className='delete-icons'><MdDelete /></span></td>
                 </tr>
                 <tr>
                 <td>
                    <img src={img4} className="product-img"></img>
                   </td>
                   <td>9765823476</td>
                   <td>item4</td>
                   <td>120</td>
                   <td><span className='edit-icons'><FiEdit /></span><span className='delete-icons'><MdDelete /></span></td>
                 </tr>
                 <tr>
                 <td>
                    <img src={img2} className="product-img"></img>
                   </td>
                   <td>9265234455</td>
                   <td><div className="second-col">item5</div></td>
                   <td>120</td>
                   <td><span className='edit-icons'><FiEdit /></span><span className='delete-icons'><MdDelete /></span></td>
                 </tr>
                 <tr>
                 <td>
                    <img src={img3} className="product-img"></img>
                   </td>
                   <td>4265233333</td>
                   <td><div  className="second-col">item6</div></td>
                   <td>120</td>
                   <td><span className='edit-icons'><FiEdit /></span><span className='delete-icons'><MdDelete /></span></td>
                 </tr>
                 <tr>
                 <td>
                    <img src={img2} className="product-img"></img>
                   </td>
                   <td>63555549832</td>
                   <td><div  className="second-col">item7</div></td>
                   <td>120</td>
                   <td><span className='edit-icons'><FiEdit /></span><span className='delete-icons' ><MdDelete /></span></td>
                 </tr>
                 <tr>
                   <td>
                    <img src={img4} className="product-img"></img>
                   </td>
                   <td>5575849830</td>
                   <td><div  className="second-col">item8</div></td>
                   <td>120</td>
                   <td><span className='edit-icons'><FiEdit /></span><span className='delete-icons'><MdDelete /></span></td>
                 </tr>
                 <tr>
                   <td>
                    <img src={img1} className="product-img"></img>
                   </td>
                   <td>2275849844</td>
                   <td><div  className="second-col">item9</div></td>
                   <td>120</td>
                   <td><span className='edit-icons'><FiEdit /></span><span className='delete-icons'><MdDelete /></span></td>
                 </tr>
                    
                 </tbody>
                
              </table>
             </div>
            </>     
        )
        }
}
export default Products_List;