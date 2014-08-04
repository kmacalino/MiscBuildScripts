/**
 *  Order Entry Automation Library:
 *
 *
 *      - This script contains global functions that can be used for automation.
 *      - Import this library to utilize any of the following functions.
 *
 *
 *  Created by Ken Macalino on 5/8/14.
 *
 */



// Global Variables:
var ELEMENT_TIMEOUT = 20; //The default timeout in seconds.
var kLogType = {"Debug":1, "Error":2, "Fail":3, "Issue":4, "Message":5, "Pass":6, "Start":7, "Warning":8};



// OELib Functions:
var OELib =
{
    /** logMessage(message, logType);
     *
     * Description: Writes a message to the log with a specific log type.
     *
     * 2 Parameters:
     *      @param {string} Message to Log
     *      @param {int} Log Type {Debug, Error, Fail, Issue, Message, Pass, Start, Warning}
     *
     * Example: OELib.logMessage("Swiping to the Left", 7);
     *
     */
    logMessage: function(message, logType)
    {
        switch(logType)
        {
            case kLogType.Debug:
                UIALogger.logDebug(message);
                break;
            case kLogType.Error:
                UIALogger.logError(message);
                break;
            case kLogType.Fail:
                UIALogger.logFail(message);
                break;
            case kLogType.Issue:
                UIALogger.logIssue(message);
                break;
            case kLogType.Message:
                UIALogger.logMessage(message);
                break;
            case kLogType.Pass:
                UIALogger.logPass(message);
                break;
            case kLogType.Start:
                UIALogger.logStart(message);
                break;
            case kLogType.Warning:
                UIALogger.logWarning(message);
                break;
            default:
                UIALogger.logMessage(message);

                break;

        }
    },

    /** swipeTo(direction);
     *
     * Description: Mimics the swipe gesture on an iPad.
     *
     * 1 Parameter:
     *      @param {string} Name of Direction
     *
     * Example: swipeTo("Left");
     *
     */
    swipeTo: function(direction)
    {
        this.logMessage("Swiping app to " + direction + " direction.");

        this.delay(1);
        var listScrollViews = this.getMainWindow().scrollViews();

        for (var i = 0; i < listScrollViews.length; i++)
        {
            this.logMessage("Scrollview Object; " + i + " " + listScrollViews[i], kLogType.Debug);

            try
            {
                switch(direction.toUpperCase())
                {
                    case "LEFT":
                        this.logMessage("Swiping the screen: " + direction, kLogType.Debug);
                        this.getMainWindow().scrollViews()[i].scrollLeft();
                        this.delay(1);
                        break;

                    case "RIGHT":
                        this.logMessage("Swiping the sceren: " + direction, kLogType.Debug);
                        this.getMainWindow().scrollViews()[i].scrollRight();
                        this.delay(1);
                        break;

                    default:
                        this.logMessage("direction is invalid", kLogType.Fail);

                }
                this.delay(1);
            }
            catch(err)
            {
                this.logMessage(err, kLogType.Debug);
                continue;
            }
            break;

        }

    },

    /** tapButtonNamed(buttonName);
     *
     * Description: Tap buttons that you cannot find via tapElementNamed.
     *
     * 1 Parameter:
     *      @param {string} Name of Button
     *
     * Example: tapButtonNamed("Finalize");
     *
     */
    alertHandler: function(handle)
    {
        OELib.logMessage("Watching if Alert exists.", kLogType.Debug);
        OELib.delay(4);
        UIATarget.onAlert = function onAlert(parameter)
        {
            var title = parameter.name();
            var getTarget = UIATarget.localTarget();
            //var frontApp = this.getTarget().frontMostApp();

            UIALogger.logDebug("Alert with title ’" + title + "’ encountered!");
            getTarget.delay(4);

            if (handle.toUpperCase() == "DEFAULT")
            {
                OELib.logMessage("Tapping Default button", kLogType.Debug);
                parameter.defaultButton().tap();
                return true;
            }
            else if (handle.toUpperCase() == "CANCEL")
            {
                OELib.logMessage("Tapping Cancel button", kLogType.Debug);
                parameter.cancelButton().tap();
                return true;
            }

            return false; // use default handler

        };
    },

    advancedOrderPlacement: function(email, account)
    {
        OELib.logMessage("Attaching Advanced Order Account" + account);
        OELib.delay(2);
        OELib.tapElementNamed("silhouette outline");
        OELib.getMainWindow().textFields()[0].tap();
        OELib.getTarget().frontMostApp().keyboard().typeString(email);
        OELib.getMainWindow().textFields()[1].tap();
        OELib.getMainWindow().tableViews()[1].cells()[account + ", " + email].tap();
        OELib.getTarget().frontMostApp().tap();
        OELib.tapElementNamed("Set Date & Time").tap();
        OELib.tapElementNamed("Date, Today").tap();


    },

    //Creating Picker Wheel!!!!!
    pickerWheel: function(name)
    {
        var i;
        var wheel = OELib.getMainWindow().popover().pickers()[i];
        var searchWheel = searchElements(wheel, name, "name");

        while(searchWheel.isValid())
        {
            this.logMessage("looking for picker wheel", kLogType.Debug);

        }
    },

    /** Function that will dismiss popovers
     *
     *  Use this when you need to dismiss a popover that will not go away after
     *  you touch an option.
     */
    dismissPopover: function()
    {
        OELib.logMessage("Dismissing Popover windows", kLogType.Debug);
        OELib.delay(1);
        this.getMainWindow().popover().dismiss();
    },

    /** attachToLocation(locationNumber);
     *
     * Description: Selects a location number to attach to. Checks for alert on location attachment.
     *
     * 1 Parameter:
     *      @param {string} Location Number
     *mess
     * Example: attachToLocation("501")
     *
     */
    attachToLocation: function(locationNumber)
    {
        this.alertHandler();
        this.logMessage("Choosing Location " + locationNumber, kLogType.Debug);
        this.tapElementNamed(locationNumber);
    },

    /** loginWithUserNumber(user);
     *
     * Description: Login with user number
     *
     * 1 Parameter:
     *      @param {String} This user number has to be a string
     *
     * Example: loginWithUserNumber("1111")
     *
     */
    loginWithUserNumber: function(user)
    {
        this.logMessage("Logging in with user number " + user, kLogType.Debug);
        var strUser = user.toString();

        for (var i = 0; i < user.length; i++ )
        {
            this.logMessage("Tapping " + strUser.charAt(i), kLogType.Debug);
            this.tapElementNamed("LoginKeypad - " + strUser.charAt(i));
            this.delay(.5)
        }

        this.tapElementNamed("LoginKeypad - OK");
        this.delay(4);

    },

    addMemo: function(memo)
    {
        this.logMessage("Adding memo " + memo, kLogType.Debug);
        this.tapElementNamed("Add Memo");
        this.delay(2);
        this.getTarget().frontMostApp().keyboard().typeString(memo);
        this.getMainWindow().popover().toolbar().buttons()["Add Memo"].tap();
        this.delay(2);
    },

    /** clearScreenSaver();
     *
     * Description: This function clears the screen saver if it is present.
     *
     * No Parameters
     *
     * Example: clearScreenSaver();
     *
     */
    clearScreenSaver: function ()
    {
       var kTapScreenSaver = {x:50, y:5};
       this.logMessage("Clearing the screensaver", kLogType.Debug);
       this.getTarget().tap(kTapScreenSaver);
       this.delay(1);
    },

    /** tapComponent
     *
     * Description: This function is for the component screen.
     *              You have to enter the name of the component and what type of action
     *              you want the component to do.  Either ADD or SUBTRACT.
     *
     * @param name - Name of the component
     * @param modify - Choose either to ADD or SUBTRACT.
     */
    tapComponentNamed: function(name, modify)
    {
        var kModifyComponent = {Add:{x:0.90, y:0.75}, Subtract:{x:0.10, y:0.75}};
        OELib.delay(1);
        switch (modify.toUpperCase())
        {
            case "ADD":

                this.waitForElementNamed(name);
                componentModificationNamed(name, kModifyComponent.Add);
                break;

            case "SUBTRACT":

                this.waitForElementNamed(name);
                componentModificationNamed(name, kModifyComponent.Subtract);
                break;

            default:

                this.logMessage("Make sure you are using ADD or SUBTRACT modify paramaters", kLogType.Fail);
                break;

        }

    },

    /** Function to do On Screen Check Actions on Items
     *
     *  NOTE: MUST BE DONE ON A DEVICE.  CURRENTLY DOES NOT WORK ON IOS SIMULATOR 7.0
     *
     * @param name - Exact name that appears in the on screen check
     * @param action - Current actions that are accepted:
     *                  Remove - Removes the item on the check
     *                  Info - Touches the Info button of the item
     *
     */
    onScreenCheckOrderItemActions: function(name, action)
    {
        var onScreenElement = OELib.getMainWindow().tableViews()[0];
        //var element = onScreenElement.withPredicate("name contains " + "'" + name + "'");
        var element = searchElements(onScreenElement, name, "name");

        this.logMessage("Performing On Screen Check Task " + action + " on " + element, kLogType.Debug);

        onScreenCheckTasks(element, action, name);
    },

    tapElementWithOptions: function(name, timeout, offSet)
    {
        if (!timeout)
        {
            timeout = ELEMENT_TIMEOUT;
        }

        var element = elementNamed(name, timeout);

        if (!isNil(element))
        {
            this.logMessage("Tapping element " + element + "with offset " + offSet, kLogType.Debug);

            try
            {
                element.tapWithOptions({tapCount:1, tapOffSet:offSet});
                this.delay(1);
            }
            catch (err)
            {
                this.logMessage(err, kLogType.Debug);
            }
        }


    },

    tapElementNamed: function(name, timeout)
    {
        if (!timeout)
        {
            timeout = ELEMENT_TIMEOUT;
        }

        this.logMessage("Tapping element named " + name + " with a timeout of " + timeout + " seconds. ", kLogType.Debug);

        var element = elementNamed(name, timeout);

        if (!isNil(element))
        {
            this.logMessage("Tapping element " + element, kLogType.Debug);

            try
            {
                OELib.waitForElementNamed(name, 5);
                element.tap();
                this.delay(1);
            }
            catch (err)
            {
                this.logMessage(err, kLogType.Debug);
                tapElementIndex(name);
            }
        }

    },


    /**  This will list available elements on the current screen.  Useful for debugging.
     *
     */
    showAvailableElements: function()
    {
        OELib.logMessage("Start Logging Elements", kLogType.Start);
        var logTree = OELib.getMainWindow().logElementTree();
        OELib.logMessage(logTree, kLogType.Message);
        OELib.logMessage("Finished Logging elements", kLogType.Pass);
    },

    /** Delays the script until the element appears
     *
     * @returns {BOOLEAN} if the element is found within the timeout, return true else false
     * @param {String} element name
     * @param {timeout} int in seconds.  default timeout is ELEMENT_TIMEOUT
     */
    waitForElementNamed: function (name, timeout)
    {
        if (!timeout)
        {
            timeout = ELEMENT_TIMEOUT;
        }

        this.logMessage("Waiting for element named " + name + " for " + timeout + " seconds", kLogType.Debug);

        var element = elementNamed(name, timeout);

        if (isNil(element))
        {
            this.logMessage("Timed out waiting for the element named " + name + " for " + timeout + " seconds ", kLogType.Debug);
            return false;
        }
        else
        {
            return true;
        }
    },

    /** getMainWindow();
     *
     * Description: This will get the mainWindow of the of the local Target.
     *
     * No Parameters
     *
     * Example: getMainWindow();
     *
     */
    getMainWindow: function ()
    {
        return this.getTarget().frontMostApp().mainWindow();
    },

    /** getTarget();
     *
     * Description: This will get the local target. Used at the very beginning of every App action to get the App controls
     *
     * No Parameters
     *
     * Example: getTarget();
     *
     */
    getTarget: function()
    {
        return UIATarget.localTarget();
    },

    /** delay(seconds);
     *
     * Description: Adds a delay in seconds.
     *
     * 1 Parameter:
     *      @param {int} Number of Seconds
     *
     * Example: delay(3);
     *
     */
    delay: function(sec)
    {
        this.logMessage("Delaying " + sec + "seconds.");
        this.getTarget().delay(sec);
    }
};



