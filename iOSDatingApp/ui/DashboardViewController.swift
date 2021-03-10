//
//  DashboardViewController.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 05/03/2021.
//

import UIKit
class DashboardViewController: UIViewController {
    
    private var NEW_CELL = "new_cell"
    private var NEARBY_CELL = "nearby_cell"
    private var NEW_SECTION = "New Users"
    private var NEARBY_SECTION = "Nearby Users"
    
    let socket: SocketServer = SocketServer()
    private var newUsers: [UserDistance]?
    private var nearbyUsers: [UserDistance]?
    
    private var newCollection: UICollectionView?
    private var nearbyCollection: UICollectionView?
    private var progress: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.BACKROUND_COLOR
        navigationItem.title = Constants.Strings.DASH_FRAGMENT
        
        progress = UIActivityIndicatorView(style: .large)
        guard let progress = progress else {
            return
        }
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.startAnimating()
        progress.hidesWhenStopped = true
        view.addSubview(progress)
        progress.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progress.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let newLayout = UICollectionViewFlowLayout()
        newLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let nearbyLayout = UICollectionViewFlowLayout()
        nearbyLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        newCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                         collectionViewLayout: newLayout)
        guard let newCollection = newCollection else {
            return
        }
        view.addSubview(newCollection)
        newCollection.translatesAutoresizingMaskIntoConstraints = false
        newCollection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        newCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        newCollection.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        newCollection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        newCollection.backgroundColor = Constants.Colors.BACKROUND_COLOR
        
        newCollection.delegate = self
        newCollection.dataSource = self
        newCollection.register(CollectionCell.self, forCellWithReuseIdentifier: NEW_CELL)
        
        newCollection.isPagingEnabled = true
        
        nearbyCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: nearbyLayout)
        guard let nearbyCollection = nearbyCollection else {
            return
        }
        nearbyCollection.backgroundColor = Constants.Colors.BACKROUND_COLOR
        view.addSubview(nearbyCollection)
        nearbyCollection.translatesAutoresizingMaskIntoConstraints = false
        nearbyCollection.topAnchor.constraint(equalTo: newCollection.bottomAnchor).isActive = true
        nearbyCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nearbyCollection.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        nearbyCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        nearbyCollection.delegate = self
        nearbyCollection.dataSource = self
        nearbyCollection.register(CollectionCell.self, forCellWithReuseIdentifier: NEARBY_CELL)
        
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
        socket.getNewUsers(uid: 5)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        newUsers = nil
        nearbyUsers = nil
    }
}
extension DashboardViewController: SocketDelegate {
    func socketDataReceived(result: Data?) {
        if result == nil { return }
        print("data: \(result)")
        let result = UserDistance.processUserDistancesFromData(data: result!)
        if let _ = newUsers,
           let nearbyUsers = result {
            print("nearby")
            self.nearbyUsers = nearbyUsers
            nearbyCollection?.reloadData()
            progress!.stopAnimating()
        } else {
            print("new")
            self.newUsers = result
            newCollection?.reloadData()
            if !socket.isOpen {
                socket.connect()
            }
            socket.getNearbyUsers(uid: 5)
        }
    }
    
    func receivedNil() {
        connect()
    }
}
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == newCollection {
            print("numOfItems new")
            if let newUsers = self.newUsers {
                return newUsers.count
            }else {
                return 0
            }
        } else {
            print("numOfItems nearby")
            if let nearbyUsers = self.nearbyUsers {
                return nearbyUsers.count
            }else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: CollectionCell
        
        if collectionView == newCollection {
            print("cellForItem new")
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NEW_CELL, for: indexPath) as! CollectionCell
            cell.user = newUsers![indexPath.row]
        } else {
            print("cellForItem nearby")
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NEARBY_CELL, for: indexPath) as! CollectionCell
            cell.user = nearbyUsers![indexPath.row]
        }
        
        cell.viewDidLoad()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == newCollection {
            return view.bounds.size.applying(CGAffineTransform.init(scaleX: CGFloat(0.2), y: CGFloat(0.2)))
        } else {
            return view.bounds.size.applying(CGAffineTransform.init(scaleX: CGFloat(0.25), y: CGFloat(0.25)))
        }
    }
}
