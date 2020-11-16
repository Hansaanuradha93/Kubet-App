import UIKit
import Firebase

class MainVC: UIViewController {
    
    // MARK: Properties
    fileprivate let viewModel = MainVM()
    
    fileprivate let fullNameLabel = KATextField(padding: 16, placeholderText: Strings.fullName)
    fileprivate let phoneNumberLabel = KATextField(padding: 16, placeholderText: Strings.phoneNumber)
    fileprivate let registerButton = KAButton(backgroundColor: UIColor.appColor(.lightGray), title: Strings.register, titleColor: .gray, fontSize: 18)
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fullNameLabel, phoneNumberLabel, registerButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        return stackView
    }()

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        setupNotifications()
        setupViewModelObserver()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - Objc Methods
fileprivate extension MainVC {
    
    @objc func handleRegister() {
        registerUser()
    }
    
    
    @objc func handleTextChange(textField: UITextField) {
        viewModel.fullName = fullNameLabel.text
        viewModel.phoneNumber = phoneNumberLabel.text
    }
    
    
    @objc func handleTapDismiss() {
        view.endEditing(true)
    }
    
    
    @objc func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.verticalStackView.transform = .identity
        })
    }
    
    
    @objc func handleKeyboardShow(notification: Notification) {
        self.verticalStackView.transform = CGAffineTransform(translationX: 0, y: -10)
    }
}


// MARK: - Fileprivate Methods
fileprivate extension MainVC {
    
    func registerUser() {
        viewModel.registerUser { [weak self] status, message in
            guard let self = self else { return }
            self.resetScreen()
            
            if status {
                print(message)
                // Go to the url
            } else {
                self.presentAlertOnMainTread(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
    
    
    func resetScreen() {
        viewModel.fullName = ""
        viewModel.phoneNumber = ""
        
        fullNameLabel.text = ""
        phoneNumberLabel.text = ""
    }
    
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func setupViewModelObserver() {
        viewModel.bindalbeIsFormValid.bind { [weak self] isFormValid in
            guard let self = self, let isFormValid = isFormValid else { return }
            if isFormValid {
                self.registerButton.backgroundColor = .black
                self.registerButton.setTitleColor(.white, for: .normal)
            } else {
                self.registerButton.backgroundColor = UIColor.appColor(.lightGray)
                self.registerButton.setTitleColor(.gray, for: .disabled)
            }
            self.registerButton.isEnabled = isFormValid
        }
        
        viewModel.bindableIsRegistering.bind { [weak self] isRegistering in
            guard let self = self, let isRegistering = isRegistering else { return }
            if isRegistering {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    func addTargets() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        fullNameLabel.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        phoneNumberLabel.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    
    func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = Strings.register
        tabBarItem.title = Strings.empty
        
        fullNameLabel.autocorrectionType = .no
        phoneNumberLabel.keyboardType = .phonePad
        registerButton.isEnabled = false
        
        fullNameLabel.setRoundedBorder(borderColor: GlobalConstants.borderColor, borderWidth: GlobalConstants.borderWidth, radius: GlobalConstants.cornerRadius)
        phoneNumberLabel.setRoundedBorder(borderColor: GlobalConstants.borderColor, borderWidth: GlobalConstants.borderWidth, radius: GlobalConstants.cornerRadius)
        registerButton.setRoundedBorder(borderColor: .black, borderWidth: 0, radius: 2)
        
        let paddingTop: CGFloat = 30
        let paddingCorners: CGFloat = 24
        view.addSubviews(verticalStackView)
        registerButton.heightAnchor.constraint(equalToConstant: GlobalConstants.height).isActive = true
        verticalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: paddingCorners, bottom: 0, right: paddingCorners))
    }
}
