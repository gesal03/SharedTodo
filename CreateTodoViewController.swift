//
//  createTodoViewController.swift
//  SharedTODOList
//
//  Created by 이현승 on 2023/06/20.
//

import UIKit

class CreateTodoViewController: UIViewController {
    @IBOutlet weak var contentText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var todo: Todo? // 나중에 PlanGroupViewController로부터 데이터를 전달받는다
    var user: User!
    var categoryIndex: Int!
    var saveChangeDelegate: ((Todo)-> Void)?
    
    @IBAction func gotoBack(_ sender: UIButton) {
        todo!.date = datePicker.date
        todo!.owner = ""    // 수정할 수 없는 UILabel이므로 필요없는 연산임
        todo!.dept = Todo.Dept(rawValue: user.dept.rawValue)!
        todo!.category = Todo.Category(rawValue: categoryIndex)!
        todo!.content = contentText.text!

        saveChangeDelegate?(todo!)

        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        todo = todo ?? Todo(date: Date(), withData: true)
        datePicker.date = todo?.date ?? Date()
        contentText.text = todo?.content

    }

}

