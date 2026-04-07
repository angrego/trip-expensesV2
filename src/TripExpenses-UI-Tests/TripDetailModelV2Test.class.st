"
Je teste TripDetailModel APRÈS refactorisation.
La différence avec TripDetailModelTest :
  - service est un TripApplicationService pur, PAS un TripExpensesServerApp.
  - Aucun handleMessage: / Dictionary JSON dans le setUp ni dans le code testé.
  - TripDetailModel appelle service directement (findTrip:, addExpense:toTrip:, etc.).
Ces tests doivent être ROUGES avant refactorisation, VERTS après.
"
Class {
	#name : 'TripDetailModelV2Test',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'model',
		'tripId',
		'aliceId',
		'bobId'
	],
	#category : 'TripExpenses-UI-Tests-TripDetail',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'TripDetail'
}

{ #category : 'helpers' }
TripDetailModelV2Test >> addExpenseAmount: anAmount [
	"Dépense simple payée par Alice, répartie entre Alice et Bob."

	model
		addExpenseDescription: 'Resto'
		amount: anAmount
		payerId: aliceId
		participantWeights: {
				(aliceId -> 1).
				(bobId -> 1) }
]

{ #category : 'helpers' }
TripDetailModelV2Test >> addExpenseAmount: anAmount weights: aPairCollection [

	model
		addExpenseDescription: 'Resto'
		amount: anAmount
		payerId: aliceId
		participantWeights: aPairCollection
]

{ #category : 'running' }
TripDetailModelV2Test >> setUp [

	| trip alice bob |
	service := TripApplicationService withRepository:
		           InMemoryTripRepository new.
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	alice := service addParticipantByName: 'Alice' toTrip: trip id.
	bob := service addParticipantByName: 'Bob' toTrip: trip id.
	tripId := trip id.
	aliceId := alice id value.
	bobId := bob id value.
	model := TripDetailModel onService: service tripId: tripId
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testAddExpenseAllWeightsZeroSetsErrorMessage [
	"Tous les poids à zéro → aucun participant dans la split rule → erreur."

	model addExpenseDescription: 'Resto' amount: 90 payerId: aliceId participantWeights: { aliceId -> 0. bobId -> 0 }.
    self assert: model errorMessage isNotNil.
    self deny: model errorMessage isEmpty
]

{ #category : 'tests - ajout dépense' }
TripDetailModelV2Test >> testAddExpenseAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model addExpenseDescription:  'Resto' amount: 90 payerId: aliceId participantWeights: { aliceId -> 1. bobId -> 1 }.
    self assert: announced
]

{ #category : 'tests - ajout dépense' }
TripDetailModelV2Test >> testAddExpenseAppearsInExpenses [

self addExpenseAmount: 60.
self assert: model expenses size equals: 1
]

{ #category : 'tests - ajout dépense' }
TripDetailModelV2Test >> testAddExpenseCreatesSettlement [
	self addExpenseAmount: 60.
	self assert: model settlements size equals: 1
]

{ #category : 'tests - ajout dépense' }
TripDetailModelV2Test >> testAddExpenseExpenseItemHasAmount [
"Le montant est stocké comme String affichable."

	self addExpenseAmount: 60.
	self assert: model expenses first amount isNotNil
]

{ #category : 'tests - ajout dépense' }
TripDetailModelV2Test >> testAddExpenseExpenseItemHasDescription [

self addExpenseAmount: 60.
	self assert: model expenses first description equals: 'Resto'
]

{ #category : 'tests - ajout dépense' }
TripDetailModelV2Test >> testAddExpenseHidesForm [

model showExpenseForm.
	self addExpenseAmount: 60.
	self deny: model showingExpenseForm
]

{ #category : 'tests - ajout dépense' }
TripDetailModelV2Test >> testAddExpenseIsATripExpenseItemModel [

self addExpenseAmount: 60.
	self assert:
		(model expenses first isKindOf: TripExpenseExpenseItemModel)
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testAddExpenseIsSavedInTrip [
    model addExpenseDescription: 'Resto' amount: 90 payerId: aliceId participantWeights: { aliceId -> 1. bobId -> 1 }.
    self assert: (service findTrip: tripId) expenses size equals: 1
]

{ #category : 'tests - validation' }
TripDetailModelV2Test >> testAddExpenseSettlementHasFromAndTo [
	| s |
	"Le règlement doit exposer les noms des participants."
	self addExpenseAmount: 60.

	s := model settlements first.
	self assert: (s fromName isNotNil and: [ s toName isNotNil ])
]

{ #category : 'tests - ajout dépense' }
TripDetailModelV2Test >> testAddExpenseUpdatesBalances [

	| aliceBalance |
	self addExpenseAmount: 60.
	aliceBalance := model balances detect: [ :b |
		                b participantName = 'Alice' ].
	self assert: aliceBalance amount equals: '30'
]

{ #category : 'tests - validation' }
TripDetailModelV2Test >> testAddExpenseWithBlankDescriptionDoesNotAddExpense [
	model
		addExpenseDescription: ''
		amount: 60
		payerId: aliceId
participantWeights: { aliceId -> 1. bobId -> 1 }.
	self assert: model expenses isEmpty
]

{ #category : 'tests - validation' }
TripDetailModelV2Test >> testAddExpenseWithBlankDescriptionSetsError [

model
		addExpenseDescription: ''
		amount: 60
		payerId: aliceId
	participantWeights: { aliceId -> 1. bobId -> 1 }.
	self assert: model errorMessage isNotNil
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testAddExpenseWithDoubleWeightForAlice [
    "Alice poids 2, Bob poids 1 → Alice doit payer 60, Bob 30.
     Alice paie tout (90) → balance Alice = +30, Bob = -30."
    | trip alice bob expense |
    self addExpenseAmount: 90 weights: { aliceId -> 2. bobId -> 1 }.
    trip    := service findTrip: tripId.
    expense := trip expenses first.
    alice   := trip participants detect: [ :p | p id value = aliceId ].
    bob     := trip participants detect: [ :p | p id value = bobId ].
    self assert: (expense balanceFor: alice) amount equals: 30.
    self assert: (expense balanceFor: bob)   amount equals: -30
]

{ #category : 'tests - validation' }
TripDetailModelV2Test >> testAddExpenseWithEmptyParticipantsSetsError [

model
		addExpenseDescription: 'Resto'
		amount: 60
		payerId: aliceId
		participantWeights: #(  ).
	self assert: model errorMessage isNotNil
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testAddExpenseWithEqualWeightsBalancesCorrectly [
    "Poids identiques → même comportement qu'avant."
    | trip alice expense |
    self addExpenseAmount: 90 weights: { aliceId -> 1. bobId -> 1 }.
    trip    := service findTrip: tripId.
    expense := trip expenses first.
    alice   := trip participants detect: [ :p | p id value = aliceId ].
    self assert: (expense balanceFor: alice) amount equals: 45
]

{ #category : 'tests - validation' }
TripDetailModelV2Test >> testAddExpenseWithNegativeAmountSetsError [

model
		addExpenseDescription: 'Resto'
		amount: -10
		payerId: aliceId
participantWeights: { aliceId -> 1. bobId -> 1 }.
	self assert: model errorMessage isNotNil
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testAddExpenseWithWeightsAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    self addExpenseAmount: 90 weights: { aliceId -> 2. bobId -> 1 }.
    self assert: announced
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testAddExpenseWithWeightsCreatesCorrectSplitRule [
    "Alice poids 2, Bob poids 1 → Alice paie double part"
 | trip expense |    
self addExpenseAmount: 90 weights: { aliceId -> 2. bobId -> 1 }.
   
    trip := service findTrip: tripId.
    expense := trip expenses first.
    self assert: (expense balanceFor: (trip participants detect: [:p | p id value = aliceId])) amount equals: 30.
    self assert: (expense balanceFor: (trip participants detect: [:p | p id value = bobId])) amount equals: -30
]

{ #category : 'tests - validation' }
TripDetailModelV2Test >> testAddExpenseWithZeroAmountSetsError [

	model
		addExpenseDescription: 'Resto'
		amount: 0
		payerId: aliceId
participantWeights: { aliceId -> 1. bobId -> 1 }.
	self assert: model errorMessage isNotNil
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testAddExpenseWithZeroWeightExcludesParticipant [
    "Bob poids 0 → seule Alice est dans la répartition.
     Alice paie 90, part 90 → balance zéro pour Alice, zéro pour Bob."
    | trip alice bob expense |
    self addExpenseAmount: 90 weights: { aliceId -> 1. bobId -> 0 }.
    trip    := service findTrip: tripId.
    expense := trip expenses first.
    alice   := trip participants detect: [ :p | p id value = aliceId ].
    bob     := trip participants detect: [ :p | p id value = bobId ].
    self assert: (expense balanceFor: alice) amount equals: 0.
    self assert: (expense balanceFor: bob)   amount equals: 0
]

{ #category : 'tests - ajout dépense' }
TripDetailModelV2Test >> testAddTwoExpensesBothInList [

self addExpenseAmount: 60.
	self addExpenseAmount: 40.
	self assert: model expenses size equals: 2
]

{ #category : 'tests - validation' }
TripDetailModelV2Test >> testAddValidExpenseClearsError [
	model
		addExpenseDescription: ''
		amount: 60
		payerId: aliceId
participantWeights: { aliceId -> 1. bobId -> 1 }.
	self addExpenseAmount: 30.
	self assert: model errorMessage isNil
]

{ #category : 'tests - formulaire' }
TripDetailModelV2Test >> testHideExpenseFormAnnouncesValueChanged [

| announced |
	announced := false.
	model showExpenseForm.
	model when: ValueChanged do: [ announced := true ].
	model hideExpenseForm.
	self assert: announced
]

{ #category : 'tests - formulaire' }
TripDetailModelV2Test >> testHideExpenseFormClearsError [

model errorMessage: 'une erreur'.
	model hideExpenseForm.
	self assert: model errorMessage isNil
]

{ #category : 'tests - formulaire' }
TripDetailModelV2Test >> testHideExpenseFormClearsFlag [

model showExpenseForm.
	model hideExpenseForm.
	self deny: model showingExpenseForm
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testInitialBalancesHasOneEntryPerParticipant [

self assert: model balances size equals: 2
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testInitialErrorIsNil [

self assert: model errorMessage isNil
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testInitialExpensesIsEmpty [

self assert: model expenses isEmpty
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testInitialSettlementsIsEmpty [

self assert: model settlements isEmpty
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testInitialShowingExpenseFormIsFalse [

self deny: model showingExpenseForm
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testLoadTripAnnouncesValueChanged [

| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model loadTrip.
	self assert: announced
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testLoadTripHasTwoParticipants [

self assert: model participants size equals: 2
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testLoadTripStoresCurrency [

self assert: model currency equals: 'EUR'
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testLoadTripStoresName [

self assert: model tripName equals: 'Vacances'
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testParticipantsAreTripParticipantModels [

self assert:
		(model participants first isKindOf: TripParticipantModel)
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testParticipantsExposeParticipantId [
"participantId doit être une String non vide — la vue en a besoin pour le select."

	model participants do: [ :p |
			self assert: p participantId isNotNil.
			self deny: p participantId isEmpty ]
]

{ #category : 'tests - chargement' }
TripDetailModelV2Test >> testParticipantsHaveNames [

| names |
	names := model participants collect: [ :p | p name ].
	self assert: (names includes: 'Alice').
	self assert: (names includes: 'Bob')
]

{ #category : 'tests - formulaire' }
TripDetailModelV2Test >> testShowExpenseFormAnnouncesValueChanged [

| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model showExpenseForm.
	self assert: announced
]

{ #category : 'tests - formulaire' }
TripDetailModelV2Test >> testShowExpenseFormClearsError [

model errorMessage: 'une erreur'.
	model showExpenseForm.
	self assert: model errorMessage isNil
]

{ #category : 'tests - formulaire' }
TripDetailModelV2Test >> testShowExpenseFormSetsFlag [

model showExpenseForm.
	self assert: model showingExpenseForm
]
