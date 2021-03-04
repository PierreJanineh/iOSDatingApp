//
//  CollectionCell.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 04/03/2021.
//

import UIKit
class CollectionCell: UIView {
    
    private var user: UserDistance?
    public var nameLabel: UITextView?
    public var image: UIImageView?
    
    init(frame: CGRect, user: UserDistance) {
        super.init(frame: frame)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewDidLoad() {
        
        guard let user = user else { return }
        
        image = UIImageView()
        guard let image = image else { return }
        image.downloaded(from: user.smallUser!.img_url!)
        
        self.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        nameLabel = UITextView()
        guard let nameLabel = nameLabel else { return }
        nameLabel.isEditable = false
        nameLabel.text = user.smallUser!.username
//        nameLabel.backgroundColor = nil
        
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(distanceLabel)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.topAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        distanceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        distanceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
