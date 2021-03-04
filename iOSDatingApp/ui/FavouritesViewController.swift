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
        
        collection = UICollectionView(frame: CGRect(origin: view.bounds.origin, size: view.bounds.size), collectionViewLayout: UICollectionViewFlowLayout())
        guard let collection = collection else {
            return
        }
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: FAV_CELL)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FAV_CELL, for: indexPath)
        
        let view = CollectionCell(frame: CGRect(origin: cell.bounds.origin, size: cell.bounds.size), user: result![indexPath.row])
        cell.addSubview(view)
        view.viewDidLoad()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        view.bounds.size.applying(CGAffineTransform.init(scaleX: CGFloat(0.3), y: CGFloat(0.3)))
    }
}
