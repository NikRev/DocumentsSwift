import UIKit

class ChangePasswordViewController: UIViewController {
    weak var coordinator: AuthCoordinator?
    private let authView = ViewAuth()
    private let passwordModel = PasswordModel()
    let viewContoller = ViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
        
    }

    private func setupUI() {
        authView.delegate = self
        view.addSubview(authView)
    }

    private func setupConstraints() {
        authView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            authView.topAnchor.constraint(equalTo: view.topAnchor),
            authView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ChangePasswordViewController: AuthViewDelegate {
    func didTapActionButton(_ authView: ViewAuth) {
        switch authView.passwordState {
        case .notSet:
            handleNotSetState()
        case .setPassword:
            handleSetPasswordState()
        case .enterPassword:
            handleEnterPasswordState()
        }
    }

    private func handleNotSetState() {
        guard let password = authView.passwordTextField.text, password.count >= 4 else {
            showAlert(title: "Ошибка", message: "Пароль должен состоять минимум из четырех символов")
            return
        }

        passwordModel.temporaryPassword = password
        authView.passwordState = .setPassword
        authView.passwordTextField.text = ""
        authView.actionButton.setTitle("Повторите пароль", for: .normal)
    }

    private func handleSetPasswordState() {
        guard let enteredPassword = authView.passwordTextField.text, enteredPassword == passwordModel.temporaryPassword else {
            showAlert(title: "Ошибка", message: "Пароли не совпадают")
            authView.passwordState = .notSet
            authView.actionButton.setTitle("Создать пароль", for: .normal)
            return
        }

        // Сохранение пароля в Keychain
        passwordModel.savePasswordToKeychain(password: enteredPassword)
        showAlert(title: "Успешно", message: "Пароль сохранен в KeyChain")
        // Переход на следующий экран
        coordinator?.showTabBar()
    }
    private func handleEnterPasswordState() {
           guard let enteredPassword = authView.passwordTextField.text else {
               // Handle the case where the entered password is nil
               return
           }

           // Perform some action with the entered password, for example, check it against a stored password.
           if passwordModel.verifyPassword(enteredPassword) {
               showAlert(title: "Успешно", message: "Пароль верен")
               coordinator?.showTabBar()
           } else {
               showAlert(title: "Ошибка", message: "Введен неверный пароль")
           }
       }
   }



extension UIViewController {
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
