//
//  LectureReducer.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/04/30.
//

import Foundation

func lectureReducer(_ state: LectureState, action: LectureAction) -> LectureState {
    var state = state

    switch action {
    case let .didReceiveLectureList(response: response):
        state.lectures = response.map { $0.to() }
    case let .didReceiveLectureProgress(response: response):
        var lectures = state.lectures
        guard let index = lectures.firstIndex(where: { $0.id == response.courseID }) else { break }
        var lecture = lectures[index]
        lecture.progreess = response.progress
        lectures[index] = lecture
        state.lectures = lectures
    case let .didReceiveError(error):
        state.error = error
    default:
        break
    }
    
    return state
}
