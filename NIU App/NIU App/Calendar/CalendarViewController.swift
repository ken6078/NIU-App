//
//  CalendarViewController.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/8/27.
//

import UIKit
import PDFKit

class CalendarViewController: UIViewController {
    
    let calendarViewModel = CalendarViewModel()
    let screenSize:CGRect = UIScreen.main.bounds
    
    lazy var pdfView: PDFView = {
        let width = screenSize.width * 1.0
        let heigth = screenSize.height * 0.89
        let x = CGFloat(0)
        let y = screenSize.height * 0.11
        let url = "https://www2016.niu.edu.tw/ezfiles/3/1003/img/41/198741840.pdf"
        
        var pdfView = PDFView(frame: CGRect(x: x, y: y, width: width, height: heigth))
        pdfView.backgroundColor = UIColor.darkGray
        if (calendarViewModel.pdfFileAlreadySaved(url: url, fileName: "calendar")) {
            calendarViewModel.showSavedPdf(url: url, fileName: "calendar"){ url in
                pdfView.document = PDFDocument(url: url)
            }
        } else {
            calendarViewModel.savePdf(urlString: url, fileName: "calendar") {
                DispatchQueue.main.async {
                    self.calendarViewModel.showSavedPdf(url: url, fileName: "calendar"){ url in
                        self.pdfView.document = PDFDocument(url: url)
                    }
                }
            }
        }
        return pdfView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "行事曆"
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(pdfView)
        
    }
}

