Class {
	#name : 'TripBalanceItemModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'TripExpenses-UI-Tests-TripList',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'TripList'
}

{ #category : 'running' }
TripBalanceItemModelTest >> testAmount [
    self assert: model amount equals: '30'
]

{ #category : 'running' }
TripBalanceItemModelTest >> testCurrency [
    self assert: model currency equals: 'EUR'
]

{ #category : 'running' }
TripBalanceItemModelTest >> testParticipantName [
    self assert: model participantName equals: 'Alice'
]

{ #category : 'running' }
TripBalanceItemModelTest >> testPreferredPresenterClass [
    self
        assert: model preferredPresenterClass
        equals: TripBalanceItemPresenter
]
