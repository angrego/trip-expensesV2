Class {
	#name : 'TripGiftBeneficiaryModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'TripExpenses-UI-Tests-Gift',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'Gift'
}

{ #category : 'running' }
TripGiftBeneficiaryModelTest >> setUp [
    | alice |
    alice := Participant name: 'Alice'.
    model := TripGiftBeneficiaryModel
        participant: alice
        weight: 1
        included: true
]

{ #category : 'running' }
TripGiftBeneficiaryModelTest >> testIncludedByDefault [
    self assert: model included
]

{ #category : 'running' }
TripGiftBeneficiaryModelTest >> testIsKindOfTripParticipantWeightModel [
    self assert: (model isKindOf: TripParticipantWeightModel)
]

{ #category : 'running' }
TripGiftBeneficiaryModelTest >> testParticipantName [
    self assert: model participantName equals: 'Alice'
]

{ #category : 'running' }
TripGiftBeneficiaryModelTest >> testPreferredPresenterClass [
    self
        assert: model preferredPresenterClass
        equals: TripGiftBeneficiaryPresenter
]
