//
//  LectureRow.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/04/30.
//

import Foundation
import SwiftUI

struct LectureRow: View {
    let lecture: Lecture
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: lecture.iconURL),
                       content: { image in
                image.resizable()
                    .frame(width: 100, height: 100, alignment: .center)
            }, placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100, alignment: .center)
            })
                        
            VStack(alignment: .trailing, spacing: 8.0) {
                Text(lecture.name)
                Text(lecture.teacherName)
                Text(String(lecture.numberOfTopics))
                if let progress = lecture.progreess {
                    Text("\(progress) %")
                }
            }
            
            Spacer()
        }
    }
}
