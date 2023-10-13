import Foundation
import Firebase

class Todo: NSObject /*, NSCoding*/{
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
    
    enum Category: Int {
        case Schedule = 0, Meeting
        func toString() -> String{
            switch self {
                case .Schedule: return "일정";     case .Meeting: return "미팅"
            }
        }
        static var count: Int { return Category.Meeting.rawValue + 1}
    }
    var key: String;        var date: Date
    var owner: String?;     var dept: Dept;
    var content: String;    var category: Category;
    
    //생성자
    init(date: Date, owner: String?, dept: Dept, content: String, category: Category){
        self.key = UUID().uuidString   // 거의 unique한 id를 만들어 낸다.
        self.date = Date(timeInterval: 0, since: date)
        self.owner = owner;
        self.dept = dept;
        self.content = content
        self.category = category
        super.init()
    }
    func encode(with aCoder: NSCoder){
        aCoder.encode(key, forKey: "key")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(owner, forKey: "owner")
        aCoder.encode(dept.rawValue, forKey: "dept")
        aCoder.encode(category.rawValue, forKey: "category")
        aCoder.encode(content, forKey: "content")
    }
    required init(coder aDecoder: NSCoder){
        key = aDecoder.decodeObject(forKey: "key") as! String? ?? "" // 내부적으로 String.init가 호출된다
        date = aDecoder.decodeObject(forKey: "date") as! Date
        owner = aDecoder.decodeObject(forKey: "owner") as? String
        let rawValue = aDecoder.decodeInteger(forKey: "dept")
        dept = Dept(rawValue: rawValue)!
        let rawValue2 = aDecoder.decodeInteger(forKey: "category")
        category = Category(rawValue: rawValue2)!
        content = aDecoder.decodeObject(forKey: "content") as! String? ?? ""
        super.init()

    }
}

extension Todo{
    convenience init(date: Date? = nil, withData: Bool = false){
        if withData == true{
            var index = Int(arc4random_uniform(UInt32(Dept.count)))
            let dept = Dept(rawValue: index)! // 이것의 타입은 옵셔널이다. Option+click해보라
            
            index = Int(arc4random_uniform(UInt32(Category.count)))
            let category = Category(rawValue: index)!
            
            let contents = ["iOS 숙제", "졸업 프로젝트", "아르바이트","데이트","엄마 도와드리기"]
            index = Int(arc4random_uniform(UInt32(contents.count)))
            let content = contents[index]
            
            self.init(date: date ?? Date(), owner: "me", dept: dept, content: content, category: category)
            
        }else{
            self.init(date: date ?? Date(), owner: "me", dept: .Sales, content: "", category: .Meeting)

        }
    }
}

extension Todo{        // Plan.swift
    func clone() -> Todo {
        let clonee = Todo()

        clonee.key = self.key    // key는 String이고 String은 struct이다. 따라서 복제가 된다
        clonee.date = Date(timeInterval: 0, since: self.date) // Date는 struct가 아니라 class이기 때문
        clonee.owner = self.owner
        clonee.dept = self.dept    // enum도 struct처럼 복제가 된다
        clonee.category = self.category
        clonee.content = self.content
        return clonee
    }
}
extension Todo{
    func toDict() -> [String: Any?]{
        var dict: [String: Any?] = [:]
        
        dict["key"] = key
        dict["date"] = Timestamp(date: date)
        dict["owner"] = owner
        dict["dept"] = dept.rawValue
        dict["category"] = category.rawValue
        dict["content"] = content
        
        return dict
    }
    func toTodo(dict: [String: Any?]) {
                if let key = dict["key"] as? String {
                    self.key = key
                } else {
                    self.key = ""
                }
                
                if let timestamp = dict["date"] as? Timestamp {
                    date = timestamp.dateValue()
                } else {
                    date = Date() // Assign a default value if date is nil
                }
                
                owner = dict["owner"] as? String ?? ""
                
                if let rawValue = dict["dept"] as? Int,
                   let dept = Todo.Dept(rawValue: rawValue) {
                    self.dept = dept
                } else {
                    self.dept = Todo.Dept(rawValue: 0)! // Assign a default value if kind is nil or invalid
                }
        
                if let rawValue2 = dict["category"] as? Int,
                    let category = Todo.Category(rawValue: rawValue2) {
                        self.category = category
                } else {
                        self.category = Todo.Category(rawValue: 0)! // Assign a default value if kind is nil or invalid
                }
                
                content = dict["content"] as? String ?? ""
            }
}


