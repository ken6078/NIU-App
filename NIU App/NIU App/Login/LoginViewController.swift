//
//  LoginViewController.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/5/13.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    let loginViewModel: LoginViewModel = LoginViewModel()
    
    lazy var niuLogoImage: UIImageView = {
        let width = (screenSize.width*0.9 - 20) * 0.095 * 2
        let heigth = 1151 * width / 1200
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: heigth))
        guard let image = UIImage(named: "NiuLogo") else { return imageView }
        imageView.image = image
        // address
        imageView.center.x = 10 + width/2
        imageView.center.y = 60 + heigth/2
        
        return imageView
    }()
    
    lazy var niuLogoNameImage: UIImageView = {
        let width = (screenSize.width*0.85) * 0.095 * 8
        let heigth = 83 * width / 400
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: heigth))
        guard let image = UIImage(named: "NiuLogoName") else { print("Can't find name");return imageView }
        imageView.image = image
        // address
        imageView.center.x = screenSize.width * 0.9 - 10 - width/2
        imageView.center.y = 65 + heigth/2
        return imageView
    }()
    
    lazy var accountTextField: UITextField = {
        let width = screenSize.width * 0.9 * 0.9
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: width, height: 64))
        textField.keyboardType = .asciiCapable
        textField.returnKeyType = .done
        textField.delegate = self;
        textField.font = UIFont.systemFont(ofSize: 38)
        textField.textColor = .black
        // Address
        textField.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        textField.layer.cornerRadius = 20
        textField.center.x = view.center.x * 0.9
        textField.center.y = 174 + textField.frame.size.height/2
        // LeftView
        var imageUIView = UIView(frame: CGRect(x: 0, y: 0, width: 67, height: 37))
        var imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 37, height: 37))
        guard let image = UIImage(named: "user") else {return textField}
        imageView.image = image
        imageUIView.addSubview(imageView)
        textField.leftView = imageUIView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let labelWidth = screenSize.width * 0.9 * 0.9
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: labelWidth, height: 64))
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.font = UIFont.systemFont(ofSize: 32)
        textField.textColor = .black
        // Address
        textField.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        textField.layer.cornerRadius = 20
        textField.center.x = view.center.x * 0.9
        textField.center.y = 278 + textField.frame.size.height/2
        // LeftView
        var imageUIView = UIView(frame: CGRect(x: 0, y: 0, width: 67, height: 37))
        var imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 37, height: 37))
        guard let image = UIImage(named: "padlock") else {return textField}
        imageView.image = image
        imageUIView.addSubview(imageView)
        textField.leftView = imageUIView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    lazy var loginButton: LoaderButton =  {
        let button = LoaderButton(frame: CGRect(x: 0, y: 0, width: 136, height: 60))
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor(red: 0, green: 0.18, blue: 0.529, alpha: 0.8)
        button.setTitle("登入", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        // address
        button.center.x = view.center.x * 0.9
        button.center.y = 422
        // action
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        return button
    }()
    
    @objc func login() {
        loginButton.isLoading = true
        accountTextField.isEnabled = false
        accountTextField.textColor = .gray
        passwordTextField.isEnabled = false
        passwordTextField.textColor = .gray
        
        loginViewModel.saveData(
            account: accountTextField.text!,
            password: passwordTextField.text!
        )
        
        loginViewModel.login(
            account: accountTextField.text!,
            password: passwordTextField.text!,
            success: { username in
                DispatchQueue.main.async {
                    let newViewController = MenuViewController(username: username)
                    self.navigationController!.pushViewController(newViewController, animated: false)
                }
            },
            error: { errorMessage in
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "失敗", message: errorMessage, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.loginButton.isLoading = false
                    self.accountTextField.isEnabled = true
                    self.accountTextField.textColor = .black
                    self.passwordTextField.isEnabled = true
                    self.passwordTextField.textColor = .black
                }
            }
        )
    }
    
    lazy var loginAreiaLabel: UIView = {
        let label = UIView()
        label.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.layer.cornerRadius = 30
        let labelWidth = screenSize.width * 0.9
        label.frame = CGRect(x: 0, y: 0, width: labelWidth, height: 500)
        label.center = view.center
        
        label.addSubview(self.niuLogoNameImage)
        label.addSubview(self.niuLogoImage)
        label.addSubview(self.accountTextField)
        label.addSubview(self.passwordTextField)
        label.addSubview(self.loginButton)
        
        return label
    }()

    
    let userDefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 0, green: 0.18, blue: 0.529, alpha: 1)
        
        view.addSubview(self.loginAreiaLabel)
        
        let account: String, password: String
        if userDefault.value(forKey: "account") != nil {
            account = userDefault.value(forKey: "account") as! String
        } else {
            account = ""
        }
        
        if userDefault.value(forKey: "password") != nil {
            password = userDefault.value(forKey: "password") as! String
        } else {
            password = ""
        }
        self.accountTextField.text = account
        self.passwordTextField.text = password
        if (account != "" && password != "") {
            login()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Do something...
        view.endEditing(true)
        return true
    }
}
