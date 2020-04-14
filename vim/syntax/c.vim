" setl foldmarker=/**,*/
setl foldmethod=marker
syn keyword cOperator  ssizeof fieldsizeof countof assert offsetof fieldtypeof bitsizeof
syn keyword cStatement p_delete p_new p_new_raw p_clear p_realloc
syn keyword cStatement mp_delete mp_new mp_new_raw
syn keyword cStatement p_dup p_dupstr p_dupz
syn keyword cStatement t_push t_pop t_pop_and_return t_new t_new_extra t_fmt t_scope

syn keyword isGlobal   _G
syn match   isGlobal "\<[a-zA-Z_][a-zA-Z0-9_]*_g\>"

syn keyword cType byte
syn match cFunction "\<\([a-z][a-zA-Z0-9_]*\|[a-zA-Z_][a-zA-Z0-9_]*[a-z][a-zA-Z0-9_]*\)\> *("me=e-1
syn match Function "\$\<\([a-z][a-zA-Z0-9_]*\|[a-zA-Z_][a-zA-Z0-9_]*[a-z][a-zA-Z0-9_]*\)\> *[({]"me=e-1
syn match cType "\<[a-zA-Z_][a-zA-Z0-9_]*_[ft]\>"

syn keyword arduinoConstant  BIN CHANGE DEC DEFAULT EXTERNAL FALLING HALF_PI HEX
syn keyword arduinoConstant  HIGH INPUT INTERNAL INTERNAL1V1 INTERNAL2V56 LOW
syn keyword arduinoConstant  LSBFIRST MSBFIRST OCT OUTPUT PI RISING TWO_PI

syn keyword arduinoFunc      analogRead analogReference analogWrite
syn keyword arduinoFunc      attachInterrupt bit bitClear bitRead bitSet
syn keyword arduinoFunc      bitWrite delay delayMicroseconds detachInterrupt
syn keyword arduinoFunc      digitalRead digitalWrite highByte interrupts
syn keyword arduinoFunc      lowByte micros millis noInterrupts noTone pinMode
syn keyword arduinoFunc      pulseIn shiftIn shiftOut tone

syn keyword arduinoMethod    available begin end find findUntil flush loop
syn keyword arduinoMethod    parseFloat parseInt peek print println read
syn keyword arduinoMethod    readBytes readBytesUntil setTimeout setup

syn keyword arduinoModule    Serial Serial1 Serial2 Serial3

syn keyword arduinoStdFunc   abs acos asin atan atan2 ceil constrain cos degrees
syn keyword arduinoStdFunc   exp floor log map max min radians random randomSeed
syn keyword arduinoStdFunc   round sin sq sqrt tan

syn keyword arduinoType      boolean byte null String word

hi def link arduinoType Type
hi def link arduinoConstant Constant
hi def link arduinoStdFunc Function
hi def link arduinoFunc Function
hi def link arduinoMethod Function
hi def link arduinoModule Identifier
hi def link isGlobal Function
hi def link cStorageClass Statement
hi def link enumName Type
