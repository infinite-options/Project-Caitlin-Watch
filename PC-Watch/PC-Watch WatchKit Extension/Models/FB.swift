//
//  FB.swift
//  WatchLandmarks Extension
//
//  Created by Kyle Hoefer on 3/25/20.
//  Copyright © 2020 Apple. All rights reserved.
//

//   let firebase = try? newJSONDecoder().decode(Firebase.self, from: jsonData)

import Foundation

// MARK: - Firebase
struct Firebase: Codable {
    var name: String
    var fields: FirebaseFields
    var createTime, updateTime: String
}

// MARK: - FirebaseFields
struct FirebaseFields: Codable {
    var goalsRoutines: GoalsRoutines
    var googleAuthToken, googleRefreshToken, lastName, firstName: stringValue
    var aboutMe: AboutMe?

    enum CodingKeys: String, CodingKey {
        case goalsRoutines = "goals&routines"
        case googleAuthToken = "google_auth_token"
        case googleRefreshToken = "google_refresh_token"
        case lastName = "last_name"
        case firstName = "first_name"
        case aboutMe = "about_me"
    }
}

// MARK: - AboutMe
struct AboutMe: Codable {
    var mapValue: AboutMeMapValue
}

// MARK: - AboutMeMapValue
struct AboutMeMapValue: Codable {
    var fields: AboutMeMapFields
}

// MARK: - AboutMeMapFields
struct AboutMeMapFields: Codable {
    var havePic: HavePic
    var pic, messageDay, messageCard: stringValue
    var importantPeople: ImportantPeople?

    enum CodingKeys: String, CodingKey {
        case havePic = "have_pic"
        case pic
        case messageDay = "message_day"
        case messageCard = "message_card"
        case importantPeople = "important_people"
    }
}

// MARK: - HavePic
struct HavePic: Codable {
    var booleanValue: Bool
}

// MARK: - ImportantPeople
struct ImportantPeople: Codable {
    var arrayValue: ImportantPeopleArrayValue
}

// MARK: - ImportantPeopleArrayValue
struct ImportantPeopleArrayValue: Codable {
    var values: [referenceValue]
}

// MARK: - referenceValue
struct referenceValue: Codable {
    var referenceValue: String
}

// MARK: - stringValue
struct stringValue: Codable {
    var stringValue: String
}

// MARK: - GoalsRoutines
struct GoalsRoutines: Codable {
    var arrayValue: GoalsRoutinesArrayValue
}

// MARK: - GoalsRoutinesArrayValue
struct GoalsRoutinesArrayValue: Codable {
    var values: [Value]
}

// MARK: - FluffyValue
struct Value: Codable {
    var mapValue: ValueMapValue
}

// MARK: - ValueMapValue
struct ValueMapValue: Codable {
    var fields: GRFields
}

// MARK: - FluffyFields
struct GRFields: Codable {
    var photo: stringValue
    var isAvailable, isComplete, isSublistAvailable: HavePic
    var availableStartTime: stringValue
    var isPersistent: HavePic
    var datetimeCompleted: stringValue?
    var expectedCompletionTime: stringValue
    var isTimed, isInProgress: HavePic?
    var datetimeStarted, audio: stringValue?
    var availableEndTime: stringValue
    var userNotifications: Notifications
    var id: stringValue
    var tags: Tags?
    var title: stringValue
    var taNotifications: Notifications
    var deleted: HavePic?

    enum CodingKeys: String, CodingKey {
        case photo
        case isAvailable = "is_available"
        case isComplete = "is_complete"
        case isSublistAvailable = "is_sublist_available"
        case availableStartTime = "available_start_time"
        case isPersistent = "is_persistent"
        case datetimeCompleted = "datetime_completed"
        case expectedCompletionTime = "expected_completion_time"
        case isTimed = "is_timed"
        case isInProgress = "is_in_progress"
        case datetimeStarted = "datetime_started"
        case audio
        case availableEndTime = "available_end_time"
        case userNotifications = "user_notifications"
        case id, tags, title
        case taNotifications = "ta_notifications"
        case deleted
    }
}

// MARK: - Notifications
struct Notifications: Codable {
    var mapValue: TaNotificationsMapValue
}

// MARK: - TaNotificationsMapValue
struct TaNotificationsMapValue: Codable {
    var fields: NotificationFields
}

// MARK: - NotificationState
struct NotificationFields: Codable {
    var during, after, before: NotificationMapKey
}

// MARK: - NotificationMap
struct NotificationMapKey: Codable {
    var mapValue: NotificationMapValue
}

// MARK: - NotificationFields
struct NotificationMapValue: Codable {
    var fields: NotificationMapFields
}

// MARK: - StickyFields
struct NotificationMapFields: Codable {
    var isEnabled: HavePic
    var time, message: stringValue
    var isSet: HavePic

    enum CodingKeys: String, CodingKey {
        case isEnabled = "is_enabled"
        case time, message
        case isSet = "is_set"
    }
}

// MARK: - Tags
struct Tags: Codable {
    var arrayValue: TagsArrayValue
}

// MARK: - TagsArrayValue
struct TagsArrayValue: Codable {
    var values: [stringValue]
}
