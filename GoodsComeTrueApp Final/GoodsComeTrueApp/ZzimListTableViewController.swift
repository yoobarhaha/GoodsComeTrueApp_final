//
//  ZzimListTableViewController.swift
//  GoodsComeTrueApp
//
//  Created by SWUCOMPUTER on 2020/07/04.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class ZzimListTableViewController: UITableViewController {

    var zzimArray : [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Zzim")
        let sortDescriptor = NSSortDescriptor (key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            zzimArray = try context.fetch(fetchRequest)
            
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toZzimDetailView"{
            if let destination = segue.destination as? ZzimDetailViewController{
            if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row{
                destination.detailZzim = zzimArray[selectedIndex]
                
                }
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return zzimArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Zzim Cell", for: indexPath)

        let zzim = zzimArray[indexPath.row]
        if let nameLabel = zzim.value(forKey: "name") as? String{
            cell.textLabel?.text = nameLabel
        }
        if let textDate = zzim.value(forKey: "date") as? String{
            cell.detailTextLabel?.text = textDate
        }

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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = getContext()
            context.delete(zzimArray[indexPath.row])
            do{
                try context.save()
                print("delete")
            } catch let error as NSError{
                print("Could not delete \(error), \(error.userInfo)")
            }
            zzimArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
