
//  Created by Erencan Evren on 9.08.2018.
//  Copyright © 2018 Cemal BAYRI. All rights reserved.
//

import UIKit
import AudioToolbox

@IBDesignable
class ClapButtonView: UIView {

    var clapCountBtnShown = false
    var timer: Timer?
    
    @IBOutlet weak var btnCancelClap: UIButton!
    @IBOutlet weak var btnClap: UIButton!
    @IBOutlet weak var lblClapCount: UILabel!
    @IBOutlet weak var cancelBtnXConstraint: NSLayoutConstraint!
    @IBOutlet weak var clapLblYConstraint: NSLayoutConstraint!
    
    var clapCount: Int = 0
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.clear  {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
        
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
        
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupUI()
    }
    
    @objc func dismissCountLabel() {
        self.animateClapCountLabelForShowing()
    }
    
    
    // MARK: - setup
    fileprivate func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        addSubview(view)
    }
    
    private func setupUI() {
        btnClap.layer.cornerRadius = 32
        btnCancelClap.alpha = 0
        btnCancelClap.layer.cornerRadius = btnClap.layer.cornerRadius
        btnClap.layer.cornerRadius = 32
        lblClapCount.layer.cornerRadius = 32
        lblClapCount.layer.masksToBounds = true
        setupLongGestureRecognizer()
    }

    
    //MARK: Can be optimize!!
    func clap() {
        var clapEnded = false
        animateClapCountLabelForShowing()
        bounceClapCountLabel()
        btnClap.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: {
            [unowned self] in
            if clapEnded == false {
                self.btnClap.transform = .identity
                clapEnded = true
            }
        }) { (true) in
            
        }
    }
    
    func animateCancelButton() {
        UIView.animate(withDuration: 0.3) {
            self.btnCancelClap.alpha = 1
            self.cancelBtnXConstraint.constant = -80
            self.layoutIfNeeded()
        }
    }
    
    func animateClapCountLabelForShowing() {
        if clapCountBtnShown == false {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .allowUserInteraction, animations: {
                self.clapLblYConstraint.constant = -80
                self.lblClapCount.alpha = 0.9
                self.layoutIfNeeded()
                self.clapCountBtnShown = true
            }) { (true) in
               
            }
        }
    }
    
    func bounceClapCountLabel() {
        self.clapCount+=1
        lblClapCount.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: {
            [unowned self] in
            self.lblClapCount.text = "+\(self.clapCount)"
            self.lblClapCount.transform = .identity
            self.layoutIfNeeded()
        }) { (true) in
        }
        
    }
    
    
    @IBAction func btnClapAction(_ sender: Any) {
        clap()
    }
   
    
    @IBAction func btnCancelClapAction(_ sender: Any) {
        print("cancel clap action")
    }
    
    
    private func setupLongGestureRecognizer() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(gesture:)))
        gesture.minimumPressDuration = 0.2
        self.addGestureRecognizer(gesture)
    }
    
    @objc func test() {
        print("test")
        vibrate()
        clap()
    }
    @IBAction func btnClapTocuhDownAction(_ sender: UIButton) {
        
    }
    
    var count = 0
    @objc func longPressed(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.test), userInfo: nil, repeats: true)
        case .ended:
            timer?.invalidate()
        default:
            break
        }
    }
    
    func vibrate() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    
    /// Loads a XIB file into a view and returns this view.
    fileprivate func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

}
