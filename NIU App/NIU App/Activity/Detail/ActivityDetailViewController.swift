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
        let view = UIView(frame: CGRect(x: 0, y: 8, width: screenSize.width - 16, height:128))
        
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 32, height: 32))
        let image = UIImage(named: "explain")!
        imageView.image = image
        view.addSubview(imageView)
        
        let titleLabel = UITextView(frame: CGRect(x: 40, y: 4, width: 128, height: 32))
        titleLabel.text = "活動說明"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.isScrollEnabled = false
        titleLabel.isEditable = false
        view.addSubview(titleLabel)
        
        let label = UITextView(frame: CGRect(x: 0, y: 44, width: 0, height: 0))
        label.text = acticityDetail.explain
        label.font = UIFont.systemFont(ofSize: 16)
        label.isEditable = false
        label.isScrollEnabled = false
        label.frame.size = label.sizeThatFits(CGSize(width: screenSize.width - 16, height: 0))
        view.frame.size.height = min(screenSize.height * 0.8, label.frame.height + 32)

        view.addSubview(label)
        
        return view
    }
    
    // MARK: detailView
    func detailView(acticityDetail: ActivityDetail) -> UIScrollView {
        let width = screenSize.width - 16
        let heigth = screenSize.height
        let x = 8.0
        let y = 8.0
        
        let scrollView = UIScrollView(frame: CGRect(x: x, y: y, width: width, height: heigth))
        scrollView.isScrollEnabled = true
        
        scrollView.addSubview(explainView(acticityDetail: acticityDetail))
        
        return scrollView
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
            self.view.addSubview(detailView(acticityDetail: acticityDetail))
        }
    }
}
