Class {
	#name : 'ExpenseTagsTest',
	#superclass : 'TestCase',
	#instVars : [
		'splitRule',
		'alice',
		'exp'
	],
	#category : 'TripExpenses-Domain-Tests',
	#package : 'TripExpenses-Domain-Tests'
}

{ #category : 'running' }
ExpenseTagsTest >> setUp [
    alice     := Participant name: 'Alice'.
    splitRule := EqualSplitRule among: { ParticipantWeight participant: alice }.
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 50 currency: 'EUR')
        payments: { Payment participant: alice amount: (Money amount: 50 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today
]

{ #category : 'running' }
ExpenseTagsTest >> testAddDuplicateTagOnlyStoresOnce [

	exp addTag: 'restaurant'.
	exp addTag: 'restaurant'.
	self assert: (exp tags size) equals: 1
]

{ #category : 'running' }
ExpenseTagsTest >> testAddMultipleTags [
    exp addTag: 'restaurant'.
    exp addTag: 'soir'.
    self assert: (exp hasTag: 'restaurant').
    self assert: (exp hasTag: 'soir')
]

{ #category : 'running' }
ExpenseTagsTest >> testAddTag [
    exp addTag: 'restaurant'.
    self assert: (exp hasTag: 'restaurant')
]

{ #category : 'running' }
ExpenseTagsTest >> testHasTagFalseForMissingTag [
    self deny: (exp hasTag: 'transport')
]

{ #category : 'running' }
ExpenseTagsTest >> testNoTagsByDefault [
    self assert: exp tags isEmpty
]
