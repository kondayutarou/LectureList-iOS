//
//  LectureMiddleware.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/04/30.
//

import Foundation

func lectureMiddleware() -> Middleware<AppState> {
    return { state, action, dispatcher in
        guard case let .lecture(action) = action else {
            return
        }
        switch action {
        case .fetchLectureList:
            dispatcher.services.databaseService.select(dispatcher: dispatcher)
        case let .didReceiveLectureListFromDB(lectures: lectures):
            if lectures.isEmpty {
                Task {
                    await dispatcher.services.lectureCloudService.fetchLectureList(dispatcher: dispatcher)
                }
            }
        case let .didReceiveLectureList(response: response):
            response.map { $0.id }.forEach { id in
                dispatcher.dispatch(.lecture(.fetchLectureProgress(courseID: id)))
            }
            response.forEach { lecture in
                dispatcher.services.databaseService.insert(lecture: lecture.to())
            }
        case let .fetchLectureProgress(id):
            Task {
                await dispatcher.services.lectureCloudService.fetchLectureProgress(dispatcher: dispatcher, courseID: id)
            }
        case let .didReceiveLectureProgress(response: response):
            dispatcher.services.databaseService.update(progressResponse: response)
        default:
            break
        }
    }
}
