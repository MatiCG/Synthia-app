const admin = require("firebase-admin");
const reportEmail = require("./sources/sendReportByEmail");

admin.initializeApp();

exports.sendReportByEmail = reportEmail.sendReportByEmail;
