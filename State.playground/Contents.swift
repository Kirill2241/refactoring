import UIKit

//Это приложение работает с детекторами движения
//Класс MovementDetector является контекстом
class MovementDetector{
    //Ссылка на текущее состояние контекста. По умолчанию детектор движений находится в выключенном состоянии
    private lazy var detectorState: DetectorState = DeactivatedDetectorState(detector: self)
    
    //Часть поведения контекста делегируется текущему объекту Состояния
    func report(detectorDidDetectMovement: Bool) {
        if detectorDidDetectMovement{
            detectorState.reportMotion()
        }else{
            detectorState.noMotion()
        }
    }
    
    //Метод, который меняет объект Состояния во время выполнения.
    func updateState(state: DetectorState){
        self.detectorState = state
        state.reportState()
    }
}

//Базовый класс состояния
protocol DetectorState{
    func reportMotion()
    func noMotion()
    func reportState()
}

//Имплементация для выключенного состояния
class DeactivatedDetectorState: DetectorState{
    private weak var detector: MovementDetector?
    
    init(detector: MovementDetector) {
        self.detector = detector
    }
    
    func reportMotion() {
        print("In order to receive warnings about unexpected movement, please activate movement detector.")
    }
    
    func noMotion() {}
    
    func reportState() {
        print("Motion detector is switched off.")
    }
    
}

//Имплементация для включенного состояния
class ActivatedDetectorState: DetectorState{
    private weak var detector: MovementDetector?
    
    init(detector: MovementDetector) {
        self.detector = detector
    }
    
    func reportMotion() {
        print("RED ALERT!!! UNKNOWN SUBJECT IN THE ROOM!!!")
    }
    
    func noMotion() {
        print("No tresspassing detected.")
    }
    
    func reportState() {
        print("Motion detector activated. Scanning...")
    }
}

class StateTesting{
    func test(){
        let movementDetector = MovementDetector()
        movementDetector.report(detectorDidDetectMovement: false)
        movementDetector.report(detectorDidDetectMovement: true)
        movementDetector.updateState(state: ActivatedDetectorState(detector: movementDetector))
        movementDetector.report(detectorDidDetectMovement: false)
        movementDetector.report(detectorDidDetectMovement: true)
    }
}

let testing = StateTesting()
testing.test()
