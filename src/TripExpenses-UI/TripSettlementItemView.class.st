Class {
	#name : 'TripSettlementItemView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-Settlement',
	#package : 'TripExpenses-UI',
	#tag : 'Settlement'
}

{ #category : 'web resources' }
TripSettlementItemView class >> style [
    <webResource: #css>
    ^ '
    :host { display: block; margin-bottom: .5rem; }
    .settlement-card {
        display: flex;
        align-items: center;
        gap: .75rem;
        padding: .75rem 1rem;
        border-radius: 10px;
        background: #fffbf0;
        border: 1px solid #f5e6c0;
        box-shadow: 0 1px 3px rgba(0,0,0,.04);
    }
    .from { font-weight: 600; color: #1a1a2e; }
    .arrow { color: #f0a500; font-size: 1.1rem; }
    .to { font-weight: 600; color: #1a1a2e; }
    .amount { margin-left: auto; font-weight: 700; color: #f0a500; white-space: nowrap; }
    '
]

{ #category : 'web resources' }
TripSettlementItemView class >> template [
    <webResource: #html>
    ^ '
    <div class="settlement-card">
        <span class="from" id="from"></span>
        <span class="arrow">→</span>
        <span class="to" id="to"></span>
        <span class="amount" id="amount"></span>
    </div>
    '
]

{ #category : 'rendering' }
TripSettlementItemView >> renderFrom: aFromName to: aToName amount: anAmount currency: aCurrency [

   (self shadowedElementWithId: #from) textContent: aFromName.
    (self shadowedElementWithId: #to) textContent: aToName.
    (self shadowedElementWithId: #amount) textContent: anAmount , ' ' , aCurrency
]
