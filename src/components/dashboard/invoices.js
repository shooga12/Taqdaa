import React,{useEffect,useState}  from 'react';
import "./invoices.css";
import auth,{DB,db} from '../../shared/firebase';
import { doc,getDoc, collection, getDocs} from "firebase/firestore";
import {ref, set, child, get, push,update } from "firebase/database";
import { async } from '@firebase/util';
import {MdPhone, MdPhoneInTalk} from 'react-icons/md'
import {IoIosArrowDown} from 'react-icons/io'
import img1 from './sephora-brightening-hydrating-foundation-original-imaecf3t7vgdk9by.webp';
import img2 from './458789.jpeg';
import loading from './loading.gif';

function InvoiceCard({ invoices }) {
  
  const [invoicesList, setInvoicesList] = useState(invoices);


  const collapse = (id)=>{
    let invoice = document.querySelector('#invoice-'+id+'-body');
    let collapse_header = document.querySelector('#invoice'+id+'-collapse-header');
    if(invoice.style.display == 'block'){
        collapse_header.style.borderBottomRightRadius = '30px';
        collapse_header.style.borderBottomLeftRadius = '30px';
        invoice.style.display = 'none';
    }
    else{
        collapse_header.style.borderBottomRightRadius = '0px';
        collapse_header.style.borderBottomLeftRadius = '0px';
        invoice.style.display = 'block';
    }
  }

  const filterInvoices = ()=>{
    setInvoicesList([]);
  }

  return(
    <>
    {
    invoicesList && invoicesList.map ?
    invoicesList.map(invoice => (
              <div className='invoice-card'>
              <div className='invoice-card-header'>
               <div className='d-flex align-items-center justify-content-between'>
                <div className='num-date-container d-flex flex-column align-items-between'>
                    <h5>Invoice#: {invoice.ID}</h5>
                    <h6>Date: {invoice.Date}</h6>
                </div>
                <a href={'tel:'+invoice.cutomerphone}>
                    <button><MdPhone/> Contact Customer</button>
                </a>
               </div>
              </div>
              <hr></hr>
              <div className='d-flex flex-column justify-content-center align-items-center'>
                <div className='invoice-collapse-header d-flex justify-content-center align-items-center' id='invoice1-collapse-header' onClick={()=> collapse(1)}>
                    <div>View more</div>
                    &nbsp;
                    <IoIosArrowDown/>
                </div>
              </div>
              <div className='invoice-card-body' id='invoice-1-body'>
                <div className='p-5'>
                    <h5>Items</h5>
                    <div>
                        <div className='item'>
                          <div className='w-100 p-3 mt-3 d-flex justify-content-between align-items-center'>
                            <div className='item-first-part justify-content-between d-flex align-items-center'>
                                <h6><strong>1</strong></h6>
                                <img src={img1} height='100'></img>
                                <div>
                                    <p><strong>Concealer</strong></p>
                                    <p><strong>Barcode: </strong>07348B634</p>
                                </div>
                            </div>
                            <div>
                              <span>100 SR</span>
                            </div>
                          </div>
                        </div>
                        <div className='item'>
                          <div className='w-100 p-3 mt-3 d-flex justify-content-between align-items-center'>
                            <div className='item-first-part justify-content-between d-flex align-items-center'>
                                <h6><strong>2</strong></h6>
                                <img src={img2} height='100'></img>
                                <div>
                                    <p><strong>Silicon Spong</strong></p>
                                    <p><strong>Barcode: </strong>5687GLO878</p>
                                </div>
                            </div>
                            <div>
                              <span>200 SR</span>
                            </div>
                          </div>
                        </div>
                        <hr className='mt-5'></hr>
                        <div className='total d-flex justify-content-between'>
                            <h6>Total</h6>
                            <h6>300 SR</h6>
                        </div>
                    </div>
                </div>
              </div>
            </div>
      
          )) : null
          }
          </>
     )  
}
function Invoices(){

        const [invoices,setInvoices] = useState();
        const [done,setDone] = useState(0);

        useEffect(() => {
        getData();
        console.log("Data:");
        console.log(invoices);
        },[done]);
        
        //Retrieve Invoices
        const getData = async ()=>{
          let storeName;
          //Get Store Name
          let docRef = doc(db, "Stores", 'Store'+auth.currentUser?.uid);
          let docSnap = await getDoc(docRef);
          if (docSnap.exists()) {
              storeName = docSnap.data().StoreName;
          } 
          else {
            console.log("No such document!");
          }

          //Get Invoices of Store          
          docRef = collection(db, "InvoicesManager"+storeName);
          getDocs(docRef).then((querySnapshot) => {
            const tempArr = []
            querySnapshot.forEach((doc) => {
              tempArr.push(doc.data());
            }) 
            setInvoices(tempArr);
          })
          
          //docSnap = await get(docRef);
          /*
          if (docSnap.exists()) {
              console.log("Document data:", docSnap.data());
              let myDataArray = {};
              for (var key in docSnap.data()) {
                  myDataArray[key] = docSnap.data()[key]
              }
              setData(myDataArray);
              setDone(1);
                
          } 
          else {
            console.log("No such document!");
          }
          */
        }

        
        return(  
            <>
            <h1 className="mt-3">Invoices</h1>
            {
              invoices?
              <InvoiceCard invoices={invoices}/> 
              : <img src={loading} className="loading-img"></img>
             }
            </>     
        )
    
}
export default Invoices;