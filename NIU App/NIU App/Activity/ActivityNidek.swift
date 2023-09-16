//
//  ActivityNidek.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/8/27.
//

import Foundation

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

class Action {
    let name: String
    let date: Date
    let status: ActivityStatus
    let certifiedStatus: CertifiedStatus
    
    init(name: String, date: Date, status: ActivityStatus, certifiedStatus: CertifiedStatus) {
        self.name = name
        self.date = date
        self.status = status
        self.certifiedStatus = certifiedStatus
    }
}
