//
//  ViewController.swift
//  ShtLoggerDemo-iOS
//
//  Created by Александр Тихомиров on 2023-10-02.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        logger.log(event: ShtEventCommon.create(.controller), controller: self)
    }


}

