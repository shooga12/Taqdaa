const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const braintree = require('braintree');

const gateway = new braintree.BraintreeGateway({
    environment: braintree.Environment.Sandbox,
    merchantId: 'pdhgjqwbz3wk8t76',
    publicKey: 'y8s4khw92twxvp94',
    privateKey: '8a70e42ba6cbf2830609610a4f942563',


});

// const gateway = braintree.connect({
//     environment:  braintree.Environment.Sandbox,
//     merchantId:   'pdhgjqwbz3wk8t76',
//     publicKey:    'y8s4khw92twxvp94',
//     privateKey:   '8a70e42ba6cbf2830609610a4f942563'
// });

exports.paypalPayment = functions.https.onRequest(async(req, res) => {
    const nonceFromTheClient = req.body.payment_method_nonce;
    const deviceData = req.body.device_data;

    gateway.transaction.sale({
        amount: '9.77',
        paymentMethodNonce: 'fake-paypal-one-time-nonce',
        deviceData: deviceData,
        options: {
            submitForSettlement: true
        }
    }, (err, result) => {

        if(err!=null){
            consonle.log(err);}
        else{
            res.json({result: 'success'});}
        
    }
    );

});
