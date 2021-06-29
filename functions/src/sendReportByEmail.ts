import * as functions from "firebase-functions";
import * as firebase from "@google-cloud/firestore";
import * as nodemailer from "nodemailer";
import * as dotenv from "dotenv";
import {cfAdm} from "./config";

dotenv.config();

const {ENV_EMAIL, ENV_PASSWORD} = process.env;
const authData = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 465,
  secure: true,
  auth: {
    user: ENV_EMAIL,
    pass: ENV_PASSWORD,
  },
});

export const sendReportByEmail =
functions.firestore.document("meetings/{id}")
    .onUpdate(async (change: any, context: any) => {
      const before = change.before.data();
      const data = change.after.data();

      console.log("SEND FUNCTION CALLED");

      if (before.reportUrl != undefined && before.reportUrl != "") {
        console.log("Not sending report !");
        return;
      }
      if (data.reportUrl == undefined || data.reportUrl == "") {
        console.log("Not sending report !");
        return;
      }
      const members: firebase.DocumentReference[] = data.members;
      members.forEach(async (member: firebase.DocumentReference) => {
        const userData = await cfAdm.firestore().doc(member.path).get();
        const userRights: firebase.DocumentReference[] =
        userData.data()?.rights;

        if (userRights != undefined) {
          userRights.forEach(async (right: firebase.DocumentReference) => {
            const rightData =
            (await cfAdm.firestore().doc(right.path).get()).data();

            if (rightData != undefined &&
              rightData.title == "report_send_email") {
              console.log("Sending email to", userData.data()?.email);
              authData.sendMail({
                from: "synthIA",
                to: userData.data()?.email,
                subject: "Votre compte-rendu",
                attachments: [{
                  filename: "Compte-rendu.pdf",
                  path: data.reportUrl,
                }],
                text: `Bonjour ${userData.data()?.firstname},\n\n
Vous trouverez en pièce jointe le compte rendu de votre réunion'${data.title}'.
\n\nL'équipe synthIA`,
              }).then((res: any) => {
                console.log("email successfully sent.");
              }).catch((err: any) => {
                console.error(err);
              });
            }
          });
        }
        console.log("Member: ", member.path);
      });
    });
