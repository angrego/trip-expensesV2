Class {
	#name : 'TripListModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'app',
		'model'
	],
	#category : 'TripExpenses-Server-tests',
	#package : 'TripExpenses-Server-tests'
}

{ #category : 'helpers' }
TripListModelTest >> announcementCountFrom: aModel [

	| count |
	count := 0.
	aModel when: ValueChanged do: [ count := count + 1 ].
	^ count
]

{ #category : 'helpers' }
TripListModelTest >> createTripNamed: aName [
	app handleMessage: (Dictionary new
		at: 'type'     put: 'createTrip';
		at: 'name'     put: aName;
		at: 'currency' put: 'EUR';
		yourself).
	model loadTrips
]

{ #category : 'running' }
TripListModelTest >> setUp [
	app   := TripExpensesServerApp withRepository: InMemoryTripRepository new.
	model := TripListModel onService: app
]

{ #category : 'helpers' }
TripListModelTest >> testCreateTripAddsToList [
	model createTripNamed: 'Nouveau voyage' currency: 'EUR'.
	self assert: model trips size equals: 1
]

{ #category : 'helpers' }
TripListModelTest >> testCreateTripAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model createTripNamed: 'Voyage' currency: 'EUR'.
	self assert: announced
]

{ #category : 'helpers' }
TripListModelTest >> testCreateTripHidesForm [
	model showCreateForm.
	model createTripNamed: 'Voyage' currency: 'EUR'.
	self deny: model showingCreateForm
]

{ #category : 'helpers' }
TripListModelTest >> testCreateTripStoresCorrectName [
	model createTripNamed: 'Nouveau voyage' currency: 'EUR'.
	self assert: (model trips anySatisfy: [:v | v name='Nouveau voyage'])
]

{ #category : 'helpers' }
TripListModelTest >> testCreateTripWithBlankCurrencySetsError [
	model createTripNamed: 'Voyage' currency: ''.
	self assert: model errorMessage isNotNil
]

{ #category : 'helpers' }
TripListModelTest >> testCreateTripWithBlankNameDoesNotAddToList [
	model createTripNamed: '' currency: 'EUR'.
	self assert: model trips isEmpty
]

{ #category : 'helpers' }
TripListModelTest >> testCreateTripWithBlankNameSetsError [
	model createTripNamed: '' currency: 'EUR'.
	self assert: model errorMessage isNotNil
]

{ #category : 'helpers' }
TripListModelTest >> testCreateTwoTripsBothInList [
	model createTripNamed: 'Vacances' currency: 'EUR'.
	model createTripNamed: 'Road trip' currency: 'USD'.
	self assert: model trips size equals: 2
]

{ #category : 'helpers' }
TripListModelTest >> testHideCreateFormAnnouncesValueChanged [
	| announced |
	announced := false.
	model showCreateForm.
	model when: ValueChanged do: [ announced := true ].
	model hideCreateForm.
	self assert: announced
]

{ #category : 'helpers' }
TripListModelTest >> testHideCreateFormClearsError [
	model errorMessage: 'une erreur'.
	model hideCreateForm.
	self assert: model errorMessage isNil
]

{ #category : 'helpers' }
TripListModelTest >> testHideCreateFormClearsFlag [
	model showCreateForm.
	model hideCreateForm.
	self deny: model showingCreateForm
]

{ #category : 'helpers' }
TripListModelTest >> testInitialErrorIsNil [
	self assert: model errorMessage isNil
]

{ #category : 'helpers' }
TripListModelTest >> testInitialShowingCreateFormIsFalse [
	self deny: model showingCreateForm
]

{ #category : 'helpers' }
TripListModelTest >> testInitialTripsIsEmpty [
	self assert: model trips isEmpty
]

{ #category : 'helpers' }
TripListModelTest >> testLoadTripsAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model loadTrips.
	self assert: announced
]

{ #category : 'helpers' }
TripListModelTest >> testLoadTripsClearsPreviousState [
	self createTripNamed: 'Vacances'.
	model loadTrips.
	self assert: model trips size equals: 1
]

{ #category : 'helpers' }
TripListModelTest >> testLoadTripsPopulatesTrips [
	self createTripNamed: 'Vacances'.
	self assert: model trips size equals: 1
]

{ #category : 'helpers' }
TripListModelTest >> testLoadTripsResetsError [
	model errorMessage: 'une erreur'.
	model loadTrips.
	self assert: model errorMessage isNil
]

{ #category : 'helpers' }
TripListModelTest >> testLoadTripsStoresName [

	self createTripNamed: 'Vacances'.
	self assert: (model trips anySatisfy: [ :v | v name='Vacances' ])
]

{ #category : 'helpers' }
TripListModelTest >> testShowCreateFormAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model showCreateForm.
	self assert: announced
]

{ #category : 'helpers' }
TripListModelTest >> testShowCreateFormSetsFlag [
	model showCreateForm.
	self assert: model showingCreateForm
]
