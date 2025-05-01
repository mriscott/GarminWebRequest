//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//


class DataHolder  {
  var rscore=0;
  var sscore=0;
  var ascore=0;
  var acal=0;
  var tcal=0;
  var authkey;

    // Load your resources here
    function load() {
    rscore=Application.getApp().getProperty("ReadinessScore");
    sscore=Application.getApp().getProperty("SleepScore");
    ascore=Application.getApp().getProperty("ActivityScore");
    acal=Application.getApp().getProperty("ActiveCals");
    tcal=Application.getApp().getProperty("TargetCals");
    authkey = Application.getApp().getProperty("AuthKey");
    }

    function setSleep(sscore){
	Application.getApp().setProperty("SleepScore",sscore);
    }
    function setReadiness(rscore){
    Application.getApp().setProperty("ReadinessScore",rscore);
  }

    function setActivity(ascore,acal,tcal){
      Application.getApp().setProperty("ActivityScore",ascore);
      Application.getApp().setProperty("ActiveCals",acal);
      Application.getApp().setProperty("TargetCals",tcal);
    }

   
}
