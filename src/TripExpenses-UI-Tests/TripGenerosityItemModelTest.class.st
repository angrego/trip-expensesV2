Class {
	#name : 'TripGenerosityItemModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'alice'
	],
	#category : 'TripExpenses-UI-Tests-Balance',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'Balance'
}

{ #category : 'running' }
TripGenerosityItemModelTest >> setUp [

	super setUp.
	alice := Participant name: 'Alice'.
	model := TripGenerosityItemModel
		         setParticipant: alice
		         money: (Money amount: 30 currency: 'EUR')
		rank:1
]

{ #category : 'tests' }
TripGenerosityItemModelTest >> testAmount [
    self assert: model amount equals: '30'
]

{ #category : 'tests' }
TripGenerosityItemModelTest >> testCurrency [
    self assert: model currency equals: 'EUR'
]

{ #category : 'tests' }
TripGenerosityItemModelTest >> testParticipantName [
    self assert: model participantName equals: 'Alice'
]

{ #category : 'tests' }
TripGenerosityItemModelTest >> testPreferredPresenterClass [
    self
        assert: model preferredPresenterClass
        equals: TripGenerosityItemPresenter
]
