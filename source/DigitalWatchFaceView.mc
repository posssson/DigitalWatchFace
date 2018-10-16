using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class DigitalWatchFaceView extends WatchUi.WatchFace {
var width;
var height;

    function initialize() {
        WatchFace.initialize();
        
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    
        width=dc.getWidth();
		height=dc.getHeight();
        // Get the current time and format it correctly
        var hourFormat = "$1$";
        var minFormat = "$1$";
        var secFormat = "$1$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var seconds = clockTime.sec;
        hours = hours.format("%02d");

        var hourString = Lang.format(hourFormat, [hours]);
		var minString = Lang.format(minFormat, [clockTime.min.format("%d")]);
		var secString = Lang.format(secFormat, [seconds]);
        // Update the view
        var viewHour = View.findDrawableById("HourLabel");
        setScreen(viewHour, 0.48,0.3,Graphics.FONT_NUMBER_HOT,Graphics.COLOR_BLACK,Graphics.TEXT_JUSTIFY_RIGHT,hourString);
        
        var viewMin = View.findDrawableById("MinLabel");

        setScreen(viewMin, 0.48,0.55,Graphics.FONT_SYSTEM_NUMBER_HOT,Graphics.COLOR_BLACK,Graphics.TEXT_JUSTIFY_RIGHT,minString);
        
        var viewSec = View.findDrawableById("SecLabel");
        setScreen(viewSec, 0.48,0.8,Graphics.FONT_SMALL,Graphics.COLOR_BLACK,Graphics.TEXT_JUSTIFY_RIGHT,secString);
       
        var batteryOK =19;
        batteryOK= batteryOK.toNumber();
		var myStats = System.getSystemStats();
		var batteryStatus = myStats.battery;
		batteryStatus= batteryStatus.format("%d");
		var batteryFormat = "$1$%";
		var batteryStatusString = Lang.format(batteryFormat, [batteryStatus]);
		var viewBattery = View.findDrawableById("BatteryStatusLabel");
		if (batteryStatus.toNumber() > (batteryOK.toFloat())) {
       		setScreen(viewBattery, 0.52,0.1,Graphics.FONT_SMALL,Graphics.COLOR_GREEN,Graphics.TEXT_JUSTIFY_LEFT,batteryStatusString);
		} else {
 			setScreen(viewBattery, 0.52,0.3,Graphics.FONT_SMALL,Graphics.COLOR_RED,Graphics.TEXT_JUSTIFY_LEFT,batteryStatusString);
		}
		
		var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		var dateString = Lang.format("$1$ $2$ $3$", [today.day_of_week,today.day,today.month]);
       	var viewDate = View.findDrawableById("DateLabel");
        setScreen(viewDate, 0.48,0.2,Graphics.FONT_TINY,Graphics.COLOR_BLACK,Graphics.TEXT_JUSTIFY_RIGHT,dateString);
       

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    	dc.drawLine(0.5*width,0*height,0.5*width,1*height);
   
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
    function setScreen (view, x,y,font,color,justify,string){
    	view.setColor(color);
        view.setFont(font);
        view.setJustification(justify);
        view.setLocation(x*width,y*height);
        view.setText(string);
    }

}
