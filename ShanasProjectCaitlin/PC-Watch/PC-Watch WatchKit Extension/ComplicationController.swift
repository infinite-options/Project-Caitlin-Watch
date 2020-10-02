//
//  ComplicationController.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 6/27/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
        
    let model = UserManager.shared

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
                    var time = DayDateObj.goalStartUTC.date(from: userDay[0].mapValue!.fields.startDayAndTime.stringValue)
                    
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
        } else if complication.family == .graphicRectangular {
            let userDay = model.UserDayData
            if userDay.count > 0 {
                print("Date ", Date())
                if userDay[0] is Event {
                    let start = userDay[0].start!.dateTime
                    let end = userDay[0].end!.dateTime
                    
                    let time = DayDateObj.ISOFormatter.date(from: userDay[0].start!.dateTime)
                    let startTime = DayDateObj.formatter.string(from: DayDateObj.ISOFormatter.date(from: start)!)
                    
                    let endTime = DayDateObj.formatter.string(from: DayDateObj.ISOFormatter.date(from: end)!)
                    
                    let graphicRectangular = CLKComplicationTemplateGraphicRectangularStandardBody()
                    graphicRectangular.headerTextProvider = CLKSimpleTextProvider(text: userDay[0].summary!)
                    graphicRectangular.body1TextProvider = CLKSimpleTextProvider(text: "Starts at " +  startTime)
                    graphicRectangular.body2TextProvider = CLKSimpleTextProvider(text: "Ends at " + endTime)
                            
                    let template = graphicRectangular
                    let timelineEntry = CLKComplicationTimelineEntry(date: time!, complicationTemplate: template)
                    print("Here: \(userDay[0].summary!) :: \(time!)")
                    
                    handler(timelineEntry)
                } else {
                    var time = DayDateObj.goalStartUTC.date(from: userDay[0].mapValue!.fields.startDayAndTime.stringValue)
                    
                    let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time!)
                    
                    var currentDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
                    
                    currentDate.hour = dateComponents.hour
                    currentDate.minute = dateComponents.minute
                    currentDate.second = dateComponents.second
                    
                    time = Calendar.current.date(from: currentDate)
                    
                    let times = DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: userDay[0].mapValue!.fields.startDayAndTime.stringValue)!)  + " - " + DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: userDay[0].mapValue!.fields.endDayAndTime.stringValue)!)
                       
                    let graphicRectangular = CLKComplicationTemplateGraphicRectangularStandardBody()
                    graphicRectangular.headerTextProvider = CLKSimpleTextProvider(text: userDay[0].mapValue!.fields.title.stringValue)
                    if ((userDay[0].mapValue!.fields.isInProgress?.booleanValue) == true) {
                        graphicRectangular.body1TextProvider = CLKSimpleTextProvider(text: "is in progress.")
                    } else if ((userDay[0].mapValue!.fields.isComplete?.booleanValue) == true) {
                        graphicRectangular.body1TextProvider = CLKSimpleTextProvider(text: "is complete.")
                    } else {
                        graphicRectangular.body1TextProvider = CLKSimpleTextProvider(text: "is ready to begin.")
                    }
                    graphicRectangular.body2TextProvider = CLKSimpleTextProvider(text: times)
                            
                    let template = graphicRectangular
                    let timelineEntry = CLKComplicationTimelineEntry(date: time!, complicationTemplate: template)
                    print("Here: \(userDay[0].mapValue!.fields.title.stringValue) :: \(time!)")
                    
                    handler(timelineEntry)
                }
            } else {
                handler(nil)
            }
        } else if complication.family == .circularSmall {
            let circularSmall = CLKComplicationTemplateCircularSmallSimpleImage()
            circularSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Circular")!)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: circularSmall)
            handler(timelineEntry)
        } else if complication.family == .graphicCircular {
            let graphicCircular = CLKComplicationTemplateGraphicCircularImage()
            graphicCircular.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: graphicCircular)
            handler(timelineEntry)
        } else if complication.family == .modularSmall {
            let modularSmall = CLKComplicationTemplateModularSmallSimpleImage()
            modularSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: modularSmall)
            handler(timelineEntry)
        } else if complication.family == .utilitarianSmall {
            let utilitarianSmall = CLKComplicationTemplateUtilitarianSmallSquare()
            utilitarianSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Utilitarian")!)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: utilitarianSmall)
            handler(timelineEntry)
        } else if complication.family == .extraLarge {
            let extraLarge = CLKComplicationTemplateExtraLargeSimpleImage()
            extraLarge.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Extra Large")!)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: extraLarge)
            handler(timelineEntry)
        } else if complication.family == .graphicCorner {
            let graphicCorner = CLKComplicationTemplateGraphicCornerCircularImage()
            graphicCorner.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Corner")!)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: graphicCorner)
            handler(timelineEntry)
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
                        var time: Date
                        if index == 0 {
                            time = DayDateObj.ISOFormatter.date(from: userDay[index].start!.dateTime)!
                        } else {
                            if userDay[index - 1] is Event {
                                time = DayDateObj.ISOFormatter.date(from: userDay[index - 1].end!.dateTime)!
                            } else {
                                time = DayDateObj.goalStartUTC.date(from: userDay[index - 1].mapValue!.fields.endDayAndTime.stringValue)!
                            }
                        }
                        
                        let start = userDay[index].start!.dateTime
                        let end = userDay[index].end!.dateTime
                        
                        let startTime = DayDateObj.formatter.string(from: DayDateObj.ISOFormatter.date(from: start)!)
                        
                        let endTime = DayDateObj.formatter.string(from: DayDateObj.ISOFormatter.date(from: end)!)
                        
                        
                        let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
                        modularLarge.headerTextProvider = CLKSimpleTextProvider(text: userDay[index].summary!)
                        modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "Starts at " +  startTime)
                        modularLarge.body2TextProvider = CLKSimpleTextProvider(text: "Ends at " + endTime)
                                
                        let template = modularLarge
                        let timelineEntry = CLKComplicationTimelineEntry(date: time, complicationTemplate: template)
                        
                        print("Here: \(userDay[index].summary!) :: \(time)")
                        timeLineEntries.append(timelineEntry)
                    } else {
                        var time: Date
                        if index == 0 {
                            time = DayDateObj.goalStartUTC.date(from: userDay[index].mapValue!.fields.startDayAndTime.stringValue)!
                        } else {
                            if userDay[index - 1] is Event {
                                time = DayDateObj.ISOFormatter.date(from: userDay[index - 1].end!.dateTime)!
                            } else {
                                time = DayDateObj.goalStartUTC.date(from: userDay[index - 1].mapValue!.fields.endDayAndTime.stringValue)!
                            }
                        }
                        
                        //var time = DayDateObj.goalStartUTC.date(from: starts)
                        
                        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time)
                        
                        var currentDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
                        
                        currentDate.hour = dateComponents.hour
                        currentDate.minute = dateComponents.minute
                        currentDate.second = dateComponents.second
                        
                        time = Calendar.current.date(from: currentDate)!
                        
                        let times = DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: userDay[index].mapValue!.fields.startDayAndTime.stringValue)!)  + " - " + DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: userDay[index].mapValue!.fields.endDayAndTime.stringValue)!)
                        
                        let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
                        modularLarge.headerTextProvider = CLKSimpleTextProvider(text: userDay[index].mapValue!.fields.title.stringValue)
                        if ((userDay[index].mapValue!.fields.isInProgress?.booleanValue) == true) {
                            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is in progress.")
                        } else if ((userDay[index].mapValue!.fields.isComplete?.booleanValue) == true) {
                            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is complete.")
                        } else {
                            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "is ready to begin.")
                        }
                        modularLarge.body2TextProvider = CLKSimpleTextProvider(text: times)
                                
                        let template = modularLarge
                        let timelineEntry = CLKComplicationTimelineEntry(date: time, complicationTemplate: template)
                        print("Here: \(userDay[index].mapValue!.fields.title.stringValue) :: \(time)")
                        timeLineEntries.append(timelineEntry)
                    }
                }
            }
            handler(timeLineEntries)
        } else if complication.family == .graphicRectangular {
            let userDay = model.UserDayData
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            if (userDay.count > 0) {
                for index in 0...(userDay.count-2) {
                    if userDay[index] is Event {
                        var time: Date
                        if index == 0 {
                            time = DayDateObj.ISOFormatter.date(from: userDay[index].start!.dateTime)!
                        } else {
                            if userDay[index - 1] is Event {
                                time = DayDateObj.ISOFormatter.date(from: userDay[index - 1].end!.dateTime)!
                            } else {
                                time = DayDateObj.goalStartUTC.date(from: userDay[index - 1].mapValue!.fields.endDayAndTime.stringValue)!
                            }
                        }
                        
                        let start = userDay[index].start!.dateTime
                        let end = userDay[index].end!.dateTime
                        
                        let startTime = DayDateObj.formatter.string(from: DayDateObj.ISOFormatter.date(from: start)!)
                        
                        let endTime = DayDateObj.formatter.string(from: DayDateObj.ISOFormatter.date(from: end)!)
                        
                        
                        let graphicRectangular = CLKComplicationTemplateGraphicRectangularStandardBody()
                        graphicRectangular.headerTextProvider = CLKSimpleTextProvider(text: userDay[index].summary!)
                        graphicRectangular.body1TextProvider = CLKSimpleTextProvider(text: "Starts at " +  startTime)
                        graphicRectangular.body2TextProvider = CLKSimpleTextProvider(text: "Ends at " + endTime)
                                
                        let template = graphicRectangular
                        let timelineEntry = CLKComplicationTimelineEntry(date: time, complicationTemplate: template)
                        
                        print("Here: \(userDay[index].summary!) :: \(time)")
                        timeLineEntries.append(timelineEntry)
                    } else {
                        var time: Date
                        if index == 0 {
                            time = DayDateObj.goalStartUTC.date(from: userDay[index].mapValue!.fields.startDayAndTime.stringValue)!
                        } else {
                            if userDay[index - 1] is Event {
                                time = DayDateObj.ISOFormatter.date(from: userDay[index - 1].end!.dateTime)!
                            } else {
                                time = DayDateObj.goalStartUTC.date(from: userDay[index - 1].mapValue!.fields.endDayAndTime.stringValue)!
                            }
                        }
                        
                        //var time = DayDateObj.goalStartUTC.date(from: starts)
                        
                        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time)
                        
                        var currentDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
                        
                        currentDate.hour = dateComponents.hour
                        currentDate.minute = dateComponents.minute
                        currentDate.second = dateComponents.second
                        
                        time = Calendar.current.date(from: currentDate)!
                        
                        let times = DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: userDay[index].mapValue!.fields.startDayAndTime.stringValue)!)  + " - " + DayDateObj.formatter.string(from: DayDateObj.timeLeft.date(from: userDay[index].mapValue!.fields.endDayAndTime.stringValue)!)
                        
                        let graphicRectangular = CLKComplicationTemplateGraphicRectangularStandardBody()
                        graphicRectangular.headerTextProvider = CLKSimpleTextProvider(text: userDay[index].mapValue!.fields.title.stringValue)
                        if ((userDay[index].mapValue!.fields.isInProgress?.booleanValue) == true) {
                            graphicRectangular.body1TextProvider = CLKSimpleTextProvider(text: "is in progress.")
                        } else if ((userDay[index].mapValue!.fields.isComplete?.booleanValue) == true) {
                            graphicRectangular.body1TextProvider = CLKSimpleTextProvider(text: "is complete.")
                        } else {
                            graphicRectangular.body1TextProvider = CLKSimpleTextProvider(text: "is ready to begin.")
                        }
                        graphicRectangular.body2TextProvider = CLKSimpleTextProvider(text: times)
                                
                        let template = graphicRectangular
                        let timelineEntry = CLKComplicationTimelineEntry(date: time, complicationTemplate: template)
                        print("Here: \(userDay[index].mapValue!.fields.title.stringValue) :: \(time)")
                        timeLineEntries.append(timelineEntry)
                    }
                }
            }
            handler(timeLineEntries)
        } else if complication.family == .circularSmall {
            let circularSmall = CLKComplicationTemplateCircularSmallSimpleImage()
            circularSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Circular")!)
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: circularSmall)
            timeLineEntries.append(timelineEntry)
            handler(timeLineEntries)
        } else if complication.family == .graphicCircular {
            let graphicCircular = CLKComplicationTemplateGraphicCircularImage()
            graphicCircular.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!)
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: graphicCircular)
            timeLineEntries.append(timelineEntry)
            handler(timeLineEntries)
        } else if complication.family == .modularSmall {
            let modularSmall = CLKComplicationTemplateModularSmallSimpleImage()
            modularSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!)
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: modularSmall)
            timeLineEntries.append(timelineEntry)
            handler(timeLineEntries)
        } else if complication.family == .utilitarianSmall {
            let utilitarianSmall = CLKComplicationTemplateUtilitarianSmallSquare()
            utilitarianSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Utilitarian")!)
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: utilitarianSmall)
            timeLineEntries.append(timelineEntry)
            handler(timeLineEntries)
        } else if complication.family == .extraLarge {
            let extraLarge = CLKComplicationTemplateExtraLargeSimpleImage()
            extraLarge.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Extra Large")!)
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: extraLarge)
            timeLineEntries.append(timelineEntry)
            handler(timeLineEntries)
        } else if complication.family == .graphicCorner {
            let graphicCorner = CLKComplicationTemplateGraphicCornerCircularImage()
            graphicCorner.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Corner")!)
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: graphicCorner)
            timeLineEntries.append(timelineEntry)
            handler(timeLineEntries)
        } else {
            handler(nil)
        }
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        if complication.family == .modularLarge{
            let modularLarge = CLKComplicationTemplateModularLargeStandardBody()
            modularLarge.headerTextProvider = CLKSimpleTextProvider(text: "Goal/Routine")
            modularLarge.body1TextProvider = CLKSimpleTextProvider(text: "Status")
            modularLarge.body2TextProvider = CLKSimpleTextProvider(text: "Time - Time")
            handler(modularLarge)
        } else if complication.family == .graphicRectangular {
            let graphicRectangular = CLKComplicationTemplateGraphicRectangularStandardBody()
            graphicRectangular.headerTextProvider = CLKSimpleTextProvider(text: "Goal/Routine")
            graphicRectangular.body1TextProvider = CLKSimpleTextProvider(text: "Status")
            graphicRectangular.body2TextProvider = CLKSimpleTextProvider(text: "Time - Time")
            handler(graphicRectangular)
        } else if complication.family == .circularSmall {
            let circularSmall = CLKComplicationTemplateCircularSmallSimpleImage()
            circularSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Circular")!)
            handler(circularSmall)
        } else if complication.family == .graphicCircular {
            let graphicCircular = CLKComplicationTemplateGraphicCircularImage()
            graphicCircular.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!)
            handler(graphicCircular)
        } else if complication.family == .modularSmall {
            let modularSmall = CLKComplicationTemplateModularSmallSimpleImage()
            modularSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!)
            handler(modularSmall)
        } else if complication.family == .utilitarianSmall {
            let utilitarianSmall = CLKComplicationTemplateUtilitarianSmallSquare()
            utilitarianSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Utilitarian")!)
            handler(utilitarianSmall)
        } else if complication.family == .extraLarge {
            let extraLarge = CLKComplicationTemplateExtraLargeSimpleImage()
            extraLarge.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Extra Large")!)
            handler(extraLarge)
        } else if complication.family == .graphicCorner {
            let graphicCorner = CLKComplicationTemplateGraphicCornerCircularImage()
            graphicCorner.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!)
            handler(graphicCorner)
        } else {
            handler(nil)
        }
    }

}

