"
Je rends le detail d un seul voyage.
J utilise des child presenters pour participants, depenses, balances et reglements.
Le bouton Retour delegue via self application navigateToList
qui delegue a TripAppModel navigateToList qui annonce valueChanged.
"
Class {
	#name : 'TripDetailPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-Server-TripDetail',
	#package : 'TripExpenses-Server',
	#tag : 'TripDetail'
}

{ #category : 'private' }
TripDetailPresenter >> buildParticipantOptionsString [
	^ '|' join: (self model participants collect: [ :p |
		p participantId , ':' , p name ])
]

{ #category : 'event handling' }
TripDetailPresenter >> onAddExpense: anAnnouncement [
	| amount allParticipantIds |
	amount            := anAnnouncement amountString asNumber.
	allParticipantIds := self model participants collect: [ :p | p participantId ].
	self model
		addExpenseDescription: anAnnouncement description
		amount:                amount
		payerId:               anAnnouncement payerId
		participantIds:        allParticipantIds
]

{ #category : 'event handling' }
TripDetailPresenter >> onBackRequested [
	self application navigateToList
]

{ #category : 'event handling' }
TripDetailPresenter >> onHideExpenseForm [
	self model hideExpenseForm
]

{ #category : 'event handling' }
TripDetailPresenter >> onShowExpenseForm [
	self model showExpenseForm
]

{ #category : 'rendering' }
TripDetailPresenter >> renderView [
	self view
		renderTripName:           self model tripName;
		renderCurrency:           self model currency;
		renderTotalExpenses:      self model totalExpenses;
		renderErrorMessage:       (self model errorMessage ifNil: [ '' ]);
		renderShowExpenseForm:    self model showingExpenseForm;
		renderParticipantOptions: self buildParticipantOptionsString.
	self
		renderAllChildViewsForModels: self model participants
		atSlotNamed: #participants.
	self
		renderAllChildViewsForModels: self model expenses
		atSlotNamed: #expenses.
	self
		renderAllChildViewsForModels: self model balances
		atSlotNamed: #balances.
	self
		renderAllChildViewsForModels: self model settlements
		atSlotNamed: #settlements
]

{ #category : 'rendering' }
TripDetailPresenter >> viewCreated [
	super viewCreated.
	self view
		when: TripDetailBackRequested            send: #onBackRequested  to: self;
		when: TripDetailShowExpenseFormRequested send: #onShowExpenseForm to: self;
		when: TripDetailHideExpenseFormRequested send: #onHideExpenseForm to: self;
		when: TripDetailAddExpenseRequested      send: #onAddExpense:     to: self
]
