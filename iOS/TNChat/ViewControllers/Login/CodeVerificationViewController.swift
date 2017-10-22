//
//  CodeVerificationViewController.swift
//  TNChat
//
//  Created by Tawa Nicolas on 15/10/17.
//  Copyright © 2017 Tawa Nicolas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CodeVerificationViewController: UIViewController {
	
	@IBOutlet weak var verificationCodeTextField: UITextField!
	
	var verificationID: String?
	
	@IBAction func verifyAction(_ sender: LoadingButton) {
		let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "", verificationCode: verificationCodeTextField.text!)

		sender.startLoading()
		
		Auth.auth().signIn(with: credential) { (_, error) in
			sender.stopLoading()
			
			if let error = error {
				let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default))
				self.present(alert, animated: true)
			} else {
				if let user = Auth.auth().currentUser,
					let number = user.phoneNumber {
					CurrentUserManager.shared.userID = String(number.dropFirst())
					Database.database().reference().child("users/"+number.dropFirst()).setValue(true)
				}
				NotificationCenter.default.post(name: NotificationName.signedIn.notification, object: nil)
				self.dismiss(animated: true)
			}
		}
	}
}
