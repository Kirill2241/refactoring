import UIKit
import Foundation

//Данная программа позволяет создавать медиафайлы.
//Введение общего протокола для строителя медиафайлов.
protocol MediafileBuilderProtocol {
    func addImage()
    func addAudio()
    func addSubtitles(_ subtitles: String)
}

class MediafileBuilder: MediafileBuilderProtocol {
    private var file = Mediafile()
    
    func addImage() {
        file.addCharacteristic("The file contains a photo of a blue sky")
    }
    
    func addAudio() {
        file.addCharacteristic("A soft music plays in the backgroud")
    }
    
    func addSubtitles(_ subtitles: String) {
        file.addCharacteristic("The subtitles at the bottom of the screen say: "+subtitles)
    }
}

class Director{
    private var mediaFileBuilder: MediafileBuilderProtocol?
    
    func update(mediaFileBuilder: MediafileBuilderProtocol) {
            self.mediaFileBuilder = mediaFileBuilder
    }
    
    func imageOnly() {
        mediaFileBuilder?.addImage
    }
    
    func allContentPossible(_ subtitles: String) {
        mediaFileBuilder?.addImage()
        mediaFileBuilder?.addAudio()
        mediaFileBuilder?.addSubtitles()
    }
}
class Mediafile{
    var characteristics : [String] = []
    
    func addCharacteristic(_ characteristic: String) {
        characteristics.append(characteristic)
    }
    
    func listCharacteristics(){
        print(characteristics.joined(separator: "\n"))
    }
}

class ClientCode{
    
}
