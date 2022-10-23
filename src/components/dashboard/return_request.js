import React from 'react';

function RequestCard({ invoices }) {

    return(
        <>
        </>
    )
}
function Return_Req(){

    const [done,setDone] = useState(0);
    const [requests,setRequests] = useState();

    useEffect(() => {
    getData();
    console.log("Data:");
    },[done]);
    
    //Retrieve Return Requests
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

        //Get Return Requests of Store          
        docRef = collection(db, "RequestsManager"+storeName);
        getDocs(docRef).then((querySnapshot) => {
          const tempArr = []
          querySnapshot.forEach((doc) => {
            tempArr.push(doc.data());
          }) 
          setRequests(tempArr); 
        })
    }



    const handleFile = (e) => {
       
    }

    return(  
        <>
        <h1 class="mt-3">Return Requests</h1>
        
        </>     
    )
    
}
export default Return_Req;