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
  var acals=0;
  var tcals=0;

    // Load your resources here
    function onLayout(dc) {
    rscore=Application.getApp().getProperty("ReadinessScore");
    sscore=Application.getApp().getProperty("SleepScore");
    ascore=Application.getApp().getProperty("ActivityScore");
    acals=Application.getApp().getProperty("ActiveCals");
    tcals=Application.getApp().getProperty("TargetCals");
    }

    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(dc.getWidth()/2, dc.getHeight()/4*3, Graphics.FONT_SMALL, getMessage(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(5, dc.getHeight()/4, Graphics.FONT_SMALL, "Oura", Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
	dc.drawLine(0,dc.getHeight()/2,dc.getWidth(),dc.getHeight()/2);
	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);
	dc.fillRectangle(0,dc.getHeight()/2-5,(dc.getWidth()*acals)/tcals,10);
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

    function getMessage(){

      return "R:"+rscore+" S:"+sscore+" A:"+ascore;
    }


}
