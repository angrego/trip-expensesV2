"
Je rends TripListModel.
La navigation vers un voyage est gérée par TripItemPresenter directement —
je ne m abonne plus à TripListTripSelected (ce chemin était mort).
"
Class {
	#name : 'TripListPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-Server-TripList',
	#package : 'TripExpenses-Server',
	#tag : 'TripList'
}

{ #category : 'event handling' }
TripListPresenter >> onCreateRequested: anAnnouncement [
	self model
		createTripNamed: anAnnouncement tripName
		currency:        anAnnouncement currency
]

{ #category : 'event handling' }
TripListPresenter >> onHideFormRequested [
	self model hideCreateForm
]

{ #category : 'event handling' }
TripListPresenter >> onShowFormRequested [
	self model showCreateForm
]

{ #category : 'rendering' }
TripListPresenter >> onTripSelected: anAnnouncement [
	"self application donne accès à TripExpensesApplication depuis n importe quel presenter"
	self application navigateToTrip: anAnnouncement tripId
]

{ #category : 'rendering' }
TripListPresenter >> renderView [
	self
		renderAllChildViewsForModels: self model trips
		atSlotNamed: #trips.
	self view
		renderErrorMessage:    (self model errorMessage ifNil: [ '' ]);
		renderShowCreateForm:  self model showingCreateForm
]

{ #category : 'rendering' }
TripListPresenter >> viewCreated [
	super viewCreated.
	self view
		when: TripListShowFormRequested send: #onShowFormRequested to: self;
		when: TripListHideFormRequested send: #onHideFormRequested to: self;
		when: TripListCreateRequested   send: #onCreateRequested:  to: self
]
