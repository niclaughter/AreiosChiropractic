//
//  SignatureCaptureView.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/16/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import UIKit

@IBDesignable
class SignatureCaptureView: UIView {
    
    weak var delegate: SignatureCaptureDelegate?
    
    // MARK: - Public properties
    @IBInspectable public var strokeWidth: CGFloat = 2.0 {
        didSet {
            self.path.lineWidth = strokeWidth
        }
    }
    
    @IBInspectable public var strokeColor = UIColor.black {
        didSet {
            self.strokeColor.setStroke()
        }
    }
    
    @IBInspectable public var signatureBackgroundColor = UIColor.white {
        didSet {
            self.backgroundColor = signatureBackgroundColor
        }
    }
    
    // Computed Property returns true if the view actually contains a signature
    public var doesContainSignature: Bool {
        get {
            if self.path.isEmpty {
                return false
            } else {
                return true
            }
        }
    }
    
    // MARK: - Private properties
    private var path = UIBezierPath()
    private var points = [CGPoint](repeating: CGPoint(), count: 5)
    private var controlPoint = 0
    
    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = self.signatureBackgroundColor
        self.path.lineWidth = self.strokeWidth
        self.path.lineJoinStyle = CGLineJoin.round
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = self.signatureBackgroundColor
        self.path.lineWidth = self.strokeWidth
        self.path.lineJoinStyle = CGLineJoin.round
    }
    
    // MARK: - Draw
    override public func draw(_ rect: CGRect) {
        self.strokeColor.setStroke()
        self.path.stroke()
    }
    
    // MARK: - Touch handling functions
    override public func touchesBegan(_ touches: Set <UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            self.controlPoint = 0
            self.points[0] = touchPoint
        }
        
        if let delegate = self.delegate {
            delegate.startedDrawing()
        }
    }
    
    override public func touchesMoved(_ touches: Set <UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            self.controlPoint += 1
            self.points[self.controlPoint] = touchPoint
            if (self.controlPoint == 4) {
                self.points[3] = CGPoint(x: (self.points[2].x + self.points[4].x)/2.0, y: (self.points[2].y + self.points[4].y)/2.0)
                self.path.move(to: self.points[0])
                self.path.addCurve(to: self.points[3], controlPoint1:self.points[1], controlPoint2:self.points[2])
                
                self.setNeedsDisplay()
                self.points[0] = self.points[3]
                self.points[1] = self.points[4]
                self.controlPoint = 1
            }
            
            self.setNeedsDisplay()
        }
    }
    
    override public func touchesEnded(_ touches: Set <UITouch>, with event: UIEvent?) {
        if self.controlPoint == 0 {
            let touchPoint = self.points[0]
            self.path.move(to: CGPoint(x: touchPoint.x-1.0,y: touchPoint.y))
            self.path.addLine(to: CGPoint(x: touchPoint.x+1.0,y: touchPoint.y))
            self.setNeedsDisplay()
        } else {
            self.controlPoint = 0
        }
        
        if let delegate = self.delegate {
            delegate.finishedDrawing()
        }
    }
    
    // MARK: - Methods for interacting with Signature View
    
    // Clear the Signature View
    public func clear() {
        self.path.removeAllPoints()
        self.setNeedsDisplay()
    }
    
    // Save the Signature as an UIImage
    public func getSignature(scale:CGFloat = 1) -> UIImage? {
        if !doesContainSignature { return nil }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        self.path.stroke()
        let signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return signature
    }
    
    // Save the Signature (cropped of outside white space) as a UIImage
    public func getCroppedSignature(scale:CGFloat = 1) -> UIImage? {
        guard let fullRender = getSignature(scale:scale) else { return nil }
        let bounds = self.scale(path.bounds.insetBy(dx: -strokeWidth/2, dy: -strokeWidth/2), byFactor: scale)
        guard let imageRef = fullRender.cgImage?.cropping(to: bounds) else { return nil }
        return UIImage(cgImage: imageRef)
    }
    
    
    private func scale(_ rect: CGRect, byFactor factor: CGFloat) -> CGRect
    {
        var scaledRect = rect
        scaledRect.origin.x *= factor
        scaledRect.origin.y *= factor
        scaledRect.size.width *= factor
        scaledRect.size.height *= factor
        return scaledRect
    }
}

@objc protocol SignatureCaptureDelegate: class {
    @objc func startedDrawing()
    @objc func finishedDrawing()
}
