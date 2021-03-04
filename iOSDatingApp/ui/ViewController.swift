//
//  ViewController.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 03/03/2021.
//

import UIKit

class ViewController: UIViewController {
    
    let socket: SocketServer = SocketServer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        socket.delegate = self
        socket.connect()
        socket.getNearbyUsers(uid: 3)
    }


}
extension ViewController: SocketDelegate {
    func received(result: Data) {
        
        let d: NSData = NSData(data: result)
        let result = UserDistance.processUserDistancesFromData(data: result)
        if let result = result {
            print("result: \(result)")
        }
    }
}
