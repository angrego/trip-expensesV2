Class {
	#name : 'MoneyTest',
	#superclass : 'TestCase',
	#category : 'TripExpenses-Domain-Tests',
	#package : 'TripExpenses-Domain-Tests'
}

{ #category : 'tests' }
MoneyTest >> testAbsoluteValue [ 
    self assert: (Money amount: -30 currency: 'EUR') abs amount equals: 30.
    self assert: (Money amount:  30 currency: 'EUR') abs amount equals: 30
]

{ #category : 'tests' }
MoneyTest >> testAddition [ 
    | result |
    result := (Money amount: 30 currency: 'EUR') + (Money amount: 70 currency: 'EUR').
    self assert: result equals: (Money amount: 100 currency: 'EUR')

]

{ #category : 'tests' }
MoneyTest >> testAdditionDifferentCurrenciesRaisesError [ 
    self should: [
        (Money amount: 30 currency: 'EUR') + (Money amount: 70 currency: 'USD')
    ] raise: Error
]

{ #category : 'tests' }
MoneyTest >> testCreation [ 
    | m |
    m := Money amount: 100 currency: 'EUR'.
    self assert: m amount   equals: 100.
    self assert: m currency equals: 'EUR'
]

{ #category : 'tests' }
MoneyTest >> testEqualityInstanceSideMethod [
  self assert:    (Money amount: 42 currency: 'EUR') equals: (Money amount: 42 currency: 'EUR').
    self deny:      (Money amount: 42 currency: 'EUR') equals: (Money amount: 43 currency: 'EUR').
    self deny:      (Money amount: 42 currency: 'EUR') equals: (Money amount: 42 currency: 'USD')
]

{ #category : 'tests' }
MoneyTest >> testHashConsistentWithEquality [
    | a b |
    a := Money amount: 42 currency: 'EUR'.
    b := Money amount: 42 currency: 'EUR'.
    self assert: a hash equals: b hash
]

{ #category : 'tests' }
MoneyTest >> testIsNegative [
    self assert:  (Money amount: -1 currency: 'EUR') isNegative.
    self deny:    (Money amount:  0 currency: 'EUR') isNegative.
    self deny:    (Money amount:  1 currency: 'EUR') isNegative
]

{ #category : 'tests' }
MoneyTest >> testIsPositive [ 
    self assert:  (Money amount: 1  currency: 'EUR') isPositive.
    self deny:    (Money amount: 0  currency: 'EUR') isPositive.
    self deny:    (Money amount: -1 currency: 'EUR') isPositive.
]

{ #category : 'tests' }
MoneyTest >> testIsZero [
    self assert:  (Money amount: 0  currency: 'EUR') isZero.
    self deny:    (Money amount: 1  currency: 'EUR') isZero.
    self deny:    (Money amount: -1 currency: 'EUR') isZero
]

{ #category : 'tests' }
MoneyTest >> testMultiplication [ 
    | result |
    result := (Money amount: 120 currency: 'EUR') * (1/4).
    self assert: result equals: (Money amount: 30 currency: 'EUR')
]

{ #category : 'tests' }
MoneyTest >> testMultiplicationByNegativeInvertsSign [ 
    | result |
    result := (Money amount: 50 currency: 'EUR') * -1.
    self assert: result amount equals: -50
]

{ #category : 'tests' }
MoneyTest >> testPrintString [
    self assert: (Money amount: 42 currency: 'EUR') printString equals: '42 EUR'
]

{ #category : 'tests' }
MoneyTest >> testSubtraction [ 
    | result |
    result := (Money amount: 100 currency: 'EUR') - (Money amount: 30 currency: 'EUR').
    self assert: result equals: (Money amount: 70 currency: 'EUR')
]

{ #category : 'tests' }
MoneyTest >> testSubtractionCanBeNegative [ 
    | result |
    result := (Money amount: 30 currency: 'EUR') - (Money amount: 100 currency: 'EUR').
    self assert: result amount equals: -70
]
