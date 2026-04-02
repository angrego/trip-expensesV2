"
Je teste TripAddParticipantModel — composant autonome d ajout de participant.
Il est independant de TripDetailModel : il recoit le service et le tripId,
fait son travail, et annonce valueChanged quand son etat change.
"
Class {
	#name : 'TripAddParticipantModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'tripId',
		'model'
	],
	#category : 'TripExpenses-Server-tests',
	#package : 'TripExpenses-Server-tests'
}

{ #category : 'running' }
TripAddParticipantModelTest >> setUp [
	| trip |
	service := TripApplicationService withRepository: InMemoryTripRepository new.
	trip    := service createTrip: 'Vacances' currency: 'EUR'.
	tripId  := trip id.
	model   := TripAddParticipantModel onService: service tripId: tripId
]

{ #category : 'tests - validation' }
TripAddParticipantModelTest >> testAddDuplicateParticipantSetsError [
	model addParticipantNamed: 'Alice'.
	model addParticipantNamed: 'Alice'.
	self assert: model errorMessage isNotNil
]

{ #category : 'tests - addParticipant' }
TripAddParticipantModelTest >> testAddParticipantAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model addParticipantNamed: 'Alice'.
	self assert: announced
]

{ #category : 'tests - addParticipant' }
TripAddParticipantModelTest >> testAddParticipantHidesForm [
	model showForm.
	model addParticipantNamed: 'Alice'.
	self deny: model showingForm
]

{ #category : 'tests - validation' }
TripAddParticipantModelTest >> testAddParticipantWithBlankNameDoesNotPersist [
	model addParticipantNamed: ''.
	self assert: (service findTrip: tripId) participants isEmpty
]

{ #category : 'tests - validation' }
TripAddParticipantModelTest >> testAddParticipantWithBlankNameSetsError [
	model addParticipantNamed: ''.
	self assert: model errorMessage isNotNil
]

{ #category : 'tests - addParticipant' }
TripAddParticipantModelTest >> testAddParticipantWithValidNamePersists [
	model addParticipantNamed: 'Alice'.
	self assert: (service findTrip: tripId) participants size equals: 1
]

{ #category : 'tests - addParticipant' }
TripAddParticipantModelTest >> testAddParticipantWithValidNameStoresCorrectName [
	model addParticipantNamed: 'Alice'.
	self assert: (service findTrip: tripId) participants first name equals: 'Alice'
]

{ #category : 'tests - validation' }
TripAddParticipantModelTest >> testAddParticipantWithWhitespaceNameSetsError [
	model addParticipantNamed: '   '.
	self assert: model errorMessage isNotNil
]

{ #category : 'tests - validation' }
TripAddParticipantModelTest >> testAddTwoParticipantsBothPersist [
	model addParticipantNamed: 'Alice'.
	model addParticipantNamed: 'Bob'.
	self assert: (service findTrip: tripId) participants size equals: 2
]

{ #category : 'tests - validation' }
TripAddParticipantModelTest >> testAddValidParticipantClearsError [
	model addParticipantNamed: ''.
	model addParticipantNamed: 'Alice'.
	self assert: model errorMessage isNil
]

{ #category : 'tests - hideForm' }
TripAddParticipantModelTest >> testHideFormAnnouncesValueChanged [
	| announced |
	announced := false.
	model showForm.
	model when: ValueChanged do: [ announced := true ].
	model hideForm.
	self assert: announced
]

{ #category : 'tests - hideForm' }
TripAddParticipantModelTest >> testHideFormClearsError [
	model errorMessage: 'une erreur'.
	model hideForm.
	self assert: model errorMessage isNil
]

{ #category : 'tests - hideForm' }
TripAddParticipantModelTest >> testHideFormClearsFlag [
	model showForm.
	model hideForm.
	self deny: model showingForm
]

{ #category : 'tests - etat initial' }
TripAddParticipantModelTest >> testInitialErrorIsNil [
	self assert: model errorMessage isNil
]

{ #category : 'tests - etat initial' }
TripAddParticipantModelTest >> testInitialShowingFormIsFalse [
	self deny: model showingForm
]

{ #category : 'tests - showForm' }
TripAddParticipantModelTest >> testShowFormAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model showForm.
	self assert: announced
]

{ #category : 'tests - showForm' }
TripAddParticipantModelTest >> testShowFormClearsError [
	model errorMessage: 'une erreur'.
	model showForm.
	self assert: model errorMessage isNil
]

{ #category : 'tests - showForm' }
TripAddParticipantModelTest >> testShowFormSetsFlag [
	model showForm.
	self assert: model showingForm
]
