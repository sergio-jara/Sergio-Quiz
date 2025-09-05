import Foundation
import RealmSwift

class RealmService: RealmServiceProtocol {
    private let configuration: Realm.Configuration
    
    init() {
        self.configuration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { _, _ in }
        )
    }
    
    private func getRealm() throws -> Realm {
        return try Realm(configuration: configuration)
    }
    
    // MARK: - Generic Database Operations
    
    func add<T: Object>(_ object: T) {
        do {
            let realm = try getRealm()
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch {
            print("Failed to add object to Realm: \(error)")
        }
    }
    
    func getAll<T: Object>(_ type: T.Type) -> Results<T>? {
        do {
            let realm = try getRealm()
            return realm.objects(type)
        } catch {
            print("Failed to get objects from Realm: \(error)")
            return nil
        }
    }
    
    func get<T: Object>(ofType type: T.Type, forPrimaryKey key: String) -> T? {
        do {
            let realm = try getRealm()
            return realm.object(ofType: type, forPrimaryKey: key)
        } catch {
            print("Failed to get object from Realm: \(error)")
            return nil
        }
    }
    
    
}

