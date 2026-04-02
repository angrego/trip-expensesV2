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

{ #category : 'event handling' }
TripDetailPresenter >> buildPayerOptions [
	"Retourne un Array de Dictionary { 'id' -> String. 'name' -> String }.
	 CP peut serialiser des Dictionary contenant uniquement des String.
	 Plus de String encodee — plus de substrings: fragile."

	^ (self model participants collect: [ :p |
			  Dictionary new
				  at: 'id' put: p participantId;
				  at: 'name' put: p name;
				  yourself ]) asArray 
]

{ #category : 'event handling' }
TripDetailPresenter >> onAddExpense: anAnnouncement [
	| amount allParticipantIds |
	amount := anAnnouncement amountString asNumber.
	allParticipantIds := self model participants collect: [ :p |
		                     p participantId ].
	self model
		addExpenseDescription: anAnnouncement description
		amount: amount
		payerId: anAnnouncement payerId
		participantIds: allParticipantIds
]

{ #category : 'event handling' }
TripDetailPresenter >> onBackRequested [
	self application navigateToList
]

{ #category : 'event handling' }
TripDetailPresenter >> onDeleteExpenseId: anAnouncement [
	"Appele par TripExpenseItemPresenter quand l utilisateur supprime une depense."

	self model removeExpenseId: anAnouncement 
]

{ #category : 'event handling' }
TripDetailPresenter >> onHideExpenseForm [
	self model hideExpenseForm
]

{ #category : 'event handling' }
TripDetailPresenter >> onParticipantAdded [
	"Le composant addParticipant a reussi — on recharge le voyage pour rafraichir la liste des participants et les balances."

	self model loadTrip
]

{ #category : 'event handling' }
TripDetailPresenter >> onShowExpenseForm [
	self model showExpenseForm
]

{ #category : 'rendering' }
TripDetailPresenter >> renderView [

	self view
		renderTripName: self model tripName;
		renderCurrency: self model currency;
		renderTotalExpenses: self model totalExpenses;
		renderErrorMessage: (self model errorMessage ifNil: [ '' ]);
		renderShowExpenseForm: self model showingExpenseForm;
		renderEmptySettlements:   self model settlements isEmpty;
		renderPayerOptions: self buildPayerOptions.
	self
		renderAllChildViewsForModels: self model participants
		atSlotNamed: #participants.
	self
		renderChildViewForModel: self model addParticipantModel
		atSlotNamed: #addParticipant.
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
	"Observe le composant addParticipant : quand il ajoute un participant avec succes, on recharge le detail du voyage."
	self model addParticipantModel
		when: ValueChanged
		send: #onParticipantAdded
		to: self.
	self view
		when: TripDetailBackRequested send: #onBackRequested to: self;
		when: TripDetailShowExpenseFormRequested
		send: #onShowExpenseForm
		to: self;
		when: TripDetailHideExpenseFormRequested
		send: #onHideExpenseForm
		to: self;
		when: TripDetailAddExpenseRequested send: #onAddExpense: to: self
]
