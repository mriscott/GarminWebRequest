//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;

class WebRequestMenuDelegate extends Ui.MenuInputDelegate {
    function onMenuItem(item) {
	Application.getApp().makeRequest(item);
	}
    
}
