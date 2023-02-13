//
//  PresentationTableViewCell.swift
//  SharpsellCore
//
//  Created by Surya on 11/02/22.
//

import UIKit
//import SkyFloatingLabelTextField

class PresentationTableViewCell: UITableViewCell {
    
    //MARK: - Property Declaration
    static let reuseId = "PresentationTableViewCell"
    
    //MARK: - IBOutlet Declaration
    @IBOutlet weak var presentationNameLbl: UITextField!//SkyFloatingLabelTextField!
    @IBOutlet weak var inputOneTxtFld: UITextField!//SkyFloatingLabelTextField!
    @IBOutlet weak var inputTwoTxtFld: UITextField!//SkyFloatingLabelTextField!
    @IBOutlet weak var openPresentationBtn: UIButton!
    @IBOutlet weak var holderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        openPresentationBtn.layer.cornerRadius = 10
        holderView.layer.cornerRadius = 10
    }

}
