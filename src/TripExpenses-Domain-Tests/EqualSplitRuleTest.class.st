Class {
	#name : 'EqualSplitRuleTest',
	#superclass : 'TestCase',
	#instVars : [
		'greg',
		'malvina',
		'antoine'
	],
	#category : 'TripExpenses-Domain-Tests-TripExpenses-Domain-Tests-Rule',
	#package : 'TripExpenses-Domain-Tests',
	#tag : 'TripExpenses-Domain-Tests-Rule'
}

{ #category : 'tests' }
EqualSplitRuleTest >> setUp [

	antoine := Participant name: 'Antoine'.
	greg := Participant name: 'Greg'.
	malvina := Participant name: 'Malvina'
]

{ #category : 'tests' }
EqualSplitRuleTest >> testCasAlcool [ 
    "Alcool : Greg poids 1 (Leo ne boit pas), Aantoine exclu"
    | martine georges rule shares |

    rule := EqualSplitRule among: {
        ParticipantWeight participant: malvina weight: 1.
        ParticipantWeight participant: greg weight: 1 }.
    shares := rule computeShares: (Money amount: 200 currency: 'EUR').
    self assert: (shares at: malvina ) equals: (Money amount: 100 currency: 'EUR').
    self assert: (shares at: greg) equals: (Money amount: 100 currency: 'EUR').
    self assert: shares size equals: 2
]

{ #category : 'tests' }
EqualSplitRuleTest >> testCasGite [
    "Le cas concret : greg poids 2, antoine et malv poids 1"
    |    rule shares |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: malvina weight: 1.
        ParticipantWeight participant: antoine  weight: 1.
        ParticipantWeight participant: greg weight: 2 }.
    shares := rule computeShares: (Money amount: 7000 currency: 'EUR').
    self assert: (shares at: malvina ) equals: (Money amount: 1750 currency: 'EUR').
    self assert: (shares at: antoine )  equals: (Money amount: 1750 currency: 'EUR').
    self assert: (shares at: greg ) equals: (Money amount: 3500 currency: 'EUR')
]

{ #category : 'tests' }
EqualSplitRuleTest >> testCreation [
    | rule |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: greg.
        ParticipantWeight participant: antoine }.
    self assert: rule participantWeights size equals: 2
]

{ #category : 'tests' }
EqualSplitRuleTest >> testEmptyRuleRaisesError [
    self should: [ EqualSplitRule among: {} ] raise: Error
]

{ #category : 'tests' }
EqualSplitRuleTest >> testEqualWeightsEqualShares [

	| rule shares |
	rule := EqualSplitRule among: {
			        (ParticipantWeight participant: greg weight: 2).
			        (ParticipantWeight participant: antoine).
			        (ParticipantWeight participant: malvina) }.
	shares := rule computeShares: (Money amount: 120 currency: 'EUR').
	self
		assert: (shares at: greg)
		equals: (Money amount: 60 currency: 'EUR').
	self
		assert: (shares at: antoine)
		equals: (Money amount: 30 currency: 'EUR').
	self
		assert: (shares at: malvina)
		equals: (Money amount: 30 currency: 'EUR')
]

{ #category : 'tests' }
EqualSplitRuleTest >> testIncludesKnownParticipant [
    | rule |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: greg.
        ParticipantWeight participant: antoine }.
    self assert: (rule includes: greg ).
    self assert: (rule includes: antoine )
]

{ #category : 'tests' }
EqualSplitRuleTest >> testNonDivisibleAmountSumsToTotal [
    "100 EUR / 3 parts → les parts doivent sommer exactement à 100 EUR"
    | rule shares total |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: greg.
        ParticipantWeight participant: antoine.
        ParticipantWeight participant: malvina }.
    shares := rule computeShares: (Money amount: 100 currency: 'EUR').
    total := shares values sumNumbers: [ :m | m amount ].
    self assert: total equals: 100
]

{ #category : 'tests' }
EqualSplitRuleTest >> testNotIncludesUnknownParticipant [ 
    | rule |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: greg.
        ParticipantWeight participant: antoine }.
    self deny: (rule includes: malvina )
]

{ #category : 'tests' }
EqualSplitRuleTest >> testParticipants [
    | rule |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: greg.
        ParticipantWeight participant: antoine }.
    self assert: (rule participants includes: greg ).
    self assert: (rule participants includes: antoine ).
    self assert: rule participants size equals: 2
]

{ #category : 'tests' }
EqualSplitRuleTest >> testPrintString [ 
    | rule str |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: antoine weight: 1.
        ParticipantWeight participant: greg   weight: 2 }.
    str := rule printString.
    self assert: (str includesSubstring: 'Antoine').
    self assert: (str includesSubstring: 'Greg')
]

{ #category : 'tests' }
EqualSplitRuleTest >> testSharesKeysAreParticipants [
    | rule shares |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: greg .
        ParticipantWeight participant: antoine }.
    shares := rule computeShares: (Money amount: 100 currency: 'EUR').
    self assert: (shares includesKey: greg).
    self assert: (shares includesKey: antoine )
]

{ #category : 'tests' }
EqualSplitRuleTest >> testSharesReturnDictionary [
    | rule shares |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: greg.
        ParticipantWeight participant: antoine }.
    shares := rule computeShares: (Money amount: 100 currency: 'EUR').
    self assert: (shares isKindOf: Dictionary).
    self assert: shares size equals: 2
]

{ #category : 'tests' }
EqualSplitRuleTest >> testSingleParticipantGetsAll [ 
    | rule shares |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: greg }.
    shares := rule computeShares: (Money amount: 50 currency: 'EUR').
    self assert: (shares at: greg) equals: (Money amount: 50 currency: 'EUR')
]

{ #category : 'tests' }
EqualSplitRuleTest >> testTotalWeightAllOnes [
    | rule |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: greg.
        ParticipantWeight participant: antoine .
        ParticipantWeight participant: malvina }.
    self assert: rule totalWeight equals: 3
]

{ #category : 'tests' }
EqualSplitRuleTest >> testTotalWeightMixed [ 
    | rule |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: greg   weight: 2.
        ParticipantWeight participant: antoine     weight: 1.
        ParticipantWeight participant: malvina weight: 1 }.
    self assert: rule totalWeight equals: 4
]

{ #category : 'tests' }
EqualSplitRuleTest >> testTotalWeightSingleParticipant [
    | rule |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: greg weight: 3 }.
    self assert: rule totalWeight equals: 3
]

{ #category : 'tests' }
EqualSplitRuleTest >> testZeroTotalGivesZeroShares [
    | rule shares |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: greg .
        ParticipantWeight participant: antoine }.
    shares := rule computeShares: (Money amount: 0 currency: 'EUR').
    self assert: (shares at: greg) equals: (Money amount: 0 currency: 'EUR').
    self assert: (shares at: antoine )   equals: (Money amount: 0 currency: 'EUR')
]
