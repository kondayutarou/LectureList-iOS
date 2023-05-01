//
//  LectureCloudService.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/04/30.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case serverError
}

protocol LectureCloudService {
    var baseURL: String { get }
    init(baseURL: String)
    func fetchLectureList(dispatcher: Store<AppState>) async
    func fetchLectureProgress(dispatcher: Store<AppState>, courseID: String) async
}

final class LectureCloudServiceImpl: LectureCloudService {
    var baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func fetchLectureList(dispatcher: Store<AppState>) async {
        guard let url = URL(string: "\(baseURL)/api/courses") else {
            dispatcher.dispatch(.lecture(.didReceiveError(APIError.invalidURL)))
            return
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            let decoded = try JSONDecoder().decode(LectureListAPIResponse.self, from: data)
            dispatcher.dispatch(.lecture(.didReceiveLectureList(response: decoded)))
        } catch {
            dispatcher.dispatch(.lecture(.didReceiveError(error)))
        }
    }
    
    func fetchLectureProgress(dispatcher: Store<AppState>, courseID: String) async {
        guard let url = URL(string: "\(baseURL)/api/\(courseID)/usage") else {
            return
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            let decoded = try JSONDecoder().decode(LectureProgressAPIResponse.self, from: data)
            dispatcher.dispatch(.lecture(.didReceiveLectureProgress(response: decoded)))
        } catch {
        }
    }
}
