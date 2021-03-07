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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.BACKROUND_COLOR
        
        let newLayout = UICollectionViewFlowLayout()
        newLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let nearbyLayout = UICollectionViewFlowLayout()
        nearbyLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        newCollection = UICollectionView(frame: CGRect(origin: CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.minX,
                                                                       y: view.safeAreaLayoutGuide.layoutFrame.minY),
                                                       size: CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width,
                                                                    height: view.safeAreaLayoutGuide.layoutFrame.height*(1/5))),
                                         collectionViewLayout: newLayout)
        guard let newCollection = newCollection else {
            return
        }
        newCollection.backgroundColor = Constants.BACKROUND_COLOR
        view.addSubview(newCollection)
        
        newCollection.delegate = self
        newCollection.dataSource = self
        newCollection.register(CollectionCell.self, forCellWithReuseIdentifier: NEW_CELL)
        
        newCollection.isPagingEnabled = true
        
        nearbyCollection = UICollectionView(frame: CGRect(x: view.safeAreaLayoutGuide.layoutFrame.minX,
                                                          y: newCollection.safeAreaLayoutGuide.layoutFrame.maxY,
                                                          width: view.safeAreaLayoutGuide.layoutFrame.width,
                                                          height: view.safeAreaLayoutGuide.layoutFrame.height - newCollection.safeAreaLayoutGuide.layoutFrame.height),
                                            collectionViewLayout: nearbyLayout)
        guard let nearbyCollection = nearbyCollection else {
            return
        }
        nearbyCollection.backgroundColor = Constants.BACKROUND_COLOR
        view.addSubview(nearbyCollection)
        
        nearbyCollection.delegate = self
        nearbyCollection.dataSource = self
        nearbyCollection.register(CollectionCell.self, forCellWithReuseIdentifier: NEARBY_CELL)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        socket.delegate = self
        socket.connect()
        socket.getNewUsers(uid: 5)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        newUsers = nil
        nearbyUsers = nil
    }
}
extension DashboardViewController: SocketDelegate {
    func socketDataReceived(result: Data) {
        print("data: \(result)")
        let result = UserDistance.processUserDistancesFromData(data: result)
        if let _ = newUsers,
           let nearbyUsers = result {
            print("nearby")
            self.nearbyUsers = nearbyUsers
            nearbyCollection?.reloadData()
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
