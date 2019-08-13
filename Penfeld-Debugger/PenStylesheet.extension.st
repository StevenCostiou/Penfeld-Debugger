Extension { #name : #PenStylesheet }

{ #category : #'*Penfeld-Debugger' }
PenStylesheet class >> debuggerLight [
	^ PssParser parse: (self debuggerStylesheet: {
		#textColor -> '#1E1E1E'.
		#backgroundColor -> '#FFFFFF'.
		#borderColor -> '#505050'.
		#activeColor -> '#52AF7E'.
		#checkedColor -> '#52AF7E'.
		#disabledColor -> '#787878'.
		#buttonBackgroundColor -> '#D2D2D2'.
	} asDictionary).
]

{ #category : #'*Penfeld-Debugger' }
PenStylesheet class >> debuggerStylesheet: colors [
	^ '
* { 
	font-size: 14;
	color: ', (colors at: #textColor), ';
 }

.root { 
	background-color: ', (colors at: #backgroundColor), ';
}

label.title { 
	font-size: 16;
	font-style: italic;
	margin: 15px 10px 5px;
}

*:active { 
	background-color: ', (colors at: #activeColor), ';
 }

*:checked { 
	background-color: ', (colors at: #checkedColor), ';
 }

*:unchecked { 
	background-color: ', (colors at: #backgroundColor), ';
 }

*:disabled { 
	background-color: ', (colors at: #disabledColor), ';
 }

button, toggle { 
	width: 24px;
	height: 24px;
	text-align: center;
	margin: 10px;
	background-color: white;
 }

radioButton, checkButton { 
	margin: 0 10px;
 }

th { 
	background-color: ', (colors at: #buttonBackgroundColor), ';
 }

comboBox { 
	margin: 5px;
}

comboBox.cbbutton { 
	width: 30;
	height: 30;
	background-color: ', (colors at: #buttonBackgroundColor), ';
 }

list, tree, table { 
	width: 780px;
	margin: 10px 0px 0px 10px;
	border: 1px solid gray; 
	backgroundColor: #FFFFFF;
}

codeEditor {	
	width: 780px;
	margin: 0px 10px;
	backgroundColor: #FFFFFF; }

tr { 
	margin: 5 2 0 2; }

'
]
