//
//  InComingEventViewController.swift
//  MvvmExampleSwift5.0
//
//  Created by Bekir on 14.01.2020.
//  Copyright © 2020 Bekir. All rights reserved.
//

import UIKit

class InComingEventViewController: BaseViewController, BaseViewControllerProtocol {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        self.viewModel = InComingEventViewModel()
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
