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
	var start_date=""+today.year+"-"+today.month.format("%02d")+"-"+today.day.format("%02d");
	var end_date=""+tomorrow.year+"-"+tomorrow.month.format("%02d")+"-"+tomorrow.day.format("%02d");
	var sleepurl= baseurl+"daily_sleep?start_date="+start_date+"&end_date="+end_date;
	var acturl= baseurl+"daily_activity?start_date="+start_date+"&end_date="+end_date;
	var readyurl= baseurl+"daily_readiness?start_date="+start_date+"&end_date="+end_date;
	var params={};

	var options = {                                             // set the options
           :headers => {                                           // set headers
		"Authorization" => "Bearer  "+dataholder.authkey
		},
       };

        if(System.getDeviceSettings().phoneConnected){
        notify.invoke("Loading ");
	error="";
        Comm.makeWebRequest( sleepurl,params , options , method(:onReceiveSleep));
        Comm.makeWebRequest( acturl,params , options , method(:onReceiveActivity));
        Comm.makeWebRequest( readyurl,params , options , method(:onReceiveReadiness));

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

    // Receive the data from the web request
    function updatemsg(){
      if(error.length()>0){
	notify.invoke(error);
      }else{
      notify.invoke(
         "Readiness : "+dataholder.rscore+
         "\nSleep : "+dataholder.sscore+
         "\nActivity : "+dataholder.ascore+
         "\n\nCal : "+dataholder.acal+"/"+dataholder.tcal);
	}
    }
    function onReceiveSleep(responseCode as Toybox.Lang.Number, data as Null or Toybox.Lang.String or Toybox.PersistedContent.Iterator or Toybox.Lang.Dictionary) as Void {
        if (responseCode == 200) {
	    if (data instanceof Dictionary){
		data=data.get("data");
		if(data==null || (data as Toybox.Lang.Array).size()==0){
                  error=("No sleep data");
		}else{
			data=data[0];
			var sscore=data.get("score");
			dataholder.setSleep(sscore);
			updatemsg();
		}

	    } else {
		error="Bad sleep response:"+responseCode;
	    }

        } else {
            error=("Failed to load sleep\nError: " + responseCode.toString());
        }
    }
    function onReceiveReadiness(responseCode as Toybox.Lang.Number, data as Null or Toybox.Lang.String or Toybox.PersistedContent.Iterator or Toybox.Lang.Dictionary) as Void {
        if (responseCode == 200) {
	    if (data instanceof Dictionary){
		data=data.get("data");
		if(data==null || (data as Toybox.Lang.Array).size()==0){
                  error=("No readiness for today");
		}else{
			data=data[0];
			var rscore=data.get("score");
			dataholder.setReadiness(rscore);
			updatemsg();

		}

	    } else {
		error=("Bad readiness response:"+responseCode);
	    }

        } else {
            error=("Failed to load sleep\nError: " + responseCode.toString());
        }
    }
    function onReceiveActivity(responseCode as Toybox.Lang.Number, data as Null or Toybox.Lang.String or Toybox.PersistedContent.Iterator or Toybox.Lang.Dictionary) as Void {
        if (responseCode == 200) {
	    if (data instanceof Dictionary){
		data=data.get("data");
		if(data==null || (data as Toybox.Lang.Array).size()==0){
                  error=("No data for today");
		}else{
		data=data[0];
		var ascore=data.get("score");
		var acal=data.get("active_calories");
		var tcal=data.get("target_calories");
		dataholder.setActivity(ascore,acal,tcal);
		updatemsg();
		}

	    } else {
		error=("Bad activity response:\n"+responseCode);
	    }

        } else {
            error=("Failed to load activity\nError: " + responseCode.toString());
        }
    }

}
