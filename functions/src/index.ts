import {cfAdm} from "./config";
import * as reportEmail from "./sendReportByEmail";
import * as createFile from "./createReportFile";

cfAdm.initializeApp();

export const sendReportByEmail = reportEmail.sendReportByEmail;
export const createReportFile = createFile.createReportFile;
