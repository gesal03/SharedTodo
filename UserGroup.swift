import Foundation
import Firebase

class UserGroup: NSObject {
    var users = [User]()
    var database: UserDatabase!
    var parentNotification: ((User?, DbAction?) -> Void)?
    
    init(parentNotification: ((User?, DbAction?) -> Void)?) {
        super.init()
        self.parentNotification = parentNotification
        database = UserFirebase(parentNotification: { [weak self] user, action in
            self?.receivingNotification(user: user, action: action)
        })
    }
    
    private var isDataLoaded = false
    
    func receivingNotification(user: User?, action: DbActionUser?) {
        if let user = user {
            switch action {
            case .Add:
                addUser(user: user)
            case .Modify:
                modifyUser(modifiedUser: user)
            case .Delete:
                removeUser(removedUser: user)
            default:
                break
            }
        }
        
        isDataLoaded = true
        
        if let parentNotification = parentNotification {
            parentNotification(user, action as? DbAction)
        }
    }
}

extension UserGroup {
    func queryData(completion: @escaping (Int) -> Void) {
        users.removeAll()
        
        database.queryUsers { users, error in
            if let error = error {
                // 에러 처리
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            // 성공적으로 사용자를 가져왔을 때의 로직
            if let users = users {
                self.users = users
                let userCount = users.count
                completion(userCount)
            }
        }
    }


    
    func saveChange(user: User, action: DbActionUser) {
        database.saveChange(user: user, action: action)
    }
}

extension UserGroup {
    private func addUser(user: User) {
        users.append(user)
    }
    
    private func modifyUser(modifiedUser: User) {
        if let index = findUserIndex(userID: modifiedUser.id) {
            users[index] = modifiedUser
        }
    }
    
    func removeUser(removedUser: User) {
        if let index = findUserIndex(userID: removedUser.id) {
            users.remove(at: index)
        }
    }
    
    private func findUserIndex(userID: String) -> Int? {
        for (index, user) in users.enumerated() {
            if user.id == userID {
                return index
            }
        }
        return nil
    }
}

extension UserGroup {
    func getUsers() -> [User] {
        return users
    }
    
    func getUserByID(userID: String) -> User? {
        if let index = findUserIndex(userID: userID) {
            return users[index]
        }
        return nil
    }
    
    func getUsersByDept(dept: User.Dept) -> [User] {
        print(dept.toString())
        return users.filter { $0.dept == dept }
    }
}
