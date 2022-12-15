import UIKit
import XCTest

//Это расширение выступает в качестве адаптера для работы со сторонней библиотекой ColorCreator
extension UIColor{
    public convenience init(hexString: String) {
        let colorComponents = ColorCreator().convertHEXToColor(hexString)
        self.init(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: CGFloat(1))
    }
    public convenience init(red: Int, green: Int, blue: Int, _ alpha: Int = 1){
        let colorComponents = ColorCreator().convertRGBToColor(r: red, g: green, b: blue)
        self.init(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: colorComponents[3])
    }
}

//Сторонняя библиотека, которая конвертирует входные данные разных форматов в CGFloat-компоненты для UIColor
private class ColorCreator{
    //Этот метод создаёт компоненты из hex-кода в текстовом представлении
    func convertHEXToColor(_ string: String)-> [CGFloat]{
        let hexText = (string ?? "")
                .replacingOccurrences(of: "#", with: "")
                .uppercased()
        let scanner = Scanner(string: hexText)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = (rgbValue & 0xFF0000) >> 16
        let green = (rgbValue & 0xFF00) >> 8
        let blue = rgbValue & 0xFF
        let redFloat = CGFloat(red)/255.0
        let greenFloat = CGFloat(green)/255.0
        let blueFloat = CGFloat(blue)/255.0
        return [redFloat, greenFloat, blueFloat]
    }
    //Этот метод создаёт компоненты из чисел RGB кода в формате Int
    func convertRGBToColor(r: Int, g: Int, b: Int, _ alpha: Int = 1)->[CGFloat]{
        assert(r >= 0 && r <= 255, "Invalid Red component")
        assert(g >= 0 && g <= 255, "Invalid Green component")
        assert(b >= 0 && b <= 255, "Invalid Blue component")
        let redFloat = CGFloat(r) / 255.0
        let greenFloat = CGFloat(g)/255.0
        let blueFloat = CGFloat(b) / 255.0
        let alphaFloat = CGFloat(alpha)
        return [redFloat, greenFloat, blueFloat, alphaFloat]
    }
}

//Клиентский код
class ClientCode{
    func convertHEXToColor(_ hexCode: String) -> UIColor{
        return UIColor(hexString: hexCode)
    }
    
    func convertRGBToColor(red: Int, green: Int, blue: Int, _ alpha: Int = 1) -> UIColor{
        return UIColor(red: red, green: green, blue: blue)
    }
}
class TestAdapter: XCTest{
    func testAdapter() -> (String, String){
        let clientCode = ClientCode()
        let hexColor = clientCode.convertHEXToColor("#33BBBB")
        let rgbColor = clientCode.convertRGBToColor(red: 244, green: 67, blue: 54)
        let wrongHex = clientCode.convertHEXToColor("#GGGGGG")
        let hexName = hexColor.accessibilityName
        let rgbName = rgbColor.accessibilityName
        assert(wrongHex.accessibilityName == "black")
        return (hexName, rgbName)
    }
}

let test = TestAdapter()
test.testAdapter()

