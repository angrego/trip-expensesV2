Class {
	#name : 'PaymentTest',
	#superclass : 'TestCase',
	#instVars : [
		'greg'
	],
	#category : 'TripExpenses-Domain-Tests',
	#package : 'TripExpenses-Domain-Tests'
}

{ #category : 'running' }
PaymentTest >> setUp [ 

greg := Participant name: 'greg'
]

{ #category : 'running' }
PaymentTest >> testCreation [
    | p |
    p := Payment participant: greg amount: (Money amount: 50 currency: 'EUR').
    self assert: p participant equals: greg.
    self assert: p amount      equals: (Money amount: 50 currency: 'EUR')
]

{ #category : 'running' }
PaymentTest >> testNegativeAmountRaisesError [
    self should: [
        Payment participant: greg amount: (Money amount: -10 currency: 'EUR')
    ] raise: Error
]

{ #category : 'running' }
PaymentTest >> testPrintStringContainsAmount [
    | p |
    p := Payment participant: greg amount: (Money amount: 50 currency: 'EUR').
    self assert: (p printString includesSubstring: '50')
]

{ #category : 'running' }
PaymentTest >> testPrintStringContainsName [
    | p |
    p := Payment participant: greg amount: (Money amount: 50 currency: 'EUR').
    self assert: (p printString includesSubstring: 'greg')
]

{ #category : 'running' }
PaymentTest >> testZeroAmountRaisesError [
    self should: [
        Payment participant: greg amount: (Money amount: 0 currency: 'EUR')
    ] raise: Error
]
