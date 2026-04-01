"
I am the Presenter for TripListModel.
I handle announcements from the View and delegate to the Model.
I render the View when the Model changes (via valueChanged → renderView
"
Class {
	#name : 'TripListPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-Server-TripList',
	#package : 'TripExpenses-Server',
	#tag : 'TripList'
}

{ #category : 'rendering' }
TripListPresenter >> onCreateRequested: anAnnouncement [
	"Reçu depuis TripItemPresenter — navigue vers le détail"

	self model
		createTripNamed: anAnnouncement tripName
		currency: anAnnouncement currency
]

{ #category : 'rendering' }
TripListPresenter >> onHideFormRequested [
	self model hideCreateForm
]

{ #category : 'rendering' }
TripListPresenter >> onShowFormRequested [
	"Délègue au modèle — même pattern que CpCounterPresenter >> modelIncrease"
	self model showCreateForm
]

{ #category : 'rendering' }
TripListPresenter >> onTripSelected: anAnnouncement [
	"self application donne accès à TripExpensesApplication depuis n importe quel presenter"
	self application navigateToTrip: anAnnouncement tripId
]

{ #category : 'rendering' }
TripListPresenter >> renderView [
	"Envoie uniquement des String/Boolean à la vue directe.
	 Les TripItemModel sont rendus via des child presenters — pas de collection envoyée à la vue."

	self
		renderAllChildViewsForModels: self model trips
		atSlotNamed: #trips.
	self view
		renderErrorMessage: (self model errorMessage ifNil: [ 'Welcome' ]);
		renderShowCreateForm: self model showingCreateForm
]

{ #category : 'rendering' }
TripListPresenter >> viewCreated [
	"Appelé par CP quand la vue est prête dans le browser.
	 Je m abonne aux annonces de la vue — même pattern que CpCounterPresenter."
	super viewCreated.
	self view
		when: TripListShowFormRequested send: #onShowFormRequested    to: self;
		when: TripListHideFormRequested send: #onHideFormRequested    to: self;
		when: TripListCreateRequested   send: #onCreateRequested:     to: self;
		when: TripListTripSelected      send: #onTripSelected:        to: self
]
