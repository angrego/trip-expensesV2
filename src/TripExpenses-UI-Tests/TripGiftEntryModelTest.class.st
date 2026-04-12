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
        theoreticalShares: Dictionary new
]

{ #category : 'helper' }
TripGiftEntryModelTest >> setUpWithShares [
    | theoreticalShares |
    theoreticalShares := Dictionary new.
    theoreticalShares at: alice   put: (Money amount: 30 currency: 'EUR').
    theoreticalShares at: bob     put: (Money amount: 30 currency: 'EUR').
    theoreticalShares at: charlie put: (Money amount: 30 currency: 'EUR').
    model := TripGiftEntryModel
        fromParticipant: alice
        maxAmount: 90
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob.
            TripExpenseParticipantEntry forParticipant: charlie }
        theoreticalShares: theoreticalShares
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

{ #category : 'tests' }
TripGiftEntryModelTest >> testPayPartForAnnouncesValueChanged [
    | announced |
    self setUpWithShares.
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model payPartFor: bobId.
    self assert: announced
]

{ #category : 'tests' }
TripGiftEntryModelTest >> testPayPartForBobAndCharlieAccumulates [
    self setUpWithShares.
    model payPartFor: bobId.
    model payPartFor: charlieId.
    self assert: model sliderValue equals: 90
]

{ #category : 'tests' }
TripGiftEntryModelTest >> testPayPartForBobPositionsSliderCorrectly [
    self setUpWithShares.
    model payPartFor: bobId.
    self assert: model sliderValue equals: 60
]

{ #category : 'tests' }
TripGiftEntryModelTest >> testPayPartForCannotExceedMaxAmount [
    self setUpWithShares.
    model payPartFor: bobId.
    model payPartFor: charlieId.
    model payPartFor: bobId.
    self assert: model sliderValue equals: 90
]

{ #category : 'tests' }
TripGiftEntryModelTest >> testPayPartForUnknownParticipantDoesNothing [
    self setUpWithShares.
    model payPartFor: 'unknown-id'.
    self assert: model sliderValue equals: 30
]

{ #category : 'running' }
TripGiftEntryModelTest >> testPayerIsExcludedFromBeneficiaries [
    "Alice est le payeur — elle ne doit pas apparaître comme bénéficiaire"
    self deny: (model beneficiaries anySatisfy: [ :b | b participantId = aliceId ])
]

{ #category : 'tests' }
TripGiftEntryModelTest >> testPayerTheoreticalShare [
    self setUpWithShares.
    self assert: model payerTheoreticalShare equals: (Money amount: 30 currency: 'EUR')
]

{ #category : 'running' }
TripGiftEntryModelTest >> testPayerTheoreticalShareAfterCreation [
    self setUpWithShares.
    self assert: model payerTheoreticalShare amount equals: 30
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
TripGiftEntryModelTest >> testSliderInitializedToPayerShareAfterCreation [
    self setUpWithShares.
    self assert: model sliderValue equals: 30
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

    gifts := model toGift: 'EUR' payerShare: 0.
    self assert: (gifts allSatisfy: [ :g | g amount = (Money amount: 15 currency: 'EUR') ])
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftAmountSplitWithWeights [
	"Bob poids 2, Charlie poids 1 → Bob 20, Charlie 10"

	| gifts bobGift charlieGift |
	model sliderValue: 30.
	model setWeight: 2 forBeneficiaryId: bobId.
	gifts := model toGift: 'EUR' payerShare: 0.
	bobGift := gifts detect: [ :g | g to = bob ].
	charlieGift := gifts detect: [ :g | g to = charlie ].
	self
		assert: bobGift amount
		equals: (Money amount: 20 currency: 'EUR').
	self
		assert: charlieGift amount
		equals: (Money amount: 10 currency: 'EUR')
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftExcludedBeneficiaryNotInGifts [

	| gifts |
	model sliderValue: 30.
	model excludeBeneficiaryId: charlieId.

	gifts := model toGift: 'EUR' payerShare: 0.
	self assert: gifts size equals: 1.
	self assert: gifts first to equals: bob
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftFromIsAlice [

	| gifts |
	model sliderValue: 30.

	gifts := model toGift: 'EUR' payerShare: 0.
	self assert: (gifts allSatisfy: [ :g | g from = alice ])
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftNetAmountIsSliderMinusPayerShare [
	"Alice paie 4000 sur 7000. Poids : Alice(1), Bob(1), Charlie(2).
     Part théorique Alice = 7000 * 1/4 = 1750.
     Montant net gifté = 4000 - 1750 = 2250.
     Bob reçoit 2250 * 1/3 = 750, Charlie reçoit 2250 * 2/3 = 1500."

	| gifts |
	model := TripGiftEntryModel
		         fromParticipant: alice
		         maxAmount: 4000
		         beneficiaries: {
				         (TripExpenseParticipantEntry forParticipant: alice).
				         (TripExpenseParticipantEntry forParticipant: bob).
				         (TripExpenseParticipantEntry forParticipant: charlie) }.
	model sliderValue: 4000.
	model setWeight: 1 forBeneficiaryId: bob id value.
	model setWeight: 2 forBeneficiaryId: charlie id value.
	gifts := model toGift: 'EUR' payerShare: 1750.
	self
		assert: (gifts detect: [ :g | g to = bob ]) amount
		equals: (Money amount: 750 currency: 'EUR').
	self
		assert: (gifts detect: [ :g | g to = charlie ]) amount
		equals: (Money amount: 1500 currency: 'EUR')
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftNetAmountIsZeroWhenSliderEqualsPayerShare [
    "Si Alice paie exactement sa part, le montant net gifté est 0 → pas de gift."
    | gifts |
    model := TripGiftEntryModel
        fromParticipant: alice
        maxAmount: 1750
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob }.
    model sliderValue: 1750.
    gifts := model toGift: 'EUR' payerShare: 1750.
    self assert: gifts isEmpty
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftNetAmountNegativeReturnsEmpty [
    "Si sliderValue < payerShare (impossible normalement) → pas de gift."
    | gifts |
    alice := Participant name: 'Alice'.
    bob   := Participant name: 'Bob'.
    model := TripGiftEntryModel
        fromParticipant: alice
        maxAmount: 1000
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob }.
    model sliderValue: 1000.
    gifts := model toGift: 'EUR' payerShare: 1750.
    self assert: gifts isEmpty
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftOneGiftPerIncludedBeneficiary [

	model sliderValue: 30.
	self assert: (model toGift: 'EUR' payerShare:0) size equals: 2
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftReturnsCollectionOfGifts [

	model sliderValue: 30.
	self assert: (model toGift: 'EUR' payerShare: 0) isCollection
]

{ #category : 'running' }
TripGiftEntryModelTest >> testToGiftTotalGiftedEqualsNetAmount [
    "Total des gifts = sliderValue - payerShare."
    | gifts total |
    alice   := Participant name: 'Alice'.
    bob     := Participant name: 'Bob'.
    charlie := Participant name: 'Charlie'.
    model := TripGiftEntryModel
        fromParticipant: alice
        maxAmount: 4000
        beneficiaries: {
            TripExpenseParticipantEntry forParticipant: alice.
            TripExpenseParticipantEntry forParticipant: bob.
            TripExpenseParticipantEntry forParticipant: charlie }.
    model sliderValue: 4000.
    model setWeight: 1 forBeneficiaryId: bob id value.
    model setWeight: 2 forBeneficiaryId: charlie id value.
    gifts := model toGift: 'EUR' payerShare: 1750.
    total := gifts inject: 0 into: [ :sum :g | sum + g amount amount ].
    self assert: total equals: 2250
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
