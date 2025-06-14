//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Communications as Comm;
using Toybox.System;
using Toybox.Time as Time;
using Toybox.Background;

(:background)	
class DataHolder extends System.ServiceDelegate {
  var rscore=0;
  var sscore=0;
  var ascore=0;
  var acal=0;
  var tcal=0;
  var authkey;
  var expire=0;
  var delegate=0;
  var updateView=false;
	var error="";
    var baseurl= "https://api.ouraring.com/v2/usercollection/";
	var view;
		
    function setUpdateView(x){
	updateView=x;
    }

    function updatemsg(){
	var msg="";
	System.println("Update:"+error);
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

	
		
	
    }
    
    function setView(v){
	view=v;
    }

    // Load your resources here
    function load() {
    expire = Application.getApp().getProperty("expire");
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
	var values = {
 	   "rscore" => rscore,
    	   "sscore" => sscore,
    	   "ascore" => ascore,
    	   "acal" => acal,
    	   "tcal" => tcal,
    	   "expire" => expire
	   };
	   System.println("Returning values:"+values);
	Background.exit(values);
    }


    

    function setSleep(score){
	sscore=score;
	setExpiry();
    }
    function setReadiness(score){
	rscore=score;
	setExpiry();
  }

    function setActivity(score,acals,tcals){
	ascore=score;
	acal=acals;
	tcal=tcals;
	setExpiry();
    }

    function saveData(dict){
      if(dict.get("ascore")!=0){
	Application.getApp().setProperty("ActivityScore",dict.get("ascore"));
	Application.getApp().setProperty("ActiveCals",dict.get("acal"));
	Application.getApp().setProperty("TargetCals",dict.get("tcal"));
      }
      if(dict.get("rscore")!=0){
	Application.getApp().setProperty("ReadinessScore",dict.get("rscore"));
      }
      if(dict.get("sscore")!=0){
	Application.getApp().setProperty("SleepScore",dict.get("sscore"));
      }
      if(dict.get("expire")!=0){
	Application.getApp().setProperty("expire",dict.get("expire"));
      }

    } 

		function requestData(all){
				load();
				var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
				System.println("Requesting:"+today.hour+":"+today.min+":"+today.sec);;
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
						if(all){
						  Comm.makeWebRequest( sleepurl,params , options , method(:onReceiveSleep));
						  Comm.makeWebRequest( readyurl,params , options , method(:onReceiveReadiness));
						}
						Comm.makeWebRequest( acturl,params , options , method(:onReceiveActivity));
						
				} 


		}




		function onReceiveSleep(responseCode as Toybox.Lang.Number, data as Null or Toybox.Lang.String or Toybox.PersistedContent.Iterator or Toybox.Lang.Dictionary) as Void {
	System.println("Got sleep "+responseCode);
        if (responseCode == 200) {
						if (data instanceof Dictionary){
								data=data.get("data");
								if(data==null || (data as Toybox.Lang.Array).size()==0){
										error=("No sleep data");
								}else{
										data=data[0];
										var sscore=data.get("score");
										setSleep(sscore);
System.println("Sleep:"+sscore);
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
	System.println("Got readiness "+responseCode);
        if (responseCode == 200) {
						if (data instanceof Dictionary){
								data=data.get("data");
								if(data==null || (data as Toybox.Lang.Array).size()==0){
										error=("No readiness for today");
								}else{
										data=data[0];
										var rscore=data.get("score");
System.println("Readiness:"+rscore);
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
	System.println("Got activity "+responseCode);
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
System.println("Activity:"+ascore);
										updatemsg();
								}

						} else {
								error=("Bad activity response:\n"+responseCode);
						}
						
        } else {
            error=("Failed to load activity\nError: " + responseCode.toString());
        }
    }

	function onTemporalEvent(){
		System.println("Temporal event!");
		requestData(false);
	}
}


