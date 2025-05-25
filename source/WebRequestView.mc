//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.Graphics;

class WebRequestView extends Ui.View {
    hidden var mMessage = "Press menu button";
    hidden var mModel;

    var dataholder;

    function initialize(data) {
        Ui.View.initialize();
	dataholder=data;
    }


    // Load your resources here
    function onLayout(dc) {
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
	dataholder.setUpdateView(true);
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mMessage, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
	dataholder.setUpdateView(false);
    }

    function onReceive(args) {
        if (args instanceof Lang.String) {
            mMessage = args;
        }
        Ui.requestUpdate();
    }

}
