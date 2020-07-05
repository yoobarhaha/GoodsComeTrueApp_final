//
//  UploadViewController.swift
//  GoodsComeTrue
//
//  Created by SWUCOMPUTER on 2020/07/01.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var goodsName: UITextField!
    @IBOutlet var goodsPrice: UITextField!
    @IBOutlet var goodsMin: UITextField!
    @IBOutlet var textDescription: UITextView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var buttonCamera: UIButton! // 카메라가 없을 경우 Disable 시키기 위함

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="굿즈컴트루 제작소"
        
        if !(UIImagePickerController.isSourceTypeAvailable(.camera)) {
        let alert = UIAlertController(title: "Error!!", message: "Device has no Camera!",
        preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        buttonCamera.isEnabled = false // 카메라 버튼 사용을 금지시킴
            
        }
    }
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        if textField == self.goodsName{
             textField.resignFirstResponder()
            self.goodsPrice.becomeFirstResponder()
         }
        else if textField == self.goodsPrice{
             textField.resignFirstResponder()
            self.goodsMin.becomeFirstResponder()
         }
         else if textField == self.goodsMin{
            self.textDescription.becomeFirstResponder()
         }
        textField.resignFirstResponder()
        return true
         
     }
    
    @IBAction func uploadGoods(_ sender: UIBarButtonItem) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let name = goodsName.text!
        let price = goodsPrice.text!
        let min = goodsMin.text!
        let description = textDescription.text!
        if (name == "" || price == "" || min == "" || description == "") {
        let alert = UIAlertController(title: "빈 칸을 채워주세요.",
        message: "Save Failed!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
            return
            
        }
        if (appDelegate.userName == "") {
        let alert = UIAlertController(title: "로그인 후 이용해주세요.",
        message: "Save Failed!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
            return
            
        }
        guard let goodsImage = imageView.image else {
        let alert = UIAlertController(title: "이미지를 선택하세요",
        message: "Save Failed!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        alert.dismiss(animated: true, completion: nil) }))
        self.present(alert, animated: true)
            return
            
        }
        let myUrl = URL(string: "http://condi.swu.ac.kr/student/T05/GoodsComeTrue/upload.php");
        var request = URLRequest(url:myUrl!);
        request.httpMethod = "POST";
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)",
        forHTTPHeaderField: "Content-Type")
        guard let imageData = goodsImage.jpegData(compressionQuality:1) else {
            return }
        var body = Data()
        var dataString = "--\(boundary)\r\n"
        dataString += "Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n"
        dataString += "Content-Type: application/octet-stream\r\n\r\n"
        if let data = dataString.data(using: .utf8) { body.append(data) }
        // imageData 위 아래로 boundary 정보 추가
        body.append(imageData)
        dataString = "\r\n"
        dataString += "--\(boundary)--\r\n"
        if let data = dataString.data(using: .utf8) { body.append(data) }
        request.httpBody = body
        var imageFileName: String = ""
        let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else {
                print("Error: calling POST");
                return
                
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
                
            }
        if let utf8Data = String(data: receivedData, encoding: .utf8) { // 서버에 저장한 이미지 파일 이름
                imageFileName = utf8Data
                print(imageFileName)
                semaphore.signal()
            }
            
        }
        task.resume()
        // 이미지 파일 이름을 서버로 부터 받은 후 해당 이름을 DB에 저장하기 위해 wait()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        let urlString: String = "http://condi.swu.ac.kr/student/T05/GoodsComeTrue/insertFavorite.php"
        guard let requestURL = URL(string: urlString) else { return }
        request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        guard let userID = appDelegate.userName else { return }
        print(userID)//확인
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myDate = formatter.string(from: Date())
        var restString: String = "name=" + name + "&userid="+userID+"&price=" + price + "&minimum=" + min
        restString += "&descrip=" + description
        restString += "&image=" + imageFileName + "&date=" + myDate
        print(restString)
        request.httpBody = restString.data(using: .utf8)
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else {
            print("Error: calling POST")
            return
            
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return }
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async{
                    print(utf8Data)
                }
            }
        }
        task2.resume()
 
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func takePicture(_ sender: UIButton) {
    let myPicker = UIImagePickerController()
    myPicker.delegate = self;
    myPicker.allowsEditing = true
    myPicker.sourceType = .camera
    self.present(myPicker, animated: true, completion: nil)
   }
   
   @IBAction func selectPicture(_ sender: UIButton) {
       let myPicker = UIImagePickerController()
       myPicker.delegate = self;
       myPicker.sourceType = .photoLibrary
       self.present(myPicker, animated: true, completion: nil)
       
   }
          // 앨범에서 이미지 선택을 위한 함수
   func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           self.imageView.image = image
       }
       self.dismiss(animated: true, completion: nil) }
   func imagePickerControllerDidCancel (_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
   }
       
    
}

