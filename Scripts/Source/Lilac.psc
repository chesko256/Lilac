scriptname Lilac

string SystemName = "Lilac"

; Conditions
bool property to 					= true 	autoReadOnly
bool property notTo					= false	autoReadOnly

; Matchers
int property beEqualTo 				= 0		autoReadOnly
int property beLessThan 			= 1		autoReadOnly
int property beLessThanOrEqualTo 	= 2		autoReadOnly
int property beGreaterThan 			= 3		autoReadOnly
int property beGreaterThanOrEqualTo	= 4		autoReadOnly
int property beTruthy 				= 5		autoReadOnly
int property beFalsy 				= 6		autoReadOnly
int property contain 				= 7		autoReadOnly
int property beNone					= 8		autoReadOnly



function TestRunner()

endFunction

function describe(string asTestSuiteName, bool testCases) global

endFunction

bool function it(string asTestCaseName, bool testSteps) global
	string resultString
	if testSteps == true
		resultString = "SUCCESS"
	else
		resultString = "FAILED"
	endif

	debug.trace(SystemName + ": Executed # (skipped #) " + resultString + " (" + executionTime + " secs)")

	afterEach()
	beforeEach()
endFunction

bool function xit() global
	return false
endFunction

bool function afterEach() global

endFunction

bool function beforeEach() global

endFunction

bool function expectForm(Form akActual, bool abCondition, int aiMatcher, Form akExpected = None) global
	bool result
	if aiMatcher == beEqualTo
		result = akBaseObject == (akExpected as Form)
	elseif aiMatcher == beTruthy
		result = akActual != None
	elseif aiMatcher == beFalsy
		result = akActual == None
	else
		RaiseException_InvalidMatcher(aiMatcher)
		return false
	endif
	return result
endFunction

bool function expectRef(ObjectReference akActual, bool abCondition, int aiMatcher, ObjectReference akExpected = None) global
	bool result
	if aiMatcher == beEqualTo
		result = akBaseObject == (akExpected as ObjectReference)
	elseif aiMatcher == beTruthy
		result = akActual != None
	elseif aiMatcher == beFalsy
		result = akActual == None
	else
		RaiseException_InvalidMatcher(aiMatcher)
		return false
	endif
	RaiseResult(result)
	return result
endFunction

bool function expectInt(int aiActual, bool abCondition, int aiMatcher, int aiExpected = -1) global
	bool result
	if aiMatcher == beEqualTo
		result = aiActual == abExpected
	elseif aiMatcher == beLessThan
		result = aiActual < afExpected
	elseif aiMatcher == beGreaterThan
		result = aiActual > afExpected
	elseif aiMatcher == beLessThanOrEqualTo
		result = aiActual <= afExpected
	elseif aiMatcher == beGreaterThanOrEqualTo
		result = aiActual >= afExpected
	elseif aiMatcher == beTruthy
		result = aiActual == true
	elseif aiMatcher == beFalsy
		result = aiActual == false
	else
		RaiseException_InvalidMatcher(aiMatcher)
		return false
	endif
	RaiseResult(result)
	return result
endFunction

bool function expectFloat(float afActual, bool abCondition, int aiMatcher, float afExpected = -1.0) global
	bool result
	if aiMatcher == beEqualTo
		result = afActual == abExpected
	elseif aiMatcher == beLessThan
		result = afActual < afExpected
	elseif aiMatcher == beGreaterThan
		result = afActual > afExpected
	elseif aiMatcher == beLessThanOrEqualTo
		result = afActual <= afExpected
	elseif aiMatcher == beGreaterThanOrEqualTo
		result = afActual >= afExpected
	elseif aiMatcher == beTruthy
		result = afActual == true
	elseif aiMatcher == beFalsy
		result = afActual == false
	else
		RaiseException_InvalidMatcher(aiMatcher)
		return false
	endif
	RaiseResult(result)
	return result
endFunction

bool function expectBool(bool abActual, bool abCondition, int aiMatcher, bool abExpected = false) global
	bool result
	if aiMatcher == beEqualTo
		result = abActual == abExpected
	elseif aiMatcher == beTruthy
		result = akActual == true
	elseif aiMatcher == beFalsy
		result = akActual == false
	else
		RaiseException_InvalidMatcher(aiMatcher)
		return false
	endif
	RaiseResult(result)
	return result
endFunction

bool function expectString(string asActual, bool abCondition, int aiMatcher, string asExpected = "") global
	bool result
	if aiMatcher == beEqualTo
		result = akBaseObject == asExpected
	elseif aiMatcher == beTruthy
		result = akActual == true
	elseif aiMatcher == beFalsy
		result = akActual == false
	elseif aiMatcher == contain
		result = StringUtil.Find(asActual, asExpected) != -1
	else
		RaiseException_InvalidMatcher(aiMatcher)
		return false
	endif
	RaiseResult(result)
	return result
endFunction

function RaiseException_InvalidMatcher(int aiMatcher)
	string matcher
	if aiMatcher == 0
		matcher = "beEqualTo"
	elseif aiMatcher == 1
		matcher = "beLessThan"
	elseif aiMatcher == 2
		matcher = "beLessThanOrEqualTo"
	elseif aiMatcher == 3
		matcher = "beGreaterThan"
	elseif aiMatcher == 4
		matcher = "beGreaterThanOrEqualTo"
	elseif aiMatcher == 5
		matcher = "beTruthy"
	elseif aiMatcher == 6
		matcher = "beFalsy"
	elseif aiMatcher == 7
		matcher = "contain"
	elseif aiMatcher == 8
		matcher = "beNone"
	endif

	lilacDebug(ERROR, "Invalid matcher '" + matcher + "' used.")
endFunction

function lilacDebug()
	debug.trace()
endFunction

string function getLogLevel(int aiLogLevel)

endFunction