//
//  ContainerViewController+Ext.swift
//  RWBlueLibrary
//
//  Created by Qaptive Technologies on 02/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit

extension ContainerViewController: UIGestureRecognizerDelegate {
  
  @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
    funcs.gestureAction(recognizer)
  }
  
}
