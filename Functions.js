/**
 * Created by Ken on 5/9/14.
 */

#import "../lib/LibraryHeader.js"

var logIn =
{
    run: function()
    {
        OELib.logMessage("Starting Login Script", kLogType.Start);
        OELib.clearScreenSaver();
        OELib.loginWithUserNumber("1111");
    }
};

var chooseLocation =
{
    run: function()
    {
        var frontApp = this.getTarget().frontMostApp();
        OELib.alertHandler();
        OELib.logMessage("Choosing Location 9991", kLogType.Debug);
        OELib.tapElementNamed("9991");
        OELib.alertHandler("Default");

    }
};

var BasicServerFunction =
{
    run: function()
    {
        OELib.logMessage("Starting Basic Server Function Script", kLogType.Start);
        OELib.waitForElementNamed("1", 35);
        OELib.clearScreenSaver();
        OELib.loginWithUserNumber("1");

        OELib.alertHandler("Default");
        OELib.logMessage("Choosing Location 9991", kLogType.Debug);
        OELib.tapElementNamed("9991");

        OELib.logMessage("Swiping to the left of the left", kLogType.Debug);
        OELib.swipeTo("Left");
        OELib.waitForElementNamed("Dine In")
        OELib.tapElementNamed("Dine In");
        OELib.tapElementNamed("Menus");
        OELib.tapElementNamed("Full Menu");
        OELib.tapElementNamed("Non-Alcoholic Beverages");

        OELib.tapElementNamed("Coke");
        OELib.tapElementNamed("Add to Order");

        OELib.alertHandler("Cancel");
        OELib.delay(2);
        OELib.tapElementNamed("Payment");

        OELib.tapElementNamed("Apply Payment Cash");
        OELib.tapElementNamed("Finalize");
        OELib.swipeTo("Left");

        OELib.alertHandler("Default");
        OELib.tapElementNamed("Finalize", 1);
        OELib.tapElementNamed("  Logout", 1);
        OELib.logMessage("Basic Server Function Test Passed!!!", kLogType.Pass);
    }

};

var OrderPizza =
{
    /** Sample Code to show how to ...
     *
     * Add Components on Left Side, Right Side and Both Sides
     * Add Expedite
     * Add Memo
     * Touch Info on OnScreenCheck
     * Remove Item from On Screen Check
     *
    **/


    run: function()
    {
        OELib.logMessage("Starting Order Pizza Function", kLogType.Start);
        OELib.waitForElementNamed("1", 35);
        OELib.clearScreenSaver();
        OELib.loginWithUserNumber("1");

        OELib.alertHandler("Default");
        OELib.tapElementNamed("99");

        OELib.swipeTo("Left");
        OELib.waitForElementNamed("Dine In");
        OELib.tapElementNamed("Dine In");
        OELib.tapElementNamed("Pizza");
        OELib.tapElementNamed("Build Your Own Pizza");
        OELib.waitForElementNamed("leftSide");
        OELib.tapElementNamed("leftSide");

        //Add Pizza Proteins
        OELib.tapElementNamed("Pizza Protiens");
        OELib.tapComponentNamed("Pizza Spicy Chick", "Add");
        OELib.tapElementNamed("rightSide");
        OELib.tapComponentNamed("Pizza Sausage", "Add");

        //Add Veggies
        OELib.tapElementNamed("Pizza Veggies");
        OELib.tapElementNamed("bothSides");
        OELib.tapComponentNamed("Pizza Mushrooms", "Add");
        OELib.tapComponentNamed("Pizza Eggplant", "Add");
        OELib.tapComponentNamed("Pizza Arugula", "Add");

        //Change Pizza Sauce to BBQ Sauce
        OELib.onScreenCheckOrderItemActions("Pizza Sauce", "Remove");
        OELib.tapElementNamed("Pizza Sauce");
        OELib.tapComponentNamed("Pizza BBQ Sauce", "Add");

        OELib.addMemo("Gluten Free BOOM!");
        OELib.tapElementNamed("Add to Order");

        //Expedite the Order
        OELib.onScreenCheckOrderItemActions("Build Your Own Pizza, $7.70", "Info");
        OELib.tapElementNamed("Expedite");
        OELib.tapElementNamed("VIP Service");
        OELib.tapElementNamed("Apply");

        //Take Cash Payment
        OELib.alertHandler("Cancel");
        OELib.tapElementNamed("Payment");
        OELib.delay(3);
        OELib.tapElementNamed("Apply Payment Cash");
        OELib.tapElementNamed("Finalize");
        OELib.tapElementNamed("Go to ...");
        OELib.tapElementNamed("Detach");
        OELib.swipeTo("Right");
        OELib.tapElementNamed("  Logout", 1);
        OELib.logMessage("Finished Order Pizza Function", kLogType.Pass);
    }
};

var AdvancedOrder =
{
    run: function()
    {
        OELib.logMessage("Starting Advanced Order Function", kLogType.Start);

        OELib.waitForElementNamed("1", 35);
        OELib.clearScreenSaver();
        OELib.loginWithUserNumber("1");

        OELib.alertHandler("Default");
        OELib.tapElementNamed("99");

        OELib.swipeTo("Left");
        OELib.waitForElementNamed("Dine In");
        OELib.tapElementNamed("Dine In");
        OELib.tapElementNamed("Wok");
        OELib.tapElementNamed("Crispy Honey Orange Shrimp");
        OELib.tapElementNamed("Allergy??");
        OELib.tapElementNamed("Wheat Allergy");
        OELib.dismissPopover();
        OELib.tapElementNamed("Plates?");
        OELib.tapElementNamed("1 Plate");
        OELib.tapElementNamed("Add to Order");

//this will remind you that you need to add rice
        OELib.tapElementNamed("OK");
        OELib.tapElementNamed("Rice Choice");
        OELib.tapComponentNamed("Brown Rice", "Add");
        OELib.tapElementNamed("Add to Order");
        OELib.tapElementNamed("");

        OELib.logMessage("Finished Advanced Order Function", kLogType.Pass);
    }
};
