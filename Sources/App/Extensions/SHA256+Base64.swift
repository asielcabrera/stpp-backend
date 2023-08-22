//
//  SHA256+Base64.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Crypto
import Foundation

extension SHA256Digest {
    var base64: String {
        Data(self).base64EncodedString()
    }
    
    var base64URLEncoded: String {
        Data(self).base64URLEncodedString()
    }
}
