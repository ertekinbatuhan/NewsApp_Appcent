//
//  NewsTableViewCell.swift
//  News_App
//
//  Created by Batuhan Berk Ertekin on 8.05.2024.
//

import UIKit

class NewsTableViewCell: UITableViewCell {


    
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
