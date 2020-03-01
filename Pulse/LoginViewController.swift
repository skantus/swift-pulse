import UIKit

class LoginViewController: UIViewController {
    var emailText =  UITextField()
    var passwordText =  UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
    }
    
    @objc func onSignInPress() {
        guard emailText.text != nil else { return }
        guard passwordText.text != nil else { return }
        self.navigationController?.pushViewController(HomeController(), animated: true)
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
