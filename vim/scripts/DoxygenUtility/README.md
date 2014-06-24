# DoxygenUtility

**DoxygenUtility** provides generator functions and highlighting for Doxygen documentation in `C`/`C++` source code.

### Use
Basic use boils down to the following normal-mode keymap: `<leader>d`. If the line under the cursor contains a
Doxygen-documentable construct, insert a template comment accordingly; otherwise, `echom` an error. For instance (where
`<|>` is the user's cursor):


	int <|>*foo(int bar, char *baz){
		/* code */;
	}

Tap `<leader>d`, and:

	/*
	 * @brief 
	 *
	 * @param bar 
	 * @param baz 
	 *
	 * @return 
	*/
	int <|>*foo(int bar, char *baz){
		/* code */;
	}
