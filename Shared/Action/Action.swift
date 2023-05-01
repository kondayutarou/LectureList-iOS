//
//  Action.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/04/30.
//

import Foundation

enum Action {
    case lecture(LectureAction)
}

enum LectureAction {
    /// Database
    case fetchLectureList
    /// Server
    case didReceiveLectureList(response: [LectureListAPIResponseItem])
    /// Server
    case didReceiveError(_ error: Error)
    /// Server
    case fetchLectureProgress(courseID: String)
    /// Server
    case didReceiveLectureProgress(response: LectureProgressAPIResponse)
    /// Database
    case didReceiveLectureListFromDB(lectures: [Lecture])
}
