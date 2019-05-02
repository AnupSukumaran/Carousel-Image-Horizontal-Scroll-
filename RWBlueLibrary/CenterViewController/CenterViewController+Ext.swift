//
//  CenterViewController+Ext.swift
//  RWBlueLibrary
//
//  Created by Qaptive Technologies on 02/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit

extension CenterViewController:HorizontalScrollerViewDelegate {
  func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int) {
      funcs.horizontalScrollerView_didSelect(index: index)
  }
}

extension CenterViewController:HorizontalScrollerViewDataSource {
  func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int {
   // return funcs.allAlbums.count
    return 10
  }
  
  func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView {
    return funcs.horizontalScrollerView_Data(index)
  }
  
}
