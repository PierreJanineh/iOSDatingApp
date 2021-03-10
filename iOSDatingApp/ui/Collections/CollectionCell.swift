//
//  CollectionCell.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 04/03/2021.
//

import UIKit

///Collection cell for `UserDistance`
class CollectionCell: UICollectionViewCell {
    
    public var user: UserDistance?
    public var nameLabel: UITextView?
    public var image: UIImageView?
    public var onCellClicked: OnCellClicked?
    
    func viewDidLoad() {
        guard let user = user else { return }
        
        guard nameLabel == nil, image == nil else {
            image!.downloaded(from: user.smallUser!.img_url!)
            nameLabel!.text = user.smallUser!.username
            return
        }
        
        image = UIImageView(frame: CGRect(x: safeAreaLayoutGuide.layoutFrame.minX,
                                          y: safeAreaLayoutGuide.layoutFrame.minY,
                                          width: safeAreaLayoutGuide.layoutFrame.width,
                                          height: safeAreaLayoutGuide.layoutFrame.height))
        guard let image = image else { return }
        image.downloaded(from: user.smallUser!.img_url!)
        
        self.addSubview(image)
        
        nameLabel = UITextView(frame: CGRect(x: safeAreaLayoutGuide.layoutFrame.minX,
                                             y: safeAreaLayoutGuide.layoutFrame.minY,
                                             width: safeAreaLayoutGuide.layoutFrame.width,
                                             height: safeAreaLayoutGuide.layoutFrame.height))
        guard let nameLabel = nameLabel else { return }
        nameLabel.isEditable = false
        nameLabel.isSelectable = false
        nameLabel.text = user.smallUser!.username
        nameLabel.textAlignment = .center
        nameLabel.textColor = Constants.Colors.FOREGROUND_COLOR
        nameLabel.backgroundColor = nil
        
        self.addSubview(nameLabel)
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(onCellClicked(_:)))
        self.addGestureRecognizer(tapRec)
    }
    
    @objc func onCellClicked(_ sender: CollectionCell) {
        print(user)
        onCellClicked?.onCellClicked(user: user)
    }
}

/// Protocol to detect CollectionCell events.
protocol OnCellClicked {
    /**
     Called when a CollectionCell has been clicked/tapped.
     
     - Parameter user: `UserDistance` from the cell selected.
     */
    func onCellClicked(user: UserDistance?)
}
