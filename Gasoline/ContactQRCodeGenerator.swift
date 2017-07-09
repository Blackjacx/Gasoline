//
//  ContactQRCodeGenerator.swift
//  Gasoline
//
//  Created by Stefan Herold on 09.07.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import CoreImage

public enum QRCodeGenerationError: Swift.Error {
    case imageGenerationFailed
}

public class ContactQRCodeGenerator: NSObject {

    let completionHandler: (UIImage?, Error?) -> Void

    init(completion: @escaping (UIImage?, Error?) -> Void) {
        completionHandler = completion
    }

    private override init() {
        fatalError()
    }

    private func requestAccess(completion: @escaping () -> Void) {

        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)

        switch status {

        case .notDetermined:
            CNContactStore().requestAccess(for: CNEntityType.contacts, completionHandler: { granted ,_ in
                if granted {
                    completion()
                }
            })

        case .restricted, .denied:
            break

        case .authorized:
            completion()
        }
    }

    func qrCodeFromContact(contactPickerParent: UIViewController) {

        requestAccess {

            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            contactPickerParent.present(contactPicker, animated: true, completion: nil)
        }
    }

    private func _qrCodeFromContact(contact: CNContact, completion: @escaping (UIImage?, Error?) -> Void) {

        do {
            let data = try CNContactVCardSerialization.data(with: [contact])
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")

            guard let image = filter?.outputImage else {
                DispatchQueue.main.async {
                    completion(nil, QRCodeGenerationError.imageGenerationFailed)
                }
                return
            }

            DispatchQueue.main.async {
                completion(UIImage(ciImage: image), nil)
            }

        } catch {
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
    }
}

extension ContactQRCodeGenerator: CNContactPickerDelegate {

    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {

        _qrCodeFromContact(contact: contact, completion: completionHandler)
    }
}
