const functions = require("firebase-functions");
const firebase = require("@google-cloud/firestore");
const nodemailer = require("nodemailer");
const dotenv = require("dotenv");

dotenv.config();

const {ENV_EMAIL, ENV_PASSWORD} = process.env;

exports.sendReportByEmail =
functions.firestore.document("meetings/{id}")
    .onUpdate((change, context) => {
      const data = change.after.data();

      console.log("RESUME VALUE: ", data.resume);
      console.log("MEMBERS: ", data.members);
      const members = data.members;

      for (const member in members) {
        if (member instanceof firebase.DocumentReference) {
          console.log("MEMBER IN: ", member);
          console.log("MEMBER PATH: ", member.path);
        } else {
          console.log("IS NOT DOCUMENTREFERENCE");
        }
      }

      const authData = nodemailer.createTransport({
        host: "smtp.gmail.com",
        port: 465,
        secure: true,
        auth: {
          user: ENV_EMAIL,
          pass: ENV_PASSWORD,
        },
      });
      authData.sendMail({
        from: "synthIA",
        to: "silvinityliam@gmail.com",
        subject: "Votre compte-rendu",
        text: "Bonjour, ceci est le text",
      }).then((res) => {
        console.log("email successfully sent.");
      }).catch((err) => {
        console.error(err);
      });
    });
