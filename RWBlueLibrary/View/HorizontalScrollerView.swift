//
//  HorizontalScrollerView.swift
//  RWBlueLibrary
//
//  Created by Qaptive Technologies on 30/04/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit

protocol HorizontalScrollerViewDataSource: class {

  func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int
  func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView
}

protocol HorizontalScrollerViewDelegate: class {
  func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int)
}

class HorizontalScrollerView: UIView {

  weak var dataSource: HorizontalScrollerViewDataSource?
  weak var delegate: HorizontalScrollerViewDelegate?
  
  private enum ViewConstants {
    static let Padding: CGFloat = 10
    static let Dimensions: CGFloat = 100
    static let Offset: CGFloat = 100
  }
  
  private let scroller = UIScrollView()
  private var contentViews = [UIView]()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initializeScrollView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initializeScrollView()
  }
  
  func initializeScrollView() {
    scroller.delegate = self
    scroller.showsHorizontalScrollIndicator = false
    addSubview(scroller)
    scroller.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      scroller.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      scroller.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      scroller.topAnchor.constraint(equalTo: self.topAnchor),
      scroller.bottomAnchor.constraint(equalTo: self.bottomAnchor)
      ])
  
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollerTapped(gesture:)))
    scroller.addGestureRecognizer(tapRecognizer)
  }
  
  @objc func scrollerTapped(gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: scroller)
    guard let index = contentViews.index(where: { $0.frame.contains(location)}) else { return }
    let centralView = contentViews[index]
    animateView(centralView, index)
    
    self.delegate?.horizontalScrollerView(self, didSelectViewAt: index)
    self.scrollToView(at: index)
    
  }
  
  //MARK:
  func restoreUntapped(index: Int) {
    let _ = contentViews.enumerated().map { (arg0) -> Void in
      let (i,view) = arg0
      
      if i != index {
        animate {
          view.transform = .identity
        }
      }
    }
  }
  
  func scrollToView(at index: Int, animated: Bool = true) {
    let centralView = contentViews[index]
    
    animateView(centralView, index)
    let targetCenter = centralView.center
    let targetOffsetX = targetCenter.x - (scroller.bounds.width / 2)
    
    scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: animated)
  }
  
  func view(at index :Int) -> UIView {
    let view = contentViews[index]
    return view
  }
  
  //MARK:
  func animateView(_ view: UIView,_ index: Int) {
    
    animate {
      view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    restoreUntapped(index: index)
  }
  
  //MARK:
  func animate(_ comp: @escaping () -> ()) {
    UIView.animate(withDuration: 0.3) {
      comp()
    }
  }
  
  func reload() {

    guard let dataSource = dataSource else { return }
    contentViews.forEach { $0.removeFromSuperview() }

    var xValue = ViewConstants.Offset
    contentViews = (0..<dataSource.numberOfViews(in: self)).map {
      index in
      xValue += ViewConstants.Padding
      let view = dataSource.horizontalScrollerView(self, viewAt: index)
      view.frame = CGRect(x: CGFloat(xValue), y: bounds.midY - (ViewConstants.Dimensions / 2) , width: ViewConstants.Dimensions, height: ViewConstants.Dimensions)
      view.layer.cornerRadius = 50
      view.clipsToBounds = true
      scroller.addSubview(view)
      xValue += ViewConstants.Dimensions + ViewConstants.Padding
      return view
    }
    scroller.contentSize = CGSize(width: CGFloat(xValue + ViewConstants.Offset), height: frame.size.height)
  }
  
  private func centerCurrentView() {
    let centerRect = CGRect(
      origin: CGPoint(x: scroller.bounds.midX - ViewConstants.Padding, y: 0),
      size: CGSize(width: ViewConstants.Padding, height: bounds.height)
    )
    
    guard let selectedIndex = contentViews.index(where: { $0.frame.intersects(centerRect) }) else { return }
    let centralView = contentViews[selectedIndex]
    animateView(centralView, selectedIndex)
    let targetCenter = centralView.center
    let targetOffsetX = targetCenter.x - (scroller.bounds.width / 2)

    scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
    
    delegate?.horizontalScrollerView(self, didSelectViewAt: selectedIndex)
  }
  
}


extension HorizontalScrollerView: UIScrollViewDelegate {

  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let centerRect = CGRect(
      origin: CGPoint(x: scroller.bounds.midX - ViewConstants.Padding, y: 0),
      size: CGSize(width: ViewConstants.Padding, height: bounds.height)
    )
    
    guard let selectedIndex = contentViews.index(where: { $0.frame.intersects(centerRect) }) else { return }
    let centralView = contentViews[selectedIndex]
    animateView(centralView, selectedIndex)

  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      centerCurrentView()
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    centerCurrentView()
  }
  
}
