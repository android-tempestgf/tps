### Modelo de Datos (Ejemplo)

```mermaid
classDiagram
    class Trip {
        +String id
        +String name
        +Date startDate
        +Date endDate
        +String description
    }
    
    class Itinerary {
        +String id
        +List~Activity~ activities
    }
    
    class Activity {
        +String id
        +String title
        +String location
    }
    
    Trip --> Itinerary
    Itinerary --> Activity
