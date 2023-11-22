import UIKit

protocol AuthViewDelegate: AnyObject {
    func didTapActionButton(_ auth: ViewAuth)
}


class ViewAuth:UIView{
    
    enum PasswordState {
           case notSet
           case setPassword
           case enterPassword
       }
    
    weak var delegate: AuthViewDelegate?

      var passwordState: PasswordState = .notSet {
          didSet {
              updateUIForCurrentState()
          }
      }
    
    let passwordTextField:UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame:CGRect){
        super.init(frame:frame)
        setupUI()
        updateUIForCurrentState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        backgroundColor = .white
        addSubview(passwordTextField)
        addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
                    passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                    passwordTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
                    passwordTextField.widthAnchor.constraint(equalToConstant: 200),
                    actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                    actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
        ])
    }
    
    private func updateUIForCurrentState() {
           switch passwordState {
           case .notSet:
               passwordTextField.text = ""
               actionButton.setTitle("Создать пароль", for: .normal)
           case .setPassword:
               passwordTextField.text = ""
               actionButton.setTitle("Введите пароль", for: .normal)
           case .enterPassword:
               passwordTextField.text = ""
               actionButton.setTitle("Войти", for: .normal)
           }
       }
    
    @objc private func actionButtonTapped() {
            delegate?.didTapActionButton(self)
        }
    
}
