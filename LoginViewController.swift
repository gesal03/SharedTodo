import UIKit

class LoginViewController: UIViewController {
    // UserGroup 인스턴스 생성
    let userGroup = UserGroup(parentNotification: nil)
    var user: User?

    @IBAction func submit(_ sender: UIButton) {
           guard let id = idTextField.text, let pw = pwTextField.text else {
               return
           }

           userGroup.queryData { [weak self] userCount in
               DispatchQueue.main.async {
                   if let strongSelf = self {
                       let users = strongSelf.userGroup.getUsers()
                       if let user = users.first(where: { $0.id == id && $0.pw == pw }) {
                           strongSelf.user = user // 로그인에 성공한 경우에만 할당
                           strongSelf.performSegue(withIdentifier: "goList", sender: strongSelf)
                           print("로그인 성공: \(user.name)")
                       } else {
                           print("로그인 실패")
                       }
                   }
               }
           }
       }




    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
extension LoginViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goList" {
            if let tabBarController = segue.destination as? UITabBarController {
                if let navController1 = tabBarController.viewControllers?[0] as? UINavigationController,
                   let todoVC = navController1.topViewController as? TodoViewController {
                    todoVC.user = self.user
                }
                if let peopleVC = tabBarController.viewControllers?[1] as? PeopleViewController {
                    peopleVC.user = self.user
                }
                if let profileVC = tabBarController.viewControllers?[2] as? ProfileViewController {
                    profileVC.user = self.user
                }
            }
        }
    }
}






