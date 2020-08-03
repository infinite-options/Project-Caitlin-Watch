//
//  ComplicationController.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 6/27/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
        
    let model = UserDay.shared

    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date())
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date().addingTimeInterval(24*60*60))
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        print("getCurrentTimelineEntry")
        if complication.family == .modularLarge {
            let userDay = model.UserDayData
            if userDay.count > 0 {
                print("Date ", Date())
                if userDay[0] is Event {
                    let start = userDay[0].start!.dateTime
                    let end = userDay[0].end!.dateTime
                    
                    let time = DayDateObj.ISOFormatter.date(from: userDay[0].start!.dateTime)
                    let startTime = DayDateObj.formatter.string(from: DayDateObj.ISOFormatter.date(from: start)!)
                    
                    let endTime = DayDateObj.formatter.string(from: DayDateObj.ISOFormatter.date(from: end)!)
                    
                    let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
                    modularLarge.headerTextProvider = CLKSimpleTextProvider(text: userDay[0].summary!)
                    modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "Starts at " +  startTime)
                    modularLarge.body2TextProvider = CLKSimpleTextProvider(text: "Ends at " + endTime)
                            
                    let template = modularLarge
                    let timelineEntry = CLKComplicationTimelineEntry(date: time!, complicationTemplate: template)
                    print("Here: \(userDay[0].summary!) :: \(time!)")
                    
                    handler(timelineEntry)
                } else {
                    var time = DayDateObj.goalStartUTC.date(from: model.UserDayData[0].mapValue!.fields.startDayAndTime.stringValue)
                    
                    let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time!)
                    
                    var currentDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
                    
                    currentDate.hour = dateComponents.hour
                    currentDate.minute = dateComponents.minute
                    currentDate.second = dateComponents.second
                    
                    time = Calendar.current.date(from: currentDate)
                    
                    let times = DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: userDay[0].mapValue!.fields.startDayAndTime.stringValue)!)  + " - " + DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: userDay[0].mapValue!.fields.endDayAndTime.stringValue)!)
                       
                    let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
                    modularLarge.headerTextProvider = CLKSimpleTextProvider(text: userDay[0].mapValue!.fields.title.stringValue)
                    if ((userDay[0].mapValue!.fields.isInProgress?.booleanValue) == true) {
                        modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is in progress.")
                    } else if ((userDay[0].mapValue!.fields.isComplete?.booleanValue) == true) {
                        modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is complete.")
                    } else {
                        modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is ready to begin.")
                    }
                    modularLarge.body2TextProvider = CLKSimpleTextProvider(text: times)
                            
                    let template = modularLarge
                    let timelineEntry = CLKComplicationTimelineEntry(date: time!, complicationTemplate: template)
                    print("Here: \(userDay[0].mapValue!.fields.title.stringValue) :: \(time!)")
                    
                    handler(timelineEntry)
                }
            } else {
                handler(nil)
            }
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        
        print("getTimelineEntries")
        
        if complication.family == .modularLarge {
            let userDay = model.UserDayData
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            if (userDay.count > 0) {
                for index in 0...(userDay.count-2) {
                    if userDay[index] is Event {
                        let start = userDay[index].start!.dateTime
                        let end = userDay[index].end!.dateTime
                        
                        let time = DayDateObj.ISOFormatter.date(from: userDay[index].start!.dateTime)
                        
                        let startTime = DayDateObj.formatter.string(from: DayDateObj.ISOFormatter.date(from: start)!)
                        
                        let endTime = DayDateObj.formatter.string(from: DayDateObj.ISOFormatter.date(from: end)!)
                        
                        
                        let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
                        modularLarge.headerTextProvider = CLKSimpleTextProvider(text: userDay[index].summary!)
                        modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "Starts at " +  startTime)
                        modularLarge.body2TextProvider = CLKSimpleTextProvider(text: "Ends at " + endTime)
                                
                        let template = modularLarge
                        let timelineEntry = CLKComplicationTimelineEntry(date: time!, complicationTemplate: template)
                        
                        print("Here: \(model.UserDayData[index].summary!) :: \(time!)")
                        timeLineEntries.append(timelineEntry)
                    } else {
                        var time = DayDateObj.goalStartUTC.date(from: model.UserDayData[index].mapValue!.fields.startDayAndTime.stringValue)
                        
                        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time!)
                        
                        var currentDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
                        
                        currentDate.hour = dateComponents.hour
                        currentDate.minute = dateComponents.minute
                        currentDate.second = dateComponents.second
                        
                        time = Calendar.current.date(from: currentDate)
                        
                        let times = DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: model.UserDayData[index].mapValue!.fields.startDayAndTime.stringValue)!)  + " - " + DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: model.UserDayData[index].mapValue!.fields.endDayAndTime.stringValue)!)
                        
                        let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
                        modularLarge.headerTextProvider = CLKSimpleTextProvider(text: model.UserDayData[index].mapValue!.fields.title.stringValue)
                        if ((model.UserDayData[index].mapValue!.fields.isInProgress?.booleanValue) == true) {
                            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is in progress.")
                        } else if ((model.UserDayData[index].mapValue!.fields.isComplete?.booleanValue) == true) {
                            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is complete.")
                        } else {
                            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is ready to begin.")
                        }
                        modularLarge.body2TextProvider = CLKSimpleTextProvider(text: times)
                                
                        let template = modularLarge
                        let timelineEntry = CLKComplicationTimelineEntry(date: time!, complicationTemplate: template)
                        print("Here: \(model.UserDayData[index].mapValue!.fields.title.stringValue) :: \(time!)")
                        timeLineEntries.append(timelineEntry)
                    }
                }
            }
            handler(timeLineEntries)
        } else {
            handler(nil)
        }
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        if complication.family == .graphicRectangular{
            let graphicRectangular = CLKComplicationTemplateGraphicRectangularTextGauge()
            graphicRectangular.headerTextProvider = CLKSimpleTextProvider(text: "Goal")
            graphicRectangular.body1TextProvider = CLKSimpleTextProvider(text: "Time - Time")
            graphicRectangular.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColors: [UIColor.green], gaugeColorLocations: nil, fillFraction: Float())
            handler(graphicRectangular)
        } else if complication.family == .modularLarge{
            let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
            modularLarge.headerTextProvider = CLKSimpleTextProvider(text: "Goal/Routine")
            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "Status")
            modularLarge.body2TextProvider = CLKSimpleTextProvider(text: "Time - Time")
            handler(modularLarge)
        }
        else {
            handler(nil)
        }
    }

}

