//
//  ZzimDetailViewController.swift
//  GoodsComeTrueApp
//
//  Created by SWUCOMPUTER on 2020/07/04.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class ZzimDetailViewController: UIViewController {

    @IBOutlet var textName: UILabel!
    @IBOutlet var textId: UILabel!
    @IBOutlet var textDate: UILabel!
    @IBOutlet var textPrice: UILabel!
    @IBOutlet var textMin: UILabel!
    @IBOutlet var textDes: UILabel!
    @IBOutlet var zzimImage: UIImageView!
    
    var detailZzim: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let zzim = detailZzim{
            textName.text = zzim.value(forKey: "name") as? String
            textId.text = zzim.value(forKey: "userid") as? String
            textDate.text = zzim.value(forKey: "date") as? String
            textPrice.text = zzim.value(forKey: "price") as? String
            textMin.text = zzim.value(forKey: "minimum") as? String
            textDes.text = zzim.value(forKey: "descrip") as? String
            var imageName = zzim.value(forKey: "imagename") as? String
            if let imageN = imageName {
                var imageName2: String
                 let urlString = "http://condi.swu.ac.kr/student/T05/GoodsComeTrue/"
                 imageName2 = urlString + imageN
                 print(imageName!)
                 let url = URL(string: imageName2)!
                 if let imageData = try? Data(contentsOf: url) {
                     zzimImage.image = UIImage(data: imageData)
                    
                }
                
            }
            
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
