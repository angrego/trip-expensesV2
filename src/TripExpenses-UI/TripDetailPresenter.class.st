"
Je rends le detail d un seul voyage.
J utilise des child presenters pour participants, depenses, balances et reglements.
Le bouton Retour delegue via self application navigateToList
qui delegue a TripAppModel navigateToList qui annonce valueChanged.
"
Class {
	#name : 'TripDetailPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'event handling' }
TripDetailPresenter >> onBackRequested [
	self application navigateToList
]

{ #category : 'event handling' }
TripDetailPresenter >> onDeleteExpenseId: anExpenseId [
	"Appele par TripExpenseItemPresenter quand l utilisateur supprime une depense."

	self model removeExpenseId: anExpenseId 
]

{ #category : 'event handling' }
TripDetailPresenter >> onExpenseAdded [
    self model loadTrip
]

{ #category : 'event handling' }
TripDetailPresenter >> onInclusionChanged: anAnnouncement [
    anAnnouncement included
        ifTrue:  [ self model includeParticipantId: anAnnouncement participantId ]
        ifFalse: [ self model excludeParticipantId: anAnnouncement participantId ]
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

{ #category : 'event handling' }
TripDetailPresenter >> onWeightChanged: anAnnouncement [
    self model
        setWeight: anAnnouncement weight
        forParticipantId: anAnnouncement participantId
]

{ #category : 'rendering' }
TripDetailPresenter >> renderView [
    self view
        renderTripName: self model tripName;
        renderCurrency: self model currency;
        renderTotalExpenses: self model totalExpenses;
        renderErrorMessage: (self model errorMessage ifNil: [ '' ]);
        renderShowExpenseForm: self model showingExpenseForm;
        renderEmptySettlements: self model settlements isEmpty.
    self
        renderAllChildViewsForModels: self model participants
        atSlotNamed: #participants.
    self
        renderChildViewForModel: self model addParticipantModel
        atSlotNamed: #addParticipant.
    self
        renderAllChildViewsForModels: self model expenses
        atSlotNamed: #expenses.
    self model expenseFormModel isShowing ifTrue: [
        self
            renderChildViewForModel: self model expenseFormModel
            atSlotNamed: #expenseForm ].
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
    self model addParticipantModel
        when: ValueChanged
        send: #onParticipantAdded
        to: self.
    self view
        when: TripDetailBackRequested            send: #onBackRequested   to: self;
        when: TripDetailShowExpenseFormRequested send: #onShowExpenseForm to: self
]
