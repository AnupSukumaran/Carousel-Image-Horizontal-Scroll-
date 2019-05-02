//
//  ContainerViewModel.swift
//  RWBlueLibrary
//
//  Created by Qaptive Technologies on 02/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit

class ContainerViewModel: NSObject {
  
  weak var main: ContainerViewController!
  var centerViewController: CenterViewController!
  
  let centerPanelExpandedOffset: CGFloat = 150
  
  init(main: ContainerViewController) {
    self.main = main
  }
  
  //MARK:
  func addingCenterChildView() {
    centerViewController = UIStoryboard.centerViewController()
    main.view.addSubview(centerViewController.view)
    main.addChildViewController(centerViewController)
    centerViewController.didMove(toParentViewController: main)
    centerViewController.view.frame.origin.y = main.view.bounds.height - centerPanelExpandedOffset
  }
  
  //MARK:
  func addPanGesture() {
    let panGestureRecognizer = UIPanGestureRecognizer(target: main, action: #selector(main.handlePanGesture(_:)))
    centerViewController.view.addGestureRecognizer(panGestureRecognizer)
  }
  
  //MARK:
  func gestureAction(_ recognizer: UIPanGestureRecognizer) {
    
    switch recognizer.state {
    case .began:
      break
      
    case .changed:
      changed(recognizer)
      
    case .ended:
      ended(recognizer)
      
    default:
      break
      
    }
    
  }
  
  //MARK:
  func changed(_ recognizer: UIPanGestureRecognizer) {
    if let rview = recognizer.view {
      rview.center.y = rview.center.y + recognizer.translation(in: main.view).y
      recognizer.setTranslation(CGPoint.zero, in: main.view)
    }
  }
  
  //MARK:
  func ended(_ recognizer: UIPanGestureRecognizer) {
    if let rview = recognizer.view {
      
      let hasMovedHalfwayUp = rview.center.y < (main.view.bounds.size.height - centerPanelExpandedOffset + 300)
      print("Center = \(rview.center.y),Point = \(main.view.bounds.size.height - centerPanelExpandedOffset + 300)")
      if hasMovedHalfwayUp {
        let targetPos = centerPanelExpandedOffset + 100
        animateCenterPanelYPosition(targetPosition: targetPos)
      } else {
        let targetPos = main.view.bounds.size.height - centerPanelExpandedOffset
        animateCenterPanelYPosition(targetPosition: targetPos)
      }
      
    }
  }
  
  func animateCenterPanelYPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
    
    UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
      self.centerViewController.view.frame.origin.y = targetPosition
    }, completion: completion)
  }
  
}
