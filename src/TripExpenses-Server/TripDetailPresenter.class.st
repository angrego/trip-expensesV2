"
I render the detail of a single trip.
I use child presenters for participants, expenses, balances and settlements.
"
Class {
	#name : 'TripDetailPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-Server-TripDetail',
	#package : 'TripExpenses-Server',
	#tag : 'TripDetail'
}

{ #category : 'rendering' }
TripDetailPresenter >> buildParticipantOptionsString [
	"Encode les participants comme String pour la vue.
	 Format : 'id1:Alice|id2:Bob' — uniquement des String, CP peut encoder."
	^ '|' join: (self model participants collect: [ :p |
		p participantId , ':' , p name ])
]

{ #category : 'rendering' }
TripDetailPresenter >> onAddExpense: anAnnouncement [
	| amount allParticipantIds |
	amount := anAnnouncement amountString asNumber.
	allParticipantIds := self model participants collect: [ :p | p participantId ].
	self model
		addExpenseDescription: anAnnouncement description
		amount:                amount
		payerId:               anAnnouncement payerId
		participantIds:        allParticipantIds
]

{ #category : 'rendering' }
TripDetailPresenter >> onHideExpenseForm [
	self model hideExpenseForm
]

{ #category : 'rendering' }
TripDetailPresenter >> onShowExpenseForm [
	self model showExpenseForm
]

{ #category : 'rendering' }
TripDetailPresenter >> renderView [
	"Header — uniquement des String"
	self view
		renderTripName:     self model tripName;
		renderCurrency:     self model currency;
		renderTotalExpenses: self model totalExpenses;
		renderErrorMessage:   (self model errorMessage ifNil: [ '' ]);
		renderShowExpenseForm: self model showingExpenseForm.
 
	"Listes — child presenters, CP gère la sérialisation"
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
		atSlotNamed: #settlements.
 
	"Formulaire : envoie les participants sous forme de String encodable
	 Format : 'id1:Alice|id2:Bob' — la vue split pour construire le select"
	self view renderParticipantOptions: self buildParticipantOptionsString
]

{ #category : 'rendering' }
TripDetailPresenter >> viewCreated [
	super viewCreated.
	self view
		when: TripDetailShowExpenseFormRequested send: #onShowExpenseForm    to: self;
		when: TripDetailHideExpenseFormRequested send: #onHideExpenseForm    to: self;
		when: TripDetailAddExpenseRequested      send: #onAddExpense:        to: self
]
