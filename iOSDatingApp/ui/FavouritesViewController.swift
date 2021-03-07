//
//  ViewController.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 03/03/2021.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    private var FAV_CELL = "favourite_cell"
    
    private var result: [UserDistance]? = nil
    private var collection: UICollectionView?
    
    let socket: SocketServer = SocketServer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.BACKROUND_COLOR
        
        collection = UICollectionView(frame: CGRect(x: view.safeAreaLayoutGuide.layoutFrame.minX,
                                                    y: view.safeAreaLayoutGuide.layoutFrame.minY,
                                                    width: view.safeAreaLayoutGuide.layoutFrame.width,
                                                    height: view.safeAreaLayoutGuide.layoutFrame.height),
                                      collectionViewLayout: UICollectionViewFlowLayout())
        guard let collection = collection else {
            return
        }
        collection.backgroundColor = Constants.BACKROUND_COLOR
        view.addSubview(collection)
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(CollectionCell.self, forCellWithReuseIdentifier: FAV_CELL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        socket.delegate = self
        socket.connect()
        socket.getFavouriteUsers(uid: 5)
    }


}
extension FavouritesViewController: SocketDelegate {
    func socketDataReceived(result: Data) {
        print("data: \(result)")
        let result = UserDistance.processUserDistancesFromData(data: result)
        if let result = result {
            print("result: \(result)")
            self.result = result
            collection?.reloadData()
        }
    }
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(result == nil)
        if let result = self.result {
            return result.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FAV_CELL, for: indexPath) as! CollectionCell
        
        cell.user = result![indexPath.row]
        cell.viewDidLoad()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        view.bounds.size.applying(CGAffineTransform.init(scaleX: CGFloat(0.3), y: CGFloat(0.3)))
    }
}
