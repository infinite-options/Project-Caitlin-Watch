import Foundation

// MARK: - GoalsandRoutine
struct GoalsAndRoutinesResponse: Codable {
    var message: String
    var result: [GoalRoutine]
}

// MARK: - Result
struct GoalRoutine: Codable {
    var grUniqueID, grTitle, userID, isAvailable: String
    var isComplete, isInProgress, isDisplayedToday, isPersistent: String
    var isSublistAvailable, isTimed: String
    var photo: String
    var startDayAndTime, endDayAndTime: String
    var datetimeStarted, datetimeCompleted: String
    var expectedCompletionTime: String

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
        case datetimeStarted = "datetime_started"
        case datetimeCompleted = "datetime_completed"
        case expectedCompletionTime = "expected_completion_time"
    }
}
