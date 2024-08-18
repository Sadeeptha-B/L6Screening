// 2.1
/* 
Returns an array of free/busy intervals in a given time period for any shared calendar
   
Input: Shared google calendar ID, Time period (starting and ending moments)
Output: Array of busy intervals
*/
const { google } = require("googleapis");
const input = require("@inquirer/input").default;
const authorize = require("./auth.js");

async function requestInputs() {
  const calendarId = await input({
    message: "Enter your Calendar ID",
    default: "primary",
    required: true,
  });
  const currentDate = new Date();
  const twoDaysAgo = new Date(currentDate - (MILLISECONDS_PER_DAY * 2))

  console.log(
    "\nDate inputs must be provided as valid ISO strings" +
      "\nEg- 2024-08-16T06:17:15.780Z where the T denotes the offset from UTC time\n"
  );

  const timeMin = await input({
    message: "Enter starting time",
    default: twoDaysAgo.toISOString(),
    required: true,
    validate: validateDateInput,
  });

  const timeMax = await input({
    message: "Enter ending time",
    default: currentDate.toISOString(),
    required: true,
    validate: (str) => {
      const validDate = validateDateInput(str);
      const equalToMin = str === timeMin;
      if (equalToMin) {
        console.log("\nEnding time cannot be equal to the starting time");
      }
      return validDate && !equalToMin;
    },
  });
  return [calendarId, timeMin, timeMax];
}

async function listFreebusy(auth, [calendarId, timeMin, timeMax]) {
  const calendar = google.calendar({ version: "v3", auth });
  const res = await calendar.freebusy.query({
    requestBody: {
      items: [{ id: calendarId }],
      timeMax,
      timeMin,
    },
  });
  const busyIntervals = res.data.calendars[calendarId].busy;
  console.log("Array of busy intervals: ");
  console.log(busyIntervals);
}

// Ask for inputs
async function main() {
  /**
   * Example inputs:
   * calendarId: primary,
   * timeMin: 2024-08-16T06:17:15.780Z
   * timeMax: 2024-08-18T06:17:15.780Z,
   */
  const inputs = await requestInputs();
  authorize()
    .then((client) => listFreebusy(client, inputs))
    .catch(console.error);

}

main();

// Utils
const MILLISECONDS_PER_DAY = 1000 * 60 * 60 * 24

const validateDateInput = (str) => {
  let valid = false;
  try {
    valid = new Date(str).toISOString() === str;
  } catch (err) {
    console.log("\nInput cannot be parsed to a date");
  }
  return valid;
};
