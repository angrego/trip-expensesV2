Class {
	#name : 'TripGiftEntryPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Gift',
	#package : 'TripExpenses-UI',
	#tag : 'Gift'
}

{ #category : 'rendering' }
TripGiftEntryPresenter >> onBeneficiaryToggled: anAnnouncement [
    anAnnouncement included
        ifTrue:  [ self model includeBeneficiaryId: anAnnouncement participantId ]
        ifFalse: [ self model excludeBeneficiaryId: anAnnouncement participantId ]
]

{ #category : 'rendering' }
TripGiftEntryPresenter >> onRemoveRequested: anAnnouncement [
    self parent onRemoveGiftEntry: self model
]

{ #category : 'rendering' }
TripGiftEntryPresenter >> onSliderChanged: anAnnouncement [

	self model sliderValue: anAnnouncement amountValue
]

{ #category : 'rendering' }
TripGiftEntryPresenter >> onWeightChanged: anAnnouncement [
    self model
        setWeight: anAnnouncement weight
        forBeneficiaryId: anAnnouncement participantId
]

{ #category : 'rendering' }
TripGiftEntryPresenter >> renderView [

	self view
		renderMaxAmount: self model maxAmount;
		renderSliderValue: self model sliderValue;
		renderBeneficiaries: (self model beneficiaries collect: [ :b |
            Array
                with: b participantId
                with: b name
                with: b weight
                with: b included ]) asArray
]

{ #category : 'rendering' }
TripGiftEntryPresenter >> viewCreated [
    super viewCreated.
    self view
        when: TripGiftSliderChanged      send: #onSliderChanged:      to: self;
        when: TripGiftBeneficiaryToggled send: #onBeneficiaryToggled: to: self;
        when: TripGiftWeightChanged      send: #onWeightChanged:      to: self;
        when: TripGiftRemoveRequested    send: #onRemoveRequested     to: self
]
