import UIKit
import XCTest

//Данная программа конвертирует написанные пользователем числа(в формате String) из двоичной или шестнадцатиричной в десятичную, либо если введённый текст не является числом в соответствующей системе счисления, выдаёт ошибку.
//Для начала необходимо создать протокол для фабрики, от которого будут наследоваться все фабрики, ответственнные за создание конкретных типов конвертеров.
protocol WrittenNumberConverterFactory {
    
    //Этот метод и будет нашим фабричным методом, возвращая конвертеры для разных систем счисления.
    func createConverter() -> WrittenNumberConverter
    func displayNumberType() -> String
}

extension WrittenNumberConverterFactory {
    
    //В данной функции мы реализуем бизнес-логику фабрики - когда она создаёт конвертер для какой-либо системы счисления, то сообщает пользователю, что это за система счисления. Для этого он обращается к аналогичному методу у конвертера.
    func displayNumberType() -> String{
        let numberConverter = createConverter()
        return "The number written by the user is "+numberConverter.writeNumberType()
    }
}

//Фабрика, создающая конвертеры для двоичной системы счисления. Наследуется от общего протокола для фабрик.
class BinaryNumberConverterFactory: WrittenNumberConverterFactory{
    
    //Этот фабричный метод создаёт конвертер для двоичной системы счисления
    func createConverter() -> WrittenNumberConverter {
        return BinaryNumberConverter()
    }
}

//Фабрика, создающая конвертеры для шестнадцатеричной системы счисления. Наследуется от общего протокола для фабрик.
class HexadecimalNumberConverterFactory: WrittenNumberConverterFactory{
    
    //Этот фабричный метод создаёт конвертер для шестнадцатеричной системы счисления
    func createConverter() -> WrittenNumberConverter {
        return HexadecimalNumberConverter()
    }
}

//Базовый протокол для всех конвертеров
protocol WrittenNumberConverter{
    
    //Основной функционал конвертера - получать на вход строку, содержащую число в какой-либо системе счисления и выводить строку, содержащую то же самое число, но уже в десятичной системе.
    func writeNumberConvertedToDecimal(number: String) -> String
    
    //Дополнительный функционал - конвертер возвращает строку, где указано, с какой системой счисления он работает. Используется в методе displayNumberType() протокола фабрики.
    func writeNumberType() -> String
}

class BinaryNumberConverter: WrittenNumberConverter{
    
    //Реализация основного функционала - вывод строки, содержащей полученное двоичное число, переведённое в десятичное(или ошибку если было получено не число).
    func writeNumberConvertedToDecimal(number: String) -> String {
        if let convertedNumber = Int(number, radix: 2){
            return "\(convertedNumber)"
        } else {
            return ("ERROR: INVALID INPUT")
        }
    }
    
    //Реализация дополнительного функционала(возвращение системы счисления).
    func writeNumberType() -> String {
        return "binary"
    }
}

class HexadecimalNumberConverter: WrittenNumberConverter {
    
    //Реализация основного функционала - вывод строки, содержащей полученное шестнадцатеричное число, переведённое в десятичное(или ошибку если было получено не число).
    func writeNumberConvertedToDecimal(number: String) -> String {
        let upperCaseNumber = number.uppercased()
        if let num = UInt(upperCaseNumber, radix: 16) {
            return "\(Int(num))"
        } else {
            return ("ERROR: INVALID INPUT")
        }
    }
    
    //Реализация дополнительного функционала.
    func writeNumberType() -> String {
        return "hexadecimal"
    }
}

//Клиентский код
class ClientCode{
    
    //Функция, которая принимает строку с номером, подлежащим конвертации, а также фабрику для создания конвертера для этого числа.
    func useWrittenNumberConverter(number: String, factory: WrittenNumberConverterFactory){
            let converter = factory.createConverter()
            print(factory.displayNumberType())
            let decimalNumber = converter.writeNumberConvertedToDecimal(number: number)
            print("The written number is equal to decimal number \(decimalNumber)")
            return
    }
}

class FactoryMethodTest: XCTestCase{
    
    //Передаём в клиентский код двоичное число и фабрику для конверторов двоичных чисел.
    func testBinary(){
        let clientCode = ClientCode()
        let mockBinaryText = "1100001"
        clientCode.useWrittenNumberConverter(number: mockBinaryText, factory: BinaryNumberConverterFactory())
    }
    
    //Передаём в клиентский код шестнадцатеричное число и фабрику для конверторов двоичных чисел.
    func testHexadecimal(){
        let clientCode = ClientCode()
        let mockHexadecimalText = "A1"
        clientCode.useWrittenNumberConverter(number: mockHexadecimalText, factory: HexadecimalNumberConverterFactory())
    }
}

let testObject = FactoryMethodTest()
testObject.testBinary()
testObject.testHexadecimal()
