//
//  Lecture.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/04/30.
//

import Foundation

struct Lecture: Identifiable {
    let id: String
    let name: String
    let iconURL: String
    let numberOfTopics: Int
    let teacherName: String
    let timeStamp: Int
    var progreess: Int?
}
