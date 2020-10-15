// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let taskAndActions = try? newJSONDecoder().decode(TaskAndActions.self, from: jsonData)

import Foundation

// MARK: - TaskAndActions
struct TaskAndActionsResponse: Codable {
    var result: [TaskAndActions]
    var message: String
}

// MARK: - Result
struct TaskAndActions: Codable {
    var atUniqueID, atTitle, goalRoutineID: String
    var atSequence: Int
    var isAvailable, isComplete, isInProgress, isSublistAvailable: String
    var isMustDo: String
    var photo: String
    var isTimed, datetimeCompleted, datetimeStarted, expectedCompletionTime: String
    var availableStartTime, availableEndTime: String?

    enum CodingKeys: String, CodingKey {
        case atUniqueID = "at_unique_id"
        case atTitle = "at_title"
        case goalRoutineID = "goal_routine_id"
        case atSequence = "at_sequence"
        case isAvailable = "is_available"
        case isComplete = "is_complete"
        case isInProgress = "is_in_progress"
        case isSublistAvailable = "is_sublist_available"
        case isMustDo = "is_must_do"
        case photo
        case isTimed = "is_timed"
        case datetimeCompleted = "datetime_completed"
        case datetimeStarted = "datetime_started"
        case expectedCompletionTime = "expected_completion_time"
        case availableStartTime = "available_start_time"
        case availableEndTime = "available_end_time"
    }
}
