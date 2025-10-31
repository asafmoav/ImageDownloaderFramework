//
//  ViewController.swift
//  SampleApp
//
//  Created by Asaf Moav on 30/10/2025.
//

import UIKit
import ImageDownloaderFramework

class ViewController: UIViewController {
    @IBOutlet weak var imageView: BestAsyncImageView!
    @IBOutlet weak var imageView2: BestAsyncImageView!
    @IBOutlet weak var imageView3: BestAsyncImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.load(url: URL(string: Constants.imageURL1)!, placeholder: UIImage(named: Constants.placeholderName1))
    }

    @IBAction func buttonTapped(_ sender: Any) {
        imageView2.load(url: URL(string: Constants.imageURL1)!, placeholder: UIImage(named: Constants.placeholderName1))
        imageView3.load(url: URL(string: Constants.imageURL2)!, placeholder: UIImage(named: Constants.placeholderName2))
    }
    
    @IBAction func invalidateTapped(_ sender: Any) {
        BestImageCacheHelper.invalidateAll()
    }
    
}

