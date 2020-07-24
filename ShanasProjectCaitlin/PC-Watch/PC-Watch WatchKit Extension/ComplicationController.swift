//
//  ComplicationController.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 6/27/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
        
    let model = FirebaseGoogleService.shared
    
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
        // Call the handler with the current timeline entry
        if complication.family == .graphicRectangular {
            var counter = 0
            if let data = model.data {
                while ((counter<data.count-1) && !(model.data![counter].mapValue!.fields.isDisplayedToday.booleanValue)){
                    print("counter")
                    counter = counter+1
                }
                let percentage: Float = 25/60

                let time = timeLeft.date(from: model.data![counter].mapValue!.fields.startDayAndTime.stringValue)
                let times = formatter.string(from: timeLeft.date(from: model.data![counter].mapValue!.fields.startDayAndTime.stringValue)!)  + " - " + formatter.string(from: timeLeft.date(from: model.data![counter].mapValue!.fields.endDayAndTime.stringValue)!)//.fontWeight(.light).font(.system(size: 15)
                let timeString = formatter.string(from: time!)
                let scheduledDate = formatter.date(from: timeString)

                let graphicRectangular = CLKComplicationTemplateGraphicRectangularTextGauge()
                graphicRectangular.headerTextProvider = CLKSimpleTextProvider(text: model.data![counter].mapValue!.fields.title.stringValue)

                graphicRectangular.body1TextProvider = CLKSimpleTextProvider(text: times)

                graphicRectangular.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColors: [UIColor.green], gaugeColorLocations: nil, fillFraction: percentage)

                let template = graphicRectangular
                let timelineEntry = CLKComplicationTimelineEntry(date: scheduledDate!, complicationTemplate: template)
                print("Here: \(model.data![counter].mapValue!.fields.title.stringValue) :: \(scheduledDate!)")

                handler(timelineEntry)
            }
        } else if complication.family == .modularLarge {
            var counter = 0
            if let data = model.data {
                while ((counter<data.count-1) && !(model.data![counter].mapValue!.fields.isDisplayedToday.booleanValue)){
                    print("counter")
                    counter = counter+1
                }
                let time = timeLeft.date(from: model.data![counter].mapValue!.fields.startDayAndTime.stringValue)
                let times = formatter.string(from: timeLeft.date(from: model.data![counter].mapValue!.fields.startDayAndTime.stringValue)!)  + " - " + formatter.string(from: timeLeft.date(from: model.data![counter].mapValue!.fields.endDayAndTime.stringValue)!)//.fontWeight(.light).font(.system(size: 15)
                let timeString = formatter.string(from: time!)
                let scheduledDate = formatter.date(from: timeString)
                   
                
                let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
                modularLarge.headerTextProvider = CLKSimpleTextProvider(text: model.data![counter].mapValue!.fields.title.stringValue)
                if ((model.data![counter].mapValue!.fields.isInProgress?.booleanValue) != nil) {
                    modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is in progress.")
                } else if ((model.data![counter].mapValue!.fields.isComplete?.booleanValue) != nil) {
                    modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is complete.")
                } else {
                    modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is ready to begin.")
                }
                modularLarge.body2TextProvider = CLKSimpleTextProvider(text: times)
                        
                let template = modularLarge
                let timelineEntry = CLKComplicationTimelineEntry(date: scheduledDate!, complicationTemplate: template)
                print("Here: \(model.data![counter].mapValue!.fields.title.stringValue) :: \(scheduledDate!)")
                
                handler(timelineEntry)
            }
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        
        print("getTimelineEntries")
        
        
        if complication.family == .graphicRectangular {
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            if (model.data != nil) {
                for index in 1...(model.data!.count-1) {
                    if model.data![index].mapValue!.fields.isDisplayedToday.booleanValue {
                    
                        let percentage: Float = 25/60
                        let time = timeLeft.date(from: model.data![index].mapValue!.fields.startDayAndTime.stringValue)
                        //let times = formatter.string(from: timeLeft.date(from: model.data![index].mapValue.fields.startDayAndTime.stringValue)!)  + " - " + formatter.string(from: timeLeft.date(from: model.data![index].mapValue.fields.endDayAndTime.stringValue)!)//.fontWeight(.light).font(.system(size: 15)
                        let timeString = formatter.string(from: time!)
                        let scheduledDate = formatter.date(from: timeString)
                        
                        let graphicRectangular = CLKComplicationTemplateGraphicRectangularTextGauge()
                        graphicRectangular.headerTextProvider = CLKSimpleTextProvider(text: model.data![index].mapValue!.fields.title.stringValue)
                                   
                        graphicRectangular.body1TextProvider = CLKSimpleTextProvider(text: formatter.string(from: time!))
                                   
                        graphicRectangular.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColors: [UIColor.green], gaugeColorLocations: nil, fillFraction: percentage)
                                   
                        let template = graphicRectangular
                        let timelineEntry = CLKComplicationTimelineEntry(date: scheduledDate!, complicationTemplate: template)
                        print("Here: \(model.data![index].mapValue!.fields.title.stringValue) :: \(scheduledDate!)")
                        timeLineEntries.append(timelineEntry)
                    }
                }
            }
            handler(timeLineEntries)
        } else if complication.family == .modularLarge {
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            if (model.data != nil) {
                for index in 1...(model.data!.count-1) {
                    if model.data![index].mapValue!.fields.isDisplayedToday.booleanValue {
                        let time = timeLeft.date(from: model.data![index].mapValue!.fields.startDayAndTime.stringValue)
                        let times = formatter.string(from: timeLeft.date(from: model.data![index].mapValue!.fields.startDayAndTime.stringValue)!)  + " - " + formatter.string(from: timeLeft.date(from: model.data![index].mapValue!.fields.endDayAndTime.stringValue)!)//.fontWeight(.light).font(.system(size: 15)
                        let timeString = formatter.string(from: time!)
                        let scheduledDate = formatter.date(from: timeString)
                        
                        let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
                        modularLarge.headerTextProvider = CLKSimpleTextProvider(text: model.data![index].mapValue!.fields.title.stringValue)
                        if ((model.data![index].mapValue!.fields.isInProgress?.booleanValue) != nil) {
                            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is in progress.")
                        } else if ((model.data![index].mapValue!.fields.isComplete?.booleanValue) != nil) {
                            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is complete.")
                        } else {
                            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is ready to begin.")
                        }
                        modularLarge.body2TextProvider = CLKSimpleTextProvider(text: times)
                                
                        let template = modularLarge
                        let timelineEntry = CLKComplicationTimelineEntry(date: scheduledDate!, complicationTemplate: template)
                        print("Here: \(model.data![index].mapValue!.fields.title.stringValue) :: \(scheduledDate!)")
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

