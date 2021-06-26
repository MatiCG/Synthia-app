import {DocumentReference} from "@google-cloud/firestore";
import * as functions from "firebase-functions";
import * as nodemailer from "nodemailer";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();


/**
 * Adds two numbers together.
 * @param {int} name The first number.
 * @param {int} email The second number.
 * @param {int} reportUrl The second number.
 * @param {int} title The second number.
 * @param {int} extension The second number.
 */
async function sendEmailTo(name: string, email: string, reportUrl: string,
    title: string, extension: string) {
  const gmailEmail = functions.config().gmail.email;
  const gmailPassword = functions.config().gmail.password;
  const mailTransport = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: gmailEmail,
      pass: gmailPassword,
    },
  });
  const mailOptions = {
    from: "Synthia",
    to: email,
    subject: "Votre compte rendu ",
    text: `Bonjour ${name},\n\nVous trouverez en pièce jointe
      le compte rendu de votre réunion "${title}".
      \n\nVous avez choisi le format "${extension}".Vous
      pouvez modifier ce choix à tout moment dans
      les paramètres de l"application.\n\nL"équipe synthIA`,
    html: `Bonjour ${name},<br/><br/>Vous trouverez en pièce
      jointe le compte rendu de votre réunion
      <strong>${title}</strong>.<br/><br/>Vous avez choisi le format
      <strong>${extension}</strong>.
      Vous pouvez modifier ce choix à tout moment dans les paramètres
      de l"application.<br/><br/>
      L"équipe synthIA`,
    attachments: [{
      filename: `compteRendu.${extension}`,
      path: reportUrl[0].indexOf(extension) != -1 ? reportUrl[0] : reportUrl[1],
    }],
  };

  try {
    await mailTransport.sendMail(mailOptions);
  } catch (error) {
    console.error("err:", error);
  }
  return null;
}

export const reportSender = functions.firestore
    .document("meetings/{id}")
    .onUpdate(async (snap) => {
      const members:DocumentReference[] = snap.after.data().members;
      const meetingTitle = snap.after.data().title;
      members.forEach(async (member: DocumentReference) => {
        const user = await db.doc(member.path).get();
        const email = user.data()!["email"];
        const firstname = user.data()!["firstname"];
        const rights = user.data()!["rights"];
        if (email != undefined && firstname != undefined &&
          rights != undefined) {
          if (rights.indexOf(
              db.doc("/rights/K9KjLB0a2HJqkrgHEXLX"))) {
            await sendEmailTo(email, email,
                "http://www.africau.edu/images/default/sample.pdf", meetingTitle, "pdf");
          }
        }
      });
    });
