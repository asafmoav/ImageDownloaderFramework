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
        // Do any additional setup after loading the view.
        imageView.load(url: URL(string: "https://fastly.picsum.photos/id/1005/200/300.jpg?hmac=ZygrmRTuNYz9HivXcWqFGXDRVJxIHzaS-8MA0I3NKBw")!, placeholder: UIImage(named: "placeholder"))
    }

    @IBAction func buttonTapped(_ sender: Any) {
        imageView2.load(url: URL(string: "https://fastly.picsum.photos/id/1005/200/300.jpg?hmac=ZygrmRTuNYz9HivXcWqFGXDRVJxIHzaS-8MA0I3NKBw")!, placeholder: UIImage(named: "placeholder"))
        imageView3.load(url: URL(string: "https://fastly.picsum.photos/id/1076/200/200.jpg?hmac=KTOq4o7b6rXzwd8kYN0nWrPIeKI97mzxBdWhnn-o-Nc")!, placeholder: UIImage(named: "building"))
    }
    
}

