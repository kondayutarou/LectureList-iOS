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
    case fetchLectureList
    case didReceiveLectureList(response: [LectureListAPIResponseItem])
    case didReceiveError(_ error: Error)
    case fetchLectureProgress(courseID: String)
    case didReceiveLectureProgress(response: LectureProgressAPIResponse)
}
