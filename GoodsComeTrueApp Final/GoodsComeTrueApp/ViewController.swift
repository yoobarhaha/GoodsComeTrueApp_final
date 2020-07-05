//
//  ViewController.swift
//  GoodsComeTrueApp
//
//  Created by SWUCOMPUTER on 2020/07/04.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var logoutBtn: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.userName == ""{
            logoutBtn.isHidden = true
            loginBtn.isHidden = false
        }else{
            loginBtn.isHidden = true
            logoutBtn.isHidden = false
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in let urlString:
            String = "http://condi.swu.ac.kr/student/T05/login/logout.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { return } }
            task.resume()
            self.loginBtn.isHidden=false
            self.logoutBtn.isHidden=true
            self.appDelegate.userName = ""
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func moveTable(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let naviViewController = storyboard.instantiateViewController(withIdentifier: "TableView")
        naviViewController.modalPresentationStyle = .fullScreen
        self.present(naviViewController, animated: true, completion: nil)
    }
    
    @IBAction func moveZzim(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let naviViewController = storyboard.instantiateViewController(withIdentifier: "ZzimTableView")
        naviViewController.modalPresentationStyle = .fullScreen
        self.present(naviViewController, animated: true, completion: nil)
    }
    

}

