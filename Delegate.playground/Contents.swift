//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

protocol MyViewProtocol{
    func createHoroscopeLabel(text: String)
}

class MyViewController : UIViewController, MyViewProtocol {
    var textFieldDelegate: BirthDateTextFieldDelegateProtocol?
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 25, y: 200, width: 250, height: 70)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Пожалуйста введите дату рождения:"
        label.textColor = .black
        
        let birdthDateTextField = UITextField()
        birdthDateTextField.frame = CGRect(x: 25, y: 290, width: 250, height: 40)
        birdthDateTextField.borderStyle = .roundedRect
        birdthDateTextField.backgroundColor = UIColor.white
        birdthDateTextField.layer.borderColor = UIColor.lightGray.cgColor
        birdthDateTextField.delegate = textFieldDelegate
        birdthDateTextField.placeholder = textFieldDelegate?.createPlaceholder()
        
        view.addSubview(label)
        view.addSubview(birdthDateTextField)
        self.view = view
    }
    
    func createHoroscopeLabel(text: String){
        DispatchQueue.main.async {
            let view = UIView()
            view.backgroundColor = .white
            
            let signLabel = UILabel()
            signLabel.frame = CGRect(x: 25, y: 200, width: 250, height: 50)
            signLabel.numberOfLines = 0
            signLabel.lineBreakMode = .byWordWrapping
            signLabel.text = "Ваш знак зодиака - "+text
            signLabel.textColor = .black
            
            view.addSubview(signLabel)
            self.view = view
        }
    }
}

protocol BirthDateTextFieldDelegateProtocol: UITextFieldDelegate{
    
    init(view: MyViewProtocol)
    func createPlaceholder() -> String
    
}

class BirthDateTextFieldDelegate: NSObject, BirthDateTextFieldDelegateProtocol{
    var view: MyViewProtocol?
    
    let singsAndDates: [(Double, Double, String)] = [
        (3.21, 4.19, "Овен"),
        (4.20, 5.20, "Телец"),
        (5.21, 6.21, "Близнецы"),
        (6.22, 7.22, "Рак"),
        (7.23, 8.22, "Лев"),
        (8.23, 9.22, "Дева"),
        (9.23, 10.23, "Весы"),
        (10.24, 11.21, "Скорпион"),
        (11.22, 12.21, "Стрелец"),
        (12.22, 12.31, "Козерог"),
        (1.00, 1.19, "Козерог"),
        (1.20, 2.18, "Водолей"),
        (2.19, 3.20, "Рыбы")
    ]
    
    required init(view: MyViewProtocol) {
        self.view = view
    }
    
    func createPlaceholder() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func findOutZodiacSign(dateString: String){
        let array = dateString.components(separatedBy: ".")
        guard let day = Int(array[0]) else { return }
        guard let month = Int(array[1]) else { return }
        let dayDouble = Double(day)
        let monthDouble = Double(month)
        let comparisonDouble = monthDouble+(dayDouble/100)
        for tuple in singsAndDates{
            if comparisonDouble>=tuple.0 && comparisonDouble<=tuple.1{
                view?.createHoroscopeLabel(text: tuple.2)
            }
        }
    }
    
    func formatInput(with mask: String, date: String) -> String {
        let numbers = date.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X"{
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        textField.placeholder = nil
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formatInput(with: "XX.XX.XXXXX", date: newString)
        if textField.text?.count == 10{
            findOutZodiacSign(dateString: textField.text!)
        }
        return false
    }
}

// Present the view controller in the Live View window
let myVC = MyViewController()
let delegate = BirthDateTextFieldDelegate(view: myVC)
myVC.textFieldDelegate = delegate
PlaygroundPage.current.liveView = myVC
