//
//  ViewController.swift
//  FloatingView
//
//  Created by ELORCE INDUSTRIES PRIVATE LIMITED on 11/01/22.
//

import UIKit

class ViewController: UIViewController {

    let viewDrag = UIView(frame: CGRect(x: 30, y: 30, width: 100, height: 100))
    var panGesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFloatingView()
    }

    private func addFloatingView() {
        viewDrag.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        viewDrag.clipsToBounds = true
        viewDrag.layer.cornerRadius = 50
        viewDrag.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        viewDrag.layer.borderWidth = 3.0
        
        //Adding pangesture to drag view
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        viewDrag.isUserInteractionEnabled = true
        viewDrag.addGestureRecognizer(panGesture)
        
        self.view.addSubview(viewDrag)
    }
    
    @objc func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {

        // 1. use these values to restrict the left and right sides so the orangeImageView won't go beyond these points
        let leftSideRestrction = self.view.frame.minX
        let rightSideRestriction = self.view.frame.maxX
        
        let topSideRestrction = self.view.frame.minY
        let bottomSideRestriction = self.view.frame.maxY

        // 2. use these values to redraw the orangeImageView's correct size in either Step 6 or Step 8 below
        let imageViewHeight = self.viewDrag.frame.size.height
        let imageViewWidth = self.viewDrag.frame.size.width

        if gestureRecognizer.state == .changed || gestureRecognizer.state == .began {

            let translation: CGPoint = gestureRecognizer.translation(in: self.view)
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x  + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)

            /*
             3.
             -get the the upper left hand corner of the imageView's X and Y origin to get the current location of the imageView as it's dragged across the screen.
             -you need the orangeImageView.frame.origin.x value to make sure it doesn't go beyond the left or right edges
             -you need the orangeImageView.frame.origin.y value to redraw it in Steps 6 and 8 at whatever Y position it's in when it hits either the left or right sides
            */
            let imageViewCurrentOrginXValue = self.viewDrag.frame.origin.x
            let imageViewCurrentOrginYValue = self.viewDrag.frame.origin.y

            // 4. get the right side of the orangeImageView. It's computed using the orangeImageView.frame.origin.x + orangeImageView.frame.size.width
            let imageViewRightEdgePosition = imageViewCurrentOrginXValue + imageViewWidth
            let imageViewBottomEdgePosition = imageViewCurrentOrginYValue + imageViewHeight

            // 5. if the the orangeImageView.frame.origin.x touches the left edge of the screen or beyond it proceed to Step 6
            if imageViewCurrentOrginXValue <= leftSideRestrction {

                // 6. redraw the orangeImageView's frame with x: being the far left side of the screen and Y being where ever the current orangeImageView.frame.origin.y is currently positioned at
                viewDrag.frame = CGRect(x: leftSideRestrction, y: imageViewCurrentOrginYValue, width: imageViewWidth, height: imageViewHeight)
            }

            // 7. if the the orangeImageView.frame.origin.x touches the right edge of the screen or beyond it proceed to Step 8
            if imageViewRightEdgePosition >= rightSideRestriction{

                // 8. redraw the orangeImageView's frame with x: being the rightSide of the screen - the orangeImageView's width and y: being where ever the current orangeImageView.frame.origin.y is currently positioned at
                viewDrag.frame = CGRect(x: rightSideRestriction - imageViewWidth, y: imageViewCurrentOrginYValue, width: imageViewWidth, height: imageViewHeight)
            }
            
            if imageViewCurrentOrginYValue <= topSideRestrction {

                // 8. redraw the orangeImageView's frame with x: being the rightSide of the screen - the orangeImageView's width and y: being where ever the current orangeImageView.frame.origin.y is currently positioned at
                viewDrag.frame = CGRect(x: imageViewCurrentOrginXValue, y: topSideRestrction, width: imageViewWidth, height: imageViewHeight)
            }
            
            if imageViewBottomEdgePosition >= bottomSideRestriction {

                // 8. redraw the orangeImageView's frame with x: being the rightSide of the screen - the orangeImageView's width and y: being where ever the current orangeImageView.frame.origin.y is currently positioned at
                viewDrag.frame = CGRect(x: imageViewCurrentOrginXValue, y: bottomSideRestriction - imageViewHeight, width: imageViewWidth, height: imageViewHeight)
            }
        }
    }
}
