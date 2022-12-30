import UIKit

class Writer{
    var agency: BookAgency?
    func writeABook(){
        print("I wrote a book.")
        agency?.receiveABookFromWriter()
    }
}

//Протокол для Объекта. Содержит возможность добавить Наблюдателя, удалить его или уведомить их
protocol BookAgencyObservableProtocol {
    func addEmployee(_ employee: BasicEmployee)
    func removeEmployee(_ employee: BookAgencyEmployee)
    func notifyEmployees()
}

//Реализация протокола для Объекта. Работает с generic'ами.
class ObservableClass<T>: BookAgencyObservableProtocol {
    internal var employees: [Weak<BasicEmployee>] = []
    //Переменная, за которой "ведётся наблюдение"
    var value: T{
        didSet{
            self.notifyEmployees()
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    func notifyEmployees() {
        self.employees.forEach({ $0.value?.numberOfBooksChanged(value)})
    }
    
    func addEmployee(_ employee: BasicEmployee) {
        //Проверка, нет ли в массиве наблюдателя с таким же ID.
        guard self.employees.contains(where: { $0.value?.employeeID == employee.employeeID }) == false else {
            return
        }
        self.employees.append(Weak(value: employee))
    }
    
    func removeEmployee(_ employee: BookAgencyEmployee) {
        guard let index = self.employees.firstIndex(where: { $0.value?.employeeID == employee.employeeID }) else { return }
        self.employees.remove(at: index)
    }

}

class BookAgency{
    var numberOfBooks: ObservableClass<Int>
    
    init(numberOfBooks: Int) {
        self.numberOfBooks = ObservableClass(value: numberOfBooks)
    }
    
    func receiveABookFromWriter() {
        numberOfBooks.value += 1
    }
}

//Протокол для Наблюдателя. Текстовая переменная добавлена для того чтобы их было проще удалять. Также содержит метод, срабатывающий при изменении переменной в Объекте.
protocol BookAgencyEmployee: AnyObject {
    var employeeID: String? { get set }
    
    init(employeeID: String)
    
    func numberOfBooksChanged(_ value: Any?)
}

protocol GramaryCheckerProtocol: AnyObject {
    func checkGramary() -> GramaryCheckResults
}

protocol BookPublisherProtocol: AnyObject {
    func publish(_  value: Any?)
}

//Базовая реализация протокола Наблюдателя. Сюда вынесен общий для всех наблюдателей процесс инициализации. Также класс необходим для создания массива слабых ссылок.
class BasicEmployee: BookAgencyEmployee {
    var employeeID: String?
    
    required init(employeeID: String) {
        self.employeeID = employeeID
    }
    
    func numberOfBooksChanged(_ value: Any?) {
        // override in future implementations
        return
    }
}

class GramaryChecker: BasicEmployee, GramaryCheckerProtocol{

    override func numberOfBooksChanged(_ value: Any?) {
        checkGramary()
    }
    
    func checkGramary() -> GramaryCheckResults {
        return GramaryCheckResults.correct
    }
}
class Publisher: BasicEmployee, BookPublisherProtocol {
    
    override func numberOfBooksChanged(_ value: Any?) {
        publish(value)
    }
    
    func publish(_ value: Any?) {
        print("Published a new book. Now we have a total of \(String(describing: value)) books published")
    }
}
enum GramaryCheckResults {
    case correct
    case containsErrors
}

//Обёртка для Наблюдателей, делает их слабыми ссылками.
class Weak<T: AnyObject> {
  weak var value : T?
  init (value: T) {
    self.value = value
  }
}

let gramaryChecker = GramaryChecker(employeeID: "4576")
let publisher = Publisher(employeeID: "7622")
let publisherCopycat = Publisher(employeeID: "7622")
let agency = BookAgency(numberOfBooks: 0)
agency.numberOfBooks.addEmployee(gramaryChecker)
agency.numberOfBooks.addEmployee(publisher)
agency.numberOfBooks.addEmployee(publisherCopycat)
let writer = Writer()
writer.agency = agency
writer.writeABook()
