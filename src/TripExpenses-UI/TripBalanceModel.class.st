Class {
	#name : 'TripBalanceModel',
	#superclass : 'CpModel',
	#instVars : [
		'service',
		'tripId',
		'balances',
		'settlements'
	],
	#category : 'TripExpenses-UI-Balance',
	#package : 'TripExpenses-UI',
	#tag : 'Balance'
}

{ #category : 'instance creation' }
TripBalanceModel class >> onService: aTripApplicationService tripId: anId [
    ^ self new
        service: aTripApplicationService;
        tripId: anId;
        yourself
]

{ #category : 'accessing' }
TripBalanceModel >> balances [
	^ balances
]

{ #category : 'private - setting' }
TripBalanceModel >> initialize [
    super initialize.
    balances := OrderedCollection new.
    settlements := OrderedCollection new
]

{ #category : 'actions' }
TripBalanceModel >> load [
    | trip |
    trip := service findTrip: tripId.
    balances := trip balances associations collect: [ :assoc |
        TripBalanceItemModel
            fromParticipant: assoc key
            money: assoc value ].
    settlements := (service settlementsForTrip: tripId) collect: [ :s |
        TripSettlementItemModel fromSettlement: s ].
    self valueChanged
]

{ #category : 'private - setting' }
TripBalanceModel >> service: aService [
    service := aService
]

{ #category : 'accessing' }
TripBalanceModel >> settlements [
	^ settlements
]

{ #category : 'private - setting' }
TripBalanceModel >> tripId: anId [
    tripId := anId
]
