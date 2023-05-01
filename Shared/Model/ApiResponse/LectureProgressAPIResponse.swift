//
//  LectureProgressAPIResponse.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/04/30.
//

import Foundation

struct LectureProgressAPIResponse: Decodable {
    let courseID: String
    let progress: Int
    
    enum CodingKeys: String, CodingKey {
        case courseID = "course_id"
        case progress
    }
}
