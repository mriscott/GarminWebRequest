//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;

class WebRequestDelegate extends Ui.BehaviorDelegate {
    var notify;
    var menudata;
    var menuchoice;
        var index=0;
	var baseurl= "https://example.com/webrequests.json";

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
        if (menudata!=null){
	   //onReceiveMenu(200,menudata);
	   Application.getApp().repeatRequest();
	} else {
        if(System.getDeviceSettings().phoneConnected){
        notify.invoke("Loading Menu");
        Comm.makeWebRequest(
             baseurl,
            {
            },
            {
                "Content-Type" => Comm.REQUEST_CONTENT_TYPE_JSON
            },
            method(:onReceiveMenu)
        );

	}  else {
	   notify.invoke("Phone\ndisconnected");
	}
	}
    }

    function makeRequest(url) {
        if(System.getDeviceSettings().phoneConnected){
        notify.invoke("Loading");
        Comm.makeWebRequest(
             url,
            {
            },
            {
                "Content-Type" => Comm.REQUEST_CONTENT_TYPE_JSON
            },
            method(:onReceive)
        );

	}  else {
	   notify.invoke("Phone\ndisconnected");
	}

    }

    // Set up the callback to the view
    function initialize(handler) {
        Ui.BehaviorDelegate.initialize();
        notify = handler;
    }

    // Receive the data from the web request
    function onReceive(responseCode, data) {
        if (responseCode == 200) {
            notify.invoke(data);
        } else {
            notify.invoke("Failed to load\nError: " + responseCode.toString());
        }
    }
    function onReceiveMenu(responseCode, data) {
        if (responseCode == 200) {
	    if (data instanceof Dictionary){
	        menudata=data;
		var menu = new WatchUi.Menu();
		var delegate;
		menu.setTitle("Pages");
		var urls=data.get("urls");
		for(var i=0;i<urls.size();i++){
		    if(urls[i] instanceof Dictionary){
		    	menu.addItem(urls[i].get("name"), urls[i].get("url"));
		   }
		}
		delegate = new WebRequestMenuDelegate(); // a WatchUi.MenuInputDelegate
		WatchUi.pushView(menu, delegate, SLIDE_IMMEDIATE);
		return true;
	    } else {
		notify.invoke("Bad response");
	    }

        } else {
            notify.invoke("Failed to load\nError: " + responseCode.toString());
        }
    }
}

