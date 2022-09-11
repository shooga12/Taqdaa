import React from 'react';
import "./dataset.css";
function Dataset(){
    const clickInput = () =>{
        document.querySelector("input").click();
    }
    return(  
        <>
        <h1>Products Dataset</h1>
        <div id="container">
            
            <form>
                <div class="drag-area">
                    <div class="icon">
                        <i class='bx bx-cloud-upload'></i>
                        <i class='bx bxs-cloud-upload'></i>
                        </div>
                    <header>Drag & Drop to Upload File</header>
                    <span>OR</span>
                    <button onClick={clickInput}>Browse File</button>
                    <input type="file" hidden accept=".xlsx, .xls, .csv"/>
                </div>
                <input type="submit" value="Upload" disabled/>
                </form>
        </div> 
        </>     
    )

}
export default Dataset;