// Role Functions:
/**
 *
 * List of Roles (edit this after QA team decides on list of site roles):
 *
 * Admin
 * Barista
 * Bartender
 * Busser
 * Cashier
 * Cook
 * Dishwasher
 * Drive Thru Operator
 * Expediter
 * Food Runner
 * General Manager
 * Hostess
 * Kitchen Manager
 * Order Taker
 * Procedures Template
 * Server
 * Shift Manager
 *
 */

/** Login as an Administrator
 *
 * This function will log in as as an Administrator user with the key code "insert key code".
 *
 * Example: logInAsAdmin.run();
 *
 */
var logInAsAdmin =
{
    run: function()
    {
        OELib.logMessage("Logging in as", 6);
        OELib.clearScreenSaver();
        OELib.loginWithUserNumber("1");
    }
};

/** Login as a Barista
 *
 * This function will log in as as a Barista user with the key code "insert key code".
 *
 * Example: logInAsAdmin.run();
 *
 */
var logInAsBarista =
{
    run: function()
    {
        OELib.logMessage("Logging in as", kLogType.start);
        OELib.clearScreenSaver();
        OELib.loginWithUserNumber("");
    }
};



// Helper Functions:
/** isNil(element);
*
* Description: Tests if the supplied element is UIAElementNil
*
* 1 Paramenter:
*      @param {UIAElement} Element is the Element To test
*
* Example: isNil("textField");
*
*/
function isNil(element)
{
    if (element === undefined)
    {
        return true;
    }
    else
    {
        return (element.toString() == "[object UIAElementNil]");
    }

}

