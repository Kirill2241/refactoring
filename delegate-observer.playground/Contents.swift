import UIKit

class Writer{
    var agency: BookAgencyObservableProtocol?
    func writeABook(){
        print("I wrote a book.")
        agency?.receiveABook()
    }
}

//Протокол для Объекта. Содержит возможность добавить Наблюдателя, удалить его или уведомить их
protocol BookAgencyObservableProtocol {
    
    func addEmployee(_ employee: BookAgencyEmployee)
    func removeEmployee(_ employee: BookAgencyEmployee)
    func notifyEmployees()
    func receiveABook()
}

//Протокол для Наблюдателя. Числовая переменная добавлена для того чтобы их было проще удалять. Также содержит метод, срабатывающий при изменении переменной в Объекте.
protocol BookAgencyEmployee: class {
    var employeeNumber: Int? { get set }
    init(employeeNumber: Int)
    func numberOfBooksIncreased()
}
protocol GramaryCheckerProtocol: class{
    func checkGramary()->GramaryCheckResults
}

protocol BookPublisherProtocol: class{
    func publish()
}

//Реализация протокола для Объекта. Важно, чтобы протокол унаследовался именно классом, потому что структура - это не ссылочный тип
class BookAgency: BookAgencyObservableProtocol{
    //Хранилище Наблюдателей - массив слабых ссылок
    private var employees: [() -> BookAgencyEmployee?] = []
    
    //Кол-во книг над которыми работает агенство - переменная, которую отслеживают Наблюдатели.
    private var numberOfBooks : Int {
            didSet {
                self.notifyEmployees()
            }
        }

    required init(numberOfBooks: Int) {
        self.numberOfBooks = numberOfBooks
    }
    
    func addEmployee(_ employee: BookAgencyEmployee) {
        employees.append({ [weak employee] in return employee })
    }
    
    func removeEmployee(_ employee: BookAgencyEmployee) {
        guard let index = self.employees.firstIndex(where: { $0()?.employeeNumber == employee.employeeNumber }) else { return }
                self.employees.remove(at: index)
    }
    
    func receiveABook() {
        numberOfBooks += 1
    }
    
    func notifyEmployees() {
        employees.forEach({$0()?.numberOfBooksIncreased()})
    }
    
    deinit {
            employees.removeAll()
        }
}

class GramaryChecker: GramaryCheckerProtocol, BookAgencyEmployee{
    var employeeNumber: Int?
    
    required init(employeeNumber: Int) {
        self.employeeNumber = employeeNumber
    }

    func numberOfBooksIncreased() {
        checkGramary()
    }
    
    func checkGramary() -> GramaryCheckResults {
        return GramaryCheckResults.correct
    }
}
class Publisher: BookPublisherProtocol, BookAgencyEmployee{
    var employeeNumber: Int?
    
    required init(employeeNumber: Int) {
        self.employeeNumber = employeeNumber
    }
    
    func numberOfBooksIncreased() {
        publish()
    }
    
    func publish() {
        print("Published a new book")
    }
}
enum GramaryCheckResults {
case correct
case containsErrors
}

let gramaryChecker = GramaryChecker(employeeNumber: 4576)
let publisher = Publisher(employeeNumber: 7622)
let agency = BookAgency(numberOfBooks: 0)
agency.addEmployee(gramaryChecker)
agency.addEmployee(publisher)
let writer = Writer()
writer.agency = agency
writer.writeABook()
