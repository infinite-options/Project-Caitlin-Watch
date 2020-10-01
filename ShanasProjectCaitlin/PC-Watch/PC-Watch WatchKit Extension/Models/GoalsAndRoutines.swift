//
//  GoalsAndRoutines.swift
//  PC-Watch WatchKit Extension
//
//  Created by Radomyr Bezghin on 9/28/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation

// MARK: - GoalsandRoutine

struct GoalsAndRoutinesResponse: Codable {
    let message: String
    let result: [GoalRoutine]
}
struct GoalRoutine: Codable {
    let grUniqueID, grTitle, userID, isAvailable: String
    let isComplete, isInProgress, isDisplayedToday, isPersistent: String
    let isSublistAvailable, isTimed: String
    let photo: String
    let startDayAndTime, endDayAndTime, resultRepeat, repeatType: String
    let repeatEndsOn: String
    let repeatOccurences, repeatEvery: Int
    let repeatFrequency, repeatWeekDays, datetimeStarted, datetimeCompleted: String
    let expectedCompletionTime: String

    enum CodingKeys: String, CodingKey {
        case grUniqueID = "gr_unique_id"
        case grTitle = "gr_title"
        case userID = "user_id"
        case isAvailable = "is_available"
        case isComplete = "is_complete"
        case isInProgress = "is_in_progress"
        case isDisplayedToday = "is_displayed_today"
        case isPersistent = "is_persistent"
        case isSublistAvailable = "is_sublist_available"
        case isTimed = "is_timed"
        case photo
        case startDayAndTime = "start_day_and_time"
        case endDayAndTime = "end_day_and_time"
        case resultRepeat = "repeat"
        case repeatType = "repeat_type"
        case repeatEndsOn = "repeat_ends_on"
        case repeatOccurences = "repeat_occurences"
        case repeatEvery = "repeat_every"
        case repeatFrequency = "repeat_frequency"
        case repeatWeekDays = "repeat_week_days"
        case datetimeStarted = "datetime_started"
        case datetimeCompleted = "datetime_completed"
        case expectedCompletionTime = "expected_completion_time"
    }
}
