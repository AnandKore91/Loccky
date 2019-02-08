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
    
    @IBOutlet weak var imgFingerPrint: UIImageView!
    
    //MARK:- Class life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        //--- Setup ui
        configureButtonUI([btnOne, btnTwo, btnThree, btnFour, btnFive, btnSix, btnSeven, btnEight, btnNine, btnZero])
        
    }

    
    //MARK:- Actions
    
    @IBAction func passcodeEntered(_ sender: UIButton) {
        print("Btn Pressed: \(sender.tag)")
        
        switch sender {
        case btnOne:
            break
        case btnTwo:
            break
        case btnThree:
            break
        case btnFour:
            break
        case btnFive:
            break
        case btnSix:
            break
        case btnSeven:
            break
        case btnEight:
            break
        case btnNine:
            break
        case btnZero:
            break
        default:
            print("Invalid sender.")
            break
        }
        
    }
    
    @IBAction func btnFingerPrintPressed(_ sender: UITapGestureRecognizer) {
        print("Btn fingerprint Pressed")
    }
    

}

//MARK:- Passcode management.
extension LocckyViewController{
    fileprivate static let passcodeKey = "my_passcode"
    fileprivate func isPasswordSet() -> Bool{
        if getPasscode() != nil{
            return true
        }
        return false
    }
    
    fileprivate func setPasscode(_ passcode:String) -> Bool{
        UserDefaults.standard.set(passcode, forKey: "my_passcode")
        return UserDefaults.standard.synchronize()
    }
    
    fileprivate func getPasscode() -> String? {
        if let passcode = UserDefaults.standard.value(forKey: "my_passcode") as? String{
            return passcode
        }
        return nil
    }
    
    fileprivate func deletePasscode() -> Bool{
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
