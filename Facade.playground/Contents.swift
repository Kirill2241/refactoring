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
        guard let transactionDate = queryInfo.transactionDate else { return }
        formatter.dateFormat = "dd.MM.YYYY hh:mm"
        let dateText = formatter.string(from: transactionDate)
        print("""
              A new entry to the database:
              INSERT INTO Transactions(sender_account, receiver_account, date, sum, currency)
              VALUES (\(queryInfo.senderAccountNumber!),\(queryInfo.receiverAcountNumber!),\(dateText),\(queryInfo.amountOfMoney!),\(queryInfo.currency!.rawValue))
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
        guard let transactionDate = info.transactionDate else { return "ERROR. INVALID DATE!"}
        formatter.dateFormat = "dd.MM.YYYY hh:mm"
        let dateText = formatter.string(from: transactionDate)
        let bill = """
        № счёта: \(info.senderAccountNumber!)
        Банк: ООО Лорем Ипсум Банк
        Дата: \(dateText)
        Сумма: \(info.amountOfMoney!) \(info.currency!.rawValue)
        """
        return bill
    }
}

//Особый класс, который используется вышеупомянутыми инструментами
private class TransactionInfo{
    var senderAccountNumber: Int?
    var receiverAcountNumber: Int?
    var amountOfMoney: Int?
    var currency: Currencies?
    var transactionDate: Date?
    init(senderAccountNumber: Int, receiverAccountNumber: Int, transactionDate: Date, amountOfMoney: Int, currency: Currencies) {
        self.senderAccountNumber = senderAccountNumber
        self.receiverAcountNumber = receiverAccountNumber
        self.amountOfMoney = amountOfMoney
        self.transactionDate = transactionDate
        self.currency = currency
    }
}

//Валюты
enum Currencies: String {
case rouble = "RUB"
case dollar = "USD"
case euro = "EUR"
}

//Класс BankingToolKit и является фасадом для работы с вышеупомянутыми инструментами
class BankingToolKit{
    func processTransaction(senderAccount: Int, receiverAccount: Int, sum: Int, currency: Currencies){
        let date = Date()
        let info = TransactionInfo(senderAccountNumber: senderAccount, receiverAccountNumber: receiverAccount, transactionDate: date, amountOfMoney: sum, currency: currency)
        let sql = SQLQueryTool.shared
        sql.sendQuery(queryInfo: info)
        let billCreator = BillCreator()
        billCreator.createBill(info: info)
    }
}

//Клиентский код, который не зависит от всех внешних классов, а только от фасада.
class TestingFacade{
    func testTransaction(){
        let bankingToolKit = BankingToolKit()
        bankingToolKit.processTransaction(senderAccount: 118853975, receiverAccount: 864551500, sum: 5000, currency: .rouble)
    }
}

let testing = TestingFacade()
testing.testTransaction()
