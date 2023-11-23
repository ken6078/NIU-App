//
//  ActivityDetailViewController.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/11/22.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    var activity: Activity = Activity()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 100, width: 50, height: 50))
        loadingView.color = .gray
        loadingView.style = .medium
        loadingView.startAnimating()
        loadingView.center.x = self.view.center.x
        return loadingView
    }()
    
    // MARK: errorAlert
    func errorAlert(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: "失敗",
                message: message,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: explainView
    func explainView(acticityDetail: ActivityDetail) -> UIView {
        let view = UIView(frame: CGRect(x: screenSize.width*0.05, y: 8, width: screenSize.width * 0.9, height:128))
        
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 32, height: 32))
        let image = UIImage(named: "explain")!
        imageView.image = image
        view.addSubview(imageView)
        
        let label = UITextView(frame: CGRect(x: 8, y: 44, width: screenSize.width * 0.9 - 16, height: 128))
        label.text = acticityDetail.explain
        label.font = UIFont.systemFont(ofSize: 16)
        label.isEditable = false
        view.addSubview(label)
        
        return view
    }

    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(loadingView)
        
        Task {
            let acticityDetail = await ActivityDetailViewModel.getinformation(activity: activity)
            if (acticityDetail.success == false) {
                errorAlert(message: "伺服器連接錯誤，請稍後再試")
                return
            }
            loadingView.stopAnimating()
            self.view.addSubview(explainView(acticityDetail: acticityDetail))
        }
    }
}
