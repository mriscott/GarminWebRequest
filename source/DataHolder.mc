//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Communications as Comm;
using Toybox.System;
using Toybox.Time as Time;

class DataHolder extends System.ServiceDelegate {
  var rscore=0;
  var sscore=0;
  var ascore=0;
  var acal=0;
  var tcal=0;
  var authkey;
  var expire=0;
  var lastreq=0;
  var delegate=0;
  var updateView=false;
  var updateGlance=false;
	var error="";
    var baseurl= "https://api.ouraring.com/v2/usercollection/";
	var view;
	var glance;;
		
    function setUpdateGlanceView(x){
	updateGlance=x;
    }
    function setUpdateView(x){
	updateView=x;
    }

    function updatemsg(){
	var msg="";
	if(updateView){
	    if(error.length()>0){
		msg=error;
	    }else{
		msg=
		    "Readiness : "+rscore+
		    "\nSleep : "+sscore+
		    "\nActivity : "+ascore+
		    "\n\nCal : "+acal+"/"+tcal;
	    }
	    view.onReceive(msg);
	}
	if(updateGlance){
		glance.update();
	}

	
		
	
    }
    
    function setGlanceView(v){
	glance=v;
    }
    function setView(v){
	view=v;
    }

    // Load your resources here
    function load() {
    expire = Application.getApp().getProperty("expire");
    lastreq = Application.getApp().getProperty("lastreq");
    if(expire==null ||  expire>Time.now().value()){
    rscore=Application.getApp().getProperty("ReadinessScore");
    sscore=Application.getApp().getProperty("SleepScore");
    ascore=Application.getApp().getProperty("ActivityScore");
    acal=Application.getApp().getProperty("ActiveCals");
    tcal=Application.getApp().getProperty("TargetCals");
    }else{
    rscore=0;
    sscore=0;
    ascore=0;
    acal=0;
    tcal=1;
    }
    authkey = Application.getApp().getProperty("AuthKey");
    }

    function setExpiry(){
	var today = new Time.Moment(Time.today().value());
	var oneDay = new Time.Duration(Time.Gregorian.SECONDS_PER_DAY);
	var tomorrow = today.add(oneDay);
	expire=tomorrow.value();
	Application.getApp().setProperty("expire",expire);
    }

    function setLastReq(){
	load();
	lastreq=Time.today().value();
	Application.getApp().setProperty("lastreq",lastreq);
    }
    

    function setSleep(score){
	sscore=score;
	Application.getApp().setProperty("SleepScore",sscore);
	setExpiry();
    }
    function setReadiness(score){
	rscore=score;
	setExpiry();
    Application.getApp().setProperty("ReadinessScore",rscore);
  }

    function setActivity(score,acals,tcals){
	ascore=score;
	acal=acals;
	tcal=tcals;
      Application.getApp().setProperty("ActivityScore",ascore);
      Application.getApp().setProperty("ActiveCals",acal);
      Application.getApp().setProperty("TargetCals",tcal);
	setExpiry();
    }

		function requestData(skip){
		    var now=Time.now().value();
		    if(lastreq!=null && lastreq!=0 && now<(lastreq+600) && skip){
			return;
		    }
		    setLastReq();
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
								"Authorization" => "Bearer  "+authkey
						},
       };

				if(System.getDeviceSettings().phoneConnected){
						error="";
						Comm.makeWebRequest( sleepurl,params , options , method(:onReceiveSleep));
						Comm.makeWebRequest( acturl,params , options , method(:onReceiveActivity));
						Comm.makeWebRequest( readyurl,params , options , method(:onReceiveReadiness));
						
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
										setSleep(sscore);
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
										setReadiness(rscore);
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
										setActivity(ascore,acal,tcal);
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


