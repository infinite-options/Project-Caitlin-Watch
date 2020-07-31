//
//  StartCompleteGRATISModel.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 7/24/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation

struct startGRATISbody: Codable {
    var data: Fields
}

struct Fields: Codable {
    var userId: String
    var routineId: String
    var taskId: String?
    var routineNumber: Int?
    var taskNumber: Int?
    var stepNumber: Int?
}

struct cloudFuncResp: Decodable {
    var result: Int
}
struct completeGRATISbody: Codable {
       var data: CompleteFields
   }
   
struct CompleteFields: Codable {
    var userId: String
    var routineId: String
    var taskId: String?
    var routineNumber: Int?
    var taskNumber: Int?
    var stepNumber: Int?
}




