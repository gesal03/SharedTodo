import UIKit
import FSCalendar

class TodoViewController: UIViewController {

    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var meetingTableView: UITableView!
    
    @IBOutlet weak var fsCalendar: FSCalendar!
    
    var todoGroup: TodoGroup!
    var selectedDate: Date? = Date()     // 나중에 필요하다
    let uncheckedImage = UIImage(named: "unchecked")
    let checkedImage = UIImage(named: "checked")
    var user: User!
    var categoryIndex=0
    @IBAction func editingTodo(_ sender: UIBarButtonItem) {
        if scheduleTableView.isEditing == true{
            scheduleTableView.isEditing = false
            meetingTableView.isEditing = false
            //sender.setTitle("Edit", for: .normal)
            sender.title = "Edit"
        }else{
            scheduleTableView.isEditing = true
            meetingTableView.isEditing = true
            //sender.setTitle("Done", for: .normal)
            sender.title = "Done"
        }
    }
    
    @IBOutlet weak var addScheduleButton: UIButton!
    @IBOutlet weak var addMeetingButton: UIButton!
    
    @IBOutlet weak var notCompleteLabel: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    var complete = 0
    var notcomplete=0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scheduleTableView.dataSource=self
        meetingTableView.dataSource=self
        
        fsCalendar.dataSource = self                // 칼렌다의 데이터소스로 등록
        fsCalendar.delegate = self                  // 칼렌다의 딜리게이트로 등록
        fsCalendar.isUserInteractionEnabled = true
        fsCalendar.allowsSelection = true

        // 단순히 planGroup객체만 생성한다
        todoGroup = TodoGroup(parentNotification: receivingNotification)
        todoGroup.queryData(date: Date())       // 이달의 데이터를 가져온다. 데이터가 오면 planGroupListener가 호출된다.
        
        print(user.name)
        
        addScheduleButton.addTarget(self, action: #selector(addingScheduleTodo(_:)), for: .touchUpInside)
        addMeetingButton.addTarget(self, action: #selector(addingMeetingTodo(_:)), for: .touchUpInside)
        
        
        navigationItem.title = "Shared Todo"

        
    }

    func receivingNotification(todo: Todo?, action: DbAction?){
    // 데이터가 올때마다 이 함수가 호출되는데 맨 처음에는 기본적으로 add라는 액션으로 데이터가 온다.
        self.scheduleTableView.reloadData()  // 속도를 증가시키기 위해 action에 따라 개별적 코딩도 가능하다.
        self.meetingTableView.reloadData()  // 속도를 증가시키기 위해 action에 따라 개별적 코딩도 가능하다.
        fsCalendar.reloadData()     // 뱃지의 내용을 업데이트 한다

    }
    
}
extension TodoViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let todoGroup = todoGroup{
            notcomplete = todoGroup.getTodos(date: selectedDate).filter{$0.dept.rawValue == user.dept.rawValue}.count - complete
            completeLabel.text = String(complete)
            notCompleteLabel.text = String(notcomplete)
            
            if tableView == meetingTableView{
                var todos = todoGroup.getCategorys(date: selectedDate, category: "미팅")
                todos = todos.filter{ $0.dept.rawValue == user.dept.rawValue }
                return todos.count
            } else if tableView == scheduleTableView{
                var todos = todoGroup.getCategorys(date: selectedDate, category: "일정")
                todos = todos.filter{ $0.dept.rawValue == user.dept.rawValue }
                return todos.count
            }
        }
        return 0    // planGroup가 생성되기전에 호출될 수도 있다
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        var category: String!
        
        if tableView == meetingTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "meetingTableViewCell", for: indexPath)
            category = "미팅"
        } else if tableView == scheduleTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "scheduleTableViewCell", for: indexPath)
            category = "일정"
        }
        
        let todoGroup = todoGroup.getTodos(date: selectedDate).filter{$0.dept.rawValue == user.dept.rawValue}
        
        let filteredTodos = todoGroup.filter { $0.category.toString() == category }
        if indexPath.row < filteredTodos.count {
            let todo = filteredTodos[indexPath.row]
            
            let checkBox = cell.contentView.subviews[0] as! UIButton
            checkBox.setImage(UIImage(systemName: "square"), for: .normal)
            checkBox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
            checkBox.isSelected = false
            
            checkBox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
            (cell.contentView.subviews[1] as! UILabel).text = todo.dept.toString()
            (cell.contentView.subviews[2] as! UILabel).text = todo.content
        }
        
        return cell
    }



    @objc func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let cell = sender.superview?.superview as? UITableViewCell else{
            return
        }
        
        // 체크 박스의 상태에 따른 추가 동작 수행
        if sender.isSelected {
            // 체크된 상태인 경우
            complete += 1
            notcomplete -= 1
            completeLabel.text = String(complete)
            notCompleteLabel.text = String(notcomplete)
            
        } else {
            // 체크되지 않은 상태인 경우
            complete -= 1
            notcomplete += 1
            completeLabel.text = String(complete)
            notCompleteLabel.text = String(notcomplete)
        }
    }
}


