Interactable component adds eazy way to interac with ocjects. Simply add component to entity and set all export values. Resultat is apearing text when player is in range of interaction and emision of signal when interaction happend.  
  
To add some action to the interaction simply use emited signal.

Example :  
```

# Some entinty.gd with Interactable component.
func _on_interactable_component_interacted():
	print("interaction.")
```

#Setup

"interaction_input" : for seting insteraction method for example pressing button 'X'  
"input_text" : interaction input for example "X"  
"interaction_descryption" : interaction descryption

```
@export var interaction_input:InputEvent = null
@export var input_text:String = ""
@export var interaction_descryption:String = ""
```
