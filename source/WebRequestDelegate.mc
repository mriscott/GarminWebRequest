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
    var menudata;
    var menuchoice;
    var rscore=0;
    var sscore=0;
    var ascore=0;
    var acal=0;
    var tcal=0;
    var authkey = Ui.loadResource(Rez.Strings.AuthKey);


    var mUrl;
        var index=0;
	var baseurl= "https://api.ouraring.com/v2/usercollection/";

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
	var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
	var tomorrow = Time.Gregorian.info(Time.now().add( new Time.Duration(3600*24)), Time.FORMAT_SHORT);
	var start_date=""+today.year+"-0"+today.month+"-"+today.day;
	var end_date=""+tomorrow.year+"-0"+tomorrow.month+"-"+tomorrow.day;
	var sleepurl= baseurl+"daily_sleep?start_date="+start_date+"&end_date="+end_date;
	var acturl= baseurl+"daily_activity?start_date="+start_date+"&end_date="+end_date;
	var readyurl= baseurl+"daily_readiness?start_date="+start_date+"&end_date="+end_date;
	var params={};

	var options = {                                             // set the options
           :headers => {                                           // set headers
		"Authorization" => "Bearer  "+authkey
		},
       };

        if (menudata!=null && mUrl!=null){
	   //onReceiveMenu(200,menudata);
	   Application.getApp().repeatRequest();
	} else {
        if(System.getDeviceSettings().phoneConnected){
        notify.invoke("Loading ");
        Comm.makeWebRequest( sleepurl,params , options , method(:onReceiveSleep));
        Comm.makeWebRequest( acturl,params , options , method(:onReceiveActivity));
        Comm.makeWebRequest( readyurl,params , options , method(:onReceiveReadiness));

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
	onMenu();
    }

    // Receive the data from the web request
    function onReceive(responseCode as Toybox.Lang.Number, data as Null or Toybox.Lang.String or Toybox.PersistedContent.Iterator or Toybox.Lang.Dictionary) as Void {
        if (responseCode == 200) {
            notify.invoke(data);
        } else {
            notify.invoke("Failed to load\nError: " + responseCode.toString());
        }
    }
    function updatemsg(){
      notify.invoke(
         "Readiness : "+rscore+
         "\nSleep : "+sscore+
         "\nActivity : "+ascore+
         "\n\nCal : "+acal+"/"+tcal);
    }
    function onReceiveSleep(responseCode as Toybox.Lang.Number, data as Null or Toybox.Lang.String or Toybox.PersistedContent.Iterator or Toybox.Lang.Dictionary) as Void {
        if (responseCode == 200) {
	    if (data instanceof Dictionary){
		data=data.get("data");
		if(data==null || (data as Toybox.Lang.Array).size()==0){
                  notify.invoke("No data for today");
		}else{
			data=data[0];
			sscore=data.get("score");
			updatemsg();
		}

	    } else {
		notify.invoke("Bad sleep response:\n"+responseCode);
	    }

        } else {
            notify.invoke("Failed to load sleep\nError: " + responseCode.toString());
        }
    }
    function onReceiveReadiness(responseCode as Toybox.Lang.Number, data as Null or Toybox.Lang.String or Toybox.PersistedContent.Iterator or Toybox.Lang.Dictionary) as Void {
        if (responseCode == 200) {
	    if (data instanceof Dictionary){
		data=data.get("data");
		if(data==null || (data as Toybox.Lang.Array).size()==0){
                  notify.invoke("No data for today");
		}else{
			data=data[0];
			rscore=data.get("score");
			updatemsg();
		}

	    } else {
		notify.invoke("Bad readiness response:\n"+responseCode);
	    }

        } else {
            notify.invoke("Failed to load sleep\nError: " + responseCode.toString());
        }
    }
    function onReceiveActivity(responseCode as Toybox.Lang.Number, data as Null or Toybox.Lang.String or Toybox.PersistedContent.Iterator or Toybox.Lang.Dictionary) as Void {
        if (responseCode == 200) {
	    if (data instanceof Dictionary){
		data=data.get("data");
		if(data==null || (data as Toybox.Lang.Array).size()==0){
                  notify.invoke("No data for today");
		}else{
		data=data[0];
		ascore=data.get("score");
		acal=data.get("active_calories");
		tcal=data.get("target_calories");
		updatemsg();
		}

	    } else {
		notify.invoke("Bad activity response:\n"+responseCode);
	    }

        } else {
            notify.invoke("Failed to load activity\nError: " + responseCode.toString());
        }
    }

}
