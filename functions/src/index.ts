import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

/*
export const NewMeeting = functions.firestore
  .document('users/{userId}')
  .onWrite( async snapshot => {
    var beforeData = snapshot.before.data();
    var afterData = snapshot.after!.data();

    var beforeArr = beforeData!['meetings'];
    var afterArr = afterData!['meetings'];

    if (beforeArr != afterArr && afterArr.length > beforeArr.length) {
      var user = await admin.auth().getUserByEmail(afterData!['email']);
      const fcmToken = await db.collection('users').doc(user.uid).collection('tokens').get();

      const tokens = fcmToken.docs.map(snap => snap.id);
      console.log('SEND TOKEN = ', tokens);
      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: 'Nouvelle réunion',
          body: `Vous avez été invité à la réunion ! Elle commencera `,
          icon: 'your-icon-url',
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      };
      var res = fcm.sendToDevice(tokens, payload);
      console.log('RES = ', res);
      return res;
    }
    return false;
  });
*/

export const UpdatedMeeting = functions.firestore
  .document('meetings/{meetingId}')
  .onUpdate(async snapshot => {
    const meeting = snapshot.after.data();
    meeting.members.forEach(async (value: string) => {
        var user = await admin.auth().getUserByEmail(value);
        const permission = await db.collection('users').doc(user.uid).get();

        if (permission.data()!['meeting_change'] == true) {
          const fcmToken = await db.collection('users').doc(user.uid).collection('tokens').get();
          const tokens = fcmToken.docs.map(snap => snap.id);

          return sendToDevice("Modification d'une réunion", `La réunion ${meeting.title} a été modifée!`, tokens);
        }
        return false;
    });
  });

export const NewMeeting = functions.firestore
  .document('meetings/{meetingId}')
  .onCreate(async snapshot => {
    const meeting = snapshot.data();
    meeting.members.forEach(async (value: string) => {
        var user = await admin.auth().getUserByEmail(value);
        const permission = await db.collection('users').doc(user.uid).get();

        if (permission.data()!['meeting_new'] == true) {
          const fcmToken = await db.collection('users').doc(user.uid).collection('tokens').get();
          const tokens = fcmToken.docs.map(snap => snap.id);

          return sendToDevice('Nouvelle réunion', `Vous avez été ajouté à la réunion ${meeting.title}! Rendez vous sur l'application pour l'ordre du jour`, tokens);
        }
        return false;
    });
  });

  const sendToDevice = (title: string, body: string, tokens: any) => {
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: title,
        body: body,
        icon: 'iconurl',
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToDevice(tokens, payload);
  }