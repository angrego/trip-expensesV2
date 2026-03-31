Class {
	#name : 'ParticipantIdTest',
	#superclass : 'TestCase',
	#category : 'TripExpenses-Domain-Tests',
	#package : 'TripExpenses-Domain-Tests'
}

{ #category : 'tests' }
ParticipantIdTest >> testEqualityOnValue [ 
    self assert: (ParticipantId from: 'abc') equals: (ParticipantId from: 'abc').
    self deny:   (ParticipantId from: 'abc') equals: (ParticipantId from: 'xyz')
]

{ #category : 'tests' }
ParticipantIdTest >> testFromString [
    | id |
    id := ParticipantId from: 'abc-123'.
    self assert: id value equals: 'abc-123'
]

{ #category : 'tests' }
ParticipantIdTest >> testGenerate [

	| id |
	id := ParticipantId generate.
	self assert: id value isNotNil.
]

{ #category : 'tests' }
ParticipantIdTest >> testHashConsistentWithEquality [
    self assert: (ParticipantId from: 'abc') hash
         equals: (ParticipantId from: 'abc') hash
]

{ #category : 'tests' }
ParticipantIdTest >> testTwoGeneratedIdsAreDifferent [
    self deny: ParticipantId generate equals: ParticipantId generate
]
