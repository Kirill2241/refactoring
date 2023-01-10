import UIKit

class Writer {
    var agency: BookAgency?
    func writeABook() {
        print("I wrote a book.")
        agency?.receiveABookFromWriter()
    }
}

//Протокол для Объекта. Содержит возможность добавить Наблюдателя или удалить его.
protocol ObservableProtocol {
    func addObserver(_ observer: ObserverProtocol)
    func removeObserver(_ id: String)
}

//Реализация протокола для Объекта. Работает с generic'ами.
class ObservableClass: ObservableProtocol {
    //Словарь для Наблюдателей
    private var observersDict: [String : () -> ObserverProtocol?] = [:]
    //Переменная, за которой "ведётся наблюдение". Защищена private чтобы избежать изменения за пределами класса.
    private var value: Int {
        didSet {
            self.notifyObservers()
        }
    }
    
    init(value: Int) {
        self.value = value
    }
    
    //Функция, ответственная за ""уведомление" Наблюдателей.
    private func notifyObservers() {
        observersDict.values.forEach({$0()?.valueChanged(value)})
    }
    
    func addObserver(_ observer: ObserverProtocol) {
        //Проверка, нет ли в массиве наблюдателя с таким же ID.
        if !observersDict.keys.contains(observer.observerID) {
            observersDict[observer.observerID] = ({ [weak observer] in return observer})
        }
    }
    
    func removeObserver(_ id: String) {
        observersDict.removeValue(forKey: id)
    }
    
    func increaseValue(number: Int) {
        value += number
    }
}

class BookAgency: ObservableClass {
    
    func receiveABookFromWriter() {
        increaseValue(number: 1)
    }
}

//Протокол для Наблюдателя. Текстовая переменная добавлена для того чтобы можно было создать словарь на основе ID и самого экземпляра протокола. Также содержит метод, срабатывающий при изменении переменной в Объекте.
protocol ObserverProtocol: AnyObject {
    var observerID: String { get }
    
    init(observerID: String)
    
    func valueChanged(_ value: Int)
}

protocol GramaryCheckerProtocol {
    func checkGramary() -> GramaryCheckResults
}

protocol BookPublisherProtocol {
    func publish(_  numberOfBooks: Int)
}

//Базовая реализация протокола Наблюдателя. Сюда вынесен общий для всех наблюдателей процесс инициализации.
class BaseObserver: ObserverProtocol {
    var observerID: String
    
    required init(observerID: String) {
        self.observerID = observerID
    }
    
    func valueChanged(_ value: Int) {
        // override in future implementations
        return
    }
}

class GramaryChecker: BaseObserver, GramaryCheckerProtocol {

    override func valueChanged(_ value: Int) {
        checkGramary()
    }
    
    func checkGramary() -> GramaryCheckResults {
        return GramaryCheckResults.correct
    }
}

class Publisher: BaseObserver, BookPublisherProtocol {
    
    override func valueChanged(_ value: Int) {
        publish(value)
    }
    
    func publish(_ numberOfBooks: Int) {
        print("Published a new book. Now we have a total of \(String(describing: numberOfBooks)) books published")
    }
}

enum GramaryCheckResults {
    case correct
    case containsErrors
}

let gramaryChecker = GramaryChecker(observerID: "4576")
let publisher = Publisher(observerID: "7622")
let publisherCopycat = Publisher(observerID: "7622")
let secondGramaryChecker = GramaryChecker(observerID: "gfevue")
let agency = BookAgency(value: 0)
agency.addObserver(gramaryChecker)
agency.addObserver(publisher)
agency.addObserver(publisherCopycat)
agency.addObserver(secondGramaryChecker)
agency.removeObserver(secondGramaryChecker.observerID)
let writer = Writer()
writer.agency = agency
writer.writeABook()
