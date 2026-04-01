"
Je teste TripListModel APRÈS refactorisation.
La différence avec TripListModelTest :
  - service est un TripApplicationService, PAS un TripExpensesServerApp.
  - Aucun handleMessage: / Dictionary JSON dans les tests ni dans le code testé.
  - TripListModel appelle service directement (allTrips, createTrip:currency:).
Ces tests doivent être ROUGES avant refactorisation, VERTS après.
"
Class {
	#name : 'TripListModelV2Test',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'model',
		'tripId',
		'aliceId',
		'bobId'
	],
	#category : 'TripExpenses-Server-tests',
	#package : 'TripExpenses-Server-tests'
}

{ #category : 'helpers' }
TripListModelV2Test >> addExpenseAmount: anAmount [
	"Dépense simple payée par Alice, répartie entre Alice et Bob."
	model
		addExpenseDescription: 'Resto'
		amount:                anAmount
		payerId:               aliceId
		participantIds:        { aliceId. bobId }
]

{ #category : 'helpers' }
TripListModelV2Test >> createTripNamed: aName [
	"On crée le voyage via le service directement, puis on recharge."
	service createTrip: aName currency: 'EUR'.
	model loadTrips
]

{ #category : 'running' }
TripListModelV2Test >> estLoadTripsClearsPreviousTrips [
	"Un second loadTrips ne duplique pas les voyages."
	self createTripNamed: 'Vacances'.
	model loadTrips.
	self assert: model trips size equals: 1
]

{ #category : 'helpers' }
TripListModelV2Test >> setUp [
| trip alice bob |
	service := TripApplicationService withRepository: InMemoryTripRepository new.
	trip    := service createTrip: 'Vacances' currency: 'EUR'.
	alice   := service addParticipant: 'Alice' toTrip: trip id.
	bob     := service addParticipant: 'Bob'   toTrip: trip id.
	tripId  := trip id.
	aliceId := alice id value.
	bobId   := bob id value.
	model   := TripDetailModel onService: service tripId: tripId
]

{ #category : 'running' }
TripListModelV2Test >> testAddExpenseAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	self addExpenseAmount: 60.
	self assert: announced
]

{ #category : 'running' }
TripListModelV2Test >> testAddExpenseAppearsInExpenses [
	self addExpenseAmount: 60.
	self assert: model expenses size equals: 1
]

{ #category : 'running' }
TripListModelV2Test >> testAddExpenseCreatesSettlement [
	self addExpenseAmount: 60.
	self assert: model settlements size equals: 1
]

{ #category : 'running' }
TripListModelV2Test >> testAddExpenseExpenseItemHasAmount [
	"Le montant est stocké comme String affichable."
	self addExpenseAmount: 60.
	self assert: model expenses first amount isNotNil
]

{ #category : 'running' }
TripListModelV2Test >> testAddExpenseExpenseItemHasDescription [
	self addExpenseAmount: 60.
	self assert: model expenses first description equals: 'Resto'
]

{ #category : 'running' }
TripListModelV2Test >> testAddExpenseHidesForm [
	model showExpenseForm.
	self addExpenseAmount: 60.
	self deny: model showingExpenseForm
]

{ #category : 'running' }
TripListModelV2Test >> testAddExpenseIsATripExpenseItemModel [
	self addExpenseAmount: 60.
	self assert: (model expenses first isKindOf: TripExpenseExpenseItemModel)
]

{ #category : 'running' }
TripListModelV2Test >> testAddExpenseSettlementHasFromAndTo [
	"Le règlement doit exposer les noms des participants."
	| s |
	self addExpenseAmount: 60.

	s := model settlements first.
	self assert: (s fromName isNotNil and: [ s toName isNotNil ])
]

{ #category : 'running' }
TripListModelV2Test >> testAddExpenseUpdatesBalances [
	| aliceBalance |
	self addExpenseAmount: 60.
	aliceBalance := model balances detect: [ :b | b participantName = 'Alice' ].
	self assert: aliceBalance amount equals: '30'
]

{ #category : 'helpers' }
TripListModelV2Test >> testAddExpenseWithBlankDescriptionDoesNotAddExpense [
	model addExpenseDescription: '' amount: 60 payerId: aliceId participantIds: { aliceId. bobId }.
	self assert: model expenses isEmpty
]

{ #category : 'helpers' }
TripListModelV2Test >> testAddExpenseWithBlankDescriptionSetsError [
	model addExpenseDescription: '' amount: 60 payerId: aliceId participantIds: { aliceId. bobId }.
	self assert: model errorMessage isNotNil
]

{ #category : 'helpers' }
TripListModelV2Test >> testAddExpenseWithEmptyParticipantsSetsError [
	model addExpenseDescription: 'Resto' amount: 60 payerId: aliceId participantIds: #().
	self assert: model errorMessage isNotNil
]

{ #category : 'helpers' }
TripListModelV2Test >> testAddExpenseWithNegativeAmountSetsError [
	model addExpenseDescription: 'Resto' amount: -10 payerId: aliceId participantIds: { aliceId. bobId }.
	self assert: model errorMessage isNotNil
]

{ #category : 'helpers' }
TripListModelV2Test >> testAddExpenseWithZeroAmountSetsError [
	model addExpenseDescription: 'Resto' amount: 0 payerId: aliceId participantIds: { aliceId. bobId }.
	self assert: model errorMessage isNotNil
]

{ #category : 'running' }
TripListModelV2Test >> testAddTwoExpensesBothInList [
	self addExpenseAmount: 60.
	self addExpenseAmount: 40.
	self assert: model expenses size equals: 2
]

{ #category : 'helpers' }
TripListModelV2Test >> testAddValidExpenseClearsError [
	model addExpenseDescription: '' amount: 60 payerId: aliceId participantIds: { aliceId. bobId }.
	self addExpenseAmount: 30.
	self assert: model errorMessage isNil
]

{ #category : 'running' }
TripListModelV2Test >> testCreateTripAddsToList [
	model createTripNamed: 'Nouveau voyage' currency: 'EUR'.
	self assert: model trips size equals: 1
]

{ #category : 'running' }
TripListModelV2Test >> testCreateTripAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model createTripNamed: 'Voyage' currency: 'EUR'.
	self assert: announced
]

{ #category : 'running' }
TripListModelV2Test >> testCreateTripClearsErrorOnSuccess [
	model createTripNamed: '' currency: 'EUR'.
	model createTripNamed: 'Voyage valide' currency: 'EUR'.
	self assert: model errorMessage isNil
]

{ #category : 'running' }
TripListModelV2Test >> testCreateTripHidesForm [
	model showCreateForm.
	model createTripNamed: 'Voyage' currency: 'EUR'.
	self deny: model showingCreateForm
]

{ #category : 'running' }
TripListModelV2Test >> testCreateTripStoresCorrectName [
	model createTripNamed: 'Nouveau voyage' currency: 'EUR'.
	self assert: (model trips anySatisfy: [ :v | v name = 'Nouveau voyage' ])
]

{ #category : 'running' }
TripListModelV2Test >> testCreateTripStoresCurrency [
	model createTripNamed: 'Voyage USD' currency: 'USD'.
	self assert: (model trips anySatisfy: [ :v | v currency = 'USD' ])
]

{ #category : 'running' }
TripListModelV2Test >> testCreateTripWithBlankCurrencySetsError [
	model createTripNamed: 'Voyage' currency: ''.
	self assert: model errorMessage isNotNil
]

{ #category : 'running' }
TripListModelV2Test >> testCreateTripWithBlankNameDoesNotAddToList [
	model createTripNamed: '' currency: 'EUR'.
	self assert: model trips isEmpty
]

{ #category : 'running' }
TripListModelV2Test >> testCreateTripWithBlankNameSetsError [
	model createTripNamed: '' currency: 'EUR'.
	self assert: model errorMessage isNotNil
]

{ #category : 'running' }
TripListModelV2Test >> testCreateTripWithWhitespaceNameSetsError [
	model createTripNamed: '   ' currency: 'EUR'.
	self assert: model errorMessage isNotNil
]

{ #category : 'running' }
TripListModelV2Test >> testCreateTwoTripsBothInList [
	model createTripNamed: 'Vacances' currency: 'EUR'.
	model createTripNamed: 'Road trip' currency: 'USD'.
	self assert: model trips size equals: 2
]

{ #category : 'running' }
TripListModelV2Test >> testHideCreateFormAnnouncesValueChanged [
	| announced |
	announced := false.
	model showCreateForm.
	model when: ValueChanged do: [ announced := true ].
	model hideCreateForm.
	self assert: announced
]

{ #category : 'running' }
TripListModelV2Test >> testHideCreateFormClearsError [
	model errorMessage: 'une erreur'.
	model hideCreateForm.
	self assert: model errorMessage isNil
]

{ #category : 'running' }
TripListModelV2Test >> testHideCreateFormClearsFlag [
	model showCreateForm.
	model hideCreateForm.
	self deny: model showingCreateForm
]

{ #category : 'helpers' }
TripListModelV2Test >> testHideExpenseFormAnnouncesValueChanged [
	| announced |
	announced := false.
	model showExpenseForm.
	model when: ValueChanged do: [ announced := true ].
	model hideExpenseForm.
	self assert: announced
]

{ #category : 'helpers' }
TripListModelV2Test >> testHideExpenseFormClearsError [
	model errorMessage: 'une erreur'.
	model hideExpenseForm.
	self assert: model errorMessage isNil
]

{ #category : 'helpers' }
TripListModelV2Test >> testHideExpenseFormClearsFlag [
	model showExpenseForm.
	model hideExpenseForm.
	self deny: model showingExpenseForm
]

{ #category : 'running' }
TripListModelV2Test >> testInitialBalancesHasOneEntryPerParticipant [
	self assert: model balances size equals: 2
]

{ #category : 'running' }
TripListModelV2Test >> testInitialErrorIsNil [
	self assert: model errorMessage isNil
]

{ #category : 'running' }
TripListModelV2Test >> testInitialExpensesIsEmpty [
	self assert: model expenses isEmpty
]

{ #category : 'running' }
TripListModelV2Test >> testInitialSettlementsIsEmpty [
	self assert: model settlements isEmpty
]

{ #category : 'running' }
TripListModelV2Test >> testInitialShowingCreateFormIsFalse [
	self deny: model showingCreateForm
]

{ #category : 'running' }
TripListModelV2Test >> testInitialShowingExpenseFormIsFalse [
	self deny: model showingExpenseForm
]

{ #category : 'running' }
TripListModelV2Test >> testInitialTripsIsEmpty [
	self assert: model trips isEmpty
]

{ #category : 'running' }
TripListModelV2Test >> testLoadTripAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model loadTrip.
	self assert: announced
]

{ #category : 'running' }
TripListModelV2Test >> testLoadTripHasTwoParticipants [
	self assert: model participants size equals: 2
]

{ #category : 'running' }
TripListModelV2Test >> testLoadTripStoresCurrency [
	self assert: model currency equals: 'EUR'
]

{ #category : 'running' }
TripListModelV2Test >> testLoadTripStoresName [
	self assert: model tripName equals: 'Vacances'
]

{ #category : 'running' }
TripListModelV2Test >> testLoadTripsAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model loadTrips.
	self assert: announced
]

{ #category : 'running' }
TripListModelV2Test >> testLoadTripsItemHasTripId [
	"TripItemModel doit exposer un tripId non nil pour permettre la navigation."
	self createTripNamed: 'Vacances'.
	self assert: model trips first tripId isNotNil
]

{ #category : 'running' }
TripListModelV2Test >> testLoadTripsPopulatesTrips [
	self createTripNamed: 'Vacances'.
	self assert: model trips size equals: 1
]

{ #category : 'running' }
TripListModelV2Test >> testLoadTripsResetsError [
	model errorMessage: 'une erreur'.
	model loadTrips.
	self assert: model errorMessage isNil
]

{ #category : 'running' }
TripListModelV2Test >> testLoadTripsReturnsTripItemModels [
	"Chaque élément de trips doit être un TripItemModel."
	self createTripNamed: 'Vacances'.
	self assert: (model trips first isKindOf: TripItemModel)
]

{ #category : 'running' }
TripListModelV2Test >> testLoadTripsStoresName [
	self createTripNamed: 'Vacances'.
	self assert: (model trips anySatisfy: [ :v | v name = 'Vacances' ])
]

{ #category : 'running' }
TripListModelV2Test >> testParticipantsAreTripParticipantModels [
	self assert: (model participants first isKindOf: TripParticipantModel)
]

{ #category : 'running' }
TripListModelV2Test >> testParticipantsExposeParticipantId [
	"participantId doit être une String non vide — la vue en a besoin pour le select."
	model participants do: [ :p |
		self assert: p participantId isNotNil.
		self deny: p participantId isEmpty ]
]

{ #category : 'running' }
TripListModelV2Test >> testParticipantsHaveNames [
	| names |
	names := model participants collect: [ :p | p name ].
	self assert: (names includes: 'Alice').
	self assert: (names includes: 'Bob')
]

{ #category : 'running' }
TripListModelV2Test >> testShowCreateFormAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model showCreateForm.
	self assert: announced
]

{ #category : 'running' }
TripListModelV2Test >> testShowCreateFormClearsError [
	model errorMessage: 'une erreur'.
	model showCreateForm.
	self assert: model errorMessage isNil
]

{ #category : 'running' }
TripListModelV2Test >> testShowCreateFormSetsFlag [
	model showCreateForm.
	self assert: model showingCreateForm
]

{ #category : 'helpers' }
TripListModelV2Test >> testShowExpenseFormAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model showExpenseForm.
	self assert: announced
]

{ #category : 'helpers' }
TripListModelV2Test >> testShowExpenseFormClearsError [
	model errorMessage: 'une erreur'.
	model showExpenseForm.
	self assert: model errorMessage isNil
]

{ #category : 'helpers' }
TripListModelV2Test >> testShowExpenseFormSetsFlag [
	model showExpenseForm.
	self assert: model showingExpenseForm
]
