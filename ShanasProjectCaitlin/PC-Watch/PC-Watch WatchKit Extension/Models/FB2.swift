//
//  FB2.swift
//  PC-Watch WatchKit Extension
//
//  Created by Shana Duchin on 5/9/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let firebase = try? newJSONDecoder().decode(Firebase.self, from: jsonData)

import Foundation

// MARK: - Firebase2
struct Firebase2: Codable {
    
    struct Document: Codable {
        var name: String
        var fields: DocumentFields
        var createTime, updateTime: String
    }
    
    var documents: [Document]
    //var document: Document
}

// MARK: - Document


// MARK: - DocumentFields
struct DocumentFields: Codable {
    var dayEvent: DayEvent
}

// MARK: - DayEvent
struct DayEvent: Codable {
    var arrayValue: ArrayValue
}

// MARK: - ArrayValue
struct ArrayValue: Codable {
    var values: [Values]
}

// MARK: - Value
struct Values: Codable {
    var mapValue: MapValue
}

// MARK: - MapValue
struct MapValue: Codable {
    var fields: MapValueFields
}

// MARK: - MapValueFields
struct MapValueFields: Codable {
    var title: Title
    var isToday: IsToday
    var when: When
}

// MARK: - IsToday
struct IsToday: Codable {
    var booleanValue: Bool
}

// MARK: - Title
struct Title: Codable {
    var stringValue: String
}

// MARK: - When
struct When: Codable {
    var timestampValue: String
}

//// MARK: - Document
//struct Document: Codable {
//    var name: String
//    var fields: DocumentFields
//    var createTime, updateTime: String
//}
//
//// MARK: - DocumentFields
//struct DocumentFields: Codable {
//    var dayEvent: DayEvent
//
//    enum CodingKeys: String, CodingKey {
//        case dayEvent = "DayEvent"
//    }
//}
//
//// MARK: - DayEvent
//struct DayEvent: Codable {
//    var arrayValue: [Value]
//}
//
//// MARK: - Value
//struct DayValue: Codable {
//    var mapValue: MapValue
//}
//
//// MARK: - MapValue
//struct MapValue: Codable {
//    var fields: MapValueFields
//}
//
//// MARK: - MapValueFields
//struct MapValueFields: Codable {
//    var isToday: IsToday
//    var when: When
//    var title: Title
//}
//
//// MARK: - IsToday
//struct IsToday: Codable {
//    var booleanValue: Bool
//}
//
//// MARK: - Title
//struct Title: Codable {
//    var stringValue: String
//}
//
//// MARK: - When
//struct When: Codable {
//    var timestampValue: Date
//}
