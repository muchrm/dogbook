//
//  MD5.swift
//  Dog Book
//
//  Created by MEITOEY on 11/4/2558 BE.
//  Copyright © 2558 Pongpanot Chuaysakun. All rights reserved.
//

import Foundation

class MD5 {
    
    func stringToMD5(string string: String)->String{
        return converter(string: string)
    }
    
    private func converter(string string: String) -> String {
        
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
    
}