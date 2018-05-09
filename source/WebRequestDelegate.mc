//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;

class WebRequestDelegate extends Ui.BehaviorDelegate {
    var notify;
        var index=0;
	var urlroot= "https://example.com/garmin.php?page=";

    // Handle menu button press
    function onMenu() {
        makeRequest();
        return true;
    }

    function onSelect() {
        makeRequest();
        return true;
    }
    

    function makeRequest() {
        if(System.getDeviceSettings().phoneConnected){
        notify.invoke("Executing\nRequest");
        Comm.makeWebRequest(
             urlroot+index,
            {
            },
            {
                "Content-Type" => Comm.REQUEST_CONTENT_TYPE_JSON
            },
            method(:onReceive)
        );
		index++;

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
}
