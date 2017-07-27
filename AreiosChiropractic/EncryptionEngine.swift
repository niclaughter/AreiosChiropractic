//
//  EncryptionEngine.swift
//  AreiosChiropractic
//
//  Created by Nicholas Laughter on 5/2/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import Foundation
import RNCryptor

struct EncryptionEngine {
    
    // MARK: - Strings
    
    func encrypt(string: String) -> String {
        guard let data = string.data(using: .utf8) else { fatalError("Cannot get data from string in function: \(#function)") }
        return RNCryptor.encrypt(data: data, withPassword: .encryptionKey).base64EncodedString()
    }
    
    func decryptString(fromString string: String) -> String? {
        guard let data = Data(base64Encoded: string) else { fatalError("Could not get data from base64EncodedString in function: \(#function)") }
        var returnData = Data()
        do {
            try returnData = RNCryptor.decrypt(data: data, withPassword: .encryptionKey)
        } catch {
            fatalError("Could not decrypt data in function: \(#function)")
        }
        return String(data: returnData, encoding: .utf8)
    }
    
    // MARK: - Data
    
    func encryptToData(data: Data) -> Data {
        return RNCryptor.encrypt(data: data, withPassword: .encryptionKey)
    }
    
    func decryptData(fromData data: Data) -> Data? {
        return try? RNCryptor.decrypt(data: data, withPassword: .encryptionKey)
    }
}
