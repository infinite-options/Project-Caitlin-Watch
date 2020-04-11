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
    var googleAuthToken, googleRefreshToken, lastName, firstName: FirstName
    var aboutMe: AboutMe

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
    var fields: PurpleFields
}

// MARK: - PurpleFields
struct PurpleFields: Codable {
    var havePic: HavePic
    var pic, messageDay, messageCard: FirstName
    var importantPeople: ImportantPeople

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
    var values: [PurpleValue]
}

// MARK: - PurpleValue
struct PurpleValue: Codable {
    var referenceValue: String
}

// MARK: - FirstName
struct FirstName: Codable {
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
    var fields: FluffyFields
}

// MARK: - FluffyFields
struct FluffyFields: Codable {
    var photo: FirstName
    var isAvailable, isComplete, isSublistAvailable: HavePic
    var availableStartTime: FirstName
    var isPersistent: HavePic
    var datetimeCompleted: FirstName?
    var expectedCompletionTime: FirstName
    var isTimed, isInProgress: HavePic?
    var datetimeStarted, audio: FirstName?
    var availableEndTime: FirstName
    var userNotifications: Notifications
    var id: FirstName
    var tags: Tags?
    var title: FirstName
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
    var fields: TentacledFields
}

// MARK: - TentacledFields
struct TentacledFields: Codable {
    var during, after, before: After
}

// MARK: - After
struct After: Codable {
    var mapValue: AfterMapValue
}

// MARK: - AfterMapValue
struct AfterMapValue: Codable {
    var fields: StickyFields
}

// MARK: - StickyFields
struct StickyFields: Codable {
    var isEnabled: HavePic
    var time, message: FirstName
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
    var values: [FirstName]
}