/** searchElements(elem, value, key);
 *
 * Description: Searches all of the available elements.
 *
 * 3 Paramenter:
 *      @param {elem} Name of Element
 *      @param {value} Value of Element
 *      @param {key} Key of Element
 *
 * Example: -insert example-
 *
 */
function searchElements(elem, value, key)
{
    var enableLogging = false;

    try
    {
        OELib.getTarget().pushTimeout(0);

        if (enableLogging)
        {
            OELib.logMessage("checking " + Object.prototype.toString.call(elem) + " elem.name()=\"" + elem.name() + "\" elem.value()=\"" + elem.value() + "\" value=\"" + value + "\" key =\"" + key + "\"", kLogType.Debug);
        }

        var result = elem.withValueForKey(value, key);

        if (!isNil(result))
        {
            /** Use this to find out the list of methods inside an object
            for (var objName in result)
            {
                this.logMessage(objName, kLogType.Debug);
                var oVal = result[objName];
                this.logMessage(oVal, kLogType.Debug);

            }
            **/

            if (enableLogging)
            {
                OELib.logMessage("returning " + result.toString(), kLogType.Debug);
            }
            return result;

        }

        var elems = elem.elements();

        if (enableLogging)
        {
            OELib.logMessage("checking " + elems.length + " children", kLogType.Debug);
        }

        for (var i = 0; i < elems.length; i++)
        {
            var child = elems[i];
            result = searchElements(child, value, key);
            if (!isNil(result))
            {
                if (enableLogging)
                {
                    OELib.logMessage("returning child of " + elem.name() + "- Result is : " + result, kLogType.Debug);
                }
                return result;
            }
        }

        if (enableLogging)
        {
            OELib.logMessage(value + " not found in children of " + elem.name(), kLogType.Debug);
        }

        return result;
    }
    finally
    {
        OELib.getTarget().popTimeout();
    }
}

