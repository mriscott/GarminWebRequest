//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.Time as Time;

class WebRequestDelegate extends Ui.BehaviorDelegate {
    var notify;
    var dataholder;
    var error="";



    // Handle menu button press
    function onMenu() {
        loadMenu();
        return true;
    }

    function onSelect() {
        loadMenu();
        return true;
    }
    
    function loadMenu() {
	if(System.getDeviceSettings().phoneConnected){
	    notify.invoke("Loading ");
	    dataholder.requestData(true);
	}  else {
	    notify.invoke("Phone\ndisconnected");
	}
    }

    function initialize(handler,data) {
        Ui.BehaviorDelegate.initialize();
        notify = handler;
	dataholder=data;
	loadData();
	onMenu();
    }

    function loadData(){
	dataholder.load();		
    }



}
