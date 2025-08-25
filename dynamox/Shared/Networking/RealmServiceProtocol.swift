//
//  RealmServiceProtocol.swift
//  dynamox
//
//  Created by sergio jara on 25/08/25.
//

import Foundation
import RealmSwift


protocol RealmServiceProtocol {
    func add<T: Object>(_ object: T)
    func getAll<T: Object>(_ type: T.Type) -> Results<T>?
    func get<T: Object>(ofType type: T.Type, forPrimaryKey key: String) -> T?
}
