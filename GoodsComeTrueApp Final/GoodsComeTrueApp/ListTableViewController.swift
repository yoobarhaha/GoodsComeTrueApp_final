//
//  ListTableViewController.swift
//  GoodsComeTrue
//
//  Created by SWUCOMPUTER on 2020/07/01.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="굿즈컴트루 제작소"
        self.downloadDataFromServer()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Get the new view controller using segue.destinationViewController. // Pass the selected object to the new view controller.
        if segue.identifier == "toDetailView" {
        if let destination = segue.destination as? DetailViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    let data = fetchedArray[selectedIndex]
                    destination.selectedData = data
                    destination.title = data.name
                    }
            }
        }
    }
    
    var fetchedArray: [GoodsData] = Array()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.downloadDataFromServer()
    }
    func downloadDataFromServer() -> Void {
        let urlString: String = "http://condi.swu.ac.kr/student/T05/GoodsComeTrue/favoriteTable.php"
            guard let requestURL = URL(string: urlString) else {
                return
            }
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            let response = response as! HTTPURLResponse
            if !(200...299 ~= response.statusCode) {
                print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData, options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        var newData: GoodsData = GoodsData()
                        var jsonElement = jsonData[i]
                        newData.goodsno = jsonElement["goodsno"] as! String
                        newData.userid = jsonElement["userid"] as! String
                        newData.name = jsonElement["name"] as! String
                        newData.price = jsonElement["price"] as! String
                        newData.descrip = jsonElement["descrip"] as! String
                        newData.minimum = jsonElement["minimum"] as! String
                        newData.date = jsonElement["date"] as! String
                        newData.imagename = jsonElement["imagename"] as! String
                        self.fetchedArray.append(newData)
                }
                 DispatchQueue.main.async{
                    self.tableView.reloadData()
                    }
                }
            }
            catch { print("Error: Catch") }
            
            }
            task.resume()
        
    }
     
      override func numberOfSections(in tableView: UITableView) -> Int {
          // #warning Incomplete implementation, return the number of sections
          return 1
      }

      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          // #warning Incomplete implementation, return the number of rows
        return fetchedArray.count
      }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Goods Cell", for: indexPath)
        let item = fetchedArray[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.date

        return cell
    }
    @IBAction func moveMain(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let naviViewController = storyboard.instantiateViewController(withIdentifier: "MainView")
        naviViewController.modalPresentationStyle = .fullScreen
        self.present(naviViewController, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

