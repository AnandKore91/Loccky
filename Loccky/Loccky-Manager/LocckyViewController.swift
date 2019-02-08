//
//  LocckyViewController.swift
//  Loccky
//
//  Created by Anand Kore on 08/02/19.
//  Copyright © 2019 Blancco Tech. All rights reserved.
//

import UIKit
import LocalAuthentication

public class LocckyViewController: UIViewController {

    //MARK:- Properties
    var appTitle:String = "My App"
    fileprivate var arrPasscode = [String]()
    fileprivate var arrTmpPwd = [String]()
    
    //MARK:- Outlets
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var lblKeyOne: UILabel!
    @IBOutlet weak var lblKeyTwo: UILabel!
    @IBOutlet weak var lblKeyThree: UILabel!
    @IBOutlet weak var lblKeyFour: UILabel!
    
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnFive: UIButton!
    @IBOutlet weak var btnSix: UIButton!
    @IBOutlet weak var btnSeven: UIButton!
    @IBOutlet weak var btnEight: UIButton!
    @IBOutlet weak var btnNine: UIButton!
    @IBOutlet weak var btnZero: UIButton!
    
    @IBOutlet weak var btnErase: UIButton!
    
    @IBOutlet weak var imgFingerPrint: UIImageView!
    
    //MARK:- Class life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        //--- Setup ui
        configureButtonUI([btnOne, btnTwo, btnThree, btnFour, btnFive, btnSix, btnSeven, btnEight, btnNine, btnZero])
        
        //--- Add notifier
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocckyViewController.isPasswordSet() == false{
            lblInstructions.text = "Set Passcode"
        }
    }

    @objc func willResignActive(){
        //--- Remove previous VC.
        NotificationCenter.default.removeObserver(self)
        dismiss(animated: false, completion: nil)
    }
    
    //MARK:- Actions
    @IBAction func passcodeEntered(_ sender: UIButton) {
        if LocckyViewController.isPasswordSet(){
            arrPasscode.append("\(sender.tag)")
            lblInstructions.text = "Enter Passcode"
            if arrPasscode.count == 4{
                if arrPasscode.joined() == getPasscode(){
                    //--- Success.
                    dismiss(animated: true, completion: nil)
                }else{
                    //--- Invalid Passcode.
                    arrPasscode.removeAll()
                    lblInstructions.text = "Wrong Passcode. Retry"
                }
            }
        }else{
            arrPasscode.append("\(sender.tag)")
            lblInstructions.text = "Set Passcode"
            if arrPasscode.count == 4{
                if arrTmpPwd.isEmpty{
                    arrTmpPwd.append(contentsOf: arrPasscode)
                    arrPasscode.removeAll()
                    lblInstructions.text = "Re-Enter Passcode"
                }else if arrTmpPwd.joined() == arrPasscode.joined(){
                    //--- Successfully added new passcode.
                    setPasscode(arrPasscode.joined())
                    dismiss(animated: true, completion: nil)
                }else{
                    arrPasscode.removeAll()
                    arrTmpPwd.removeAll()
                    lblInstructions.text = "Enter Passcode"
                    //--- Invalid pwd. Reset.
                }
            }
        }
        //--- Update labels
        validatePasscodeCount()
    }
    
    @IBAction func btnErasePressed(_ sender: UIButton) {
        if !arrPasscode.isEmpty{ //--- Check array is not empty
            arrPasscode.remove(at: arrPasscode.count - 1)
            validatePasscodeCount() //--- Update labels
        }
    }
    
    @IBAction func btnFingerPrintPressed(_ sender: UITapGestureRecognizer) {
        let biometrics:(available:Bool, error:Error?) = LocckyViewController.isBiometricsAvailable()
        if biometrics.available{
            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To unlock the app.") { success, error in
                DispatchQueue.main.async {
                    if success{
                        self.willResignActive()
                    }else{
                        self.lblInstructions.text = error?.localizedDescription ?? ""
                        LocckyViewController.present()
                    }
                }
            }
        }else{
            lblInstructions.text = biometrics.error?.localizedDescription ?? ""
        }
    }
}

//MARK:- Passcode validation
extension LocckyViewController{
    fileprivate func validatePasscodeCount() {
        let arrTmpLbls:[UILabel] = [lblKeyOne, lblKeyTwo, lblKeyThree, lblKeyFour]
        
        //--- Reset
        for lbl in arrTmpLbls{  lbl.text = "O"  }
        
        //--- Set
        if arrPasscode.count <= arrTmpLbls.count{
            for index in 0..<arrPasscode.count{
                let lbl = arrTmpLbls[index]
                lbl.text = "X"
            }
        }
    }
}

//MARK:- Passcode management.
extension LocckyViewController{
    fileprivate static let passcodeKey = "my_passcode"
    @discardableResult public class func isPasswordSet() -> Bool{
        if LocckyViewController().getPasscode() != nil{
            return true
        }
        return false
    }
    
    @discardableResult fileprivate func setPasscode(_ passcode:String) -> Bool{
        UserDefaults.standard.set(passcode, forKey: "my_passcode")
        return UserDefaults.standard.synchronize()
    }
    
    @discardableResult fileprivate func getPasscode() -> String? {
        if let passcode = UserDefaults.standard.value(forKey: "my_passcode") as? String{
            return passcode
        }
        return nil
    }
    
    @discardableResult fileprivate func deletePasscode() -> Bool{
        UserDefaults.standard.removeObject(forKey: "my_passcode")
        return UserDefaults.standard.synchronize()
    }
}

//MARK:- UI Management
extension LocckyViewController{
    fileprivate func configureButtonUI(_ btns:[UIButton]){
        for btn in btns{
            btn.layer.cornerRadius = btn.frame.size.height/2
            btn.layer.borderColor = UIColor.white.cgColor
            btn.layer.borderWidth = 1
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnFingerPrintPressed(_:)))
        imgFingerPrint.isUserInteractionEnabled = true
        imgFingerPrint.addGestureRecognizer(tapGestureRecognizer)
        
//        let biometrics:(available:Bool, error:Error?) = LocckyViewController.isBiometricsAvailable()
//        if biometrics.available == false{
//            imgFingerPrint.isHidden = true
//        }
    }
}

//MARK:- Utility
extension LocckyViewController{
    
    fileprivate class func isBiometricsAvailable() -> (Bool, Error?){
        var authError:NSError?
        if (LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)){
            return (true,nil)
        }else{
            return (false, authError)
        }
    }

    fileprivate class func showViewControler(_ vc: UIViewController?) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        if let vc = vc {
            window.rootViewController?.present(vc, animated: true)
        }
    }
    
    public class func present(){
        let lvc = LocckyViewController()
        lvc.modalTransitionStyle = .crossDissolve
        LocckyViewController.showViewControler(lvc)
    }
}
