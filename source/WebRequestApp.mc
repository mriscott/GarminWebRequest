//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application as App;

(:background)
class WebRequestApp extends App.AppBase {
    hidden var mView;
    hidden var mDelegate;
    hidden var mUrl;
    hidden var data;
    function initialize() {
        App.AppBase.initialize();
	data=new DataHolder();
	
	Background.registerForTemporalEvent(new Time.Duration (5*60));
    }

    function getServiceDelegate(){
	return [data];
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        mView = new WebRequestView(data);
        mDelegate =  new WebRequestDelegate(mView.method(:onReceive),data);
	data.setView(mView);
        return [mView, mDelegate];
    }

    function onBackgroundData(bgdata){
	data.saveData(bgdata);
    }

    function getGlanceView(){
	var glance=new WebRequestGlanceView(data);
	return [glance];
    }



}
