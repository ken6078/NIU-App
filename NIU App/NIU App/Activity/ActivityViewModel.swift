//
//  ActivityViewModel.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/8/27.
//

import Foundation

class ActivityViewModel {
    
    let userDefault = UserDefaults()
    let account: String
    let password: String
    
    init() {
        account = userDefault.value(forKey: "account") as! String
        password = userDefault.value(forKey: "password") as! String
    }
    
//    func getInformation() -> <#return type#> {
//        <#function body#>
//    }
}
