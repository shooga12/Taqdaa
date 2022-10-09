import React from 'react';
import "./invoices.css";
import {MdEmail} from 'react-icons/md'
import {IoIosArrowDown} from 'react-icons/io'
import img1 from './sephora-brightening-hydrating-foundation-original-imaecf3t7vgdk9by.webp';
import img2 from './458789.jpeg';
function Invoices(){

        const [data,setData] = useState();
        const [done,setDone] = useState(0);

        useEffect(() => {
        getData();
        console.log("Data:");
        console.log(data);
        },[done]);

        const getData = async ()=>{
        const docRef = doc(db, "Invoices");
        const docSnap = await getDoc(docRef);
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
        }
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
        return(  
            <>
            <h1 className="mt-3">Invoices</h1>
            <div className='invoice-card'>
              <div className='invoice-card-header'>
               <div className='d-flex align-items-center justify-content-between'>
                <div className='num-date-container d-flex flex-column align-items-between'>
                    <h5>Invoice#: 6854</h5>
                    <h6>Date: 23/9/2022 7:35 PM</h6>
                </div>
                <a href='mailto:reem99am@gmail.com'>
                    <button><MdEmail/> Contact Customer</button>
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
            <div className='invoice-card'>
              <div className='invoice-card-header'>
               <div className='d-flex align-items-center justify-content-between'>
                <div className='num-date-container d-flex flex-column align-items-between'>
                    <h5>Invoice#: 6853</h5>
                    <h6>Date: 23/9/2022 7:35 PM</h6>
                </div>
                <a href='mailto:reem99am@gmail.com'>
                    <button><MdEmail/> Contact Customer</button>
                </a>
               </div>
              </div>
              <hr></hr>
              <div className='d-flex flex-column justify-content-center align-items-center'>
                <div className='invoice-collapse-header d-flex justify-content-center align-items-center' id='invoice2-collapse-header' onClick={()=> collapse(2)}>
                    <div>View more</div>
                    &nbsp;
                    <IoIosArrowDown/>
                </div>
              </div>
              <div className='invoice-card-body' id='invoice-2-body'>
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
            </>     
        )
    
}
export default Invoices;