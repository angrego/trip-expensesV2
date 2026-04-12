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
.slider-container { 
    position: relative; 
    height: 30px; 
    display: flex; 
    align-items: center;
    width: 100%;
}
.slider-track { 
    position: absolute; 
    left: 0; 
    right: 0; 
    height: 6px; 
    border-radius: 3px; 
    z-index: 0;
    background: #e0e0e0;
    top: 50%;
    transform: translateY(-50%);
}

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
    <input id="slider" type="range" min="0" max="0" value="0">
    <span id="slider-value" class="slider-value">0</span>
</div>
<div class="slider-labels">
    <span id="payer-share-label" class="payer-share-label"></span>
    <span class="slider-max-label" id="max-label"></span>
</div>
<div class="slider-hint">
    <span id="payer-share-hint" class="payer-share-hint"></span>
</div>
        <slot name="beneficiaries"></slot>
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
TripGiftEntryView >> renderSlider: aValue max: aMax payerShare: aPayerShare [
    | slider |
    slider := self shadowedElementWithId: #slider.
    slider propertyAt: 'min' put: aPayerShare printString.
    slider propertyAt: 'max' put: aMax printString.
    slider propertyAt: 'value' put: aValue printString.
    (self shadowedElementWithId: #'slider-value') textContent: aValue printString.
    (self shadowedElementWithId: #'payer-share-label') textContent: 
        'Ma part : ' , aPayerShare printString.
    (self shadowedElementWithId: #'max-label') textContent: 
        'Max : ' , aMax printString
]
