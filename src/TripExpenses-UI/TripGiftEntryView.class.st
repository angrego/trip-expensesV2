Class {
	#name : 'TripGiftEntryView',
	#superclass : 'CpView',
	#instVars : [
		'beneficiaryRows'
	],
	#category : 'TripExpenses-UI-Gift',
	#package : 'TripExpenses-UI',
	#tag : 'Gift'
}

{ #category : 'web resources' }
TripGiftEntryView class >> style [
    <webResource: #css>
    ^ '
    :host { display: block; }
    .gift-card {
        border: 1px solid #d0c8ff;
        border-radius: 10px;
        padding: 1rem;
        margin-bottom: .75rem;
        background: #faf9ff;
    }
    .gift-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: .75rem;
    }
    .gift-title { font-weight: 500; color: #5046e4; }
    .btn-remove {
        background: transparent;
        border: none;
        cursor: pointer;
        color: #993c1d;
        font-size: 1rem;
    }
    .slider-row {
        display: flex;
        align-items: center;
        gap: .75rem;
        margin-bottom: .75rem;
    }
    .slider-row input[type=range] { flex: 1; }
    .slider-value {
        min-width: 40px;
        font-weight: 500;
        color: #333;
        text-align: right;
    }
    .beneficiary-row {
        display: flex;
        align-items: center;
        gap: .5rem;
        margin: .3rem 0;
    }
    .beneficiary-name { flex: 1; font-size: .95rem; }
    .weight-input {
        width: 50px;
        border: 1px solid #ccc;
        border-radius: 6px;
        padding: .25rem .4rem;
        font-size: .9rem;
        text-align: center;
    }
    .weight-input:disabled { background: #f0f0f0; color: #aaa; }
    '
]

{ #category : 'web resources' }
TripGiftEntryView class >> template [
    <webResource: #html>
    ^ '
    <div class="gift-card">
        <div class="gift-header">
            <span class="gift-title">🎁 Cadeau</span>
            <button id="btn-remove" class="btn-remove" title="Supprimer">✕</button>
        </div>
        <div class="slider-row">
            <input id="slider" type="range" min="0" max="100" value="0">
            <span id="slider-value" class="slider-value">0</span>
        </div>
        <div id="beneficiaries"></div>
    </div>
    '
]

{ #category : 'initialization' }
TripGiftEntryView >> handleRemove [
    self serverAnnounce: TripGiftRemoveRequested
]

{ #category : 'initialization' }
TripGiftEntryView >> handleSliderChanged [
    | slider val |
    slider := self shadowedElementWithId: #'slider'.
    val := (slider propertyAt: 'value') asNumber truncated.
    (self shadowedElementWithId: #'slider-value') textContent: val printString.
    self serverAnnounce: (TripGiftSliderChanged amountValue: val)
]

{ #category : 'initialization' }
TripGiftEntryView >> initializeShadowRoot [
    super initializeShadowRoot.
    (self shadowedElementWithId: #'btn-remove')
        when: CpClickEvent basicPrimary
        send: #handleRemove
        to: self.
    (self shadowedElementWithId: #'slider')
        when: CpInputEvent
        send: #handleSliderChanged
        to: self
]

{ #category : 'rendering' }
TripGiftEntryView >> renderBeneficiaries: aCollectionOfArrays [

	| container |
	container := self shadowedElementWithId: #beneficiaries.
	container removeChildren.
	beneficiaryRows := OrderedCollection new.
	aCollectionOfArrays do: [ :arr |
			| pid name weight included row cb weightInput label |
			pid := arr first.
			name := arr at: 2.
			weight := arr at: 3.
			included := arr at: 4.
			row := CpHtmlElement newWithTag: 'div'.
			row addClass: 'beneficiary-row'.
			cb := CpHtmlElement newWithTag: 'input'.
			cb attributeAt: 'type' put: 'checkbox'.
			cb attributeAt: 'data-pid' put: pid.
			included ifTrue: [ cb attributeAt: 'checked' put: '' ].
			cb
				when: CpChangeEvent
				do: [
						self serverAnnounce: (TripGiftBeneficiaryToggled
								 participantId: pid
								 included: (cb propertyAt: 'checked')) ]
				for: self.
			label := CpHtmlElement newWithTag: 'span'.
			label addClass: 'beneficiary-name'.
			label textContent: name.
			weightInput := CpHtmlElement newWithTag: 'input'.
			weightInput attributeAt: 'type' put: 'number'.
			weightInput attributeAt: 'min' put: '1'.
			weightInput attributeAt: 'class' put: 'weight-input'.
			weightInput propertyAt: 'value' put: weight printString.
			included ifFalse: [ weightInput attributeAt: 'disabled' put: '' ].
			weightInput
				when: CpChangeEvent
				do: [
						| w |
						w := (weightInput propertyAt: 'value') asNumber truncated.
						self serverAnnounce:
							(TripGiftWeightChanged participantId: pid weight: w) ]
				for: self.
			row appendChild: cb.
			row appendChild: label.
			row appendChild: weightInput.
			container appendChild: row ]
]

{ #category : 'rendering' }
TripGiftEntryView >> renderMaxAmount: aMax [

	(self shadowedElementWithId: #slider)
		propertyAt: 'max'
		put: aMax printString
]

{ #category : 'rendering' }
TripGiftEntryView >> renderSliderValue: aValue [
    (self shadowedElementWithId: #'slider')
        propertyAt: 'value' put: aValue printString.
    (self shadowedElementWithId: #'slider-value')
        textContent: aValue printString
]
