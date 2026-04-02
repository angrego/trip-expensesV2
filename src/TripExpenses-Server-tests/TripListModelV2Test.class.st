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
		'model'
	],
	#category : 'TripExpenses-Server-tests',
	#package : 'TripExpenses-Server-tests'
}

{ #category : 'helpers' }
TripListModelV2Test >> createTripNamed: aName [
	"On crée le voyage via le service directement, puis on recharge."
	service createTrip: aName currency: 'EUR'.
	model loadTrips
]

{ #category : 'running' }
TripListModelV2Test >> setUp [
	"Le service est un TripApplicationService pur — pas de CpServerApplication."
	service := TripApplicationService withRepository: InMemoryTripRepository new.
	model   := TripListModel onService: service
]

{ #category : 'tests - createTrip' }
TripListModelV2Test >> testCreateTripAddsToList [
	model createTripNamed: 'Nouveau voyage' currency: 'EUR'.
	self assert: model trips size equals: 1
]

{ #category : 'tests - createTrip' }
TripListModelV2Test >> testCreateTripAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model createTripNamed: 'Voyage' currency: 'EUR'.
	self assert: announced
]

{ #category : 'tests - createTrip' }
TripListModelV2Test >> testCreateTripClearsErrorOnSuccess [
	model createTripNamed: '' currency: 'EUR'.
	model createTripNamed: 'Voyage valide' currency: 'EUR'.
	self assert: model errorMessage isNil
]

{ #category : 'tests - createTrip' }
TripListModelV2Test >> testCreateTripHidesForm [
	model showCreateForm.
	model createTripNamed: 'Voyage' currency: 'EUR'.
	self deny: model showingCreateForm
]

{ #category : 'tests - createTrip' }
TripListModelV2Test >> testCreateTripStoresCorrectName [
	model createTripNamed: 'Nouveau voyage' currency: 'EUR'.
	self assert: (model trips anySatisfy: [ :v | v name = 'Nouveau voyage' ])
]

{ #category : 'tests - createTrip' }
TripListModelV2Test >> testCreateTripStoresCurrency [
	model createTripNamed: 'Voyage USD' currency: 'USD'.
	self assert: (model trips anySatisfy: [ :v | v currency = 'USD' ])
]

{ #category : 'tests - createTrip' }
TripListModelV2Test >> testCreateTripWithBlankCurrencySetsError [
	model createTripNamed: 'Voyage' currency: ''.
	self assert: model errorMessage isNotNil
]

{ #category : 'tests - createTrip' }
TripListModelV2Test >> testCreateTripWithBlankNameDoesNotAddToList [
	model createTripNamed: '' currency: 'EUR'.
	self assert: model trips isEmpty
]

{ #category : 'tests - createTrip' }
TripListModelV2Test >> testCreateTripWithBlankNameSetsError [
	model createTripNamed: '' currency: 'EUR'.
	self assert: model errorMessage isNotNil
]

{ #category : 'tests - createTrip' }
TripListModelV2Test >> testCreateTripWithWhitespaceNameSetsError [
	model createTripNamed: '   ' currency: 'EUR'.
	self assert: model errorMessage isNotNil
]

{ #category : 'tests - createTrip' }
TripListModelV2Test >> testCreateTwoTripsBothInList [
	model createTripNamed: 'Vacances' currency: 'EUR'.
	model createTripNamed: 'Road trip' currency: 'USD'.
	self assert: model trips size equals: 2
]

{ #category : 'tests - formulaire' }
TripListModelV2Test >> testHideCreateFormAnnouncesValueChanged [
	| announced |
	announced := false.
	model showCreateForm.
	model when: ValueChanged do: [ announced := true ].
	model hideCreateForm.
	self assert: announced
]

{ #category : 'tests - formulaire' }
TripListModelV2Test >> testHideCreateFormClearsError [
	model errorMessage: 'une erreur'.
	model hideCreateForm.
	self assert: model errorMessage isNil
]

{ #category : 'tests - formulaire' }
TripListModelV2Test >> testHideCreateFormClearsFlag [
	model showCreateForm.
	model hideCreateForm.
	self deny: model showingCreateForm
]

{ #category : 'tests - état initial' }
TripListModelV2Test >> testInitialErrorIsNil [
	self assert: model errorMessage isNil
]

{ #category : 'tests - état initial' }
TripListModelV2Test >> testInitialShowingCreateFormIsFalse [
	self deny: model showingCreateForm
]

{ #category : 'tests - état initial' }
TripListModelV2Test >> testInitialTripsIsEmpty [
	self assert: model trips isEmpty
]

{ #category : 'tests - loadTrips' }
TripListModelV2Test >> testLoadTripsAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model loadTrips.
	self assert: announced
]

{ #category : 'tests - loadTrips' }
TripListModelV2Test >> testLoadTripsClearsPreviousTrips [
	"Un second loadTrips ne duplique pas les voyages."
	self createTripNamed: 'Vacances'.
	model loadTrips.
	self assert: model trips size equals: 1
]

{ #category : 'tests - loadTrips' }
TripListModelV2Test >> testLoadTripsItemHasTripId [
	"TripItemModel doit exposer un tripId non nil pour permettre la navigation."
	self createTripNamed: 'Vacances'.
	self assert: model trips first tripId isNotNil
]

{ #category : 'tests - loadTrips' }
TripListModelV2Test >> testLoadTripsPopulatesTrips [
	self createTripNamed: 'Vacances'.
	self assert: model trips size equals: 1
]

{ #category : 'tests - loadTrips' }
TripListModelV2Test >> testLoadTripsResetsError [
	model errorMessage: 'une erreur'.
	model loadTrips.
	self assert: model errorMessage isNil
]

{ #category : 'tests - loadTrips' }
TripListModelV2Test >> testLoadTripsReturnsTripItemModels [
	"Chaque élément de trips doit être un TripItemModel."
	self createTripNamed: 'Vacances'.
	self assert: (model trips first isKindOf: TripItemModel)
]

{ #category : 'tests - loadTrips' }
TripListModelV2Test >> testLoadTripsStoresName [
	self createTripNamed: 'Vacances'.
	self assert: (model trips anySatisfy: [ :v | v name = 'Vacances' ])
]

{ #category : 'tests - formulaire' }
TripListModelV2Test >> testShowCreateFormAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model showCreateForm.
	self assert: announced
]

{ #category : 'tests - formulaire' }
TripListModelV2Test >> testShowCreateFormClearsError [
	model errorMessage: 'une erreur'.
	model showCreateForm.
	self assert: model errorMessage isNil
]

{ #category : 'tests - formulaire' }
TripListModelV2Test >> testShowCreateFormSetsFlag [
	model showCreateForm.
	self assert: model showingCreateForm
]
