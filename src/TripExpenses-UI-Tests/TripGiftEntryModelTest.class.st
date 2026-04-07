Class {
	#name : 'TripGiftEntryModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'alice',
		'bob',
		'charlie',
		'aliceId',
		'bobId',
		'charlieId',
		'model'
	],
	#category : 'TripExpenses-UI-Tests-Gift',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'Gift'
}

{ #category : 'running' }
TripGiftEntryModelTest >> setUp [
    alice   := Participant name: 'Alice'.
    bob     := Participant name: 'Bob'.
    charlie := Participant name: 'Charlie'.
    aliceId   := alice id value.
    bobId     := bob id value.
    charlieId := charlie id value.
    model := TripGiftEntryModel
        fromParticipant: alice
        maxAmount: 90
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob.
            TripExpenseParticipantEntry forParticipant: charlie }
]

{ #category : 'running' }
TripGiftEntryModelTest >> testAllOtherBeneficiariesIncludedByDefault [
    "Bob et Charlie sont inclus par défaut"
    self assert: (model beneficiaries allSatisfy: [ :b | b included ])
]

{ #category : 'running' }
TripGiftEntryModelTest >> testAllParticipantsAreBeneficiariesWhenNoPlayer [
    | modelNoPayer |
    modelNoPayer := TripGiftEntryModel
        maxAmount: 90
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob.
            TripExpenseParticipantEntry forParticipant: charlie }.
    self assert: modelNoPayer beneficiaries size equals: 3
]

{ #category : 'running' }
TripGiftEntryModelTest >> testBeneficiariesCountExcludesPayer [
    "3 participants - 1 payeur = 2 bénéficiaires"
    self assert: model beneficiaries size equals: 2
]

{ #category : 'running' }
TripGiftEntryModelTest >> testDebugFromParticipant [
    | modelNoPayer |
    modelNoPayer := TripGiftEntryModel
        maxAmount: 90
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob.
            TripExpenseParticipantEntry forParticipant: charlie }.
    self assert: modelNoPayer fromId isNil
]

{ #category : 'running' }
TripGiftEntryModelTest >> testDebugInitialState [
    | modelNoPayer |
    modelNoPayer := TripGiftEntryModel
        maxAmount: 90
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob.
            TripExpenseParticipantEntry forParticipant: charlie }.
    self assert: modelNoPayer maxAmount equals: 90.
    self assert: modelNoPayer sliderValue equals: 0
]

{ #category : 'running' }
TripGiftEntryModelTest >> testExcludeBeneficiary [
    model excludeBeneficiaryId: bobId.
    self deny: (model beneficiaries detect: [ :b | b participantId = bobId ]) included
]

{ #category : 'running' }
TripGiftEntryModelTest >> testFromIdIsSet [
    self assert: model fromId equals: aliceId
]

{ #category : 'running' }
TripGiftEntryModelTest >> testIncludeBeneficiary [
    model excludeBeneficiaryId: bobId.
    model includeBeneficiaryId: bobId.
    self assert: (model beneficiaries detect: [ :b | b participantId = bobId ]) included
]

{ #category : 'running' }
TripGiftEntryModelTest >> testInitialFromIdIsNil [
    | modelNoPayer |
    modelNoPayer := TripGiftEntryModel
        maxAmount: 90
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob.
            TripExpenseParticipantEntry forParticipant: charlie }.
    self assert: modelNoPayer fromId isNil
]

{ #category : 'running' }
TripGiftEntryModelTest >> testInitialSliderValueIsZero [
    self assert: model sliderValue equals: 0
]

{ #category : 'running' }
TripGiftEntryModelTest >> testIsCompleteWhenSliderPositiveAndAtLeastOneBeneficiary [
    model sliderValue: 30.
    self assert: model isComplete
]

{ #category : 'running' }
TripGiftEntryModelTest >> testIsNotCompleteWhenNoBeneficiaryIncluded [
    model sliderValue: 30.
    model excludeBeneficiaryId: bobId.
    model excludeBeneficiaryId: charlieId.
    self deny: model isComplete
]

{ #category : 'running' }
TripGiftEntryModelTest >> testIsNotCompleteWhenNoPlayer [
    | modelNoPayer |
    modelNoPayer := TripGiftEntryModel
        maxAmount: 90
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob.
            TripExpenseParticipantEntry forParticipant: charlie }.
    modelNoPayer sliderValue: 30.
    self deny: modelNoPayer isComplete
]

{ #category : 'running' }
TripGiftEntryModelTest >> testIsNotCompleteWhenSliderIsZero [
    self deny: model isComplete
]

{ #category : 'running' }
TripGiftEntryModelTest >> testMaxAmountIsPayerAmount [
    self assert: model maxAmount equals: 90
]

{ #category : 'running' }
TripGiftEntryModelTest >> testPayerIsExcludedFromBeneficiaries [
    "Alice est le payeur — elle ne doit pas apparaître comme bénéficiaire"
    self deny: (model beneficiaries anySatisfy: [ :b | b participantId = aliceId ])
]

{ #category : 'running' }
TripGiftEntryModelTest >> testPreferredPresenterClassIsTripGiftEntryPresenter [
    self
        assert: model preferredPresenterClass
        equals: TripGiftEntryPresenter
]

{ #category : 'running' }
TripGiftEntryModelTest >> testSetPayerAnnouncesValueChanged [
    | modelNoPayer announced |
    modelNoPayer := TripGiftEntryModel
        maxAmount: 90
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob.
            TripExpenseParticipantEntry forParticipant: charlie }.
    announced := false.
    modelNoPayer when: ValueChanged do: [ announced := true ].
    modelNoPayer setFromParticipant: alice.
    self assert: announced
]

{ #category : 'running' }
TripGiftEntryModelTest >> testSetPayerExcludesFromBeneficiaries [
    | modelNoPayer |
    modelNoPayer := TripGiftEntryModel
        maxAmount: 90
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob.
            TripExpenseParticipantEntry forParticipant: charlie }.
    modelNoPayer setFromParticipant: alice.
    self assert: modelNoPayer beneficiaries size equals: 2.
    self deny: (modelNoPayer beneficiaries anySatisfy: [ :b | b participantId = aliceId ])
]

{ #category : 'running' }
TripGiftEntryModelTest >> testSetPayerTwiceUpdatesExclusion [
    "Si on change de payeur, l'ancien est remis comme bénéficiaire, le nouveau est exclu."
    | modelNoPayer |
    modelNoPayer := TripGiftEntryModel
        maxAmount: 90
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob.
            TripExpenseParticipantEntry forParticipant: charlie }.
    modelNoPayer setFromParticipant: alice.
    modelNoPayer setFromParticipant: bob.
    self assert: modelNoPayer beneficiaries size equals: 2.
    self deny: (modelNoPayer beneficiaries anySatisfy: [ :b | b participantId = bobId ]).
    self assert: (modelNoPayer beneficiaries anySatisfy: [ :b | b participantId = aliceId ])
]

{ #category : 'running' }
TripGiftEntryModelTest >> testSetSliderValue [
    model sliderValue: 30.
    self assert: model sliderValue equals: 30
]

{ #category : 'running' }
TripGiftEntryModelTest >> testSetWeightAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model setWeight: 2 forBeneficiaryId: bobId.
    self assert: announced
]

{ #category : 'running' }
TripGiftEntryModelTest >> testSetWeightForBeneficiary [
    model setWeight: 2 forBeneficiaryId: bobId.
    self assert: (model beneficiaries detect: [ :b | b participantId = bobId ]) weight equals: 2
]

{ #category : 'running' }
TripGiftEntryModelTest >> testSliderAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model sliderValue: 30.
    self assert: announced
]

{ #category : 'running' }
TripGiftEntryModelTest >> testSliderValueCannotBeNegative [
    model sliderValue: -10.
    self assert: model sliderValue equals: 0
]

{ #category : 'running' }
TripGiftEntryModelTest >> testSliderValueCannotExceedMax [
    model sliderValue: 200.
    self assert: model sliderValue equals: 90
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftAmountSplitProportionally [
    "Bob poids 1, Charlie poids 1 → 15 chacun"
    | gifts |
    model sliderValue: 30.

    gifts := model toGift: 'EUR'.
    self assert: (gifts allSatisfy: [ :g | g amount = (Money amount: 15 currency: 'EUR') ])
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftAmountSplitWithWeights [
    "Bob poids 2, Charlie poids 1 → Bob 20, Charlie 10"
    | gifts bobGift charlieGift |

    model sliderValue: 30.
    model setWeight: 2 forBeneficiaryId: bobId.
    gifts := model toGift: 'EUR'.
    bobGift     := gifts detect: [ :g | g to = bob ].
    charlieGift := gifts detect: [ :g | g to = charlie ].
    self assert: bobGift amount     equals: (Money amount: 20 currency: 'EUR').
    self assert: charlieGift amount equals: (Money amount: 10 currency: 'EUR')
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftExcludedBeneficiaryNotInGifts [
    | gifts |
    model sliderValue: 30.
    model excludeBeneficiaryId: charlieId.

    gifts := model toGift: 'EUR'.
    self assert: gifts size equals: 1.
    self assert: gifts first to equals: bob
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftFromIsAlice [
   | gifts | 
   model sliderValue: 30.
 
    gifts := model toGift: 'EUR'.
    self assert: (gifts allSatisfy: [ :g | g from = alice ])
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftOneGiftPerIncludedBeneficiary [
    model sliderValue: 30.
    self assert: (model toGift: 'EUR') size equals: 2
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftReturnsCollectionOfGifts [
    model sliderValue: 30.
    self assert: (model toGift: 'EUR') isCollection
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftReturnsNilWhenNotComplete [
    self assert: (model toGift: 'EUR') isNil
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToggleBeneficiaryAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model excludeBeneficiaryId: bobId.
    self assert: announced
]

{ #category : 'running' }
TripGiftEntryModelTest >> testWeightsInheritedFromExpense [
    "Poids hérités — ici tous à 1"
    self assert: (model beneficiaries allSatisfy: [ :b | b weight = 1 ])
]
