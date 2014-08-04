
target.frontMostApp().mainWindow().scrollViews()[0].scrollViews()[1].staticTexts()["Non-Alcoholic Beverages"].tapWithOptions({tapOffset:{x:0.45, y:0.57}});
target.frontMostApp().mainWindow().scrollViews()[0].scrollViews()[0].staticTexts()["Coke"].tapWithOptions({tapOffset:{x:0.43, y:0.52}});
target.frontMostApp().mainWindow().buttons()["Add to Order"].tap();
target.frontMostApp().mainWindow().buttons()["Payment"].tap();
// Alert detected. Expressions for handling alerts should be moved into the UIATarget.onAlert function definition.
target.frontMostApp().alert().defaultButton().tap();
target.frontMostApp().mainWindow().tableViews()[2].cells()["Test Combo II"].tap();
target.frontMostApp().mainWindow().tableViews()[3].tapWithOptions({tapOffset:{x:0.90, y:0.15}});
target.frontMostApp().toolbar().buttons()["Confirm"].tap();
target.frontMostApp().mainWindow().buttons()["Finalize"].tap();
target.frontMostApp().mainWindow().scrollViews()[0].dragInsideWithOptions({startOffset:{x:0.84, y:0.70}, endOffset:{x:0.04, y:0.71}});
target.frontMostApp().mainWindow().scrollViews()[0].staticTexts()["Finalize"].tapWithOptions({tapOffset:{x:0.50, y:0.33}});
// Alert detected. Expressions for handling alerts should be moved into the UIATarget.onAlert function definition.
target.frontMostApp().alert().defaultButton().tap();
target.frontMostApp().toolbar().buttons()["  Logout"].tap();