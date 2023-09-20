//
//  ActivityModel.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/8/27.
//

import Foundation
import Kanna

enum ActivityStatus {
    case unable
    case enable
    case full
    case expried
}

enum CertifiedStatus {
    case unable
    case enable
}

class Activity {
    var id: Int
    var organizer: String
    var name: String
    var startDate: Date
    var endDate: Date
    var applyStartDate: Date
    var applyEndDate: Date
    var status: ActivityStatus
    var certifiedStatus: CertifiedStatus
    var numberOfParticipants: Int
    var maximumParticipantLimit: Int
    var waitlistNumber: Int
    var maximumWaitlistLimit: Int
    var select: Bool = false
    
    // MARK: init(node)
    init (node: Kanna.XMLElement) {
        let cols = node.xpath("//td")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh-TW")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        // 編號
        var col = cols[1]
        self.id = Int(col.text!) ?? 0
        
        // 主辦單位
        col = cols[2]
        self.organizer = col.text!
        
        // 活動名稱
        col = cols[3]
        let divs = col.xpath("div")
        self.name = divs.first?.text ?? ""
        self.name = self.name.replacingOccurrences(of: "\n", with: "")
        
        // 認證狀態
        col = cols[4]
        if (col.text! == "已認證") {
            self.certifiedStatus = .enable
        } else {
            self.certifiedStatus = .unable
        }
        
        // 報名起訖
        col = cols[5]
        var spans = col.xpath("//span")
        self.applyStartDate = dateFormatter.date(from:spans[0].text!)!
        self.applyEndDate = dateFormatter.date(from:spans[2].text!)!
        
        // 活動期間
        col = cols[6]
        spans = col.xpath("//span")
        self.startDate = dateFormatter.date(from:spans[0].text!)!
        self.endDate = dateFormatter.date(from:spans[2].text!)!
        
        //報名人數
        col = cols[7]
        spans = col.xpath("//span")
        self.numberOfParticipants = Int(spans[1].text!)!
        self.maximumParticipantLimit = Int(spans[3].text!)!
        self.waitlistNumber = Int(spans[6].text!)!
        self.maximumWaitlistLimit = Int(spans[8].text!)!
        
        // 報名狀態
        col = cols[8]
        if (col.text! == "報名中") {
            self.status = .enable
        } else if (col.text! == "已額滿") {
            self.status = .full
        } else if (col.text! == "已過期") {
            self.status = .expried
        } else {
            self.status = .unable
        }
    }
    
    // MARK: init
    init(
        id: Int, name: String, organizer: String,
        startDate: Date, endDate: Date,
        applyStartDate: Date, applyEndDate: Date,
        status: ActivityStatus, certifiedStatus: CertifiedStatus,
        numberOfParticipants: Int, maximumParticipantLimit: Int,
        waitlistNumber: Int, maximumWaitlistLimit: Int
    ) {
        self.id = id
        self.name = name
        self.organizer = organizer
        self.startDate = startDate
        self.endDate = endDate
        self.applyStartDate = applyStartDate
        self.applyEndDate = applyEndDate
        self.status = status
        self.certifiedStatus = certifiedStatus
        self.numberOfParticipants = numberOfParticipants
        self.maximumParticipantLimit = maximumParticipantLimit
        self.waitlistNumber = waitlistNumber
        self.maximumWaitlistLimit = maximumWaitlistLimit
    }
}
