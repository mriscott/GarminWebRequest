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
    var mUrl;
        var index=0;
	var baseurl= Ui.loadResource(Rez.Strings.MenuURL);

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
        if (menudata!=null && mUrl!=null){
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
        mUrl=url;
        if(System.getDeviceSettings().phoneConnected){
        notify.invoke("Loading");
	var callback=method(:onReceive);
        Comm.makeWebRequest(
             url,
            {
            },
            {
                "Content-Type" => Comm.REQUEST_CONTENT_TYPE_JSON
            },
            callback
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
    function onReceive(responseCode as Toybox.Lang.Number, data as Null or Toybox.Lang.String or Toybox.PersistedContent.Iterator or Toybox.Lang.Dictionary) as Void {
        if (responseCode == 200) {
            notify.invoke(data);
        } else {
            notify.invoke("Failed to load\nError: " + responseCode.toString());
        }
    }
    function onReceiveMenu(responseCode as Toybox.Lang.Number, data as Null or Toybox.Lang.String or Toybox.PersistedContent.Iterator or Toybox.Lang.Dictionary) as Void {
        if (responseCode == 200) {
	    if (data instanceof Dictionary){
	        menudata=data;
		var menu = new WatchUi.Menu();
		var delegate;
		menu.setTitle("Pages");
		var oldnote=Application.getApp().getNote();
		var note = data.get("note");
		if (note!=null && note != oldnote){
		System.println("Got note:"+note);
		       Application.getApp().setNote(note);
		       notify.invoke(note);
		}
		var urls=data.get("urls");
		if(urls instanceof Array){
		for(var i=0;i<urls.size();i++){
		    if(urls[i] instanceof Dictionary){
		    	menu.addItem(urls[i].get("name"), urls[i].get("url"));
		   }
		}
		}
		delegate = new WebRequestMenuDelegate(); // a WatchUi.MenuInputDelegate
		WatchUi.pushView(menu, delegate, SLIDE_IMMEDIATE);
		Attention.vibrate([new Attention.VibeProfile(100,500)]);

	    } else {
		notify.invoke("Bad response:"+responseCode);
	    }

        } else {
            notify.invoke("Failed to load\nError: " + responseCode.toString());
        }
    }
}
