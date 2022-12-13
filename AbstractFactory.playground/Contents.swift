import UIKit
import XCTest

//В данной программе абстрактная фабрика создаёт элементы интерфейса(кнопки и надписи), которые должны быть или обычного цвета, или особого цвета на случай если пользователь страдает эпилепсией.
//Создадим протокол абстрактной фабрики:
protocol UIElementsAbstractFactory{
    
    //Данный метод создаёт кнопки
    func createButton()-> Button
    
    //Данный метод создаёт надписи
    func createLabel() -> Label
}

//Конкретная реализация абстрактной фабрики. Создаёт обычные элементы интерфейса.
class AverageUIElementsFactory: UIElementsAbstractFactory {
    func createButton() -> Button {
        return AverageButton()
    }
    
    func createLabel() -> Label {
        return AverageLabel()
    }
}

//Конкретная реализация абстрактной фабрики. Создаёт особые элементы интерфейса для пользователей с эпилепсией.
class AntiEpilepsyUIElementsFactory: UIElementsAbstractFactory{
    func createButton() -> Button {
        return AntiEpilepsyButton()
    }
    
    func createLabel() -> Label {
        return AntiEpilepsyLabel()
    }
}

//Базовая имплементация кнопки
protocol Button{
    //Выводит информацию о том, в какой цвет будет раскрашена кнопка.
    func configureColor() -> String
}

//Базовая имплементация надписи
protocol Label{
    //Выводит информацию о том, какой цвет будет у шрифта надписи.
    func configureFontColor() -> String
}

//Реализация обычной кнопки.
class AverageButton: Button{
    func configureColor() -> String {
        return "The color of button is average"
    }
}

//Реализация обычной надписи.
class AverageLabel: Label{
    func configureFontColor() -> String {
        return "The font color for the label is average"
    }
}

//Реализация особой кнопки для пользователей с эпилепсией.
class AntiEpilepsyButton: Button{
    func configureColor() -> String {
        return "The color of button is changed to avoid epilepsy"
    }
}

//Реализация особой надписи для пользователей с эпилепсией.
class AntiEpilepsyLabel: Label{
    func configureFontColor() -> String {
        return "The font color for the label is changed to avoid epilepsy"
    }
}

//Клиентский код
class ClientCode{
    
    //Функция создаёт элементы интерфейса в зависимости от значения буллевой переменной.
    func createInterface(userIsEpileptic: Bool){
        var factory: UIElementsAbstractFactory?
        if userIsEpileptic{
            factory = AntiEpilepsyUIElementsFactory()
        }else{
            factory = AverageUIElementsFactory()
        }
        let button = factory?.createButton()
        let label = factory?.createLabel()
        button?.configureColor()
        label?.configureFontColor()
    }
}

class AbstractFactoryTest: XCTestCase{
    
    //Запускает функцию createInterface из клиентского кода с буллевой переменной равен false.
    func testAverageUI(){
        let clientCode = ClientCode()
        clientCode.createInterface(userIsEpileptic: false)
    }
}
let test = AbstractFactoryTest()
test.testAverageUI()
