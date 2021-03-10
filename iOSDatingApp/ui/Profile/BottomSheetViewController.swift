//
//  BottomSheetViewController.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 08/03/2021.
//

import UIKit
class BottomSheetViewController: UIViewController {
    
    public var isScrollViewPrepared: Bool = false
    
    private(set) var state: State = .fullExpand
    
    private var scrollView: UIScrollView?
    private var stack: UIStackView?
    private var mainView: UIView?
    
    private var info: UserInfo?
    private var sheet: BottomSheet?
    
    init(info: UserInfo?, sheet: BottomSheet) {
        super.init(nibName: nil, bundle: nil)
        self.info = info
        self.sheet = sheet
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
        scrollView = UIScrollView()
        guard let scrollView = scrollView else { return }
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        if let info = info {
            prepareScrollView(scrollView, info: info)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setBottomSheetViewState(state: .minExpand)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        prepareBackground()
    }
    
    /// Prepares the background blur and effects.
    func prepareBackground() {
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let blurredView = UIVisualEffectView.init(effect: blurEffect)
        blurredView.contentView.addSubview(visualEffect)

        visualEffect.frame = UIScreen.main.bounds.applying(CGAffineTransform(scaleX: 1, y: 2))
        blurredView.frame = UIScreen.main.bounds.applying(CGAffineTransform(scaleX: 1, y: 2))
        blurredView.clipsToBounds = true
        blurredView.layer.cornerRadius = 30

        view.insertSubview(blurredView, at: 0)
    }
    
    /**
     Prepares the ScrollView views to attach to it.
     
     - Parameters:
        - scrollView: The `UIScrollView` to insert views in.
        - info: The `UserInfo` instance to take data from.
     */
    func prepareScrollView(_ scrollView: UIScrollView, info: UserInfo) {
        
        let titles = [(UserInfo.ABOUT, info.about!), (UserInfo.WEIGHT, info.weight!.description),
                      (UserInfo.HEIGHT, info.height!.description), (UserInfo.BIRTH_DATE, info.birthDate!.description),
                      (UserInfo.RELATIONSHIP, info.relationship!.toString()), (UserInfo.RELIGION, info.religion!.toString()),
                      (UserInfo.ORIENTATION, info.orientation!.toString()), (UserInfo.ETHNICITY, info.ethnicity!.toString()),
                      (UserInfo.REFERENCE, info.reference!.toString()), (UserInfo.STDS, info.stDs!.toString(isDisability: false)),
                      (UserInfo.ROLE, info.role!.toString()), (UserInfo.DISABILITIES, info.disabilities!.toString(isDisability: true))] as [(String, String)]
        var views: [UIView] = []
        
        for i in 0..<10 {
            let title = UILabel()
            title.text = titles[i].0
            title.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
            views.append(title)
            
            let value = UILabel()
            value.text = titles[i].1
            views.append(value)
        }
        mainView = UIView()
        guard let mainView = mainView else { return }
        scrollView.addSubview(mainView)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mainView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        let constraint = mainView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
        mainView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        self.stack = UIStackView()
        stack!.axis = .vertical
        stack!.distribution = .equalSpacing
        stack!.spacing = 0
        stack!.alignment = .center
        for view in views {
            stack!.addArrangedSubview(view)
        }
        
        mainView.addSubview(stack!)
        
        stack!.translatesAutoresizingMaskIntoConstraints = false
        stack!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stack!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stack!.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stack!.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        isScrollViewPrepared = true
    }
    
    /**
     Pan gesture recognizer to detect when the user pans the BottomSheet up/down and move it with their finger.
     
     ## Limitations:
     - BottomSheet never goes beyond `State.maxExpand` or `State.minExpand`.
     - It aligns itself to nearby `State` values on every `panGesture.ended`.
     */
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let y = self.view.frame.minY
        let vTranslation = y+translation.y
        
        if vTranslation <= State.maxExpand.val {
            setBottomSheetViewState(state: .fullExpand)
            return
        }
        
        self.view.frame = CGRect(x: 0, y: vTranslation, width: view.frame.width, height: view.frame.height)
        sender.setTranslation(CGPoint.zero, in: self.view)
        sheet!.didMove(y: vTranslation)
        
        var state: State = .fullExpand
        if sender.state == .ended {
            if vTranslation >= State.fullExpand.val && vTranslation < State.partialExpand.val || vTranslation < State.fullExpand.val {
                state = .fullExpand
            }else if vTranslation >= State.partialExpand.val && vTranslation < State.minExpand.val {
                state = .partialExpand
            }else if vTranslation >= State.minExpand.val && vTranslation < State.closed.val {
                state = .minExpand
            }else {
                state = .closed
            }
            setBottomSheetViewState(state: state)
            sheet!.didMove(y: state.val)
        }
    }
    
    /**
     Calls private method `prepareScollView(,info)`.
     
     - Parameter info: The `UserInfo` to take data from.
     */
    public func prepareInfo(_ info: UserInfo){
        prepareScrollView(scrollView!, info: info)
    }
    
    /**
     Calls private method `prepareScollView(,info)` after removing `mainView` from it's parent if it's not nil (meaning hadn't been created yet).
     
     - Parameter info: The `UserInfo` to take data from.
     */
    public func updateInfo(_ info: UserInfo) {
        if let mainView = mainView {
            mainView.removeFromSuperview()
        }
        prepareInfo(info)
    }
}
extension BottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == State.fullExpand.val && scrollView!.contentOffset.y == 0 && direction > 0) || (y == State.partialExpand.val) {
            scrollView!.isScrollEnabled = false
        } else {
            scrollView!.isScrollEnabled = true
        }
        
        return false
    }
}

extension BottomSheetViewController {
    
    /**
     Sets the BottomSheet state by adding animation and changing it's Y position.
     
     - Parameter state: The `State` desired to change Y position to.
     */
    func setBottomSheetViewState(state: BottomSheetViewController.State){
        UIView.animate(withDuration: 0.3) {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: state.val, width: frame.width, height: frame.height)
        }
//        self.view.frame = CGRect(x: 0, y: state.val, width: view.bounds.width, height: view.bounds.height)
    }
    
    ///BottomSheet positions state
    class State {
        static public var maxExpand: State = State(-(UIScreen.main.bounds.height * 0.5)),
                          fullExpand: State = State(UIScreen.main.bounds.minY + (UIScreen.main.bounds.height * 1/8)),
                          partialExpand: State = State(UIScreen.main.bounds.minY + (UIScreen.main.bounds.height * 4/8)),
                          minExpand: State = State(UIScreen.main.bounds.minY + (UIScreen.main.bounds.height * 7/8)),
                          closed: State = State(UIScreen.main.bounds.maxY)
        /// Y position value for state.
        public var val: CGFloat!
        
        private init(_ val: CGFloat) {
            self.val = val
        }
    }
}
/// Protocol to detect whenever the BottomSheet events
protocol BottomSheet {
    /**
     Called when BottomSheet has moved to a Y position.
     
     - Parameter y: `CGFloat` of Y position.
     */
    func didMove(y: CGFloat)
}
