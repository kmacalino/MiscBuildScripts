
#import "../lib/OELib.js"

// Reset Device to a default state
OELib.resetDeviceToDefault();


// Insert your testing steps here
OELib.loginWithUserNumber("1");


// The bash script scrapes the log for this message. This logMessage is required for a test to be considered successful
OELib.logMessage("Test Successful", kLogType.Pass);


