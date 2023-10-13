import Foundation
import Firebase

class UserFirebase: UserDatabase {
    var reference: CollectionReference
    var parentNotification: ((User?, DbActionUser?) -> Void)?  // 타입 변경
    var existQuery: ListenerRegistration?
    
    required init(parentNotification: ((User?, DbActionUser?) -> Void)?) {
        self.parentNotification = parentNotification
        reference = Firestore.firestore().collection("Users")
    }
    
    func queryUsers(completion: @escaping ([User]?, Error?) -> Void) {
        reference.getDocuments { snapshot, error in
            if let error = error {
                print("Failed to fetch users: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            var users = [User]()
            
            for document in snapshot!.documents {
                if let user = User(document: document) {
                    users.append(user)
                }
            }
            
            completion(users, nil)
        }
    }
    
    
    func saveChange(user: User, action: DbActionUser) {
        if action == .Delete {
            reference.document(user.id).delete()
            return
        }
        
        let dict = user.toDict().compactMapValues { $0 }
        reference.document(user.id).setData(dict)
    }
    
}
