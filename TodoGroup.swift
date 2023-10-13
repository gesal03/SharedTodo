import Foundation

class TodoGroup: NSObject{
    var todos = [Todo]()            // var plans: [Plan] = []와 동일, 퀴리를 만족하는 plan들만 저장한다.
    var fromDate, toDate: Date?     // queryPlan 함수에서 주어진다.
    var database: Database!
    var parentNotification: ((Todo?, DbAction?) -> Void)?
    
    init(parentNotification: ((Todo?, DbAction?) -> Void)? ){
        super.init()
        self.parentNotification = parentNotification
//        database = DbMemory(parentNotification: receivingNotification) // 데이터베이스 생성
        database = DbFirebase(parentNotification: receivingNotification) // 데이터베이스 생성
    }
    func receivingNotification(todo: Todo?, action: DbAction?){
        // 데이터베이스로부터 메시지를 받고 이를 부모에게 전달한다
        if let todo = todo{
            switch(action){    // 액션에 따라 적절히     plans에 적용한다
                case .Add: addTodo(todo: todo)
                case .Modify: modifyTodo(modifiedTodo: todo)
                case .Delete: removeTodo(removedTodo: todo)
                default: break
            }
        }
        if let parentNotification = parentNotification{
            parentNotification(todo, action) // 역시 부모에게 알림내용을 전달한다.
        }
    }
}

extension TodoGroup{
    
    func queryData(date: Date){
        todos.removeAll()    // 새로운 쿼리에 맞는 데이터를 채우기 위해 기존 데이터를 전부 지운다
        
        // date가 속한 1개월 +-알파만큼 가져온다
        fromDate = date.firstOfMonth().firstOfWeek()// 1일이 속한 일요일을 시작시간
        toDate = date.lastOfMonth().lastOfWeek()    // 이달 마지막일이 속한 토요일을 마감시간
        database.queryPlan(fromDate: fromDate!, toDate: toDate!)
    }
    
    func saveChange(todo: Todo, action: DbAction){
        // 단순히 데이터베이스에 변경요청을 하고 plans에 대해서는
        // 데이터베이스가 변경알림을 호출하는 receivingNotification에서 적용한다
        database.saveChange(todo: todo, action: action)
    }
}

extension TodoGroup{
    func getTodos(date: Date? = nil) -> [Todo] {
        
        // plans중에서 date날짜에 있는 것만 리턴한다
        if let date = date{
            var todoForDate: [Todo] = []
            let start = date.firstOfDay()    // yyyy:mm:dd 00:00:00
            let end = date.lastOfDay()    // yyyy:mm”dd 23:59:59
            for todo in todos{
                if todo.date >= start && todo.date <= end {
                    todoForDate.append(todo)
                }
            }
            return todoForDate
        }
        return todos
    }
    
    func getCategorys(date:Date?=nil, category:String) -> [Todo]{
        if let date = date{
            var todoForDate: [Todo] = []
            let start = date.firstOfDay()    // yyyy:mm:dd 00:00:00
            let end = date.lastOfDay()    // yyyy:mm”dd 23:59:59
            for todo in todos{
                if todo.date >= start && todo.date <= end {
                    if todo.category.toString() == category{
                        todoForDate.append(todo)
                    }
                }
            }
            return todoForDate
        }
        return todos
    }
}

extension TodoGroup{
    private func count() -> Int{ return todos.count }
    func isIn(date: Date) -> Bool{
        if let from = fromDate, let to = toDate{
            return (date >= from && date <= to) ? true: false
        }
        return false
    }
    
    private func find(_ key: String) -> Int?{
        for i in 0..<todos.count{
            if key == todos[i].key{
                return i
            }
        }
        return nil
    }
}

extension TodoGroup{
    private func addTodo(todo:Todo){ todos.append(todo) }
    private func modifyTodo(modifiedTodo: Todo){
        if let index = find(modifiedTodo.key){
            todos[index] = modifiedTodo
        }
    }
    func removeTodo(removedTodo: Todo){
        if let index = find(removedTodo.key){
            todos.remove(at: index)
            
            database.deleteTodo(todo: removedTodo)
        }
    }
    func changeTodo(from: Todo, to: Todo){
        if let fromIndex = find(from.key), let toIndex = find(to.key) {
                let temp = todos[fromIndex]
                todos[fromIndex] = todos[toIndex]
                todos[toIndex] = temp
            }
    }
}
