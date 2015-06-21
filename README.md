# react-native-xml
React native compatable XML parser with XPath support

# Usage

```javascript
let xml = require('NativeModules').RNMXml
xml.find('<doc a="V1">V2</doc>', 
         ['/doc/@a', '/doc'], 
          results => results.map(nodes => console.log(nodes[0]))) 
// Output: 
//	V1 
//	V2 
```

`find(xmlString,queries) -> results`

- `xmlString` - xml string
- `queries` - array of xpath strings which would be executed against xml string
- `results` - array of results such as `queries.length == results.length`. Each result is an array as well

```javascript
let xml = require('NativeModules').RNMXml
xml.find('<doc><n>V1</n><n>V2</n></doc>',
		 ['//n'],
		 results => console.log(results[0]))
//Output: ['V1','V2']
``` 		 

# Installation

Using [Cocoapods](http://cocoapods.org): 

`pod 'react-native-xml', '~> 0.0.2' `