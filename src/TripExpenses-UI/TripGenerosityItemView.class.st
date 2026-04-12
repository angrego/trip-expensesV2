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
    :host { display: block; margin-bottom: .5rem; }
    .generosity-card {
        display: flex;
        align-items: center;
        gap: .75rem;
        padding: .75rem 1rem;
        border-radius: 10px;
        background: white;
        border: 1px solid #e8e8ff;
        box-shadow: 0 1px 3px rgba(80,70,228,.06);
    }
    .medal { font-size: 1.2rem; }
    .participant-name { flex: 1; font-weight: 500; font-size: .95rem; color: #1a1a2e; }
    .amount { font-weight: 700; color: #5046e4; font-size: 1rem; }
    .currency { font-size: .8rem; color: #888; margin-left: .2rem; }
    '
]

{ #category : 'web resources' }
TripGenerosityItemView class >> template [
    <webResource: #html>
    ^ '
    <div class="generosity-card">
        <span id="medal" class="medal"></span>
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
TripGenerosityItemView >> renderMedal: aString [
    (self shadowedElementWithId: #medal) textContent: aString
]

{ #category : 'rendering' }
TripGenerosityItemView >> renderParticipantName: aString [
    (self shadowedElementWithId: #name) textContent: aString
]
