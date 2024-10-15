/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

//const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require('firebase-functions');
const admin = require('firebase-admin');

// notifications for new messages
exports.sendNotificationOnMessage = functions.firestore
.document('chat_room/{chatRoomId}/messages/{messageId}')
.onCreate(async (snapshot , context) => {
    const message = snapshot.data();

    try {
        const receiverDoc = await admin.firestore().collection('Users').doc(message.receiverId).get();

        if(!receiverDoc.exists) {
            console.log("no receiver");
            return null;
        }

        const receiverData = receiverDoc.data();
        const token = receiverData.fcmToken;

        if(!token) {
            console.log('No token');
            return null;
        }

        // updated message payload for 'send' method
        const messagePayload = {
            token: token,
            notification: {
                title: "New Message",
                body: '${message.senderEmail} says: ${message.message}',
            },
            android: {
                notification: {
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                }
            },
            apns: {
                payload: {
                    category: 'FLUTTER_NOTIFICATION_CLICK'
                }
            }
        };

        // send the notification 
        const response = await admin.messaging().send(messagePayload);
        console.log("Succesfull: ", response);

        return response;
    } catch (error) {
        console.error("Details: ", error);
        if(error.code && error.message) {
            console.error("Code: ", error.code);
            console.error("Messgae: ", error.message);
        }
        throw new Error("Faild");
    }
})
