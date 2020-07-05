//
//  DetailViewController.swift
//  GoodsComeTrue
//
//  Created by SWUCOMPUTER on 2020/07/02.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    var selectedData: GoodsData?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var goodsImage: UIImageView!
    @IBOutlet var textName: UILabel!
    @IBOutlet var textID: UILabel!
    @IBOutlet var textDate: UILabel!
    @IBOutlet var textPrice: UILabel!
    @IBOutlet var textMin: UILabel!
    @IBOutlet var textDes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let GoodsData = selectedData else { return }
        textName.text = GoodsData.name
        textID.text = GoodsData.userid
        textDate.text = GoodsData.date
        textPrice.text = GoodsData.price
        textMin.text = GoodsData.minimum
        textDes.numberOfLines = 0
        textDes.text = GoodsData.descrip
        var imageName = GoodsData.imagename
        // 숫자.jpg 로 저장된 파일 이름
        if (imageName != "") {
        let urlString = "http://condi.swu.ac.kr/student/T05/GoodsComeTrue/"
        imageName = urlString + imageName
        let url = URL(string: imageName)!
        if let imageData = try? Data(contentsOf: url) {
            goodsImage.image = UIImage(data: imageData)
        } }
    }
    
    func getContext()-> NSManagedObjectContext{
           return appDelegate.persistentContainer.viewContext
       }
    
    @IBAction func addZzim(_ sender: UIBarButtonItem) {
        guard let GoodsData = selectedData else { return }
        let context = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Zzim", in: context)
        
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(textName.text, forKey: "name")
        object.setValue(textID.text, forKey: "userid")
        object.setValue(textDate.text, forKey: "date")
        object.setValue(textPrice.text, forKey: "price")
        object.setValue(textMin.text, forKey: "minimum")
        object.setValue(textDes.text, forKey: "descrip")
        object.setValue(GoodsData.goodsno, forKey: "goodsno")
        object.setValue(GoodsData.imagename, forKey: "imagename")
        do{
            try context.save()
            print("saved!")
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func buttonDelete(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.userName == self.selectedData?.userid{

            let alert = UIAlertController(title: "게시글을 삭제하시겠습니까?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { action in
                let urlString: String = "http://condi.swu.ac.kr/student/T05/GoodsComeTrue/deleteFavorite.php"
                guard let requestURL = URL(string: urlString) else { return }
                var request = URLRequest(url: requestURL)
                request.httpMethod = "POST"
                guard let deleteNO = self.selectedData?.goodsno else { return }
                let restString: String = "favoriteno=" + deleteNO
                request.httpBody = restString.data(using: .utf8)
                let session = URLSession.shared
                let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else { return }
                    guard let receivedData = responseData else { return }
                    if let utf8Data = String(data: receivedData, encoding: .utf8) {
                        print(utf8Data)
                        //자료삭제
                        /*let context = self.getContext()
                        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Zzim")
                        var zzimArray : [NSManagedObject] = []
                        do{
                                   zzimArray = try context.fetch(fetchRequest)
                                   
                               }catch let error as NSError{
                                   print("Could not fetch. \(error), \(error.userInfo)")
                               }
                            for i in 0...zzimArray.count-1 {
                                if zzimArray[i].value(forKey: "name") as? String == self.selectedData?.name{
                                    DispatchQueue.main.async{

                                        zzimArray.remove(at: i)
                                    }
                                }
                            }*/
                    }
            }
            task.resume()
            self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else{
            let alert = UIAlertController(title: "작성자가 아닙니다.",
            message: "Delete Failed!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true)
                return
        }
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

