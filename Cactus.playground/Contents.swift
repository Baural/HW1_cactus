import Foundation

class Session {
    let durationInSeconds: Int
    
    init(durationInSeconds: Int) {
        self.durationInSeconds = durationInSeconds
    }
}

protocol SessionManagerDelegate {
    func showSessionStarted()
    func showTimeLeft(secondsLeft: Int)
    func showSessionEnded()
}

class SessionManager {
    var sessionDelegate: SessionManagerDelegate
    var timer: Timer?
    let sessionStorage = SessionsStorage()
    
    init(sessionDelegate: SessionManagerDelegate) {
        self.sessionDelegate = sessionDelegate
    }
    
    func startSession(session: Session) {
        sessionDelegate.showSessionStarted()
        sessionDelegate.showTimeLeft(secondsLeft: session.durationInSeconds)

        
        var secondsLeft = session.durationInSeconds
    
       
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            secondsLeft -= 1
            self.sessionDelegate.showTimeLeft(secondsLeft: secondsLeft)
            if secondsLeft == 1 {
                SessionsStorage.shared.add(session: session)
                self.sessionDelegate.showSessionEnded()
                
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
    
}

class SessionsStorage {
    static let shared = SessionsStorage()
    
    var sessions = [Session]()
    
    func add(session: Session) {
        sessions.append(session)
    }
}

class BreakView: SessionManagerDelegate {
    var sessionManager: SessionManager?
    

    
    func userStartedBreak(durationInSeconds: Int) {
        sessionManager?.startSession(session: Session(durationInSeconds: durationInSeconds))
    }

    
    func showSessionStarted() {
        print("break started")
    }
    
    func showTimeLeft(secondsLeft: Int) {
        print("\(secondsLeft)")
    }
    
    func showSessionEnded() {
        print("break ended")
    }
}

let breakView = BreakView()
breakView.sessionManager = SessionManager(sessionDelegate: breakView)

breakView.userStartedBreak(durationInSeconds: 5)


