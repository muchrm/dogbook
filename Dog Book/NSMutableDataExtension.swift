//
//  NSMutableDataExtension.swift
//  Dog Book
//
//  Created by Pongpanot Chuaysakun on 8/31/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import Foundation
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}