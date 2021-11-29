import {cfAdm} from "./config";
import * as reportEmail from "./sendReportByEmail";
import * as createFile from "./createReportFile";
import * as notifications from "./notifications";

cfAdm.initializeApp();

export const updatedMeetingNotification = notifications.updatedMeeting;
export const sendReportByEmail = reportEmail.sendReportByEmail;
export const createReportFile = createFile.createReportFile;
