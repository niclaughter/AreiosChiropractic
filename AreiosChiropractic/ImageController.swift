//
//  ImageController.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 3/5/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class ImageController {
    
    static let shared = ImageController()
    
    let encryptionEngine = EncryptionEngine()
    var imagesDict = [String: UIImage]()
    
    func saveSignatureImageToDatabase(_ image: UIImage, completion: @escaping (String) -> Void = { _ in }) {
        let identifier = FirebaseController.databaseRef.child(.clientsEndpoint).childByAutoId().key
        defer { completion(identifier) }
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
        let dataToSave = encryptionEngine.encryptToData(data: imageData)
        let signatureRef = FirebaseController.storageRef.child(.imagesEndpoint).child(.signaturesEndpoint).child(identifier)
        signatureRef.put(dataToSave, metadata: nil) { (_, error) in
            if let error = error {
                NSLog("Error saving signature image:\n\(error)")
            }
        }
    }
    
    func fetchImage(forClient client: Client, completion: @escaping (UIImage?) -> Void = { _ in }) {
        defer { completion(nil) }
        guard let identifier = client.identifier else { return }
        let signatureRef = FirebaseController.storageRef.child(.imagesEndpoint).child(.signaturesEndpoint).child(identifier)
        signatureRef.data(withMaxSize: (1 * 480 * 480)) { (data, error) in
            if let error = error {
                NSLog("Error getting signature from server:\n\(error)")
            }
            guard let data = data,
                let decryptedData = self.encryptionEngine.decryptData(fromData: data),
                let image = UIImage(data: decryptedData) else { return }
            self.imagesDict.updateValue(image, forKey: identifier)
            completion(image)
        }
    }
}
