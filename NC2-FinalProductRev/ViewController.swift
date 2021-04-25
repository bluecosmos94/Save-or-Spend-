//
//  ViewController.swift
//  NC2-FinalProductRev
//
//  Created by Kelny Tan on 11/04/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var itemTableView: UITableView!
    var itemsPurchased: [Expenditure] = []
    // 3 properties below are meant as the textfield in alert box
    var itemTextField: UITextField!
    var qtyItemTextField: UITextField!
    var pricePerItemTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.dataSource = self
        itemTableView.delegate = self
    }
    
    // This function converts Double value into currency String
    func DoubleToCurrency(d: Double) -> String{
        let converter = NumberFormatter()
        converter.numberStyle = .currency
        converter.locale = Locale(identifier: "id-ID")
        let output: String = converter.string(from: NSNumber(value: d))!
        return output
    }
    
    func indoStringToDouble(s: String) -> Double?{
        let converter = NumberFormatter()
        converter.numberStyle = .decimal
        converter.groupingSeparator = "."
        converter.decimalSeparator = ","
        converter.locale = Locale(identifier: "id-ID")
        let output: Double = converter.number(from: s) as? Double ?? 0.0
        return output
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsPurchased.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = itemsPurchased[indexPath.row].itemName
        cell.detailTextLabel?.text = String(itemsPurchased[indexPath.row].qtyItem) + "@" + DoubleToCurrency(d: itemsPurchased[indexPath.row].pricePerItem) + "/item"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
        if editingStyle == .delete {
                
            // delete the record from collection
            self.itemsPurchased.remove(at: indexPath.row)
                
            //delete row from tableview
            tableView.deleteRows(at: [indexPath], with: .fade)
                
            //refresh tableview
            tableView.reloadData()
        }
    }
    
    
    @IBAction func addItemPurchased(_ sender: Any) {
        displayForm(message: "")
    }
    
    func displayForm(message: String)
    {
        // Create alert
        let alert = UIAlertController(title:"Enter your expense", message: message, preferredStyle: .alert)
            
        // Create cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
        // Done button
        let done = UIAlertAction(title: "Done", style: .default){(action) -> Void in self.validateInput()}
            
        // add the buttons to AlertController
        alert.addAction(done)
        alert.addAction(cancel)
            
        // create text fields for the items in the TableView
        alert.addTextField(configurationHandler: {(textField: UITextField!) in textField.placeholder = "Type item here:"
            self.itemTextField = textField
        })
        alert.addTextField(configurationHandler: {(textField: UITextField!) in textField.placeholder = "Type quantity here (in numbers only):"
            self.qtyItemTextField = textField
        })
        alert.addTextField(configurationHandler: {(textField: UITextField!) in textField.placeholder = "Type price per item here:(in Rp, numbers)"
            self.pricePerItemTextField = textField
        })
            
        self.present(alert, animated: true, completion: nil)
    }
        
    func validateInput(){
    // checking if the forms are empty
        if((self.itemTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!){
            self.itemTextField.text = ""
            self.displayForm(message: "Please enter a valid value")
        }
            
        if((self.qtyItemTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!){
            self.qtyItemTextField.text = ""
            self.displayForm(message: "Please enter a valid value")
        }
        
            
        if((self.pricePerItemTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!){
            self.pricePerItemTextField.text = ""
            self.displayForm(message: "Please enter a valid value")
        }
        
        // no empty values
        else
        {
            if(Int(self.qtyItemTextField.text!) != nil && indoStringToDouble(s: self.pricePerItemTextField.text!) != nil){
                addItem(itemName: self.itemTextField.text!, qty: Int(self.qtyItemTextField.text!)!, price: indoStringToDouble(s: self.pricePerItemTextField.text!)!)
            }
            else{
                self.displayForm(message: "Please enter numeric values for qty and price!")
            }
        }
    }
        
    func addItem(itemName: String, qty: Int, price: Double)
    {
        self.itemsPurchased.append(Expenditure(itemName: itemName, qtyItem: qty, pricePerItem: price))
            
        let index: Int = self.itemsPurchased.count - 1
            
        let indexPath = IndexPath(item: index, section: 0)
            
        self.itemTableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination.isKind(of: SegueController.self)){
            let dest = segue.destination as! SegueController
            for i in itemsPurchased{
                dest.itemsSummed.append(i)
            }
        }
    }
}

