//
//  LocckyViewController.swift
//  Loccky
//
//  Created by Anand Kore on 08/02/19.
//  Copyright © 2019 Blancco Tech. All rights reserved.
//

import UIKit

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)

    }

    @objc func willResignActive(){
        NotificationCenter.default.removeObserver(self)
        dismiss(animated: false, completion: nil)
    }
    
    //MARK:- Actions
    
    @IBAction func passcodeEntered(_ sender: UIButton) {
        print("Btn Pressed: \(sender.tag)")
        if isPasswordSet(){
            arrPasscode.append("\(sender.tag)")
            if arrPasscode.count == 4{
                if arrPasscode.joined() == getPasscode(){
                    //--- Success.
                    dismiss(animated: true, completion: nil)
                }else{
                    //--- Invalid Passcode.
                    arrPasscode.removeAll()
                }
            }
        }else{
            arrPasscode.append("\(sender.tag)")
            
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
        validatePasscodeCount()
        
    }
    
    @IBAction func btnErasePressed(_ sender: UIButton) {
        print("Btn erase pressed.")
        arrPasscode.remove(at: arrPasscode.count - 1)
        validatePasscodeCount()
    }
    
    @IBAction func btnFingerPrintPressed(_ sender: UITapGestureRecognizer) {
        print("Btn fingerprint Pressed")
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
                print(index)
                let lbl = arrTmpLbls[index]
                lbl.text = "X"
            }
        }
    }
}

//MARK:- Passcode management.
extension LocckyViewController{
    fileprivate static let passcodeKey = "my_passcode"
    @discardableResult fileprivate func isPasswordSet() -> Bool{
        if getPasscode() != nil{
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
    }
}

extension LocckyViewController{
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
