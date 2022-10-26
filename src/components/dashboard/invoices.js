import React,{useEffect,useState}  from 'react';
import "./invoices.css";
import auth,{DB,db} from '../../shared/firebase';
import { doc,getDoc, collection, getDocs} from "firebase/firestore";
import {ref, set, child, get, push,update } from "firebase/database";
import { async } from '@firebase/util';
import {MdPhone, MdPhoneInTalk} from 'react-icons/md'
import {IoIosArrowDown} from 'react-icons/io'
import {HiFilter} from 'react-icons/hi'
import {FiSearch} from 'react-icons/fi'
import {TbFileInvoice} from 'react-icons/tb'
import img1 from './sephora-brightening-hydrating-foundation-original-imaecf3t7vgdk9by.webp';
import img2 from './458789.jpeg';
import loading from './loading.gif';

function InvoiceCard({ invoices }) {
  
  const [invoicesList, setInvoicesList] = useState(invoices);
  let date = new Date();
  const [today, setToday] = useState(date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate());
  const [startDate, setStartDate] = useState(today);
  const [filterApplied, setFilterApplied] = useState(false);
  const [endDate, setEndDate] = useState(today);
  const [errorState, setErrorState] = useState(false);
  const [noInvoices, setNoInvoices] = useState(false);
 
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
    if(errorState === false){
      let tmpArray = [];
      let start = new Date(startDate);
      let end = new Date(endDate);
      Object.keys(invoices).map(key=>{
        let date = invoices[key]['Date'].split('/');
        date = date[2] + '-' + date[1] + '-' + date[0]
        date = new Date(date);
        if(date >= start && date <= end){
          tmpArray.push(invoices[key]);
        }
      });
      setInvoicesList(tmpArray);
      setFilterApplied(true);
      if(tmpArray.length == 0){
        setNoInvoices(true);
      }
      document.querySelector('#filter-box').style.display = 'none';
    }
  }

  const removeFilter = ()=>{
    setInvoicesList(invoices);
    setFilterApplied(false);
    setNoInvoices(false);
    document.querySelector('#filter-box').style.display = 'none';
  }
  
  const handleStartDateChange = (date) =>{
     setStartDate(date);
     let start = new Date(date);
     let end = document.querySelector('#end-date').value;
     end = new Date(end);
     if(start > end){
      setErrorState(true);
      let errorMSG = document.querySelector('#error-msg');
      errorMSG.innerHTML = 'Start date must not be a date after end date';
      errorMSG.style.display = 'visibile';
     }
     else{
      setErrorState(false);
      let errorMSG = document.querySelector('#error-msg');
      errorMSG.innerHTML = '';
      errorMSG.style.display = 'hidden';
     }
  }

  const handleEndDateChange = (date) =>{
     setEndDate(date);
     let end = new Date(date);
     let start = document.querySelector('#start-date').value;
     start = new Date(start);
     if(start > end){
      setErrorState(true);
      let errorMSG = document.querySelector('#error-msg');
      errorMSG.innerHTML = 'Start date must not be a date after end date';
      errorMSG.style.display = 'visibile';
     }
     else{
      setErrorState(false);
      let errorMSG = document.querySelector('#error-msg');
      errorMSG.innerHTML = '';
      errorMSG.style.display = 'hidden';
     }
  }

  const filterCollapse = ()=>{
    let filterBox = document.querySelector('#filter-box');
    if(filterBox.style.display == 'block'){
      filterBox.style.display = 'none';
    }
    else{
      filterBox.style.display = 'block';
    }
  }

  return(
    <>
      <div className='p-2 mb-4 d-flex justify-content-between' style={{width: '900px'}}>
          <div className='justify-self-start'>
            <input type={'text'} id='search-bar' placeholder='Search by invoice number'></input>
            <button id='search-btn'><FiSearch /></button>
          </div>
          <div className='d-flex flex-column align-items-end'>
            <button id='filter-btn' onClick={()=>filterCollapse()}><HiFilter/> Filter {filterApplied === true?  <span id='filterApplied'>&#9679;</span> : null}</button>
            <div id='filter-box' className='p-4'>
              <div className='d-flex flex-column align-items-start'>
                <label htmlFor='start-date'>Start Date</label>
                <input type={'date'} name='start-date' min={'2020-01-01'} max={today} value={startDate} className='date-fields' id='start-date' onChange={(e)=>{handleStartDateChange(e.target.value)}}></input>
                <label htmlFor='end-date' className='mt-3'>End Date</label>
                <input type={'date'} name='end-date' min={'2020-01-01'} max={today} value={endDate} className='date-fields' id='end-date' onChange={(e)=>{handleEndDateChange(e.target.value)}}></input>
                <p id="error-msg" className='mt-3'></p>
                <div className='d-flex w-100 justify-content-center'>
                  <button id='apply-filter-btn' className='mt-1' onClick={()=>filterInvoices()}>Apply</button>
                  {filterApplied === true ?
                    <button id='remove-filter-btn' className='mt-1' onClick={()=>removeFilter()}>Remove Filter</button>
                    :
                    null
                  }
                </div>
              </div>
            </div>
          </div>
      </div>
      {
      noInvoices === true? 
      <div className='w-100 h-100 d-flex justify-content-center'>
        <div className='d-flex flex-column p-5 justify-content-center align-items-center'>
          <TbFileInvoice style={{fontSize: '150px', color: '#d2d2d2'}}/>
          <p style={{fontSize: '40px', color: '#d2d2d2'}}>No Invoices</p>
        </div>
      </div> 
      :
      invoicesList.length != 0 && invoicesList.map ?
      Object.keys(invoicesList).map(key => (
                <div className='invoice-card'>
                <div className='invoice-card-header'>
                <div className='d-flex align-items-center justify-content-between'>
                  <div className='num-date-container d-flex flex-column align-items-between'>
                      <h5>Invoice#: {invoicesList[key]['ID']}</h5>
                      <h6>Date: {invoicesList[key]['Date']}</h6>
                  </div>
                  <a href={'tel:'+invoicesList[key]['customerphone']}>
                      <button><MdPhone/> Contact Customer</button>
                  </a>
                </div>
                </div>
                <hr></hr>
                <div className='d-flex flex-column justify-content-center align-items-center'>
                  <div className='invoice-collapse-header d-flex justify-content-center align-items-center' id={'invoice'+key+'-collapse-header'} onClick={()=> collapse(key)}>
                      <div>View more</div>
                      &nbsp;
                      <IoIosArrowDown/>
                  </div>
                </div>
                <div className='invoice-card-body' id={'invoice-'+key+'-body'}>
                  <div className='p-5'>
                      <h5>Items</h5>
                      <div>
                        { 
                          Object.keys(invoicesList[key].items).map(itemKey => (
                            <div className='item'>
                              <div className='w-100 p-3 mt-3 d-flex justify-content-between align-items-center'>
                                <div className='item-first-part justify-content-between d-flex align-items-center'>
                                    <h6><strong>{parseInt(itemKey)+1}</strong></h6>
                                    <img src={invoicesList[key].items[itemKey]['img']} height='100'/>
                                    <div>
                                        <p><strong>{invoicesList[key].items[itemKey]['name']}</strong></p>
                                        <p><strong>Barcode: </strong>{invoicesList[key].items[itemKey]['barcode']}</p>
                                    </div>
                                </div>
                                <div>
                                  <span>{invoicesList[key].items[itemKey]['price']} SR</span>
                                </div>
                              </div>
                            </div>
                          ))   
                        }
                          <hr className='mt-5'></hr>
                          <div className='total d-flex justify-content-between'>
                              <h6>Vat 15%</h6>
                              <h6>{invoicesList[key]['vat-total']} SR</h6>
                          </div>
                          <div className='total d-flex justify-content-between'>
                              <h6>Sub Total</h6>
                              <h6>{invoicesList[key]['sub-total']} SR</h6>
                          </div>
                          <div className='total d-flex justify-content-between'>
                              <h6><strong>Total</strong></h6>
                              <h6>{invoicesList[key]['Total']} SR</h6>
                          </div>
                      </div>
                  </div>
                </div>
              </div>

          )) : 
          <div className='w-100 h-100 d-flex justify-content-center'>
            <div className='d-flex flex-column p-5 justify-content-center align-items-center'>
              <TbFileInvoice style={{fontSize: '150px', color: '#d2d2d2'}}/>
              <p style={{fontSize: '40px', color: '#d2d2d2'}}>No Invoices</p>
            </div>
          </div> 
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