Class {
	#name : 'SettlementTest',
	#superclass : 'TestCase',
	#instVars : [
		'alice',
		'bob',
		'settlement'
	],
	#category : 'TripExpenses-Domain-Tests',
	#package : 'TripExpenses-Domain-Tests'
}

{ #category : 'running' }
SettlementTest >> setUp [
	alice      := Participant name: 'Alice'.
	bob        := Participant name: 'Bob'.
	settlement := Settlement
		from:   bob
		to:     alice
		amount: (Money amount: 30 currency: 'EUR')
]

{ #category : 'tests - creation' }
SettlementTest >> testCreationAmount [
	self assert: settlement amount equals: (Money amount: 30 currency: 'EUR')
]

{ #category : 'tests - creation' }
SettlementTest >> testCreationAmountIsPositive [
	self assert: settlement amount amount > 0
]

{ #category : 'tests - creation' }
SettlementTest >> testCreationFrom [
	self assert: settlement from equals: bob
]

{ #category : 'tests - creation' }
SettlementTest >> testCreationTo [
	self assert: settlement to equals: alice
]

{ #category : 'tests' }
SettlementTest >> testFromAndToAreDifferent [
	self deny: settlement from equals: settlement to
]

{ #category : 'tests - printOn' }
SettlementTest >> testPrintStringContainsAmount [
	self assert: (settlement printString includesSubstring: '30')
]

{ #category : 'tests - printOn' }
SettlementTest >> testPrintStringContainsCreditorName [
	self assert: (settlement printString includesSubstring: 'Alice')
]

{ #category : 'tests - printOn' }
SettlementTest >> testPrintStringContainsCurrency [
	self assert: (settlement printString includesSubstring: 'EUR')
]

{ #category : 'tests - printOn' }
SettlementTest >> testPrintStringContainsDebtorName [
	self assert: (settlement printString includesSubstring: 'Bob')
]

{ #category : 'tests - printOn' }
SettlementTest >> testPrintStringDebtorBeforeCreditor [
"Bob (débiteur) doit apparaître avant Alice (créditeur)."
	| str |
	str := settlement printString.
	self assert: (str indexOfSubCollection: 'Bob'   startingAt: 1) 
	          <  (str indexOfSubCollection: 'Alice' startingAt: 1)
]
