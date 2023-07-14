//
//  CityCellViewController.swift
//  WeatherAppModelMVVMDemo3
//
//  Created by Ateeq Ahmed on 04/06/23.
//

import UIKit

class CityCellViewController: UITableViewCell {

    @IBOutlet weak var AboveView: UIView!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var cityNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.AboveView.layer.cornerRadius = 10.0
        self.AboveView.clipsToBounds = true

        // Configure the view for the selected state
    }

}
