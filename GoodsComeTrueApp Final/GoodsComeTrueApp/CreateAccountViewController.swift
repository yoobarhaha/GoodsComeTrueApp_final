//
//  CreateAccountViewController.swift
//  GoodsComeTrue
//
//  Created by SWUCOMPUTER on 2020/07/01.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var createID: UITextField!
    @IBOutlet var createPW: UITextField!
    @IBOutlet var createName: UITextField!
    @IBOutlet var labelStatus: UILabel!
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
       if textField == self.createID{
            textField.resignFirstResponder()
            self.createPW.becomeFirstResponder()
        }
        else if textField == self.createPW{
            textField.resignFirstResponder()
            self.createName.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func executeRequest(request: URLRequest)->Void{
        let session = URLSession.shared
        let task = session.dataTask(with: request){(responseData, response, responseError) in guard responseError == nil else{
            print("Error : calling POST")
            return
            }
            guard let receivedData = responseData else{
                print("Error: not receiving Data")
                return
            }
            if let utf8Data = String(data: receivedData, encoding: .utf8){
                DispatchQueue.main.async{
                    self.labelStatus.text = utf8Data
                    print(utf8Data)
                }
            }
        }
        task.resume()
    }
    @IBAction func AccountSave(_ sender: Any) {
        
        if createID.text==""{
            labelStatus.text="아이디 입력 바람";
            return;
        }
        if createPW.text==""{
            labelStatus.text="비번 입력 바람";
            return;
        }
        if createName.text==""{
            labelStatus.text="이름 입력 바람";
            return;
        }
        let urlString: String = "http://condi.swu.ac.kr/student/T05/login/insertUser.php"
            
        guard let requestURL = URL(string: urlString) else{
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod="POST"
        let restString: String = "id="+createID.text!+"&password="+createPW.text!+"&name="+createName.text!
        request.httpBody=restString.data(using: .utf8)
        self.executeRequest(request: request)
    }
    @IBAction func moveLogin(_ sender: Any) {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let naviViewController = storyboard.instantiateViewController(withIdentifier: "LoginView")
           naviViewController.modalPresentationStyle = .fullScreen
           self.present(naviViewController, animated: true, completion: nil)
       }
}

