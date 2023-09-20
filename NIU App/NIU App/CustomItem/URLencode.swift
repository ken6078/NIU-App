//
//  URLencode.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/8/19.
//

import Foundation

extension String {
    // MARK: urlEncoded
    func urlEncoded() -> String {
        var reault = self
        reault = reault.replacingOccurrences(of: "+", with: "%2B")
        reault = reault.replacingOccurrences(of: "/", with: "%2F")
        return reault
    }
}
