Class {
	#name : 'TripExpenseFormModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'model',
		'tripId',
		'aliceId',
		'bobId',
		'charlieId'
	],
	#category : 'TripExpenses-UI-Tests-TripDetail',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'TripDetail'
}

{ #category : 'running' }
TripExpenseFormModelTest >> setUp [

	| trip alice bob charlie |
	service := TripApplicationService withRepository:
		           InMemoryTripRepository new.
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	alice := service addParticipantByName: 'Alice' toTrip: trip id.
	bob := service addParticipantByName: 'Bob' toTrip: trip id.
	charlie := service addParticipantByName: 'charlie' toTrip: trip id.
	tripId := trip id.
	aliceId := alice id value.
	bobId := bob id value.
	charlieId := charlie id value.
	model := TripExpenseFormModel onService: service tripId: tripId
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddExpenseCreatesExpenseOnTrip [
    | trip |
    model show.
    model addExpense: 'Resto' amount: 90 payerId: aliceId.
    trip := service findTrip: tripId.
    self assert: trip expenses size equals: 1
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddExpenseHidesForm [
    model show.
    model addExpense: 'Resto' amount: 90 payerId: aliceId.
    self deny: model isShowing
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddExpenseWithEmptyDescriptionKeepsFormShowing [
    model show.
    model addExpense: '' amount: 90 payerId: aliceId.
    self assert: model isShowing
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddExpenseWithZeroAmountKeepsFormShowing [
    model show.
    model addExpense: 'Resto' amount: 0 payerId: aliceId.
    self assert: model isShowing
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddGiftEntryCreatesTripGiftEntryModel [
model show.
    model setCurrentPayerId: aliceId.
    model setCurrentAmount: 90.
    model addGiftEntry.
    self assert: (model giftEntries first isKindOf: TripGiftEntryModel)
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddGiftEntryHasAllParticipantsAsBeneficiaries [
    model show.
    model setCurrentPayerId: aliceId.
    model setCurrentAmount: 90.
    model addGiftEntry.
    "Alice est le payeur — 2 bénéficiaires restants"
    self assert: model giftEntries first beneficiaries size equals: 2
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddGiftEntryIncreasesCount [


    model show.
    model setCurrentPayerId: aliceId.
    model setCurrentAmount: 90.
    model addGiftEntry.
    self assert: model giftEntries size equals: 1
]

{ #category : 'running' }
TripExpenseFormModelTest >> testCanAddGiftEntryAnnouncesValueChanged [
    | announced |
    model show.
    model setCurrentPayerId: aliceId.
    model setCurrentAmount: 90.
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model addGiftEntry.
    self assert: announced
]

{ #category : 'running' }
TripExpenseFormModelTest >> testCanAddGiftEntryWithPayerAndAmount [
    model show.
    model setCurrentPayerId: aliceId.
    model setCurrentAmount: 90.
    model addGiftEntry.
    self assert: model giftEntries size equals: 1
]

{ #category : 'running' }
TripExpenseFormModelTest >> testCannotAddGiftEntryWithoutAmount [
    model show.
    model setCurrentPayerId: aliceId.
    model addGiftEntry.
    self assert: model giftEntries isEmpty
]

{ #category : 'running' }
TripExpenseFormModelTest >> testCannotAddGiftEntryWithoutPayer [
    model show.
    model addGiftEntry.
    self assert: model giftEntries isEmpty
]

{ #category : 'running' }
TripExpenseFormModelTest >> testGiftEntriesInitiallyEmpty [
    model show.
    self assert: model giftEntries isEmpty
]

{ #category : 'running' }
TripExpenseFormModelTest >> testGiftEntryMaxAmountMatchesCurrentAmount [
    model show.
    model setCurrentPayerId: aliceId.
    model setCurrentAmount: 90.
    model addGiftEntry.
    self assert: model giftEntries first maxAmount equals: 90
]

{ #category : 'running' }
TripExpenseFormModelTest >> testGiftEntryPayerIsSet [
    model show.
    model setCurrentPayerId: aliceId.
    model setCurrentAmount: 90.
    model addGiftEntry.
    self deny: (model giftEntries first beneficiaries 
        anySatisfy: [ :b | b participantId = aliceId ])
]

{ #category : 'running' }
TripExpenseFormModelTest >> testHideFormClearsIsShowing [
    model show.
    model hide.
    self deny: model isShowing
]

{ #category : 'running' }
TripExpenseFormModelTest >> testInitiallyNotShowing [
    self deny: model isShowing
]

{ #category : 'running' }
TripExpenseFormModelTest >> testRemoveGiftEntryModel [
   | entryId |   
 model show.
    model setCurrentPayerId: aliceId.
    model setCurrentAmount: 90.
    model addGiftEntry.
    model addGiftEntry.
 
    entryId := model giftEntries first entryId.
    model removeGiftEntryId: entryId.
    self assert: model giftEntries size equals: 1
]

{ #category : 'running' }
TripExpenseFormModelTest >> testSetAmountUpdatesGiftEntriesMaxAmount [
    model show.
    model setCurrentPayerId: aliceId.
    model setCurrentAmount: 90.
    model addGiftEntry.
    model setCurrentAmount: 120.
    self assert: model giftEntries first maxAmount equals: 120
]

{ #category : 'running' }
TripExpenseFormModelTest >> testSetPayerUpdatesGiftEntries [
    "Quand le payeur change, tous les gift entries excluent ce payeur."
    model show.
    model addGiftEntry.
    model addGiftEntry.
    model setCurrentPayerId: aliceId.
    model giftEntries do: [ :g |
        self deny: (g beneficiaries anySatisfy: [ :b | b participantId = aliceId ]) ]
]

{ #category : 'running' }
TripExpenseFormModelTest >> testShowFormAllParticipantsIncludedByDefault [
    model show.
    model participantEntries do: [ :e |
        self assert: e included ]
]

{ #category : 'running' }
TripExpenseFormModelTest >> testShowFormDefaultWeightIsOne [
    model show.
    model participantEntries do: [ :e |
        self assert: e weight equals: 1 ]
]

{ #category : 'running' }
TripExpenseFormModelTest >> testShowFormLoadsParticipants [

	model show.
	self assert: model participantEntries size equals: 3
]

{ #category : 'running' }
TripExpenseFormModelTest >> testShowFormResetsGiftEntries [
    model show.
    model addGiftEntry.
    model hide.
    model show.
    self assert: model giftEntries isEmpty
]

{ #category : 'running' }
TripExpenseFormModelTest >> testShowFormSetsIsShowing [
    model show.
    self assert: model isShowing
]

{ #category : 'running' }
TripExpenseFormModelTest >> testShowResetsGiftEntries [
    model show.
    model addGiftEntry.
    model show.
    self assert: model giftEntries isEmpty
]
