//
//  BaseViewController.swift
//  MvvmExampleSwift5.0
//
//  Created by Bekir on 14.01.2020.
//  Copyright © 2020 Bekir. All rights reserved.
//

import UIKit

protocol BaseViewControllerProtocol {    
    func bindViewModel()
    func setupUI()
}

public class BaseViewController: UIViewController {
    var viewModel: BaseViewModel?
    let baseData  =  BaseData.sharedInstance
    let restClient = RestClient.sharedInstance
    var loading : UIView?
      
    public func showSpinner(onView : UIView) {
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = onView.center
             
        DispatchQueue.main.async {
            onView.addSubview(ai)
        }
        loading = ai
    }
    
    override public func viewDidLayoutSubviews() {
        self.loading?.center = self.view.center
    }
    
    public func removeSpinner() {
        DispatchQueue.main.async {
            self.loading?.removeFromSuperview()
            self.loading = nil
        }
    }
    
}
