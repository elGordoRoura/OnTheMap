//
//  StudentLocationListCell.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/18/20.
//

import UIKit

class StudentLocationListCell: UITableViewCell {
    
    var user: StudentLocation? {
        didSet {
            guard let user = user else { return }
            let fullName        = "\(user.firstName ?? "First name") \(user.lastName ?? "Last name")"
            let mediaUrl        = user.mediaURL
            
            nameLabel.text      = fullName
            urlLabel.text       = mediaUrl
        }
    }
    
    private let iconImageView   = UIImageView(image: #imageLiteral(resourceName: "icon_pin"),
                                              contentMode: .scaleAspectFit)
    
    private let nameLabel       = UILabel(text: "No name found",
                                          font: .preferredFont(for: .headline,
                                                               weight: .bold),
                                          textColor: .label,
                                          textAlignment: .left)
    
    private let urlLabel        = UILabel(text: "www.christopherroura.co",
                                          font: .preferredFont(for: .subheadline,
                                                               weight: .thin),
                                          textColor: .label,
                                          textAlignment: .left)

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        hstack(
            iconImageView.withSize(.init(width: 96, height: 96)),
            stack(
                nameLabel,
                urlLabel, spacing: 4, alignment: .leading, distribution: .fillEqually),
            spacing: 10,
            alignment: .center)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
