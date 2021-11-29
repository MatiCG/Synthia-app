import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {cfAdm} from "./config";

// const db = admin.firestore();
// const fcm = admin.messaging();

export const updatedMeeting = functions.firestore
    .document("meetings/{id}").onUpdate(async (snap) => {
      const meeting = snap.after.data();

      meeting.members.forEach(async (value: any) => {
        console.log("ID: " + value.id);

        const user = await cfAdm.firestore()
            .collection("users").doc(value.id).get();

        const token = user.data()!["fcmToken"];
        console.log("TOKEN: " + token);

        const rights: [] = user.data()!["rights"];
        console.log("RIGHS ARRAYY: " + rights);

        console.log("LENGHT: " + rights.length);
        if (rights.length > 0) {
          user.data()!["rights"].forEach(async (value: any) => {
            const right = await cfAdm.firestore()
                .collection("rights").doc(value.id).get();
            console.log("RIGHT: " + right.data()!["title"]);
          });
        }

        return sendToDevice("Réunion mise à jour",
            `La réunion ${meeting.title} a été modifiée!`, [token]);
      });
    });

const sendToDevice = (title: string, body: string, tokens: any) => {
  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: title,
      body: body,
      icon: "iconurl",
      click_action: "FLUTTER_NOTIFICATION_CLICK",
    },
  };

  return cfAdm.messaging().sendToDevice(tokens, payload);
};
