Class {
	#name : 'TripExpenseListModel',
	#superclass : 'CpModel',
	#instVars : [
		'service',
		'tripId',
		'currency',
		'expenses'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'instance creation' }
TripExpenseListModel class >> onService: aTripApplicationService tripId: anId [
    ^ self new
        service: aTripApplicationService;
        tripId: anId;
        yourself
]

{ #category : 'accessing' }
TripExpenseListModel >> expenses [
	^ expenses
]

{ #category : 'private - setting' }
TripExpenseListModel >> initialize [
    super initialize.
    expenses := OrderedCollection new
]

{ #category : 'accessing' }
TripExpenseListModel >> load [

	| trip |
	trip := service findTrip: tripId.
	expenses := trip expenses collect: [ :e |
		            TripExpenseExpenseItemModel fromExpense: e ].
	self valueChanged.
	^self
]

{ #category : 'accessing' }
TripExpenseListModel >> removeExpenseId: anExpenseId [
    service removeExpenseById: anExpenseId fromTrip: tripId.
    self load
]

{ #category : 'private - setting' }
TripExpenseListModel >> service: aService [
    service := aService
]

{ #category : 'private - setting' }
TripExpenseListModel >> tripId: anId [
    | trip |
    tripId := anId.
    trip := service findTrip: anId.
    currency := trip currency
]