function elementNamed(name, timeout)
{
    var start = (new Date()).getTime();
    if(!timeout)
    {
        timeout = OELib.getTarget().timeout();
    }
    OELib.logMessage("Searching for " + name, kLogType.Debug);
    var result;
    while (((new Date()).getTime() - start) < (timeout * 1000) || timeout == 0)
    {
        result = searchElements(OELib.getMainWindow(), name, "name");
        if (!isNil(result))
        {
            OELib.logMessage("searchElements returned " + result.toString(), "Debug");
            OELib.delay(.5); //Small Delay to allow UI to catch up
            return result;
        }
        if (timeout == 0)
        {
            break;
        }
    }

    //Script will fail if the element was not found
    OELib.logMessage("Unable to find the element named " + name, kLogType.Fail);

}

/** This is a function to search for duplicate elements
 *
 * @param element
 * @param name
 * @param index
 * @returns {*}
 */
function searchElementIndex(element,elementLength, name, index)
 {
     for (index; index < elementLength; index++)
     {
         var elementsRemaining = elementLength - index;
         OELib.logMessage("Searching through " + elementsRemaining + " elements left", kLogType.Debug);

         var result = searchElements(element[index], name, "name");

         if (!isNil(result))
         {
             OELib.logMessage("Returning element " + result + " with index of : " + index, kLogType.Debug);
             return result;
         }
     }
 }


