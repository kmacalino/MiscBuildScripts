#!/bin/sh

#  runTests.sh
#  GOPS_SDK

################################################################################################
#
# - Note:  With each new release of Xcode the device, simulator & trace template paths usually change. It is very likely that when you upgrade your copy of xcode these tests will fail to run.
# - Note:  Please update the 'xcrun instruments' cmd to include the new device, simulator or trace template path if necessary. To run tests with a device the UDID must be included in the path.
#
################################################################################################

# QA Cleanup Test 2

# Get all scripts
SCRIPTS=~/northstar.orderentry.ios/GOPS_Automation/Scripts/*

# Get the root path (used to parse the script name)
rootPath=~/northstar.orderentry.ios/GOPS_Automation/Scripts/




# Get name of computer
computerName=$(scutil --get ComputerName)



# Get Device UDID if attached#
for line in $(system_profiler SPUSBDataType | sed -n -e '/iPad/,/Serial/p' -e '/iPhone/,/Serial/p' | grep "Serial Number:" | awk -F ": " '{print $2}'); do
DEVICE_UDID=${line}
done



# Get Simulator Version
SIMULATOR_VERSION="iPad - Simulator - iOS 7.1"



# Get Instruments Automation Tempalte
INSTRUMENTS_TEMPLATE='/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate'

# Get Path to Simulator App
APP_PATH='/Users/Dobyns/Library/Developer/Xcode/DerivedData/NorthStar_Order_Entry-gobascnkwiowdwfhinhwfidiyipc/Build/Products/Debug-iphonesimulator/Order Entry.app'



# Get Path to Instruments Results
## Insert Path

# Get Path to Store Log Results
## Insert Path





# Get todays date
todaysDate=$(date +"%m/%d/%Y")

# Get time tests beganaaa
timeBeganInSeconds=$(date +"%s")
timeBeganFormatted=$(date +"%r")



# Set array of failed tests
failedTests=()

# Set array of successful tests
successfulTests=()

# Set number of failed tests
y=0

# Set number of tests ran
z=0

# Clear Terminal
clear




# Clear any folders named Logs to avoid errors
rm -rf ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs/Logs

# Create temporary folder to store logs
mkdir -p ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs/Logs




# Loop each test through Instruments UIAutomation
for script in $SCRIPTS
do

# Get name of script
name=${script#${rootPath}}
nameFormatted=${name%.js}

# Increase number of tests ran by 1
z=$((z+1))

failedTests+=('        <testcase classname="'"Automated Tests"'" name="'"$nameFormatted"'" time="'4'">')


# Add folder for script output
mkdir -p ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs/Logs/"$nameFormatted Logs"

echo "Running Test: $nameFormatted"

# Open Instruments with the selected application and store the results
if [ -n "$DEVICE_UDID" ]; then
echo "Device Detected!"
xcrun instruments -t "$INSTRUMENTS_TEMPLATE" -w "$DEVICE_UDID" "Order Entry.app" -e UIASCRIPT "$script" -e UIARESULTSPATH ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs/Logs/"$nameFormatted Logs" > ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs/Logs/"$nameFormatted Logs"/"$nameFormatted Log"
else
echo "No Device Detected"
xcrun instruments -w "$SIMULATOR_VERSION"  -t "$INSTRUMENTS_TEMPLATE" "$APP_PATH" -e UIASCRIPT "$script" -e UIARESULTSPATH ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs/Logs/"$nameFormatted Logs" > ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs/Logs/"$nameFormatted Logs"/"$nameFormatted Log"
fi


# Parse the log for test successful message
if [ $(grep -c -i "Pass: Test Successful" ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs/Logs/"$nameFormatted Logs"/"$nameFormatted Log") -gt 0 ]; then

# Add script name to successful tests array
successfulTests+=("$nameFormatted")

echo "Test Successful\n"
else
# Increase the number of failed tests by 1
y=$((y+1))

failedTests+=('            <failure message="Assertion FAILED: some failed assert" type="failure"></failure>')

echo "Test Failed\n"


fi

# If there are screenshots move them to the log folder
cd ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs/Logs/"$nameFormatted Logs"/Run\ 1
if [ "`ls | grep -i '\(\.png\)' | wc -l`" -eq 1 ]; then
mv ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs/Logs/"$nameFormatted Logs"/Run\ 1/*.png ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs/Logs/"$nameFormatted Logs"
fi

# Kill the Simulator if running
if [ -n "$DEVICE_UDID" ]; then
echo ""
else
killall "iPhone Simulator"
fi

failedTests+=('        </testcase>')

done




# Get time tests finished
timeFinishedInSeconds=$(date +"%s")
timeFinishedFormatted=$(date +"%r")

# Get duration of tests
timeToRunTestsInSeconds=$(($timeFinishedInSeconds-$timeBeganInSeconds))
((sec=timeToRunTestsInSeconds%60, timeToRunTestsInSeconds/=60, min=timeToRunTestsInSeconds%60, hrs=timeToRunTestsInSeconds/60))
timeToRunTestsFormatted=$(printf "%d:%02d:%02d" $hrs $min $sec)

sleep 2


#echo "\nAll Tests Are Complete, Sending Email Notification.\n"

# Send Email Upon Completion

{ echo '<?xml version="1.0" encoding="utf-8"?>';
echo '<testsuites errors="'0'" failures="'$y'" tests="'$z'" time="'$timeToRunTestsFormatted'">';
echo '    <testsuite name="'Automated Tests'" errors="'$y'" failures="'0'" package="'insertPackage'" tests="'$z'" timestamp="'$timeToRunTestsFormatted'">';
echo '        <properties>';
echo '        </properties>';

printf -- '%s\n' "${failedTests[@]}"

#echo '        ---insert testcase array---';
#echo '        <testcase classname="Automated Tests" name="insert test name here" time="4">';
#echo '        </testcase>';
#echo '        <testcase classname="Automated Tests" name="insert test name 2 here" time="6">';
#echo '            <failure message="Assertion FAILED: some failed assert" type="failure"></failure>';
#echo '        </testcase>';
#echo '        ---end testcase array---';

echo '    </testsuite>';
echo '</testsuites>';
sleep 1; } > ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/automatedTestResults.xml

#echo "\nEmail Sent\n"


# Send Email Upon Completion
#{ echo "helo mail.cbsnorthstar.com";
#echo "MAIL FROM: $emailAddress";
#echo "RCPT TO: $emailAddress";
#echo "DATA";
#echo "";
#echo "Subject: Automated Tests Complete";
#echo "To: $emailAddress";
#echo "From: $computerName\n";
#echo "Date: $todaysDate";
#echo "Started at: $timeBeganFormatted";
#echo "Finished at: $timeFinishedFormatted\n";
#echo "The following automated tests took $timeToRunTestsFormatted to complete.\n\n";
#echo "$y of $z Tests Ran Successfully\n";
#echo "Failed Tests:";
#printf -- '%s\n' "${failedTests[@]}"
#echo "\nSuccessful Tests:";
#echo '%s\n' "${successfulTests[@]}"
#echo ".";
#sleep 1; } | telnet mail.cbsnorthstar.com 25





# Find and remove unnecessary files
echo "Removing Unnecessary Files..."
cd ~/northstar.orderentry.ios
find . -name "Run 1" -exec rm -rf {} \;

find . -name "*.trace" -exec rm -rf {} \;

# Zip logs and delete temp folder
echo "\n\nCompressing Log Files:"
cd ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs
zip -r $(date +"%H.%M%p(%h.%d.%Y)").zip ./Logs
rm -rf ~/northstar.orderentry.ios/build/TestResults/AutomatedTests/Logs/Logs

# Remove oldest zip file if more than 7 exist
rm -rf `ls -t | awk 'NR>7'`




# End of script
clear
echo "Hooray, All Automated Tests Have Finished! Have A nice day!\n\n"
read -p "Press Any Key To Continue..."
clear


