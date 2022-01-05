import Foundation

struct EventViewModel {
    let dateFormater = DateFormatter()
    let id: UUID
    let name:String
    let location: String
    let startedDate: String
    let finishDate: String
    
    init(event: Event){
        self.dateFormater.dateStyle = .short
        self.id = event.id
        self.name = event.name
        self.location = event.location
        self.startedDate = dateFormater.string(from: event.started_date)
        self.finishDate = dateFormater.string(from: event.finish_date)
    }
}



