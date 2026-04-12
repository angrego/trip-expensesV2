Class {
	#name : 'TripGiftEntryModel',
	#superclass : 'CpModel',
	#instVars : [
		'fromParticipant',
		'maxAmount',
		'sliderValue',
		'beneficiaries',
		'allBeneficiaries',
		'entryId',
		'theoreticalShares'
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
TripGiftEntryModel class >> fromParticipant: aParticipant maxAmount: aMaxAmount beneficiaries: aCollection theoreticalShares: aDict [
    ^ (self maxAmount: aMaxAmount beneficiaries: aCollection theoreticalShares: aDict)
        setFromParticipant: aParticipant;
        yourself
]

{ #category : 'instance creation' }
TripGiftEntryModel class >> maxAmount: aMaxAmount beneficiaries: aCollection [

	^ self new
		  setMaxAmount: aMaxAmount beneficiaries: aCollection;
		  yourself
]

{ #category : 'instance creation' }
TripGiftEntryModel class >> maxAmount: aMaxAmount beneficiaries: aCollection theoreticalShares: aDict [
    ^ self new
        setMaxAmount: aMaxAmount
        beneficiaries: aCollection
        theoreticalShares: aDict;
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
TripGiftEntryModel >> fromParticipantName [
    ^ fromParticipant
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
TripGiftEntryModel >> payPartFor: aParticipantId [

	| beneficiary share payerShare newValue |
	beneficiary := allBeneficiaries
		               detect: [ :b | b participantId = aParticipantId ]
		               ifNone: [ ^self ].
	share := theoreticalShares
		         at: beneficiary participant
		         ifAbsent: [ ^ self ].
	payerShare := self payerTheoreticalShare.
	"Si slider est en dessous de la part du payeur, on part de là"
	newValue := (sliderValue max: payerShare amount) + share amount.
	self sliderValue: newValue
]

{ #category : 'calculating' }
TripGiftEntryModel >> payerTheoreticalShare [
theoreticalShares ifNil: [ ^ Money amount: 0 currency: '' ].
    ^ theoreticalShares
        at: fromParticipant
        ifAbsent: [ Money amount: 0 currency: '' ]
]

{ #category : 'accessing' }
TripGiftEntryModel >> setFromParticipant: aParticipant [

	fromParticipant := aParticipant.
	beneficiaries := allBeneficiaries reject: [ :b |
		                 b participantId = aParticipant id value ].
	sliderValue := self payerTheoreticalShare amount.
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

	maxAmount := aMaxAmount.
	entryId := UUID new asString.
	sliderValue := 0.
	fromParticipant := nil.
	allBeneficiaries := aCollection collect: [ :e |
		                    TripParticipantWeightModel fromEntry: e ].
	beneficiaries := allBeneficiaries copy
]

{ #category : 'initialization' }
TripGiftEntryModel >> setMaxAmount: aMaxAmount beneficiaries: aCollection theoreticalShares: aDict [

	maxAmount := aMaxAmount.
	entryId := UUID new asString.
	sliderValue := 0.
	fromParticipant := nil.
	theoreticalShares := aDict.
	allBeneficiaries := aCollection collect: [ :e |
		                    TripGiftBeneficiaryModel fromEntry: e ].
	beneficiaries := allBeneficiaries copy.
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
TripGiftEntryModel >> toGift: aCurrency payerShare: aPayerShare [
    | netAmount included totalWeight |
    self isComplete ifFalse: [ ^ #() ].
    netAmount := sliderValue - aPayerShare.
    netAmount <= 0 ifTrue: [ ^ #() ].
    included    := beneficiaries select: [ :b | b included ].
    totalWeight := included inject: 0 into: [ :sum :b | sum + b weight ].
    totalWeight = 0 ifTrue: [ ^ #() ].
    ^ included collect: [ :b |
        | share |
        share := (netAmount * b weight / totalWeight) rounded.
        Gift
            from:   fromParticipant
            to:     b participant
            amount: (Money amount: share currency: aCurrency) ]
]
