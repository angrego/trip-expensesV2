"
I render a single TripItemModel.
When clicked I tell my parent (TripListPresenter) which trip was selected.
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
	"Je connais mon modèle — je remonte l annonce avec le tripId au parent"
self application navigateToTrip: self model tripId
]

{ #category : 'rendering' }
TripItemPresenter >> renderView [
	"Envoie uniquement des String et Number à la vue"
	self view renderTripName:         self model name
	          currency:               self model currency
	          participantCount:       self model participantCount printString
	          totalExpenses:          self model totalExpenses printString
]

{ #category : 'rendering' }
TripItemPresenter >> viewCreated [
	super viewCreated.
	self view
		when: TripItemClicked
		send: #onClicked
		to:   self
]
