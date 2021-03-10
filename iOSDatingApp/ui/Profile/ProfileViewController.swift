//
//  ProfileViewController.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 07/03/2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var uid: UInt8!
    
    private let IMG_CELL = "img_cell"
    
    private let socket: SocketServer = SocketServer()
    private var images: [Image]?
    private var info: UserInfo?
    
    private var imagesCollection: UICollectionView?
    private var progress: UIActivityIndicatorView?
    private var bottomSheet: BottomSheetViewController?
    
    init(uid: UInt8!) {
        super.init(nibName: nil, bundle: nil)
        self.uid = uid
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(uid: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        imagesCollection = UICollectionView(frame: CGRect(x: view.safeAreaLayoutGuide.layoutFrame.minX,
                                                          y: view.safeAreaLayoutGuide.layoutFrame.minY,
                                                          width: view.safeAreaLayoutGuide.layoutFrame.width,
                                                          height: view.safeAreaLayoutGuide.layoutFrame.height),
                                            collectionViewLayout: layout)
        guard let imagesCollection = imagesCollection else {
            return
        }
        imagesCollection.backgroundColor = Constants.Colors.BACKROUND_COLOR
        view.addSubview(imagesCollection)
        
        imagesCollection.delegate = self
        imagesCollection.dataSource = self
        imagesCollection.register(ImagesCollectionCell.self, forCellWithReuseIdentifier: IMG_CELL)
        imagesCollection.isPagingEnabled = true
        imagesCollection.showsHorizontalScrollIndicator = false
        
        bottomSheet = BottomSheetViewController(info: self.info, sheet: self)
        addChild(bottomSheet!)
        view.addSubview(bottomSheet!.view)
        bottomSheet!.didMove(toParent: self)
        
        view.bringSubviewToFront(progress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        socket.delegate = self
        connect()
    }
    
    /// Connect to Socket and start request
    private func connect(){
        socket.connect()
        socket.getImagesForUser(uid: uid)
    }
}

extension ProfileViewController: SocketDelegate {
    func socketDataReceived(result: Data?) {
        guard let result = result else { return }
        if let _ = images,
           let info = UserInfo.processUserInfoFromData(data: result) {
            print("info")
            self.info = info
            bottomSheet!.updateInfo(info)
            progress!.stopAnimating()
        } else {
            let result = Image.processImagesFromData(data: result)
            print("images")
            self.images = result
            imagesCollection?.reloadData()
            if !socket.isOpen {
                socket.connect()
            }
            socket.getUserInfo(uid: 5)
        }
    }
    
    func receivedNil() {
        connect()
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(images == nil)
        if let result = self.images {
            return result.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IMG_CELL, for: indexPath) as! ImagesCollectionCell
        
        cell.image = images![indexPath.row]
        cell.viewDidLoad()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size.applying(CGAffineTransform(scaleX: 1, y: 0.9))
    }
}
extension ProfileViewController: BottomSheet {
    func didMove(y: CGFloat) {
        
    }
}
