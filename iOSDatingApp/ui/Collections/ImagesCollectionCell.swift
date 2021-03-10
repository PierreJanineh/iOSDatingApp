//
//  ImagesCollectionCell.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 07/03/2021.
//

import UIKit

class ImagesCollectionCell: UICollectionViewCell {
    public var image: Image?
    public var imageV: UIImageView?
    
    func viewDidLoad() {
        guard let image = image else { return }
        
        guard imageV == nil else {
            imageV!.downloaded(from: image.imgUrl!)
            return
        }
        
        imageV = UIImageView(frame: CGRect(x: safeAreaLayoutGuide.layoutFrame.minX,
                                          y: safeAreaLayoutGuide.layoutFrame.minY,
                                          width: safeAreaLayoutGuide.layoutFrame.width,
                                          height: safeAreaLayoutGuide.layoutFrame.height))
        guard let imageV = imageV else { return }
        imageV.downloaded(from: image.imgUrl!)
        
        self.addSubview(imageV)
    }
}
