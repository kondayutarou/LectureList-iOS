//
//  ContentView.swift
//  Shared
//
//  Created by Yutaro Konda on 2023/04/30.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store<AppState>

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(store.state.lectureState.lectures) { lecture in
                    LectureRow(lecture: lecture)
                }
            }
        }
        .onAppear {
            store.dispatch(.lecture(.fetchLectureList))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
