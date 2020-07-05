//
//  LoginViewController.swift
//  GoodsComeTrue
//
//  Created by SWUCOMPUTER on 2020/07/01.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet var loginID: UITextField!
    @IBOutlet var loginPW: UITextField!
    @IBOutlet var labelStatus: UILabel!
    @IBOutlet var welcomName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField==self.loginID{
            textField.resignFirstResponder()
            self.loginPW.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
   

    @IBAction func Login(_ sender: UIButton) {

            if loginID.text==""{
            labelStatus.text="ID를 입력하세요";
            return;
            }
            if loginPW.text==""{
            labelStatus.text="비번 입력 바람";
            return;
            }

            let urlString: String = "http://condi.swu.ac.kr/student/T05/login/loginUser.php"
            guard let requestURL = URL(string: urlString) else{
                return
            }
            self.labelStatus.text=""
            
            var request = URLRequest(url: requestURL)
            request.httpMethod="POST"
            let restString: String = "id="+loginID.text!+"&password="+loginPW.text!
            
            request.httpBody = restString.data(using: .utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request){ (responseData, response, responseError) in guard responseError == nil else{
                    print("Error: calling POST")
                    return
                }
                guard let receivedDtata = responseData else{
                    print("Error: not receiving Data")
                    return
                }
                do{
                    let response = response as! HTTPURLResponse
                    if !(200...299 ~= response.statusCode){
                        print("HTTP Error!")
                        print(response.statusCode)
                        return
                    }
                    guard let jsonData = try JSONSerialization.jsonObject(with: receivedDtata,options: .allowFragments) as? [String:Any] else{
                    print("JSON Serialization Error!")
                    return
                    }
                    guard let success = jsonData["success"] as? String else{
                        print("Error: PHP failure(success)")
                        return
                    }
                    if success=="YES"{
                        if let name = jsonData["name"] as? String{
                            DispatchQueue.main.async {
                                self.welcomName.text=name
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                //appDelegate.userName = self.loginUserid.text
                                appDelegate.userName = name
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let naviViewController = storyboard.instantiateViewController(withIdentifier: "MainView")
                                naviViewController.modalPresentationStyle = .fullScreen
                                self.present(naviViewController, animated: true, completion: nil)
                            }
                        }
                    }
                    else{
                        if let errMessage = jsonData["error"] as? String {
                            DispatchQueue.main.async {
                                self.labelStatus.text = errMessage
                            }
                        }
                    }
                        
                } catch{
                    print("Error: \(error)")
                }
            }
            task.resume()
    }
   

}
