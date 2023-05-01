//
//  Store.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/04/30.
//

import Foundation

typealias Reducer<State: ReduxState> = (_ state: State, _ action: Action) -> State
typealias Middleware<StoreState: ReduxState> = (StoreState, Action, Store<StoreState>) -> Void

protocol ReduxState { }

struct AppState: ReduxState {
    var lectureState = LectureState()
}

struct LectureState: ReduxState {
    var lectures: [Lecture] = []
    var error: Error?
}

struct Services {
    let lectureCloudService: LectureCloudService
}

final class Store<StoreState: ReduxState>: ObservableObject {
    private(set) var reducer: Reducer<StoreState>
    @Published var state: StoreState
    private(set) var middlewares: [Middleware<StoreState>]
    private(set) var services: Services

    init(
        reducer: @escaping Reducer<StoreState>,
        state: StoreState,
        middlewares: [Middleware<StoreState>]
    ) {
        let environment = Environment()
        self.reducer = reducer
        self.state = state
        self.middlewares = middlewares
        self.services = Services(
            lectureCloudService: LectureCloudServiceImpl(baseURL: environment.baseURL)
        )
    }
    
    func dispatch(_ action: Action) {
        DispatchQueue.main.async {
            // strong reference
            self.state = self.reducer(self.state, action)
        }
        
        middlewares.forEach { middleware in
            middleware(state, action, self)
        }
    }
}
