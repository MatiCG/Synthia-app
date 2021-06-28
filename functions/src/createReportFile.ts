import * as functions from "firebase-functions";
import * as PDFDocument from "pdfkit";
import {cfAdm} from "./config";

export const createReportFile =
functions.firestore.document("meetings/{id}")
    .onUpdate(async (change: any, context: any) => {
      const before = change.before.data();
      const data = change.after.data();

      if (before.resume != undefined && before.resume != "") {
        console.log("Not creating report !");
        return;
      }
      if (data.resume == undefined || data.resume == "") {
        console.log("Not creating report !");
        return;
      }

      const doc = new PDFDocument();
      const fileRef = cfAdm
          .storage()
          .bucket()
          .file(`meetings/${context.params.id}/report.pdf`);
      await new Promise<void>((resolve, reject) => {
        const writeStream = fileRef.createWriteStream({
          public: true,
          resumable: false,
          contentType: "application/pdf",
        });
        writeStream.on("finish", () => resolve());
        writeStream.on("error vJHDKJSHDFKJHSDKJH", (e) => reject(e));
        doc.pipe(writeStream);
        doc
            .fontSize(24)
            .text(data.title)
            .fontSize(16)
            .moveDown(2)
            .text(data.resume);
        doc.end();
      });
      const url = await fileRef.getSignedUrl({
        version: "v4",
        action: "read",
        expires: Date.now() + 24 * 60 * 60 * 1000,
      });
      cfAdm.firestore().collection("meetings").doc(context.params.id)
          .update({
            "reportUrl": url[0],
          });
    });
