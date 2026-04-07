Class {
	#name : 'TripGiftEntryModel',
	#superclass : 'CpModel',
	#instVars : [
		'fromParticipant',
		'maxAmount',
		'sliderValue',
		'beneficiaries',
		'allBeneficiaries',
		'entryId'
	],
	#category : 'TripExpenses-UI-Gift',
	#package : 'TripExpenses-UI',
	#tag : 'Gift'
}

{ #category : 'instance creation' }
TripGiftEntryModel class >> fromParticipant: aParticipant maxAmount: aaMaxAmount beneficiaries: aCollection [

	^ (self maxAmount: aaMaxAmount beneficiaries: aCollection)
		  setFromParticipant: aParticipant;
		  yourself
]

{ #category : 'instance creation' }
TripGiftEntryModel class >> maxAmount: aMaxAmount beneficiaries: aCollection [

	^ self new
		  setMaxAmount: aMaxAmount beneficiaries: aCollection;
		  yourself
]

{ #category : 'accessing' }
TripGiftEntryModel >> beneficiaries [
	^ beneficiaries
]

{ #category : 'accessing' }
TripGiftEntryModel >> entryId [
    ^ entryId
]

{ #category : 'accessing' }
TripGiftEntryModel >> excludeBeneficiaryId: aParticipantId [
    beneficiaries
        detect: [ :b | b participantId = aParticipantId ]
        ifFound: [ :b | b included: false ].
    self valueChanged
]

{ #category : 'instance creation' }
TripGiftEntryModel >> fromId [
fromParticipant ifNil: [ ^ nil ].
    ^ fromParticipant id value
]

{ #category : 'accessing' }
TripGiftEntryModel >> includeBeneficiaryId: aParticipantId [
    beneficiaries
        detect: [ :b | b participantId = aParticipantId ]
        ifFound: [ :b | b included: true ].
    self valueChanged
]

{ #category : 'initialization' }
TripGiftEntryModel >> initializeFromParticipant: aParticipant maxAmount: aMaxAmount beneficiaries: aCollection [
    fromParticipant := aParticipant.
    maxAmount       := aMaxAmount.
    sliderValue     := 0.
    beneficiaries   := aCollection
        reject: [ :b | b participantId = aParticipant id value ]
]

{ #category : 'accessing' }
TripGiftEntryModel >> isComplete [
    fromParticipant ifNil: [ ^ false ].
 sliderValue = 0 ifTrue: [ ^ false ].
    ^ beneficiaries anySatisfy: [ :b | b included ]
]

{ #category : 'accessing' }
TripGiftEntryModel >> maxAmount [
	^ maxAmount
]

{ #category : 'accessing' }
TripGiftEntryModel >> setFromParticipant: aParticipant [
    fromParticipant := aParticipant.
    beneficiaries := allBeneficiaries
        reject: [ :b | b participantId = aParticipant id value ].
    self valueChanged
]

{ #category : 'accessing' }
TripGiftEntryModel >> setMaxAmount: aNumber [
    maxAmount := aNumber.
    sliderValue := (sliderValue max: 0) min: maxAmount.
    self valueChanged
]

{ #category : 'accessing' }
TripGiftEntryModel >> setMaxAmount: aMaxAmount beneficiaries: aCollection [
super initialize.    
maxAmount        := aMaxAmount.
entryId          := UUID new asString.
    sliderValue      := 0.
    fromParticipant  := nil.
    allBeneficiaries := aCollection copy.
    beneficiaries    := aCollection copy
]

{ #category : 'accessing' }
TripGiftEntryModel >> setWeight: anInteger forBeneficiaryId: aParticipantId [
    beneficiaries
        detect: [ :b | b participantId = aParticipantId ]
        ifFound: [ :b | b weight: anInteger ].
    self valueChanged
]

{ #category : 'accessing' }
TripGiftEntryModel >> sliderValue [
	^ sliderValue
]

{ #category : 'accessing' }
TripGiftEntryModel >> sliderValue: aNumber [
    sliderValue := (aNumber max: 0) min: maxAmount.
    self valueChanged
]

{ #category : 'accessing' }
TripGiftEntryModel >> toGift: aCurrency [
    | included totalWeight |
    self isComplete ifFalse: [ ^ nil ].
    included    := beneficiaries select: [ :b | b included ].
    totalWeight := included inject: 0 into: [ :sum :b | sum + b weight ].
    ^ included collect: [ :b |
        | share |
        share := (sliderValue * b weight / totalWeight) rounded.
        Gift
            from:   fromParticipant
            to:     b participant
            amount: (Money amount: share currency: aCurrency) ]
]
