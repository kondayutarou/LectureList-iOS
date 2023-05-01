//
//  ErrorView.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/05/01.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    @EnvironmentObject var store: Store<AppState>

    var body: some View {
        VStack {
            Text("Error occurred while loading lectures.\nPlease reload")
            Button("Reload") {
                store.dispatch(.lecture(.fetchLectureList))
            }
        }
    }
}

struct ErrorViewPreview: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
