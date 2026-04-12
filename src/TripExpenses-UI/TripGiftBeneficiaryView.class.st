Class {
	#name : 'TripGiftBeneficiaryView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-Gift',
	#package : 'TripExpenses-UI',
	#tag : 'Gift'
}

{ #category : 'web resources' }
TripGiftBeneficiaryView class >> style [
    <webResource: #css>
    ^ '
    :host { display: block; }
    .weight-row { display: flex; align-items: center; gap: .75rem; margin: .4rem 0; }
    .weight-row input[type=checkbox] { width: 18px; height: 18px; cursor: pointer; }
    .participant-name { flex: 1; font-size: .9rem; }
    .weight-input { width: 60px; border: 1px solid #ccc; border-radius: 6px; padding: .3rem .4rem; font-size: .95rem; text-align: center; }
    .weight-input:disabled { background: #f0f0f0; color: #aaa; }
    .share-label { min-width: 80px; font-size: .9rem; color: #444; font-weight: 500; }
    .btn-pay-part { background: transparent; border: none; cursor: pointer; font-size: .85rem; padding: .2rem .3rem; border-radius: 4px; opacity: 0.6; }
    .btn-pay-part:hover { opacity: 1; }
    '
]

{ #category : 'web resources' }
TripGiftBeneficiaryView class >> template [
    <webResource: #html>
    ^ '
    <div class="weight-row">
        <input id="checkbox" type="checkbox">
        <span id="name" class="participant-name"></span>
        <input id="weight" type="number" min="1" class="weight-input">
        <span id="share" class="share-label"></span>
        <button id="btn-pay-part" class="btn-pay-part" title="Payer la part">🎁</button>
    </div>
    '
]

{ #category : 'event handling' }
TripGiftBeneficiaryView >> handleInclusionChanged [
    | included |
    included := (self shadowedElementWithId: #checkbox) propertyAt: 'checked'.
    self serverAnnounce: (TripParticipantInclusionChanged
        participantId: ((self shadowedElementWithId: #checkbox) attributeAt: 'data-pid')
        included: included)
]

{ #category : 'event handling' }
TripGiftBeneficiaryView >> handlePayPart [
    self serverAnnounce: (TripGiftPayPartRequested
        participantId: ((self shadowedElementWithId: #checkbox) attributeAt: 'data-pid'))
]

{ #category : 'event handling' }
TripGiftBeneficiaryView >> handleWeightChanged [
    | w |
    w := (self shadowedElementWithId: #weight) propertyAt: 'value'.
    w isEmpty ifTrue: [ ^ self ].
    self serverAnnounce: (TripParticipantWeightChanged
        participantId: ((self shadowedElementWithId: #checkbox) attributeAt: 'data-pid')
        weight: w asNumber truncated)
]

{ #category : 'rendering' }
TripGiftBeneficiaryView >> initializeShadowRoot [
    super initializeShadowRoot.
    (self shadowedElementWithId: #checkbox)
        when: CpChangeEvent send: #handleInclusionChanged to: self.
    (self shadowedElementWithId: #weight)
        when: CpInputEvent send: #handleWeightChanged to: self.
    (self shadowedElementWithId: #'btn-pay-part')
        when: CpClickEvent basicPrimary send: #handlePayPart to: self
]

{ #category : 'rendering' }
TripGiftBeneficiaryView >> renderIncluded: aBoolean [
    | cb weightInput |
    cb := self shadowedElementWithId: #checkbox.
    weightInput := self shadowedElementWithId: #weight.
    cb propertyAt: 'checked' put: aBoolean.
    aBoolean
        ifTrue:  [ weightInput removeAttributeAt: 'disabled' ]
        ifFalse: [ weightInput attributeAt: 'disabled' put: '' ]
]

{ #category : 'rendering' }
TripGiftBeneficiaryView >> renderName: aString [
    (self shadowedElementWithId: #name) textContent: aString
]

{ #category : 'rendering' }
TripGiftBeneficiaryView >> renderParticipantId: anId [
    (self shadowedElementWithId: #checkbox) attributeAt: 'data-pid' put: anId
]

{ #category : 'rendering' }
TripGiftBeneficiaryView >> renderShareLabel: aString [
    (self shadowedElementWithId: 'share') textContent: aString
]

{ #category : 'rendering' }
TripGiftBeneficiaryView >> renderWeight: aNumber [
    (self shadowedElementWithId: #weight) propertyAt: 'value' put: aNumber printString
]
