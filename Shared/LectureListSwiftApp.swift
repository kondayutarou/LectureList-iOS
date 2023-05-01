//
//  LectureListSwiftApp.swift
//  Shared
//
//  Created by Yutaro Konda on 2023/04/30.
//

import SwiftUI

@main
struct LectureListSwiftApp: App {
    var body: some Scene {
        let environment = Environment()

        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [lectureMiddleware()]
        )
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
