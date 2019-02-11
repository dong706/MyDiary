//
//  ViewController.swift
//  MyDiary
//
//  Created by Ruslan NAUMENKO on 1/25/19.
//  Copyright © 2019 Ruslan NAUMENKO. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthVC: UIViewController {
    
    @IBOutlet weak var identifyLabel: UILabel!
    @IBOutlet weak var touchIDBtn: UIButton!
    
    private var context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = """
        \(NSLocalizedString("Identify yourself", comment: "Set in code"))
        ⬇️
        """
        
        identifyLabel.text = text
        
        reloadData()
    }
    
    func reloadData() {
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let imageName = (context.biometryType == .faceID ? "faceID" : "touchID")
            touchIDBtn.setImage(UIImage(named: imageName), for: .normal)
        }
        else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            touchIDBtn.setImage(UIImage(named: "passcode"), for: .normal)
        }
        else {
            self.performSegue(withIdentifier: "enterMyDiary", sender: self)
        }
        
    }
    
    private func login(completion: @escaping () -> Void) {
        let reason = NSLocalizedString("Identify yourself", comment: "Set in code")
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
            [unowned self] (succes, error) in
            DispatchQueue.main.async {
                if succes {
                    self.performSegue(withIdentifier: "enterMyDiary", sender: self)
                }
                else {
                    if !(error!.localizedDescription == "Canceled by user.") && !(error!.localizedDescription == "Fallback authentication mechanism selected.") {
                        self.showAlertController(NSLocalizedString("Authentication Failed", comment: "Set in code"))
                    }
                }
                
                self.context = LAContext()
                completion()
            }
        }
    }
    
    @IBAction func touchIDBtn(_ sender: UIButton) {
        touchIDBtn.isEnabled = false
        
        login {
            DispatchQueue.main.async {
                self.touchIDBtn.isEnabled = true
            }
        }
    }
    
}
