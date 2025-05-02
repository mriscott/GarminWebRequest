//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.Graphics;

class WebRequestGlanceView extends Ui.GlanceView {
  var data;

  function initialize(dataholder) {
    data=dataholder;
   }


    // Load your resources here
    function onLayout(dc) {
    data.load();
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
	if(data.tcal!=null && data.tcal!=0){
	dc.fillRectangle(0,dc.getHeight()/2-3,(dc.getWidth()*data.acal)/data.tcal,6);
       }
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

    function getMessage(){
	if(data.rscore!=null && data.sscore!=null && data.ascore!=null
	&& data.rscore!=0 && data.sscore!=0 && data.ascore!=0){

	return "R:"+data.rscore+" S:"+data.sscore+" A:"+data.ascore;

	}
	return "R:- S:- A:-";
    }


}
