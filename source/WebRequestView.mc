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
var linelen=22;
var maxlines=6;

    function initialize() {
        Ui.View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
	var info = ActivityMonitor.getInfo();
	/*
        mMessage = "Batt : "+System.getSystemStats().battery.format("%d")+"%\n"+
	 "Conn : "+System.getDeviceSettings().phoneConnected+"\n"+
	 "Step : "+info.steps+"/"+info.stepGoal+"\n"+
	 "Cals : "+info.calories;
	 */
	 var note = Application.getApp().getNote();
	 if(note!=null){
	 mMessage=note;
	 }
    

	
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
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
    }

    function onReceive(args) {
        if (args instanceof Lang.String) {
            mMessage = args;
        }
        else if (args instanceof Dictionary) {
	    var content= args.get("content");
	    if (content!=null) {
	       content=content.toString();	
	       if(content.find("\n")!=null) {
		   mMessage=content;
		} else {
		   mMessage=splitLines(content);
		}
	    }
	    else {
	    	 mMessage="Invalid json";
		 }
        }
        Ui.requestUpdate();
    }

    function splitLines(str){
        if(str.length()<linelen) {
           return str;
        }
        var tokens = [];
        var found = str.find(" ");
        while (found != null) {
            var token = str.substring(0, found);
            tokens.add(token);
            str = str.substring(found + 1, str.length());
            found = str.find(" ");
        }

        tokens.add(str);

        var newstr="";
        var lines=1;
        var line=0;
        for(var i=0;i<tokens.size();i++){
           line+=tokens[i].length();
           if (line>linelen){
                if(lines>=maxlines) {
                   newstr+="$";
                   break;
                }
                newstr+="\n";
                line=tokens[i].length();
                lines++;
           }
           newstr+=tokens[i];
           newstr+=" ";
           line++;
        }
        return newstr;
    }
}
