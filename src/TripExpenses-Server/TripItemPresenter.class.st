"
Je rends un seul TripItemModel.
Quand l utilisateur clique, je navigue directement via self application — chemin unique.
"
Class {
	#name : 'TripItemPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-Server-TripItem',
	#package : 'TripExpenses-Server',
	#tag : 'TripItem'
}

{ #category : 'rendering' }
TripItemPresenter >> onClicked [
	"Chemin UNIQUE de navigation vers le détail.
	 TripListPresenter ne gère plus TripListTripSelected (supprimé)."
	self application navigateToTrip: self model tripId
]

{ #category : 'rendering' }
TripItemPresenter >> renderView [
	self view
		renderTripName:       self model name
		currency:             self model currency
		participantCount:     self model participantCount printString
		totalExpenses:        self model totalExpenses printString
]

{ #category : 'rendering' }
TripItemPresenter >> viewCreated [
	super viewCreated.
	self view
		when: TripItemClicked
		send: #onClicked
		to:   self
]
