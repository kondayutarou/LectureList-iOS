//
//  LectureListAPIResponseItem.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/04/30.
//

import Foundation

typealias LectureListAPIResponse = [LectureListAPIResponseItem]

struct LectureListAPIResponseItem: Decodable {
    let id: String
    let name: String
    let iconURL: String
    let numberOfTopics: Int
    let teacherName: String
    let timeStamp: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case iconURL = "icon_url"
        case numberOfTopics = "number_of_topics"
        case teacherName = "teacher_name"
        case timeStamp = "last_attempted_ts"
    }
    
    func to() -> Lecture {
        Lecture(
            id: id,
            name: name,
            iconURL: iconURL,
            numberOfTopics: numberOfTopics,
            teacherName: teacherName,
            timeStamp: timeStamp
        )
    }
}
