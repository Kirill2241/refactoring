import UIKit

class Writer {
    var agency: BookAgency?
    func writeABook() {
        print("I wrote a book.")
        agency?.receiveABookFromWriter()
    }
}

//Класс для Объекта Наблюдения. Поддерживает дженерики.
class ObservableClass<T> {
    
    //Переменная, за которой "ведётся наблюдение".
    var value: T {
        didSet {
            observersDict.forEach({
                $0.value(value)
            })
        }
    }
    
    //Инициализация переменной
    init(value: T) { self.value = value }
    //Словарь для Наблюдателей. В качестве значений выступают кложуры
    private var observersDict: [String : (T) -> Void] = [:]
    
    func addObserver(id: String, observerHandler: @escaping((T) -> Void)) {
        //Проверка, нет ли в словаре наблюдателя с таким же ID.
        if !observersDict.keys.contains(id) {
            observersDict[id] = observerHandler
        }
    }
    
    func addObserverAndNotify(id: String, observerHandler: @escaping((T) -> Void)) {
        if !observersDict.keys.contains(id) {
            observersDict[id] = observerHandler
            observerHandler(value)
        }
    }
    
    func removeObserver(_ id: String) {
        observersDict.removeValue(forKey: id)
    }
    
}

class BookAgency {
    
    var numberOfBooks: ObservableClass<Int>
    
    init(numberOfBooks: Int){
        self.numberOfBooks = ObservableClass(value: numberOfBooks)
    }
    
    func receiveABookFromWriter() {
        numberOfBooks.value += 1
    }
}

protocol GramaryCheckerProtocol {
    func checkGramary() -> GramaryCheckResults
}

protocol BookPublisherProtocol {
    func publish(_  numberOfBooks: Int)
}

//Базовая реализация протокола Наблюдателя. Сюда вынесен общий для всех наблюдателей процесс инициализации.
class BaseEmployee {
    var employeeID: String
    
    required init(employeeID: String) {
        self.employeeID = employeeID
    }

}

class GramaryChecker: BaseEmployee, GramaryCheckerProtocol {
    func checkGramary() -> GramaryCheckResults {
        return GramaryCheckResults.correct
    }
}

class Publisher: BaseEmployee, BookPublisherProtocol {
    func publish(_ numberOfBooks: Int) {
        print("Published a new book. Now we have a total of \(String(describing: numberOfBooks)) books published")
    }
}

enum GramaryCheckResults {
    case correct
    case containsErrors
}

let gramaryChecker = GramaryChecker(employeeID: "4576")
let publisher = Publisher(employeeID: "7622")
let publisherCopycat = Publisher(employeeID: "7622")
let secondGramaryChecker = GramaryChecker(employeeID: "gfevue")
let agency = BookAgency(numberOfBooks: 0)
// Реализация кложуров
agency.numberOfBooks.addObserver(id: gramaryChecker.employeeID) { _ in
    let _ = gramaryChecker.checkGramary()
}
agency.numberOfBooks.addObserver(id: publisher.employeeID) { _ in
    publisher.publish(agency.numberOfBooks.value)
}
agency.numberOfBooks.addObserverAndNotify(id: publisherCopycat.employeeID) { _ in
    publisherCopycat.publish(agency.numberOfBooks.value)
}
agency.numberOfBooks.addObserver(id: secondGramaryChecker.employeeID) { _ in
    let _ = secondGramaryChecker.checkGramary()
}
agency.numberOfBooks.removeObserver(secondGramaryChecker.employeeID)
let writer = Writer()
writer.agency = agency
writer.writeABook()
