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
    
    let timeLeft: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        formatter.timeZone = .current
        print(formatter.timeZone!)
        return formatter
    }()

    let formatter: DateFormatter = {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "h:mm a"
        return formatter1
    }()
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
        if complication.family == .modularLarge {
            let userDay = model.UserDayData
            if userDay.count > 0 {
                let counter = userDay.count - 1
                if userDay[counter] is Event {
                    let start = userDay[counter].start!.dateTime
                    let end = userDay[counter].end!.dateTime
                    
                    let time = ISO8601DateFormatter().date(from: userDay[counter].start!.dateTime)
                    let timeString = formatter.string(from: time!)
                    let scheduledDate = formatter.date(from: timeString)
                    
                    let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
                    modularLarge.headerTextProvider = CLKSimpleTextProvider(text: userDay[counter].summary!)
                    modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "Starts at " +  start)
                    modularLarge.body2TextProvider = CLKSimpleTextProvider(text: "Ends at " + end)
                            
                    let template = modularLarge
                    let timelineEntry = CLKComplicationTimelineEntry(date: scheduledDate!, complicationTemplate: template)
                    print("Here: \(userDay[counter].summary!) :: \(scheduledDate!)")
                    
                    handler(timelineEntry)
                } else {
                    let time = timeLeft.date(from: userDay[counter].mapValue!.fields.startDayAndTime.stringValue)
                    let times = formatter.string(from: timeLeft.date(from: userDay[counter].mapValue!.fields.startDayAndTime.stringValue)!)  + " - " + formatter.string(from: timeLeft.date(from: userDay[counter].mapValue!.fields.endDayAndTime.stringValue)!)
                    let timeString = formatter.string(from: time!)
                    let scheduledDate = formatter.date(from: timeString)
                       
                    
                    let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
                    modularLarge.headerTextProvider = CLKSimpleTextProvider(text: userDay[counter].mapValue!.fields.title.stringValue)
                    if ((userDay[counter].mapValue!.fields.isInProgress?.booleanValue) != nil) {
                        modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is in progress.")
                    } else if ((userDay[counter].mapValue!.fields.isComplete?.booleanValue) != nil) {
                        modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is complete.")
                    } else {
                        modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is ready to begin.")
                    }
                    modularLarge.body2TextProvider = CLKSimpleTextProvider(text: times)
                            
                    let template = modularLarge
                    let timelineEntry = CLKComplicationTimelineEntry(date: scheduledDate!, complicationTemplate: template)
                    print("Here: \(userDay[counter].mapValue!.fields.title.stringValue) :: \(scheduledDate!)")
                    
                    handler(timelineEntry)
                }
            }
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        
        print("getTimelineEntries")
        
        if complication.family == .modularLarge {
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            if (model.UserDayData.count > 0) {
                for index in 0...(model.UserDayData.count-2) {
                    if model.UserDayData[index] is Event {
                        let start = model.UserDayData[index].start!.dateTime
                        let end = model.UserDayData[index].end!.dateTime
                        
                        let time = ISO8601DateFormatter().date(from: model.UserDayData[index].start!.dateTime)
                        let timeString = formatter.string(from: time!)
                        let scheduledDate = formatter.date(from: timeString)
                        
                        let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
                        modularLarge.headerTextProvider = CLKSimpleTextProvider(text: model.UserDayData[index].summary!)
                        modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "Starts at " +  start)
                        modularLarge.body2TextProvider = CLKSimpleTextProvider(text: "Ends at " + end)
                                
                        let template = modularLarge
                        let timelineEntry = CLKComplicationTimelineEntry(date: scheduledDate!, complicationTemplate: template)
                        print("Here: \(model.UserDayData[index].summary!) :: \(scheduledDate!)")
                        timeLineEntries.append(timelineEntry)
                    } else {
                        let time = timeLeft.date(from: model.UserDayData[index].mapValue!.fields.startDayAndTime.stringValue)
                        let times = formatter.string(from: timeLeft.date(from: model.UserDayData[index].mapValue!.fields.startDayAndTime.stringValue)!)  + " - " + formatter.string(from: timeLeft.date(from: model.UserDayData[index].mapValue!.fields.endDayAndTime.stringValue)!)
                        let timeString = formatter.string(from: time!)
                        let scheduledDate = formatter.date(from: timeString)
                        
                        let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
                        modularLarge.headerTextProvider = CLKSimpleTextProvider(text: model.UserDayData[index].mapValue!.fields.title.stringValue)
                        if ((model.UserDayData[index].mapValue!.fields.isInProgress?.booleanValue) != nil) {
                            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is in progress.")
                        } else if ((model.UserDayData[index].mapValue!.fields.isComplete?.booleanValue) != nil) {
                            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is complete.")
                        } else {
                            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is ready to begin.")
                        }
                        modularLarge.body2TextProvider = CLKSimpleTextProvider(text: times)
                                
                        let template = modularLarge
                        let timelineEntry = CLKComplicationTimelineEntry(date: scheduledDate!, complicationTemplate: template)
                        print("Here: \(model.UserDayData[index].mapValue!.fields.title.stringValue) :: \(scheduledDate!)")
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

