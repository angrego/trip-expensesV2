Class {
	#name : 'TripBalanceItemModel',
	#superclass : 'CpModel',
	#instVars : [
		'participant',
		'money'
	],
	#category : 'TripExpenses-UI-Balance',
	#package : 'TripExpenses-UI',
	#tag : 'Balance'
}

{ #category : 'instance creation' }
TripBalanceItemModel class >> fromParticipant: aParticipant money: aMoney [
	"Construit depuis un Participant et un Money du domaine."

	^ self new
		  setParticipant:  aParticipant
		  money: aMoney;
		  yourself
]

{ #category : 'accessing' }
TripBalanceItemModel >> amount [

	^ money amount printString
]

{ #category : 'accessing' }
TripBalanceItemModel >> currency [

	^ money currency
]

{ #category : 'accessing' }
TripBalanceItemModel >> participantName [

	^ participant name
]

{ #category : 'testing' }
TripBalanceItemModel >> preferredPresenterClass [
	^ TripBalanceItemPresenter
]

{ #category : 'private - setting' }
TripBalanceItemModel >> setParticipant: aParticipant money: aMoney [

	participant := aParticipant .
	money := aMoney .
]
