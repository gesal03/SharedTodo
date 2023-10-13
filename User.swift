//
//  User.swift
//  SharedTODOList
//
//  Created by 이현승 on 2023/06/20.
//


import Foundation
import Firebase

class User: NSObject {
    enum Dept: Int {
        case Personal = 0, Affairs, Planning, Sales
        func toString() -> String{
            switch self {
                case .Personal: return "인사부서";     case .Affairs: return "총무부서"
                case .Planning: return "기획부서";    case .Sales: return "영업부서"
            }
        }
        static var count: Int { return Dept.Sales.rawValue + 1}
    }
    var id: String
    var pw: String
    var name: String
    var position: String
    var dept: Dept
    
    override init() {
        self.id = ""
        self.pw = ""
        self.name = ""
        self.position=""
        self.dept = .Personal
        super.init()
    }
    
    
    
    init(id: String, pw: String, name: String, dept: Dept, position: String){
        self.id = id;
        self.pw = pw;
        self.name = name;
        self.dept = dept;
        self.position = position
        super.init()
    }
    func encode(with aCoder: NSCoder){
        aCoder.encode(id, forKey: "id")
        aCoder.encode(pw, forKey: "pw")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(position, forKey: "v")
        aCoder.encode(dept.rawValue, forKey: "dept")
    }
    required init(coder aDecoder: NSCoder){
        id = aDecoder.decodeObject(forKey: "id") as! String? ?? ""
        pw = aDecoder.decodeObject(forKey: "pw") as! String? ?? ""
        name = aDecoder.decodeObject(forKey: "name") as! String? ?? ""
        position = aDecoder.decodeObject(forKey: "position") as! String? ?? ""
        let rawValue = aDecoder.decodeInteger(forKey: "dept")
        dept = Dept(rawValue: rawValue)!
        super.init()

    }
}

extension User{
    func toDict() -> [String: Any?]{
        var dict: [String: Any?] = [:]
        
        dict["id"] = id
        dict["pw"] = pw
        dict["name"] = name
        dict["position"] = position
        dict["dept"] = dept.rawValue
    
        return dict
    }
    func toUser(dict: [String: Any?]) {
        if let id = dict["id"] as? String {
            self.id = id
        } else {
            self.id = ""
        }
        if let pw = dict["pw"] as? String {
            self.pw = pw
        } else {
            self.pw = ""
        }
        if let name = dict["name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        if let position = dict["position"] as? String {
            self.position = position
        } else {
            self.position = ""
        }
        if let rawValue = dict["dept"] as? Int,
           let dept = User.Dept(rawValue: rawValue) {
            self.dept = dept
        } else {
            self.dept = User.Dept(rawValue: 0)! // Assign a default value if kind is nil or invalid
        }
        
    }
}
extension User {
    convenience init?(document: QueryDocumentSnapshot) {
        guard let data = document.data() as? [String: Any],
              let id = data["id"] as? String,
              let pw = data["pw"] as? String,
              let name = data["name"] as? String,
              let position = data["position"] as? String,
              let deptRawValue = data["dept"] as? Int,
              let dept = Dept(rawValue: deptRawValue) else {
            return nil
        }
        
        self.init(id: id, pw: pw, name: name, dept: dept, position: position)
    }
}
