Class {
	#name : 'TripGiftBeneficiaryModel',
	#superclass : 'TripParticipantWeightModel',
	#category : 'TripExpenses-UI-Gift',
	#package : 'TripExpenses-UI',
	#tag : 'Gift'
}

{ #category : 'accessing' }
TripGiftBeneficiaryModel >> participantName [
	^participant name
]

{ #category : 'presenter' }
TripGiftBeneficiaryModel >> preferredPresenterClass [
^ TripGiftBeneficiaryPresenter
]
