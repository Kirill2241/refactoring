import UIKit
import XCTest
import Foundation

//Данное приложение использует инструменты для работы с банковскими документами
//Этот синглтон отправляет запросы в SQL базу банка, чтобы хранить данные о всех транзакциях
private class SQLQueryTool{
    init(){}
    
    static var shared: SQLQueryTool = {
            let instance = SQLQueryTool()
            return instance
    }()
    
    public func sendQuery(queryInfo: TransactionInfo) {
        let formatter = DateFormatter()
        let transactionDate = queryInfo.transactionDate
        formatter.dateFormat = "dd.MM.YYYY hh:mm"
        let dateText = formatter.string(from: transactionDate)
        print("""
              A new entry to the database:
              INSERT INTO Transactions(sender_account, receiver_account, date, sum, currency)
              VALUES (\(queryInfo.senderAccountNumber),\(queryInfo.receiverAcountNumber),\(dateText),\(queryInfo.amountOfMoney),\(queryInfo.currency.rawValue))
              """)
    }
}
//Невозможно скопировать синглтон
extension SQLQueryTool: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

//Экземпляры этого класса создают чеки для клиента
private class BillCreator{
    func createBill(info: TransactionInfo) -> String {
        let formatter = DateFormatter()
        let transactionDate = info.transactionDate
        formatter.dateFormat = "dd.MM.YYYY hh:mm"
        let dateText = formatter.string(from: transactionDate)
        let bill = """
        № счёта: \(info.senderAccountNumber)
        Банк: ООО Лорем Ипсум Банк
        Дата: \(dateText)
        Сумма: \(info.amountOfMoney) \(info.currency.rawValue)
        """
        return bill
    }
}

//Особый класс, который используется вышеупомянутыми инструментами
private struct TransactionInfo{
    var senderAccountNumber: Int
    var receiverAcountNumber: Int
    var amountOfMoney: Int
    var currency: Currencies
    var transactionDate: Date
}

//Валюты
enum Currencies: String {
case rouble = "RUB"
case dollar = "USD"
case euro = "EUR"
case error = "INVALID CURRENCY CODE!!!"
}
// Протокол фасада
protocol BankingToolKitProtocol {
    func processTransaction(senderAccount: Int, receiverAccount: Int, sum: Int, currencyCode: Int)
    func transformCodeIntoCurrency(code: Int)->Currencies
}
//Класс BankingToolKit и является фасадом для работы с вышеупомянутыми инструментами
class BankingToolKit: BankingToolKitProtocol{
    func processTransaction(senderAccount: Int, receiverAccount: Int, sum: Int, currencyCode: Int){
        let date = Date()
        let currency = transformCodeIntoCurrency(code: currencyCode)
        let info = TransactionInfo(senderAccountNumber: senderAccount, receiverAcountNumber: receiverAccount, amountOfMoney: sum, currency: currency, transactionDate: date)
        let sql = SQLQueryTool.shared
        sql.sendQuery(queryInfo: info)
        let billCreator = BillCreator()
        billCreator.createBill(info: info)
    }
    
    func transformCodeIntoCurrency(code: Int)->Currencies{
        if code == 1{
            return Currencies.rouble
        }else if code == 2{
            return Currencies.dollar
        }else if code == 3{
            return Currencies.euro
        }else{
            return Currencies.error
        }
    }
}

//Клиентский код, который не зависит от всех внешних классов, а только от фасада.
class TestingFacade{
    var bankingToolKit: BankingToolKitProtocol?
    
    init(bankingToolKit: BankingToolKitProtocol) {
        self.bankingToolKit = bankingToolKit
        
        testTransaction()
    }
    
    func testTransaction(){
        self.bankingToolKit?.processTransaction(senderAccount: 118853975, receiverAccount: 864551500, sum: 5000, currencyCode: 1)
    }
}
let bankingToolKit = BankingToolKit()
let testing = TestingFacade(bankingToolKit: bankingToolKit)
