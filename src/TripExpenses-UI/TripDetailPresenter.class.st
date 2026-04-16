"
Je rends le detail d un seul voyage.
J utilise des child presenters pour participants, depenses, balances et reglements.
Le bouton Retour delegue via self application navigateToList
qui delegue a TripAppModel navigateToList qui annonce valueChanged.
"
Class {
	#name : 'TripDetailPresenter',
	#superclass : 'CpPresenter',
	#instVars : [
		'participantListModel',
		'expenseListModel',
		'balanceModel',
		'generosityModel'
	],
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'operations' }
TripDetailPresenter >> loadAllSubModels [
    participantListModel load.
    expenseListModel load.
    balanceModel load.
    generosityModel load
]

{ #category : 'event handling' }
TripDetailPresenter >> onBackRequested [
	self application navigateToList
]

{ #category : 'event handling' }
TripDetailPresenter >> onDeleteExpenseId: anExpenseId [
	"Appele par TripExpenseItemPresenter quand l utilisateur supprime une depense."
    self model removeExpenseId: anExpenseId.
    self loadAllSubModels
]

{ #category : 'event handling' }
TripDetailPresenter >> onExpenseAdded [


	self loadAllSubModels.
		self model loadTrip.
]

{ #category : 'event handling' }
TripDetailPresenter >> onExpenseFormHidden [
    self model hideExpenseForm
]

{ #category : 'event handling' }
TripDetailPresenter >> onHideExpenseForm [
    self model hideExpenseForm
]

{ #category : 'event handling' }
TripDetailPresenter >> onInclusionChanged: anAnnouncement [
    anAnnouncement included
        ifTrue:  [ self model includeParticipantId: anAnnouncement participantId ]
        ifFalse: [ self model excludeParticipantId: anAnnouncement participantId ]
]

{ #category : 'event handling' }
TripDetailPresenter >> onParticipantAdded [
    self loadAllSubModels.
    self renderView
]

{ #category : 'event handling' }
TripDetailPresenter >> onShowExpenseForm [
    self model showExpenseFormForParticipant: self application currentParticipantName
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
        renderTripName:       self model tripName;
        renderCurrency:       self model currency;
        renderTotalExpenses:  self model totalExpenses;
        renderErrorMessage:   (self model errorMessage ifNil: [ '' ]);
        renderShowExpenseForm: self model showingExpenseForm;
        renderEmptySettlements: balanceModel settlements isEmpty.
    self
        renderAllChildViewsForModels: participantListModel participants
        atSlotNamed: #participants.
    self
        renderChildViewForModel: self model addParticipantModel
        atSlotNamed: #addParticipant.
    self
        renderAllChildViewsForModels: expenseListModel expenses
        atSlotNamed: #expenses.
    self model showingExpenseForm ifTrue: [
        self
            renderChildViewForModel: self model expenseFormModel
            atSlotNamed: #expenseForm ].
    self
        renderAllChildViewsForModels: balanceModel balances
        atSlotNamed: #balances.
    self
        renderAllChildViewsForModels: balanceModel settlements
        atSlotNamed: #settlements.
    self
        renderChildViewForModel: generosityModel
        atSlotNamed: #generosity
]

{ #category : 'view' }
TripDetailPresenter >> viewCreated [
    super viewCreated.
    participantListModel := TripParticipantListModel
        onService: self model service
        tripId:   self model tripId.
    expenseListModel := TripExpenseListModel
        onService: self model service
        tripId:   self model tripId.
    balanceModel := TripBalanceModel
        onService: self model service
        tripId:   self model tripId.
    generosityModel := TripGenerosityModel
        onService: self model service
        tripId:   self model tripId.
    self loadAllSubModels.
    self model addParticipantModel
        when: ValueChanged
        send: #onParticipantAdded
        to: self.
    self view
        when: TripDetailBackRequested            send: #onBackRequested    to: self;
        when: TripDetailShowExpenseFormRequested send: #onShowExpenseForm  to: self;
        when: TripDetailHideExpenseFormRequested send: #onHideExpenseForm  to: self
]
