//
//  AppReducer.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/04/30.
//

import Foundation

func appReducer(_ state: AppState, _ action: Action) -> AppState {
    var state = state
    
    switch action {
    case .lecture(let action):
        state.lectureState = lectureReducer(state.lectureState, action: action)
    }

    return state
}
