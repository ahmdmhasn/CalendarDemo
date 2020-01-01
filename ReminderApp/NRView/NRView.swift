//
//  NoResultView.swift
//  ExampleApp
//
//  Created by Ahmed M. Hassan on 10/27/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

protocol NRViewDelegate: class {
    func nrView(_ view: NRView, didPressButton sender: UIButton)
}

class NRView: UIView {
    
    // MARK: - Default Properties
    static var color: UIColor = UIColor.init(red: 41 / 255, green: 32 / 255, blue: 23 / 255, alpha: 1)
    static var buttonStyle: ButtonStyle = .none(color: NRView.color)
    
    enum ButtonStyle {
        case none(color: UIColor)
        case rounded(cornerRadius: CGFloat, withShadow: Bool, backgroundColor: UIColor, textColor: UIColor)
        case stroke(cornerRadius: CGFloat, withShadow: Bool, color: UIColor, strokeWidth: CGFloat)
    }
    
    enum AnimationType {
        case fade(_ duration: Double)
    }
    
    // Mark: - Outlets
    
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    // MARK: - Properties
    
    public weak var delegate: NRViewDelegate?
    
    /**
     Set image color
     */
    @IBInspectable public var imageColor : UIColor? = nil {
        didSet{
            self.setImage(imageView.image, withTintColor: imageColor)
        }
    }

    /**
     Set text color
     */
    @IBInspectable public var textColor : UIColor = NRView.color {
        didSet{
            self.titleLabel.textColor = textColor
            self.descriptionLabel.textColor = textColor
        }
    }
    
    /**
     Add shaking animation when image is tapped
     */
    public var shakeImageOnClick: Bool = false {
        didSet {
            imageView.isUserInteractionEnabled = shakeImageOnClick
            if shakeImageOnClick {
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))
            } else {
                imageView.gestureRecognizers?.forEach{imageView.removeGestureRecognizer($0)}
            }
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commitInit()
    }
    
    private func commitInit() {
        Bundle.main.loadNibNamed(String(describing: NRView.self), owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        updateInterface()
    }
    
    // Set default values
    private func updateInterface() {
        self.buttonStyle(NRView.buttonStyle)
        self.setImage(imageView.image, withTintColor: imageColor)
        self.titleLabel.textColor = textColor
        self.descriptionLabel.textColor = textColor
    }
    
    // MARK: - Public Handlers
    /**
     Create an instance of NRView
     - parameter view: parent view in which the NRView will be added to.
     - parameter initiallyHidden: If you want NRView to be added but not visible after initialization, default value is false
     */
    static func addToView(_ view: UIView, initiallyHidden: Bool = false) -> NRView {
        // Check if the view already have an instance of NRView
        for v in view.subviews {
            if v is NRView {
                return v as! NRView
            }
        }
        // Create instance and set visibility
        let nrView = NRView(frame: CGRect.zero)
        nrView.alpha = initiallyHidden ? 0 : 1
        // Add to subview
        view.addSubview(nrView)
        // Set constraints
        nrView.translatesAutoresizingMaskIntoConstraints = false
        nrView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        nrView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        nrView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        nrView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
                
        return nrView
    }
    
    /**
     Remove NRView if already added to the view
     - parameter view: parent view to remove NRView from
     - parameter animated: should animate
     */
    static func removeFromView(_ view: UIView, animated: Bool = true) {
        for v in view.subviews {
            if v is NRView {
                if animated {
                    UIView.animate(withDuration: 0.3, animations: {
                        v.alpha = 0
                    }) { (completed) in
                        v.removeFromSuperview()
                    }
                    
                } else {
                    v.removeFromSuperview()
                }
                
            }
        }
    }
        
    /**
     Set text fot NRView
     - parameter title: title text. set it nil to hide the title
     - parameter description: description text. set it nil to hide the description
     */
    public func setText(title: String?, description: String?) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        // Hide title | description if empty or nil
        self.titleLabel.isHidden = (title?.isEmpty ?? true)
        self.descriptionLabel.isHidden = (description?.isEmpty ?? true)
    }
    
    /**
     Set image for NRView with tint color
     - parameter image: image that will be displayed, can be nil
     - parameter color: tint color, leave it or set the value with nil ta add the original image
     */
    public func setImage(_ image: UIImage?, withTintColor color: UIColor? = nil) {
        if let color = color {
            self.imageView.image = image?.withRenderingMode(.alwaysTemplate)
            self.imageView.tintColor = color
        } else {
            self.imageView.image = image
        }
    }
    
    /**
     Set different styles for the button
     - parameter style: choose your prefered style
     */
    public func buttonStyle(_ style: ButtonStyle) {
        
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        
        switch style {
        case .none(let color):
            button.setTitleColor(color, for: .normal)
            
        case .rounded(let cornerRadius, let withShadow, let backgroundColor, let textColor):
            let halfHeight = button.bounds.height / 2
            button.layer.cornerRadius = (cornerRadius > halfHeight) ? halfHeight : cornerRadius
            button.backgroundColor = backgroundColor
            button.setTitleColor(textColor, for: .normal)
            if withShadow { button.shadow() }
            
        case .stroke(let cornerRadius, let withShadow, let color, let strokeWidth):
            let halfHeight = button.bounds.height / 2
            button.layer.cornerRadius = (cornerRadius > halfHeight) ? halfHeight : cornerRadius
            button.backgroundColor = .none
            button.setTitleColor(color, for: .normal)
            button.layer.borderWidth = strokeWidth
            button.layer.borderColor = color.cgColor
            if withShadow { button.shadow() }
        }
    }
    
    /**
     Show NRView with a duration
     - parameter withAnimationType: custom animation type with duration of the animation
     */
    public func show(withAnimationType type: AnimationType? = .fade(0.3)) {
        switch type {
            
        case .fade(let duration):
            UIView.animate(withDuration: duration) {
                self.alpha = 1
            }
            
        case .none:
            self.alpha = 1
        }
    }
    
    /**
     Hide NRView with a duration
     - parameter withAnimationType: custom animation type with duration of the animation
     */
    public func hide(withAnimationType type: AnimationType? = .fade(0.3)) {
        switch type {
            
        case .fade(let duration):
            UIView.animate(withDuration: duration) {
                self.alpha = 0.0
            }
            
        case .none:
            self.alpha = 1
        }
    }
    
    // MARK: - Private Handlers
    
    @IBAction private func buttonPressed(_ sender: Any) {
        delegate?.nrView(self, didPressButton: sender as! UIButton)
    }
    
    @objc private func imageViewTapped(_ sender: UIGestureRecognizer) {
        imageView.shake()
    }
    
}
