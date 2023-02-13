//
//  ViewController.swift
//  SmartsellWrapperDemo
//
//  Created by Surya on 30/08/21.
//

import UIKit
import SharpsellCore

class ViewController: UIViewController {
    
    //MARK: - IBOutlet Declration
    @IBOutlet weak var companyCodeTxtField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userUniquieIDTxtField: UITextField!
    @IBOutlet weak var userGroupIDTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var mobileNumTxtField: UITextField!
    @IBOutlet weak var companyDetailsLbl: UILabel!
    @IBOutlet weak var emailTxtField: UITextField!
    
    //MARK: - Property Declration
    var sharpsellReleaseVersion = "2.7.0"
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    

    
    //MARK: - Custom Methods
    private func initalSetup(){
        loginBtn.layer.cornerRadius = 10
        companyDetailsLbl.text = "Release version - \(sharpsellReleaseVersion)"
        userUniquieIDTxtField.delegate = self
        userGroupIDTxtField.delegate = self
        nameTxtField.delegate = self
        mobileNumTxtField.delegate = self
        emailTxtField.delegate = self
        companyCodeTxtField.delegate = self
    }
    
    private func callSmartsellLogin(){
        guard let companyCode = companyCodeTxtField.text else {return}
        
        if companyCode.isEmpty{
            let alertController = UIAlertController(title: "⚠️", message: "Enter a company code", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        var firebaseToken = ""
        if let token = defaults.string(forKey: "fcmToken") {
            firebaseToken = token
        } else {
            NSLog("Sharpsell Parent App: Firebase token is empty ⚠️")
        }
        
        //Test Function
        let initSharpsellData: [String:Any] = [
            "company_code":companyCode,
            "user_unique_id": userUniquieIDTxtField.text ?? "9999999999",
            "user_group_id": Int(userGroupIDTxtField.text ?? "410") ?? 1,
            "country_code": "",
            "user_meta": "",
            "name": nameTxtField.text ?? "Enp User",
            "mobile_number": mobileNumTxtField.text ?? "9999999999",
            "email": emailTxtField.text ?? "test9@test9.com",
            "fcm_token": firebaseToken]
        NSLog("Sharpsell Parent App: Parent AFCM TOKEN Bedore sending the data - \(firebaseToken)")
        NSLog("Sharpsell Parent App: Initlize data - \(initSharpsellData)")
        
        
        
        Sharpsell.services.enableLogs(forProd: true) { flutterViewController in
            NSLog("Sharpsell Parent App: Logs enabled successfully")
        } onFailure: { message, errorType in
            NSLog("Sharpsell Parent App: Failed to enable sharpsell logs")
        }

        Sharpsell.services.initialize(smartsellParameters: initSharpsellData) {
            NSLog("Sharpsell Parent App - Flutter Initialization Success")
            DispatchQueue.main.async {
                defaults.set(true, forKey: "isUserLoggedIn")
                defaults.set(companyCode, forKey: "companyLoggedIn")
                defaults.set("", forKey: "fcmToken")
                let cockpitVC = CockpitViewController()
                self.navigationController?.pushViewController(cockpitVC, animated: true)
            }
        } onFailure: { (errorMessage, smartsellError) in
            switch smartsellError {
            case .flutterError:
                NSLog("Error Message: \(errorMessage)")
            case .flutterMethodNotImplemented:
                NSLog("Error Message: Flutter Method Not Implemented")
            default:
                NSLog("Error Message: UnKnown Error in \(#function)")
            }
        }
        
    }
    
    
    //MARK: - IBAction Methods
    @IBAction func loginBtnTapped(_ sender: Any) {
        callSmartsellLogin()
    }
    
}


extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
