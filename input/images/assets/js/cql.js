 
Prism.languages.cql = {
	// 'function': TODO
	'comment': {
		pattern: /(^|[^\\])(?:\/\*[\s\S]*?\*\/|(?:\/\/|#).*)/,
		lookbehind: true
	},
	'string': {
		pattern: /(')(?:\\[\s\S]|(?!\1)[^\\]|\1\1)*\1/,
		greedy: true
	},
	'variable':
	{
		pattern: /(["`])(?:\\[\s\S]|(?!\1)[^\\])+\1/,
		greedy: true
	},
	'keyword': /\b(?:after|aggregate|all|and|as|asc|ascending|before|between|bind|by|called|case|cast|code|Code|codesystem|codesystems|collapse|concept|Concept|~contains|contains|context|conversion|convert|date|day|days|default|define|desc|descending|difference|display|distinct|div|duration|during|else|end|ends|except|exists|expand|explicit|extends|false|flatten|fluent|from|function|hour|hours|identifier|if|implicit|implies|~in|in|include|includes|included in|intersect|Interval|is|key|label|less|let|library|List|maximum|meets|millisecond|milliseconds|minimum|minute|minutes|mod|month|months|more|not|null|occurs|of|on|or|overlaps|path|parameter|per|point|predecessor|primary|private|properly|public|related|retrievable|return|same|singleton|second|seconds|start|starting|starts|sort|successor|such that|then|time|timezoneoffset|to|true|Tuple|type|union|using|valueset|version|week|weeks|where|when|width|with|within|without|xor|year|years)\b/i,
	'boolean': /\b(?:null|false|null)\b/i,
	'number': /\b0x[\da-f]+\b|\b\d+(?:\.\d*)?|\B\.\d+\b/i,
	'punctuation': /[;[\]()`,.]/,
	'operator': /[-+*\/=%^~]|&&?|\|\|?|!=?|<(?:=>?|<|>)?|>[>=]?\b/i
};