//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.Graphics;

class WebRequestGlanceView extends Ui.GlanceView {
  var rscore=0;
  var sscore=0;
  var ascore=0;

    // Load your resources here
    function onLayout(dc) {
    rscore=Application.getApp().getProperty("ReadinessScore");
    sscore=Application.getApp().getProperty("SleepScore");
    ascore=Application.getApp().getProperty("ActivityScore");
    }

    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_SMALL, getMessage(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

    function getMessage(){

      return "R:"+rscore+" S:"+sscore+" A:"+ascore;
    }


}
