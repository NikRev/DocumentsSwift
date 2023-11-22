import UIKit
import KeychainAccess

class AuthContoller:UIViewController,AuthViewDelegate{
    var coordinator: AuthCoordinator?
    // Переменная для хранения временного пароля
    var temporaryPassword: String?
  
    let auth = ViewAuth()
    let passwordModel = PasswordModel()
    // Добавим Keychain для сохранения пароля
    let keyChain = Keychain(service: "com.Bundle,Sandbox,FileManager")
    let viewContoller = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth.delegate = self
        view.addSubview(auth)
        view.backgroundColor = .white
        auth.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            auth.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            auth.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            auth.topAnchor.constraint(equalTo: view.topAnchor),
            auth.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        didTapActionButton(auth)
    }
  
    
    func didTapActionButton(_ auth: ViewAuth) {
        print("didTapActionButton called")
        switch auth.passwordState {
        case .notSet:
            if let password = auth.passwordTextField.text, password.count >= 4 {
                    temporaryPassword = password
                    auth.passwordState = .setPassword
                    auth.passwordTextField.text = ""
                    auth.actionButton.setTitle("Повторите пароль", for: .normal)
                } else {
                    auth.inputViewController?.showAlert(title: "Ошибка", message: "Пароль должен состоять минимум из четырех символов")
                }
        case .setPassword:
            if let enterpassword = auth.passwordTextField.text,enterpassword == temporaryPassword{
                // Сохранение пароля в Keychain
                keyChain["userPassword"] = enterpassword
                auth.inputViewController?.showAlert(title: "Успешно", message: "Пароль сохранен в KeyChain")
                // Переход на следующий экран
                coordinator?.showTabBar()
            }else {
                auth.inputViewController?.showAlert(title: "Ошибка", message: "Пароли не совпадают")
                // Сброс состояния экрана до начального
                auth.passwordState = .notSet
                auth.actionButton.setTitle("Создать пароль", for: .normal)
            }
        case .enterPassword:
            if let enteredPassword = auth.passwordTextField.text, let savedPassword = keyChain["userPassword"], enteredPassword == savedPassword{
                auth.inputViewController?.showAlert(title: "Успех", message: "Пароль верный!")
                // Переход на следующий экран
                coordinator?.showTabBar()
            }else {
                auth.inputViewController?.showAlert(title: "Ошибка", message: "Неверный пароль")
            }
        }
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
