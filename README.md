# react-native-xml
React native compatable XML/HTML parser with XPath support

# Usage

```javascript
let xml = require('react-native').NativeModules.RNMXml
xml.queryXml('<doc a="V1">V2</doc>',
            ['/doc/@a', '/doc'],
            results => results.map(nodes => console.log(nodes[0])))
// Output:
//	V1
//	V2
```

`queryXml(xmlString,queries) -> results`

`queryHtml(htmlString,queries) -> results`

- `xmlString`|`htmlString` - xml or html string
- `queries` - array of xpath strings which would be executed against xml string
- `results` - array of results such as `queries.length == results.length`. Each result is an array as well

```javascript
let xml = require('react-native').NativeModules.RNMXml
xml.queryHtml('<html><div>a</div><div>b</div></html>',
		 	 ['/html/body/div'],
		 	 results => console.log(results[0]))
//Output: ['a','b']
```

# Installation

Using [Cocoapods](http://cocoapods.org):

`pod 'react-native-xml', '~> 0.1.0' `
