// import * as functions from "firebase-functions";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
import * as admin from "firebase-admin";
import * as reportEmail from "./sendReportByEmail";

admin.initializeApp();

export const db = admin.firestore();

export const sendReportByEmail = reportEmail.sendReportByEmail;
