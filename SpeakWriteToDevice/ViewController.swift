//
//  ViewController.swift
//  SpeakWriteToDevice
//
//  Created by 近藤宏輝 on 2020/02/09.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    
    @IBAction func recordButtonTapped(_ sender: Any) {
    }
    
}

/*
 参考にしたサイト
 【Speech Framework】音声認識してテキストを入力する
 https://qiita.com/chino_tweet/items/027c432cfb983f95679a
 */

