Class {
	#name : 'TripParticipantWeightModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'TripExpenses-UI-Tests-ParticipantWeight',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'ParticipantWeight'
}

{ #category : 'running' }
TripParticipantWeightModelTest >> setUp [

	super setUp.
	model := TripParticipantWeightModel
		         participantId: 'alice-id'
		         name: 'Alice'
		         weight: 1
		         included: true
]

{ #category : 'initialize state' }
TripParticipantWeightModelTest >> testIncluded [
    self assert: model included
]

{ #category : 'initialize state' }
TripParticipantWeightModelTest >> testName [
    self assert: model name equals: 'Alice'
]

{ #category : 'initialize state' }
TripParticipantWeightModelTest >> testParticipantId [
    self assert: model participantId equals: 'alice-id'
]

{ #category : 'presenter' }
TripParticipantWeightModelTest >> testPreferredPresenterClass [
    self
        assert: model preferredPresenterClass
        equals: TripParticipantWeightPresenter
]

{ #category : 'mutations' }
TripParticipantWeightModelTest >> testSetIncluded [
    model included: false.
    self deny: model included
]

{ #category : 'mutations' }
TripParticipantWeightModelTest >> testSetIncludedAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model included: false.
    self assert: announced
]

{ #category : 'mutations' }
TripParticipantWeightModelTest >> testSetWeight [
    model weight: 2.
    self assert: model weight equals: 2
]

{ #category : 'mutations' }
TripParticipantWeightModelTest >> testSetWeightAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model weight: 2.
    self assert: announced
]

{ #category : 'initialize state' }
TripParticipantWeightModelTest >> testWeight [
    self assert: model weight equals: 1
]
