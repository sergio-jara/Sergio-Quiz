import Foundation
import RealmSwift

class RealmService: RealmServiceProtocol {
    private var realm: Realm?
    
    init() {
        setupRealm()
    }
    
    private func setupRealm() {
        do {
            let config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { _, _ in }
            )
            realm = try Realm(configuration: config)
        } catch {
            print("Failed to initialize Realm: \(error)")
        }
    }
    
    // MARK: - Generic Database Operations
    
   
    func add<T: Object>(_ object: T) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch {
            print("Failed to add object to Realm: \(error)")
        }
    }
    
    func getAll<T: Object>(_ type: T.Type) -> Results<T>? {
        guard let realm = realm else { return nil }
        return realm.objects(type)
    }
    
    func get<T: Object>(ofType type: T.Type, forPrimaryKey key: String) -> T? {
        guard let realm = realm else { return nil }
        return realm.object(ofType: type, forPrimaryKey: key)
    }
    
    
}

