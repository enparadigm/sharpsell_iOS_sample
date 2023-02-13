//
//  CockpitViewController.swift
//  SmartsellWrapperDemo
//
//  Created by Surya on 19/12/21.
//

import UIKit
import Flutter
import SharpsellCore

enum ContentType: String{
    case presentation
    case home = "Sharpsell Home"
    case launchPad = "Launch Pad"
    case marketingCollteral = "Marketing Collteral"
    case posterOfTheDay = "Poster Of The Day"
    case dvc = "Digital Visiting Card"
    case timerChallenge = "Timer Challenge"
    case salesBundle = "Sales Bundle"
    case quickLinks = "Quick Links"
    case rolePlay = "RolePlay Challenge"
    case logout = "Logout"
}


//Named this as cockpit because this screen will have all the controlls over the sharpsell
class CockpitViewController: UIViewController {
    
    // MARK: - Programmatic UI componenets
    var tableView: UITableView!
    var presentationInputName: String = ""
    var presentationInputOne: String = ""
    var presentationInputTwo: String = ""
    
    // MARK: - Property Declaration
    static let identifier = "CockpitViewController"
    let contents: [CockpitModel] =  [CockpitModel(contentType: .presentation, contentRoute: "productPresentationInput"),
                                     CockpitModel(contentType: .home, contentRoute: ""),
                                     CockpitModel(contentType: .launchPad, contentRoute: "launchpad"),
                                     CockpitModel(contentType: .marketingCollteral, contentRoute: "mcDirectory"),
                                     CockpitModel(contentType: .posterOfTheDay, contentRoute: "potd"),
                                     CockpitModel(contentType: .dvc, contentRoute: "dvc"),
                                     CockpitModel(contentType: .timerChallenge, contentRoute: "tcHome"),
                                     CockpitModel(contentType: .salesBundle, contentRoute: "productBundle"),
                                     CockpitModel(contentType: .quickLinks, contentRoute: "quickLinks"),
//                                     CockpitModel(contentType: .rolePlay, contentRoute: "rcHome"),
                                     CockpitModel(contentType: .logout, contentRoute: "")]
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initalSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    
    
    // MARK: - Custom Methods
    private func initalSetup(){
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        
        let companyLabel = UILabel()
        companyLabel.translatesAutoresizingMaskIntoConstraints = false
        let companyLoggedIn = defaults.string(forKey: "companyLoggedIn")
        companyLabel.text = "Company LoggedIn - \(companyLoggedIn?.uppercased() ?? "")"
        companyLabel.textAlignment = .center
        companyLabel.font = UIFont.systemFont(ofSize: 19)
        companyLabel.textColor = .systemOrange
        
        
        self.view.addSubview(companyLabel)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            companyLabel.heightAnchor.constraint(equalToConstant: 30),
            companyLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),
            companyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
        
        tableView.register(UINib(nibName: PresentationTableViewCell.reuseId, bundle: nil),
                           forCellReuseIdentifier: PresentationTableViewCell.reuseId)
        tableView.register(CommonTableCell.self,
                           forCellReuseIdentifier: CommonTableCell.reuseId)
    }
    
    private func openSmartSkill(with arguments: [String:Any]?){
        var sharpsellOpenDataInString: String? = nil
        
        if let sharpsellDict = arguments {
            sharpsellOpenDataInString = Sharpsell.services.convertJsonToString(dict: sharpsellDict)
        }
        
        Sharpsell.services.open(arguments: sharpsellOpenDataInString ?? ""){ (flutterViewController) in
            flutterViewController.navigationController?.navigationBar.isHidden = true
            self.navigationController?.pushViewController(flutterViewController, animated: true)
        } onFailure: { (errorMessage, smartSellError) in
            switch smartSellError {
            case .flutterError:
                debugPrint("Error Message: \(errorMessage)")
            case .flutterMethodNotImplemented:
                debugPrint("")
            default:
                debugPrint("")
            }
        }
    }
    
    private func openSharpsellScreen(with route: String){
        let args = ["route" : route]
        print(args)
        openSmartSkill(with: args)
    }
    
    // MARK: - IBAction Methods
    @objc func openPresentationTapped(_ sender: UIButton){
        let presentationArgs = ["route" : "productPresentationInput",
                                "presentation_name" : presentationInputName,
                                "input_one" : presentationInputOne,
                                "input_two" : presentationInputTwo]
        openSmartSkill(with: presentationArgs)
    }
    
}

extension CockpitViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contentName = contents[indexPath.row].contentType.rawValue
        
        switch contents[indexPath.row].contentType {
        case .presentation:
            guard let presentationCell = tableView.dequeueReusableCell(withIdentifier: PresentationTableViewCell.reuseId, for: indexPath) as? PresentationTableViewCell else {return UITableViewCell()}
            presentationCell.selectionStyle = .none
            presentationCell.presentationNameLbl.delegate = self
            presentationCell.inputOneTxtFld.delegate = self
            presentationCell.inputTwoTxtFld.delegate = self
            presentationCell.presentationNameLbl.tag = 11
            presentationCell.inputOneTxtFld.tag = 12
            presentationCell.inputTwoTxtFld.tag = 13
            presentationCell.openPresentationBtn.addTarget(self, action: #selector(openPresentationTapped(_:)),
                                                           for: .touchUpInside)
            return presentationCell
        default:
            guard let commonTableCell = tableView.dequeueReusableCell(withIdentifier: CommonTableCell.reuseId, for: indexPath) as? CommonTableCell else {return UITableViewCell()}
            commonTableCell.selectionStyle = .none
            commonTableCell.updateCell(with: contentName)
            return commonTableCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch contents[indexPath.row].contentType {
        case .presentation:
            break
        case .home:
            openSmartSkill(with: nil)
        case .logout:
            Sharpsell.services.clearData {
                defaults.set(false, forKey: "isUserLoggedIn")
                defaults.set("", forKey: "companyLoggedIn")
                AppDelegate().setLoginPageAsRootVc()
            } onFailure: { message, errorType in
                print("Logut Failed")
            }
        default:
            self.openSharpsellScreen(with: contents[indexPath.row].contentRoute)
            break
        }
    }
}

extension CockpitViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else {return}
        switch textField.tag {
        case 11:
            self.presentationInputName = text
        case 12:
            self.presentationInputOne = text
        case 13:
            self.presentationInputTwo = text
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
}


