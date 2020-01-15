//
//  OnSaleEventViewController.swift
//  MvvmExampleSwift5.0
//
//  Created by Bekir on 14.01.2020.
//  Copyright © 2020 Bekir. All rights reserved.
//

import UIKit

class OnSaleEventViewController:BaseViewController, BaseViewControllerProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
        // Do any additional setup after loading the view.
    }

    func bindViewModel() {
        self.viewModel = OnSaleEventViewModel()
        self.viewModel?.changeHandler = {
            [unowned self] change in
            switch change {
            case .error(let message):
               // Error Pop-Up
                break
            case .loaderEnd:
                self.removeSpinner()
                break
            case .loaderStart:
                self.showSpinner(onView: self.view)
                break
            case .updateDataModel:
                // BindData
                break
            }
        }
    }
    
    func setupUI() {
        self.viewModel?.startSynching()
    }

}
