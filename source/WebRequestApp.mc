//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application as App;

class WebRequestApp extends App.AppBase {
    hidden var mView;
    hidden var mDelegate;
    hidden var mUrl;

    function initialize() {
        App.AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        mView = new WebRequestView();
        mDelegate =  new WebRequestDelegate(mView.method(:onReceive));
        return [mView, mDelegate];
    }


    function makeRequest(url) {
        mUrl=url;
        return mDelegate.makeRequest(url);
    }

    function repeatRequest() {        
        return mDelegate.makeRequest(mUrl);
    }


}
