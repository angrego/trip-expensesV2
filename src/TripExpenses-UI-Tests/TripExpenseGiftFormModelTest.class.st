Class {
	#name : 'TripExpenseGiftFormModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'tripId',
		'aliceId',
		'bobId',
		'service',
		'model',
		'expenseId'
	],
	#category : 'TripExpenses-UI-Tests-Gift',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'Gift'
}

{ #category : 'running' }
TripExpenseGiftFormModelTest >> setUp [

	| trip alice bob splitRule expense |
	super setUp.
	service := TripApplicationService withRepository:
		           InMemoryTripRepository new.
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	alice := service addParticipantByName: 'Alice' toTrip: trip id.
	bob := service addParticipantByName: 'Bob' toTrip: trip id.
	tripId := trip id.
	aliceId := alice id value.
	bobId := bob id value.
	splitRule := EqualSplitRule among: {
			             (ParticipantWeight participant: alice).
			             (ParticipantWeight participant: bob) }.
	expense := Expense
		           description: 'Resto'
		           totalAmount: (Money amount: 90 currency: 'EUR')
		           payments: { (Payment
				            participant: alice
				            amount: (Money amount: 90 currency: 'EUR')) }
		           splitRule: splitRule
		           gifts: {  }
		           date: Date today.
	service addExpense: expense toTrip: tripId.
	expenseId := (service findTrip: tripId) expenses first id.
	model := TripExpenseGiftFormModel
		         onService: service
		         tripId: tripId
		         expenseId: expenseId
		         currentParticipantName: 'Alice'
]

{ #category : 'running' }
TripExpenseGiftFormModelTest >> testAddGiftAnnouncesValueChanged [
    | announced |
    model show.
    model giftEntryModel sliderValue: 60.
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model addGift.
    self assert: announced
]

{ #category : 'running' }
TripExpenseGiftFormModelTest >> testAddGiftHidesForm [
    model show.
    model giftEntryModel sliderValue: 60.
    model addGift.
    self deny: model isShowing
]

{ #category : 'running' }
TripExpenseGiftFormModelTest >> testAddGiftSavesGift [
    model show.
    model giftEntryModel sliderValue: 60.
    model addGift.
    self assert: (service findTrip: tripId) expenses first gifts isEmpty not
]

{ #category : 'running' }
TripExpenseGiftFormModelTest >> testGiftEntryModelMaxAmountIsExpenseAmount [
    model show.
    self assert: model giftEntryModel maxAmount equals: 90
]

{ #category : 'running' }
TripExpenseGiftFormModelTest >> testGiftEntryModelPayerIsCurrentParticipant [
    model show.
    self assert: model giftEntryModel fromId equals: aliceId
]

{ #category : 'running' }
TripExpenseGiftFormModelTest >> testInitiallyNotShowing [
    self deny: model isShowing
]

{ #category : 'running' }
TripExpenseGiftFormModelTest >> testShowCreatesGiftEntryModel [
    model show.
    self assert: model giftEntryModel isNotNil
]
