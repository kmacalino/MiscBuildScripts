/**
 * Created by Ken on 5/10/14.
 */

#import "../lib/LibraryHeader.js"

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


// OrderPizza.run();
//BasicServerFunction.run();
