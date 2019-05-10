set iskeyword+='
syn match _hs_module_name "\v\a\k*(\.\k)@="
syn keyword _hs_prelude_builtins abs all and any appendFile asTypeOf asin atan acos asinh atanh acosh atan2 break ceiling compare concat concatMap const curry cycle decodeFloat div divMod drop dropWhile either elem encodeFloat enumFrom enumFromThen enumFromThenTo enumFromTo error even exp sqrt log exponent fail filter flip floatDigits floatRadix floatRange floor fmap foldl foldl1 foldr foldr1 fromEnum fromInteger fromIntegral fromRational fst gcd getChar getContents getLine head id init interact ioError isDenormalized isIEEE isInfinite isNaN isNegativeZero iterate last lcm length lex lines lookup map mapM mapM_ max maximum maybe min minBound maxBound minimum mod negate not notElem null odd or otherwise pi pred print product properFraction putChar putStr putStrLn quot quotRem read readFile readIO readList readLn readParen reads readsPrec realToFrac recip rem repeat replicate return reverse round scaleFloat scanl scanl1 scanr scanr1 seq sequence sequence_ show showChar showList showParen showString shows showsPrec significand signum sin tan cos sinh tanh cosh snd span splitAt subtract succ sum tail take takeWhile toEnum toInteger toRational truncate uncurry undefined unlines until unwords unzip unzip3 userError words writeFile zip zip3 zipWith zipWith3

inorem ' <c-r>=SmartSingleQuote()<cr>
func! SmartSingleQuote()
	let isInIdentifier = getline(".")[getcurpos()[2] - 2] =~ '\k'
	return isInIdentifier ? "'" : "''\<left>"
endfunc

set ts=2 sw=2 et softtabstop
hi hsVarSym ctermfg=2
hi hsString ctermfg=6
hi hsStatement ctermfg=9
hi _hs_prelude_builtins ctermfg=4
hi _hs_module_name ctermfg=14
hi VarId ctermfg=12

so ~/.vimrc_after
