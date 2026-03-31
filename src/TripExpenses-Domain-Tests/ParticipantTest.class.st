"
A ParticipantTest is a test class for testing the behavior of Participant
"
Class {
	#name : 'ParticipantTest',
	#superclass : 'TestCase',
	#category : 'TripExpenses-Domain-Tests',
	#package : 'TripExpenses-Domain-Tests'
}

{ #category : 'tests' }
ParticipantTest >> testBlankNameRaisesError [

	self should: [ Participant name: '   ' ] raise: Error
]

{ #category : 'tests' }
ParticipantTest >> testCreation [

	| p |
	p := Participant name: 'Greg'.
	self assert: p name equals: 'Greg'.
	self assert: p id isNotNil
]

{ #category : 'tests' }
ParticipantTest >> testDifferentNamesNotEqual [

	self
		deny: (Participant name: 'Alice')
		equals: (Participant name: 'Bob')
]

{ #category : 'tests' }
ParticipantTest >> testEmptyNameRaisesError [

	self should: [ Participant name: '' ] raise: Error
]

{ #category : 'tests' }
ParticipantTest >> testEqualityBasedOnId [


		| a b |
		a := Participant name: 'Alice'.
		b := Participant name: 'Alice'.
		self deny: a equals: b 
]

{ #category : 'tests' }
ParticipantTest >> testHashConsistentWithEquality [
	"Même instance → même hash"

	| a |
	a := Participant name: 'Alice'.
	self assert: a hash equals: a hash
]

{ #category : 'tests' }
ParticipantTest >> testIdIsAParticipantId [

	| p |
	p := Participant name: 'Greg'.
	self assert: (p id isKindOf: ParticipantId)
]

{ #category : 'tests' }
ParticipantTest >> testNotEqualToNonParticipant [

	self deny: (Participant name: 'Alice') equals: 'Alice'
]

{ #category : 'tests' }
ParticipantTest >> testSameInstanceIsEqual [

	| a |
	a := Participant name: 'Alice'.
	self assert: a equals: a
]

{ #category : 'tests' }
ParticipantTest >> testTwoParticipantsHaveDifferentIds [

	| a b |
	a := Participant name: 'Alice'.
	b := Participant name: 'Alice'.
	self deny: a id equals: b id
]

{ #category : 'tests' }
ParticipantTest >> testUsableAsDictionaryKey [

	| dict p |
	dict := Dictionary new.
	p := Participant name: 'Alice'.
	dict at: p put: 42.
	self assert: (dict at: p) equals: 42
]
