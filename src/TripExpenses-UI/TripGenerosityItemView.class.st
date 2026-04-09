Class {
	#name : 'TripGenerosityItemView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-Balance',
	#package : 'TripExpenses-UI',
	#tag : 'Balance'
}

{ #category : 'web resources' }
TripGenerosityItemView class >> style [
    <webResource: #css>
    ^ '
    :host { display: block; }
    .generosity-row {
        display: flex;
        align-items: center;
        gap: .75rem;
        padding: .4rem 0;
        border-bottom: 1px solid #f0f0f0;
    }
    .participant-name { flex: 1; font-size: .9rem; }
    .amount { font-weight: 500; color: #5046e4; }
    .currency { font-size: .85rem; color: #666; }
    '
]

{ #category : 'web resources' }
TripGenerosityItemView class >> template [
    <webResource: #html>
    ^ '
    <div class="generosity-row">
        <span id="name" class="participant-name"></span>
        <span id="amount" class="amount"></span>
        <span id="currency" class="currency"></span>
    </div>
    '
]

{ #category : 'rendering' }
TripGenerosityItemView >> renderAmount: aString [
    (self shadowedElementWithId: #amount) textContent: aString
]

{ #category : 'rendering' }
TripGenerosityItemView >> renderCurrency: aString [
    (self shadowedElementWithId: #currency) textContent: aString
]

{ #category : 'rendering' }
TripGenerosityItemView >> renderParticipantName: aString [
    (self shadowedElementWithId: #name) textContent: aString
]
