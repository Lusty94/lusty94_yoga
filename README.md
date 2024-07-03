Lusty94_Yoga

# Features
- Useable yoga mat item that players can use to perform yoga
- Toggle effects such as adding health, adding armour and removing stress and their values via the config file
- Edit how long it takes to perform yoga via the config file
- Lots of other toggleable / customisable options via the config file


# Installation

- Make sure to download all dependencies and ensure they start BEFORE this script

- If adding the yoga mat to your own store then make sure to set shop = enabled to false in config

- Add items below to your core/shared/items.lua

- Add all images inside [images] folder to your inventory/html/images folder




# Items
```

['yogamat'] 			                    = {['name'] = 'yogamat', 			 	  	  	    ['label'] = 'Yoga Mat', 		        ['weight'] = 200, 		['type'] = 'item', 					['image'] = 'yogamat.png', 				    ['unique'] = true, 	    ['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'Yoga Mat - These Apparently Have Health Benefits?'},

```