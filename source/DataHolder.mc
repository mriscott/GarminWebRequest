//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Time as Time;

class DataHolder  {
  var rscore=0;
  var sscore=0;
  var ascore=0;
  var acal=0;
  var tcal=0;
  var authkey;
  var expire=0;

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
	Application.getApp().setProperty("expire",expire);
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

   
}
