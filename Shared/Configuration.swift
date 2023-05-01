//
//  Configuration.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/04/30.
//

import Foundation

struct Environment {
    var baseURL: String {
        #if DEBUG
        return "https://native-team-code-test-api.herokuapp.com"
        #else
        return "https://native-team-code-test-api.herokuapp.com"
        #endif
    }
}
