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
    private var progress: UIActivityIndicatorView?
    
    let socket: SocketServer = SocketServer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.BACKROUND_COLOR
        title = Constants.Strings.FAV_FRAGMENT
        
        progress = UIActivityIndicatorView(style: .large)
        guard let progress = progress else {
            return
        }
        progress.color = Constants.Colors.FOREGROUND_COLOR
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.startAnimating()
        progress.hidesWhenStopped = true
        view.addSubview(progress)
        progress.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progress.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        collection = UICollectionView(frame: CGRect(x: view.safeAreaLayoutGuide.layoutFrame.minX,
                                                    y: view.safeAreaLayoutGuide.layoutFrame.minY,
                                                    width: view.safeAreaLayoutGuide.layoutFrame.width,
                                                    height: view.safeAreaLayoutGuide.layoutFrame.height),
                                      collectionViewLayout: UICollectionViewFlowLayout())
        guard let collection = collection else {
            return
        }
        collection.backgroundColor = Constants.Colors.BACKROUND_COLOR
        view.addSubview(collection)
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(CollectionCell.self, forCellWithReuseIdentifier: FAV_CELL)
        
        view.bringSubviewToFront(progress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        socket.delegate = self
        connect()
    }
    
    /// Connect to Socket and start request
    private func connect() {
        socket.connect()
        socket.getFavouriteUsers(uid: 5)
    }
}
extension FavouritesViewController: SocketDelegate {
    func socketDataReceived(result: Data?) {
        if result == nil { return }
        print("data: \(result)")
        let result = UserDistance.processUserDistancesFromData(data: result!)
        if let result = result {
            print("result: \(result)")
            self.result = result
            self.collection?.reloadData()
        }
        self.progress!.stopAnimating()
    }
    
    func receivedNil() {
        connect()
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
        cell.onCellClicked = self
        cell.viewDidLoad()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        view.bounds.size.applying(CGAffineTransform.init(scaleX: CGFloat(0.3), y: CGFloat(0.3)))
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("selected")
//        navigationController?.pushViewController(ProfileViewController(uid: UInt8(result![indexPath.row].smallUser!.uid!)), animated: true)
//    }
}

extension FavouritesViewController: OnCellClicked {
    func onCellClicked(user: UserDistance?) {
        guard let user = user else { return }
        navigationController?.pushViewController(ProfileViewController(uid: UInt8(user.smallUser!.uid!)), animated: true)
    }
}
