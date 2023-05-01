//
//  ContentView.swift
//  Shared
//
//  Created by Yutaro Konda on 2023/04/30.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store<AppState>
    private var showErrorView: Binding<Bool> {
        Binding.init {
            store.state.lectureState.error != nil &&
            store.state.lectureState.lectures.isEmpty
        } set: { _ in }
    }

    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: ErrorView()
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true),
                    isActive: showErrorView
                ) {}

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
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
