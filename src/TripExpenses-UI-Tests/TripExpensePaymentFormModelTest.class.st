Class {
	#name : 'TripExpensePaymentFormModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'model',
		'tripId',
		'expenseId',
		'bobId',
		'aliceId'
	],
	#category : 'TripExpenses-UI-Tests-PaymentForm',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'PaymentForm'
}

{ #category : 'running' }
TripExpensePaymentFormModelTest >> setUp [
    | trip alice bob splitRule expense |
    service := TripApplicationService withRepository: InMemoryTripRepository new.
    trip    := service createTrip: 'Vacances' currency: 'EUR'.
    alice   := service addParticipantByName: 'Alice' toTrip: trip id.
    bob     := service addParticipantByName: 'Bob'   toTrip: trip id.
    tripId  := trip id.
    aliceId := alice id value.
    bobId   := bob id value.
    splitRule := EqualSplitRule among: {
        ParticipantWeight participant: alice.
        ParticipantWeight participant: bob }.
    expense := Expense
        description: 'Resto'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: {}
        splitRule: splitRule
        gifts: {}
        date: Date today.
    service addExpense: expense toTrip: tripId.
    expenseId := (service findTrip: tripId) expenses first id.
    model := TripExpensePaymentFormModel
        onService: service
        tripId: tripId
        expenseId: expenseId
        currentParticipantName: 'Alice'
]

{ #category : 'running' }
TripExpensePaymentFormModelTest >> testAddPaymentAnnouncesValueChanged [
    | announced |
    model show.
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model addPaymentAmount: 60.
    self assert: announced
]

{ #category : 'running' }
TripExpensePaymentFormModelTest >> testAddPaymentExceedingRemainingRaisesError [
    model show.
    model addPaymentAmount: 150.
    self assert: model errorMessage isNotNil
]

{ #category : 'running' }
TripExpensePaymentFormModelTest >> testAddPaymentHidesForm [
    model show.
    model addPaymentAmount: 60.
    self deny: model isShowing
]

{ #category : 'running' }
TripExpensePaymentFormModelTest >> testAddPaymentSavesPayment [
    model show.
    model addPaymentAmount: 60.
    self assert: (service findTrip: tripId) expenses first payments size equals: 1
]

{ #category : 'running' }
TripExpensePaymentFormModelTest >> testErrorMessageInitiallyNil [
    self assert: model errorMessage isNil
]

{ #category : 'running' }
TripExpensePaymentFormModelTest >> testInitiallyNotShowing [
    self deny: model isShowing
]

{ #category : 'running' }
TripExpensePaymentFormModelTest >> testPreferredPresenterClass [
    self
        assert: model preferredPresenterClass
        equals: TripExpensePaymentFormPresenter
]

{ #category : 'running' }
TripExpensePaymentFormModelTest >> testShowSetsCurrency [
    model show.
    self assert: model currency equals: 'EUR'
]

{ #category : 'running' }
TripExpensePaymentFormModelTest >> testShowSetsRemainingAmount [
    model show.
    self assert: model remainingAmount equals: 100
]

{ #category : 'running' }
TripExpensePaymentFormModelTest >> testShowSetsShowing [
    model show.
    self assert: model isShowing
]
