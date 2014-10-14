# JSDocUtility
A Vim plugin that generates **JSDoc** documentation comments for Javascript code: support class constructors, other
functions, and file headers.

### use
Usage is simple: move your cursor onto a line containing one of the three supported constructs, and press `<leader>d`.
For instance (`<|>` represents the cursor):

```javascript
function <|>max(a, b){
	return (a > b) ? a : b;
}
```

Tap `<leader>d`, and:

```javascript
/**
 * @brief 
 * @param a 
 * @param b 
 * @return 
 */
function max(a, b){
	return (a > b) ? a : b;
}
```
