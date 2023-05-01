//
//  DatabaseService.swift
//  LectureListSwift (iOS)
//
//  Created by Yutaro Konda on 2023/05/01.
//

import Foundation
import SQLite3

protocol DatabaseService {
    func insert(lecture: Lecture) -> Bool
    func update(progressResponse: LectureProgressAPIResponse) -> Bool
    func select(dispatcher: Store<AppState>)
}

final class DatabaseServiceImpl: DatabaseService {
    private let dbFile = "LectureDB.sqlite"
    private var db: OpaquePointer?

    init() {
        db = openDatabase()
        createTable()
    }

    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent(dbFile)

        var db: OpaquePointer?
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Failed to open database")
            return nil
        } else {
            print("Opened connection to database")
            return db
        }
    }

    private func createTable() -> Bool {
        let createSql = """
        CREATE TABLE IF NOT EXISTS lecture (
            id TEXT NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            icon_url TEXT NOT NULL,
            number_of_topics INTEGER NOT NULL,
            teacher_name TEXT NOT NULL,
            timestamp INTEGER NOT NULL,
            progress INTEGER NULL
        );
        """

        var createStmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, createSql, -1, &createStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }

        if sqlite3_step(createStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(createStmt)
            return false
        }

        sqlite3_finalize(createStmt)
        return true
    }

    func insert(lecture: Lecture) -> Bool {
        let insertSQL = """
        INSERT INTO lecture
        (id, name, icon_url, number_of_topics, teacher_name, timestamp, progress)
        VALUES
        (?, ?, ?, ?, ?, ?, ?);
        """
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        sqlite3_bind_text(statement, 1, (lecture.id as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (lecture.name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, (lecture.iconURL as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 4, Int32(lecture.numberOfTopics))
        sqlite3_bind_text(statement, 5, (lecture.teacherName as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 6, Int32(lecture.timeStamp))
        if let progress = lecture.progreess {
            sqlite3_bind_int(statement, 7, Int32(progress))
        } else {
            sqlite3_bind_null(statement, 7)
        }

        if sqlite3_step(statement) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(statement)
            return false
        }

        sqlite3_finalize(statement)
        return true
    }

    func update(progressResponse: LectureProgressAPIResponse) -> Bool {
        let updateSQL = """
        UPDATE lecture
        SET progress = ?
        WHERE id = ?
        """
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, updateSQL, -1, &statement, nil) != SQLITE_OK {
                print("db error: \(getDBErrorMessage(db))")
                return false
        }

        sqlite3_bind_int(statement, 1, Int32(progressResponse.progress))
        sqlite3_bind_text(statement, 2, progressResponse.courseID, -1, nil)

        if sqlite3_step(statement) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(statement)
            return false
        }

        sqlite3_finalize(statement)
        return true
    }

    func select(dispatcher: Store<AppState>) {
        var lectures: [Lecture] = []
        var selectStatement: OpaquePointer?
        let selectSQL = """
        SELECT DISTINCT * FROM lecture
        """
        if sqlite3_prepare_v2(db, selectSQL, -1, &selectStatement, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            lectures = []
        }
        while sqlite3_step(selectStatement) == SQLITE_ROW {
            let id = String(cString: sqlite3_column_text(selectStatement, 0))
            let name = String(cString: sqlite3_column_text(selectStatement, 1))
            let iconURL = String(cString: sqlite3_column_text(selectStatement, 2))
            let numberOfTopics = Int(sqlite3_column_int(selectStatement, 3))
            let teacherName = String(cString: sqlite3_column_text(selectStatement, 4))
            let timeStamp = Int(sqlite3_column_int(selectStatement, 5))
            var progress: Int?
            if sqlite3_column_type(selectStatement, 6) == SQLITE_NULL {
                progress = nil
            } else {
                progress = Int(sqlite3_column_int(selectStatement, 6))
            }
            lectures.append(
                Lecture(
                    id: id,
                    name: name,
                    iconURL: iconURL,
                    numberOfTopics: numberOfTopics,
                    teacherName: teacherName,
                    timeStamp: timeStamp,
                    progreess: progress
                )
            )
        }

        sqlite3_finalize(selectStatement)
        dispatcher.dispatch(.lecture(.didReceiveLectureListFromDB(lectures: lectures)))
    }

    private func getDBErrorMessage(_ db: OpaquePointer?) -> String {
        if let err = sqlite3_errmsg(db) {
            return String(cString: err)
        } else {
            return ""
        }
    }
}
