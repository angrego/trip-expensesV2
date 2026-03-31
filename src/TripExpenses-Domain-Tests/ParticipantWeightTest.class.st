Class {
	#name : 'ParticipantWeightTest',
	#superclass : 'TestCase',
	#instVars : [
		'greg'
	],
	#category : 'TripExpenses-Domain-Tests',
	#package : 'TripExpenses-Domain-Tests'
}

{ #category : 'running' }
ParticipantWeightTest >> setUp [

	greg := Participant name: 'Greg'
]

{ #category : 'running' }
ParticipantWeightTest >> testCustomWeight [
    | pw |
    pw := ParticipantWeight participant: greg weight: 2.
    self assert: pw weight    equals: 2.
    self assert: pw participant equals: greg 
]

{ #category : 'running' }
ParticipantWeightTest >> testDefaultWeightIsOne [
    | pw |
    pw := ParticipantWeight participant: greg.
    self assert: pw weight equals: 1
]

{ #category : 'running' }
ParticipantWeightTest >> testNegativeWeightRaisesError [ 
    self should: [ ParticipantWeight participant: greg weight: -1 ] raise: Error
]

{ #category : 'running' }
ParticipantWeightTest >> testZeroWeightRaisesError [
    self should: [ ParticipantWeight participant: greg weight: 0 ] raise: Error
]
