Class {
	#name : 'GenerosityRecordTest',
	#superclass : 'TestCase',
	#instVars : [
		'bob',
		'alice',
		'giftAliceToBob'
	],
	#category : 'TripExpenses-Domain-Tests-TripExpenses-Domain-Tests-Rule',
	#package : 'TripExpenses-Domain-Tests',
	#tag : 'TripExpenses-Domain-Tests-Rule'
}

{ #category : 'helpers' }
GenerosityRecordTest >> makeDebtorRecord [
	"Record de Bob : n'a rien payé, doit 30 EUR, aucun cadeau."
	^ GenerosityRecord new
		participant:      bob;
		theoreticalShare: (Money amount: 30 currency: 'EUR');
		paymentMade:      (Money amount:  0 currency: 'EUR');
		giftGiven:        {};
		giftReceived:     { giftAliceToBob };
		generosity:       (Money amount:  0 currency: 'EUR');
		finalBalance:     (Money amount: -30 currency: 'EUR');
		yourself
]

{ #category : 'helpers' }
GenerosityRecordTest >> makeRecord [
	"Construit un GenerosityRecord représentant Alice qui paie 90 EUR
	 pour une dépense de 30 EUR par personne (3 participants),
	 et offre 30 EUR à Bob."
	^ GenerosityRecord new
		participant:      alice;
		theoreticalShare: (Money amount: 30 currency: 'EUR');
		paymentMade:      (Money amount: 90 currency: 'EUR');
		giftGiven:        { giftAliceToBob };
		giftReceived:     {};
		generosity:       (Money amount: 30 currency: 'EUR');
		finalBalance:     (Money amount: 30 currency: 'EUR');
		yourself
]

{ #category : 'running' }
GenerosityRecordTest >> setUp [
	alice := Participant name: 'Alice'.
	bob   := Participant name: 'Bob'.
	giftAliceToBob := Gift
		from:   alice
		to:     bob
		amount: (Money amount: 30 currency: 'EUR')
		reason: 'Anniversaire'
]

{ #category : 'helpers' }
GenerosityRecordTest >> testCreditorIsNotDebtor [
	self deny: self makeRecord isDebtor
]

{ #category : 'helpers' }
GenerosityRecordTest >> testDebtorIsNotGenerous [
	self deny: self makeDebtorRecord isGenerous
]

{ #category : 'helpers' }
GenerosityRecordTest >> testFinalBalance [
	self assert: self makeRecord finalBalance
	     equals: (Money amount: 30 currency: 'EUR')
]

{ #category : 'helpers' }
GenerosityRecordTest >> testGenerosity [
	self assert: self makeRecord generosity
	     equals: (Money amount: 30 currency: 'EUR')
]

{ #category : 'helpers' }
GenerosityRecordTest >> testGiftGivenContainsTheGift [
	"Nécessite l'ajout du getter giftGiven dans GenerosityRecord."
	self assert: (self makeRecord giftGiven includes: giftAliceToBob)
]

{ #category : 'helpers' }
GenerosityRecordTest >> testGiftGivenEmptyWhenNoGift [
	self assert: self makeDebtorRecord giftGiven isEmpty
]

{ #category : 'helpers' }
GenerosityRecordTest >> testGiftGivenSize [
	"Nécessite l'ajout du getter giftGiven dans GenerosityRecord."
	self assert: self makeRecord giftGiven size equals: 1
]

{ #category : 'helpers' }
GenerosityRecordTest >> testGiftReceivedContainsTheGift [
	"Nécessite l'ajout du getter giftReceived dans GenerosityRecord."
	self assert: (self makeDebtorRecord giftReceived includes: giftAliceToBob)
]

{ #category : 'helpers' }
GenerosityRecordTest >> testGiftReceivedEmptyWhenNoGift [
	self assert: self makeRecord giftReceived isEmpty
]

{ #category : 'helpers' }
GenerosityRecordTest >> testGiftReceivedSize [
	"Nécessite l'ajout du getter giftReceived dans GenerosityRecord."
	self assert: self makeDebtorRecord giftReceived size equals: 1
]

{ #category : 'helpers' }
GenerosityRecordTest >> testIsDebtorFalseWhenBalancePositive [
	self deny: self makeRecord isDebtor
]

{ #category : 'helpers' }
GenerosityRecordTest >> testIsDebtorFalseWhenBalanceZero [
	| record |
	record := GenerosityRecord new
		finalBalance: (Money amount: 0 currency: 'EUR');
		yourself.
	self deny: record isDebtor
]

{ #category : 'helpers' }
GenerosityRecordTest >> testIsDebtorWhenBalanceNegative [
	self assert: self makeDebtorRecord isDebtor
]

{ #category : 'helpers' }
GenerosityRecordTest >> testIsGenerousFalseForDebtor [
	self deny: self makeDebtorRecord isGenerous
]

{ #category : 'helpers' }
GenerosityRecordTest >> testIsGenerousFalseWhenZero [
	| record |
	record := GenerosityRecord new
		generosity: (Money amount: 0 currency: 'EUR');
		yourself.
	self deny: record isGenerous
]

{ #category : 'helpers' }
GenerosityRecordTest >> testIsGenerousWhenGenerosityPositive [
	self assert: self makeRecord isGenerous
]

{ #category : 'helpers' }
GenerosityRecordTest >> testParticipant [
	self assert: self makeRecord participant equals: alice
]

{ #category : 'helpers' }
GenerosityRecordTest >> testPaymentMade [
	self assert: self makeRecord paymentMade
	     equals: (Money amount: 90 currency: 'EUR')
]

{ #category : 'helpers' }
GenerosityRecordTest >> testPrintStringContainsFinalBalance [
	self assert: (self makeRecord printString includesSubstring: 'Balance finale')
]

{ #category : 'helpers' }
GenerosityRecordTest >> testPrintStringContainsGenerosity [
	self assert: (self makeRecord printString includesSubstring: 'Générosité')
]

{ #category : 'helpers' }
GenerosityRecordTest >> testPrintStringContainsGiftGiven [
	"Le cadeau offert doit apparaître dans la représentation."
	self assert: (self makeRecord printString includesSubstring: 'Cadeau offert')
]

{ #category : 'helpers' }
GenerosityRecordTest >> testPrintStringContainsGiftReceived [
	"Le cadeau reçu doit apparaître dans la représentation du débiteur."
	self assert: (self makeDebtorRecord printString includesSubstring: 'Cadeau reçu')
]

{ #category : 'helpers' }
GenerosityRecordTest >> testPrintStringContainsParticipantName [
	self assert: (self makeRecord printString includesSubstring: 'Alice')
]

{ #category : 'helpers' }
GenerosityRecordTest >> testPrintStringContainsPaymentMade [
	self assert: (self makeRecord printString includesSubstring: '90')
]

{ #category : 'helpers' }
GenerosityRecordTest >> testPrintStringContainsTheoreticalShare [
	self assert: (self makeRecord printString includesSubstring: '30')
]

{ #category : 'helpers' }
GenerosityRecordTest >> testPrintStringNoGiftSectionWhenEmpty [
	"Sans cadeau, la section 'Cadeau offert' ne doit pas apparaître."
	self deny: (self makeDebtorRecord printString includesSubstring: 'Cadeau offert')
]

{ #category : 'helpers' }
GenerosityRecordTest >> testTheoreticalShare [
	self assert: self makeRecord theoreticalShare
	     equals: (Money amount: 30 currency: 'EUR')
]