/** Will loop through duplicate elements to tap each one.
 *
 * @param name  -- Element Name
 */
function tapElementIndex(name)
{
    var element = this.getMainWindow().elements();
    var length = element.length;

    for (var i = 0; i < length; i++)
    {
        var elementResult = searchElementIndex(element[i], length, name, i);

        if (!isNil(elementResult))
        {
            try
            {
                OELib.logMessage("Tapping element name " + elementResult, kLogType.Debug);
                elementResult.tap();
                OELib.delay(1);
            }
            catch (err)
            {
                OELib.logMessage(err, kLogType.Debug);
            }
        }
    }
}

/** Component Modification Helper for the tapComponent Function
 *
 * @param name
 * @param timeout
 * @param offSet
 */
function componentModificationNamed(name, offSet)
{
    var componentElements = OELib.getMainWindow().scrollViews()[0];
    var element = searchElements(componentElements, name, "name");

    if (!isNil(element))
    {
        OELib.logMessage("Tapping element " + element + "with offset " + offSet, kLogType.Debug);

        try
        {
            element.tapWithOptions({tapCount:1, tapOffSet:offSet});
            OELib.delay(1);
        }
        catch (err)
        {
            OELib.logMessage(err, kLogType.Debug);
        }
    }
}

function onScreenCheckTasks (element, task, name)
{
    if (!isNil(element))
    {
        OELib.logMessage("Performing " + task + " on element " + element);

        switch(task.toUpperCase())
        {
            case "REMOVE":
                element.dragInsideWithOptions({startOffset:{x:0.84, y:0.20}, endOffset:{x:0.40, y:0.19}, duration: 0.25});
                OELib.delay(1);
                element.buttons()["Remove"].tap();
                break;

            case "INFO":

                var infoName = "More info, " + name;
                OELib.logMessage("Tapping " + infoName, kLogType.Debug);
                //var elementInfo = searchElements(OELib.getMainWindow().tableViews()["Empty list"],infoName , "name");
                var elementInfo = searchElements(element,infoName , "name");
                elementInfo.tap();
                break;

        }

    }

}