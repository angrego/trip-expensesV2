Class {
	#name : 'TripSettlementItemModel',
	#superclass : 'CpModel',
	#instVars : [
		'fromParticipant',
		'toParticipant',
		'money'
	],
	#category : 'TripExpenses-UI-Settlement',
	#package : 'TripExpenses-UI',
	#tag : 'Settlement'
}

{ #category : 'instance creation' }
TripSettlementItemModel class >> fromSettlement: aSettlement [
	"Construit depuis un objet Settlement du domaine.
	 Settlement expose #from (Participant), #to (Participant), #amount (Money)."

	^ self new
		  setFrom: aSettlement from 
		  to: aSettlement to 
		  money: aSettlement amount;
		  yourself
]

{ #category : 'accessing' }
TripSettlementItemModel >> amount [

	^ money amount printString
]

{ #category : 'accessing' }
TripSettlementItemModel >> currency [

	^ money currency
]

{ #category : 'accessing' }
TripSettlementItemModel >> fromParticipantName [

	^ fromParticipant name
]

{ #category : 'accessing' }
TripSettlementItemModel >> money:aMoney [
money:=aMoney 
]

{ #category : 'testing' }
TripSettlementItemModel >> preferredPresenterClass [
	^ TripSettlementItemPresenter
]

{ #category : 'private - setting' }
TripSettlementItemModel >> setFrom: aFromParticipant to: aToParticipant money: aMoney [

	fromParticipant := aFromParticipant.
	toParticipant := aToParticipant.
	money:=aMoney
]

{ #category : 'accessing' }
TripSettlementItemModel >> toParticipantName [
    ^ toParticipant name
]
