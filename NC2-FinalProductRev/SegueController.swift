//
//  SegueController.swift
//  NC2-FinalProductRev
//
//  Created by Kelny Tan on 11/04/21.
//

import UIKit

class SegueController: UIViewController {
    var itemsSummed: [Expenditure] = []
    var allowanceGiven: Double = 0.0
    var sumExpenses: Double = 0.0

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var allowanceTextField: UITextField!
    @IBOutlet weak var expenseLabel: UILabel!
    
    
    func DoubleToCurrency(d: Double) -> String{
        let converter = NumberFormatter()
        converter.numberStyle = .currency
        converter.locale = Locale(identifier: "id-ID")
        let output: String = converter.string(from: NSNumber(value: d))!
        return output
    }
    
    func indoStringToDouble(s: String) -> Double? {
        let converter = NumberFormatter()
        converter.numberStyle = .decimal
        converter.decimalSeparator = ","
        converter.groupingSeparator = "."
        converter.locale = Locale(identifier: "id-ID")
        let output: Double = converter.number(from: s) as? Double ?? 0.0
        return output
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for i in itemsSummed{
            sumExpenses += i.total()
        }
        expenseLabel.text = DoubleToCurrency(d: sumExpenses)
        allowanceTextField.placeholder = "Enter your allowance in Rp and numbers:"
        errorLabel.isHidden = true
    }
    
    @IBAction func countExpense(_ sender: Any) {
        if(allowanceTextField.text == ""){
            errorLabel.isHidden = false
            errorLabel.text = "Please input value in the textbox!"
        }
        else if(indoStringToDouble(s: allowanceTextField.text!) == nil){
            errorLabel.isHidden = false
            errorLabel.text = "Please input numeric value only!"
        }
        else{
            errorLabel.isHidden = true
            allowanceGiven = indoStringToDouble(s: allowanceTextField.text!)!
            var allowanceLeft: Double = 0.0
            let allowanceLimit: Double = 0.1 * allowanceGiven
            if(allowanceGiven > sumExpenses){
                allowanceLeft = allowanceGiven - sumExpenses
                if(allowanceLimit > allowanceLeft){
                    let alertSpent = UIAlertController(title: "Warning!", message: "You have spent too much! Stop buying anything now!" + "(Your limit: \(DoubleToCurrency(d: allowanceLimit)), your remaining: \(DoubleToCurrency(d: allowanceLeft)))", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default)
                    alertSpent.addAction(okButton)
                    self.present(alertSpent, animated: true, completion: nil)
                }
                else if (allowanceLeft >= allowanceLimit)
                {
                    let alertSpent = UIAlertController(title: "Warning!", message:"You still have some money left (\(DoubleToCurrency(d: allowanceLeft)); your limit: \(DoubleToCurrency(d: allowanceLimit))), spend wisely!", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default)
                    alertSpent.addAction(okButton)
                    self.present(alertSpent, animated: true, completion: nil)
                }
            }
            else{
                let alertSpent = UIAlertController(title: "Warning!", message:"You have run out of money (\(DoubleToCurrency(d: allowanceLeft)))!", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default)
                alertSpent.addAction(okButton)
                self.present(alertSpent, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelSegue(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
