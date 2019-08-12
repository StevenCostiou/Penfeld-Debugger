Class {
	#name : #OpenPenDebuggerDebugAction,
	#superclass : #DebugAction,
	#category : #'Penfeld-Debugger'
}

{ #category : #registration }
OpenPenDebuggerDebugAction class >> actionType [
	<debuggingAction>
	<contextMenuDebuggingAction>
]

{ #category : #accessing }
OpenPenDebuggerDebugAction >> defaultKeymap [

	^ PharoShortcuts current stepIntoShortcut
]

{ #category : #accessing }
OpenPenDebuggerDebugAction >> defaultLabel [

	^ 'PenDebug'
]

{ #category : #accessing }
OpenPenDebuggerDebugAction >> defaultOrder [

	^ 15
]

{ #category : #actions }
OpenPenDebuggerDebugAction >> executeAction [
	(PenDebugger on: self session) open
]

{ #category : #accessing }
OpenPenDebuggerDebugAction >> help [
	^ 'Step in the highlighted message, i.e. follow the sent message, taking debugger control in the method invoked.'
]

{ #category : #accessing }
OpenPenDebuggerDebugAction >> id [

	^ #stepInto
]