extension TodoViewController{
 @IBAction func addingScheduleTodo(_ sender: UIButton) {
        categoryIndex=0
        performSegue(withIdentifier: "addTodo", sender: self)
    }
@IBAction func addingMeetingTodo(_ sender: UIButton) {
        categoryIndex=1
        performSegue(withIdentifier: "addTodo", sender: self)
    }
}

extension TodoViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTodo"{
            let createTodoViewController = segue.destination as! CreateTodoViewController
            createTodoViewController.saveChangeDelegate = saveChange
            createTodoViewController.user = self.user
            createTodoViewController.categoryIndex = self.categoryIndex
                        
            createTodoViewController.todo = Todo(date:nil, withData: false)
        }
    }
}

extension TodoViewController{    // PlanGroupViewController.swift

    // prepare함수에서 PlanDetailViewController에게 전달한다
    func saveChange(todo: Todo){

        // 만약 현재 planGroupTableView에서 선택된 row가 있다면,
        // 즉, planGroupTableView의 row를 클릭하여 PlanDetailViewController로 전이 한다면
        if scheduleTableView.indexPathForSelectedRow != nil{
            todoGroup.saveChange(todo: todo, action: .Modify)
        }else if meetingTableView.indexPathForSelectedRow != nil{
            todoGroup.saveChange(todo: todo, action: .Modify)
        }
        else{
            // 이경우는 나중에 사용할 것이다.
            todoGroup.saveChange(todo: todo, action: .Add)
        }
    }
}

extension TodoViewController{
    @IBAction func editingTodos(_ sender: UIBarButtonItem) {
        if scheduleTableView.isEditing == true{
            scheduleTableView.isEditing = false
            meetingTableView.isEditing = false
            //sender.setTitle("Edit", for: .normal)
            sender.title = "Edit"
        }else{
            scheduleTableView.isEditing = true
            meetingTableView.isEditing = true
            //sender.setTitle("Done", for: .normal)
            sender.title = "Done"
        }
    }

}
extension TodoViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 날짜가 선택되면 호출된다
        selectedDate = date
        todoGroup.queryData(date: date)
        complete=0
        notcomplete=0
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        // 스와이프로 월이 변경되면 호출된다
        selectedDate = calendar.currentPage
        todoGroup.queryData(date: calendar.currentPage)
    }
    
    // 이함수를 fsCalendar.reloadData()에 의하여 모든 날짜에 대하여 호출된다.
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let todos = todoGroup.getTodos(date: date).filter{$0.dept.rawValue == user.dept.rawValue}
        if todos.count > 0 {
            return "[\(todos.count)]"    // date에 해당한 plans의 갯수를 뱃지로 출력한다
        }
        return nil
    }
}
extension TodoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todoGroup = self.todoGroup.getTodos(date: selectedDate)
            
            var category: String!
            if tableView == meetingTableView {
                category = "미팅"
            } else if tableView == scheduleTableView {
                category = "일정"
            }
            
            let filteredTodos = todoGroup.filter { $0.category.toString() == category }
            
            if indexPath.row < filteredTodos.count {
                let todo = filteredTodos[indexPath.row]
                let title = "Delete \(todo.content)"
                let message = "Are you sure you want to delete this item?"

                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action:UIAlertAction) -> Void in
                    self.todoGroup.removeTodo(removedTodo: todo)
                    self.todoGroup.saveChange(todo: todo, action: .Delete)
                    tableView.reloadData() // 삭제 작업 후에 reloadData() 호출
                })

                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)
                tableView.deselectRow(at: indexPath, animated: true) // 선택 해제

                // 삭제 작업 완료 후에 알림 창을 표시
                present(alertController, animated: true, completion: nil)
            }
        }
    }

}
