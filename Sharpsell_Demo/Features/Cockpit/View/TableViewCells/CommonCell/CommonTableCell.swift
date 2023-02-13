//
//  CommonTableCell.swift
//  SharpsellCore
//
//  Created by Surya on 11/02/22.
//

import Foundation
import UIKit

class CommonTableCell: UITableViewCell{
    //MARK: - Property Declarations
    static let reuseId = "CommonTableCell"
    private let holderView = UIView()
    private let contentLabel = UILabel()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeFeaturedCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom methods
    private func makeFeaturedCellUI(){
        //Lable setup
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        holderView.addSubview(contentLabel)
        
        //holderView setup
        holderView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            holderView.backgroundColor = .systemIndigo
        } else {
            holderView.backgroundColor = .orange
        }
        holderView.layer.cornerRadius = 20
        contentView.addSubview(holderView)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 65),
            holderView.heightAnchor.constraint(equalToConstant: 50),
            holderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            holderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            holderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            holderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentLabel.heightAnchor.constraint(equalToConstant: 35),
            contentLabel.centerXAnchor.constraint(equalTo: holderView.centerXAnchor),
            contentLabel.centerYAnchor.constraint(equalTo: holderView.centerYAnchor)
        ])
    }
    
    func updateCell(with contentName: String){
        contentLabel.text = contentName
    }
    
}
