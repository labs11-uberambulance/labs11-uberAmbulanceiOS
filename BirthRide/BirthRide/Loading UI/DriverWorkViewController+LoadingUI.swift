//
//  DriverWorkViewController+LoadingUI.swift
//  BirthRide
//
//  Created by Austin Cole on 4/3/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import CoreGraphics

extension DriverWorkViewController {
    //MARK: Private Methods
    private func createIndeterminateLoadingView() {
        if self.loadingView == nil {
            self.loadingView = IndeterminateLoadingView(frame: CGRect(x: view.center.x - 50, y: view.center.y - 175, width: 100, height: 100))
        }
    }
    private func addToSubview() {
        if self.isSubviewOfSuperview == false {
            view.addSubview(self.loadingView!)
        }
    }
    
    //MARK: Public Methods
    public func animateLoadingView() {
        createIndeterminateLoadingView()
        addToSubview()
        if !(self.loadingView?.isAnimating)! {
            self.loadingView?.startAnimating()
            self.isSubviewOfSuperview = true
        }
    }
    public func stopAnimatingLoadingView(){
        self.loadingView?.stopAnimating()
        self.loadingView?.removeFromSuperview()
        self.isSubviewOfSuperview = false
    }
}
