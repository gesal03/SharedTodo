import Foundation

enum DbActionUser{
    case Add, Delete, Modify // 데이터베이스 변경의 유형
}
protocol UserDatabase{
    // 생성자, 데이터베이스에 변경이 생기면 parentNotification를 호출하여 부모에게 알림
    init(parentNotification: ((User?, DbActionUser?) -> Void)? )

    // fromDate ~ toDate 사이의 Plan을 읽어 parentNotification를 호출하여 부모에게 알림
    func queryUsers(completion: @escaping ([User]?, Error?) -> Void)

    // 데이터베이스에 plan을 변경하고 parentNotification를 호출하여 부모에게 알림
    func saveChange(user: User, action: DbActionUser)
    

}
