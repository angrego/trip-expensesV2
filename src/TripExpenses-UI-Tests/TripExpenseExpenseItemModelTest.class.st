Class {
	#name : 'TripExpenseExpenseItemModelTest',
	#superclass : 'TestCase',
	#category : 'TripExpenses-UI-Tests-TripDetail',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'TripDetail'
}

{ #category : 'tests' }
TripExpenseExpenseItemModelTest >> testBeneficiaryNamesIncludesWeightWhenGreaterThanOne [
	"Poids différents → affichage (x2) etc."

	| alice bob rule exp model |
	alice := Participant name: 'Alice'.
	bob := Participant name: 'Bob'.
	rule := EqualSplitRule among: {
			        (ParticipantWeight participant: alice weight: 2).
			        (ParticipantWeight participant: bob weight: 1) }.
	exp := Expense
		       description: 'Resto'
		       totalAmount: (Money amount: 90 currency: 'EUR')
		       payments: { (Payment
				        participant: alice
				        amount: (Money amount: 90 currency: 'EUR')) }
		       splitRule: rule
		       gifts: {  }
		       date: Date today.
	model := TripExpenseExpenseItemModel fromExpense: exp .
	self assert: (model beneficiaryNames includesSubstring: 'Alice (x2)').
	self assert: (model beneficiaryNames includesSubstring: 'Bob (x1)')
]

{ #category : 'tests' }
TripExpenseExpenseItemModelTest >> testBeneficiaryNamesOmitsWeightWhenAllOne [
	"Tous les poids à 1 → pas de (x1) affiché."

	| alice bob rule exp model |
	alice := Participant name: 'Alice'.
	bob := Participant name: 'Bob'.
	rule := EqualSplitRule among: {
			        (ParticipantWeight participant: alice weight: 1).
			        (ParticipantWeight participant: bob weight: 1) }.
	exp := Expense
		       description: 'Resto'
		       totalAmount: (Money amount: 60 currency: 'EUR')
		       payments: { (Payment
				        participant: alice
				        amount: (Money amount: 60 currency: 'EUR')) }
		       splitRule: rule
		       gifts: {  }
		       date: Date today.
	model := TripExpenseExpenseItemModel fromExpense: exp .
	self deny: (model beneficiaryNames includesSubstring: '(x')
]

{ #category : 'tests' }
TripExpenseExpenseItemModelTest >> testIsNotPaidWhenPartiallyPaid [
    | expense model |
    expense := self makePartiallyPaidExpense.
    model := TripExpenseExpenseItemModel fromExpense: expense.
    self deny: model isPaid
]

{ #category : 'tests' }
TripExpenseExpenseItemModelTest >> testIsPaidWhenFullyPaid [
    | expense model |
    expense := self makeFullyPaidExpense.
    model := TripExpenseExpenseItemModel fromExpense: expense.
    self assert: model isPaid
]

{ #category : 'tests' }
TripExpenseExpenseItemModelTest >> testPayerNameIncludesNoWeight [
	"Le payeur n'affiche pas de poids."

	| alice bob rule exp model |
	alice := Participant name: 'Alice'.
	bob := Participant name: 'Bob'.
	rule := EqualSplitRule among: {
			        (ParticipantWeight participant: alice weight: 2).
			        (ParticipantWeight participant: bob weight: 1) }.
	exp := Expense
		       description: 'Resto'
		       totalAmount: (Money amount: 90 currency: 'EUR')
		       payments: { (Payment
				        participant: alice
				        amount: (Money amount: 90 currency: 'EUR')) }
		       splitRule: rule
		       gifts: {  }
		       date: Date today.
	model := TripExpenseExpenseItemModel fromExpense: exp .
	self deny: (model payerName includesSubstring: '(x')
]

{ #category : 'tests' }
TripExpenseExpenseItemModelTest >> testRemainingAmountString [
    | expense model |
    expense := self makePartiallyPaidExpense.
    model := TripExpenseExpenseItemModel fromExpense: expense.
    self assert: model remainingAmount equals: '40'
]
