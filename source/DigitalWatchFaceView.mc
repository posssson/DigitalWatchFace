using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class DigitalWatchFaceView extends Ui.WatchFace {
var width;
var height;
var testFont;

    function initialize() {
        WatchFace.initialize();
        
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        testFont = Ui.loadResource(Rez.Fonts.test);

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
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        var seconds = clockTime.sec;
        hours = hours.format("%02d");

        var hourString = Lang.format(hourFormat, [hours]);
		var minString = Lang.format(minFormat, [clockTime.min.format("%d")]);
		var secString = Lang.format(secFormat, [seconds]);
        // Update the view
        var viewHour = View.findDrawableById("HourLabel");
        setScreen(viewHour, 0.48,0.3,Gfx.FONT_NUMBER_HOT,Gfx.COLOR_BLACK,Gfx.TEXT_JUSTIFY_RIGHT,hourString);
        
        var viewMin = View.findDrawableById("MinLabel");

        setScreen(viewMin, 0.48,0.55,Gfx.FONT_SYSTEM_NUMBER_HOT,Gfx.COLOR_BLACK,Gfx.TEXT_JUSTIFY_RIGHT,minString);
        
        var viewSec = View.findDrawableById("SecLabel");
        setScreen(viewSec, 0.48,0.8,Gfx.FONT_SMALL,Gfx.COLOR_BLACK,Gfx.TEXT_JUSTIFY_RIGHT,secString);
       
        var batteryOK =19;
        batteryOK= batteryOK.toNumber();
		var myStats = Sys.getSystemStats();
		var batteryStatus = myStats.battery;
		batteryStatus= batteryStatus.format("%d");
		var batteryFormat = "$1$%";
		var batteryStatusString = Lang.format(batteryFormat, [batteryStatus]);
		var viewBattery = View.findDrawableById("BatteryStatusLabel");
		if (batteryStatus.toNumber() > (batteryOK.toFloat())) {
       		setScreen(viewBattery, 0.52,0.1,Gfx.FONT_SMALL,Gfx.COLOR_GREEN,Gfx.TEXT_JUSTIFY_LEFT,batteryStatusString);
		} else {
 			setScreen(viewBattery, 0.52,0.3,Gfx.FONT_SMALL,Gfx.COLOR_RED,Gfx.TEXT_JUSTIFY_LEFT,batteryStatusString);
		}
		
		var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		var dateString = Lang.format("$1$ $2$ $3$", [today.day_of_week,today.day,today.month]);
       	var viewDate = View.findDrawableById("DateLabel");
        setScreen(viewDate, 0.48,0.2,Gfx.FONT_TINY,Gfx.COLOR_BLACK,Gfx.TEXT_JUSTIFY_RIGHT,dateString);
       

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        dc.setPenWidth(1);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
    	dc.drawLine(0.5*width,0*height,0.5*width,1*height);
    	dc.drawText(0.7*width,0.7*height, testFont, hours, Gfx.TEXT_JUSTIFY_RIGHT);
  		dc.drawText(0.7*width,0.5*height, testFont, seconds, Gfx.TEXT_JUSTIFY_RIGHT);
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
