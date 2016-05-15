;/********s* Quest/Lilac
* SCRIPTNAME
*/;
scriptname Lilac extends Quest
{
* OVERVIEW
* Papyrus unit test syntax and test runner. Base script for creating and running Lilac unit tests. Must be extended. Generally executed by 
* <pre> StartQuest <MyUnitTestQuest></pre>
* from the console.}
;*********/;

string SystemName = "Lilac"
string SystemVersion = "1.0"

; Unit Test Runner ================================================================================

float last_current_time = -1.0
string current_test_suite = ""
string current_test_case = ""
bool test_case_had_failures = false

int testsRun = 0
int testsPassed = 0
int testsFailed = 0

string[] property failedTestSuites auto
string[] property failedTestCases auto
string[] property failedActuals auto
bool[] property failedConditions auto
int[] property failedMatchers auto
string[] property failedExpecteds auto

Event OnInit()
	if self.IsRunning()
		RegisterForSingleUpdate(1)
	endif	
EndEvent

Event OnUpdate()
	RunTests()
EndEvent

function RunTests()
	debug.trace(createLilacDebugMessage(INFO, "Starting " + SystemName + " " + SystemVersion + " on " + self))
	
	; Initial setup
	ResetTestRunner()
	SetStartTime()
	beforeAll()
	beforeEach()

	; Execute test cases
	TestSuites()

	; Report results
	ShowTestFailureLog()
	ShowTestSummary()

	; Tear down
	afterEach()
	afterAll()
	self.Stop()
endFunction

; Extend
function TestSuites()
endFunction

function SetStartTime()
	last_current_time = Game.GetRealHoursPassed()
endFunction

function ResetTestRunner()
	failedTestSuites = new string[128]
	failedTestCases = new string[128]
	failedActuals = new string[128]
	failedConditions = new bool[128]
	failedMatchers = new int[128]
	failedExpecteds = new string[128]

	testsRun = 0
	testsPassed = 0
	testsFailed = 0
	last_current_time = -1.0
	current_test_suite = ""
	current_test_case = ""
endFunction

function ShowTestFailureLog()

	;/
	debug.trace("failedTestSuites: " + failedTestSuites)
	debug.trace("failedTestCases: " + failedTestCases)
	debug.trace("failedConditions: " + failedConditions)
	debug.trace("failedMatchers: " + failedMatchers)
	debug.trace("failedActuals: " + failedActuals)
	debug.trace("failedExpecteds: " + failedExpecteds)
	/;

	int working_index = 0
	bool failed_tests_msg_shown = false
	
	string current_working_test_suite = ""
	bool processing_suites = true
	while processing_suites
		if failedTestSuites[working_index] != ""
			current_working_test_suite = failedTestSuites[working_index]
			if !failed_tests_msg_shown
				debug.trace(createLilacDebugMessage(INFO, "Failed Tests (first 128 failed test steps shown):"))
				failed_tests_msg_shown = true
			endif
			debug.trace(createLilacDebugMessage(INFO, " - " + failedTestSuites[working_index] + ":"))

			string current_working_test_case = ""
			bool processing_cases = true
			while processing_cases
				bool processing_steps = true
				if failedTestCases[working_index] != ""  && failedTestSuites[working_index] == current_working_test_suite
					current_working_test_case = failedTestCases[working_index]
					debug.trace(createLilacDebugMessage(INFO, "    - " + failedTestCases[working_index] + ":"))

					while processing_steps
						if failedActuals[working_index] != "" && failedTestCases[working_index] == current_working_test_case
							debug.trace(createLilacDebugMessage(INFO, CreateStepFailureMessage(working_index)))
							working_index += 1
						else
							processing_steps = false
						endif
					endWhile
				else
					processing_cases = false
				endif
			endWhile
		else
			processing_suites = false
		endif
	endWhile
endFunction

function ShowTestSummary()
	debug.trace(createLilacDebugMessage(INFO, "  " + testsRun + " total  " + testsPassed + " passed  " + testsFailed + " failed"))
endFunction

string function CreateStepFailureMessage(int index)
	string header = "        - expected"

	bool cdtn_val = failedConditions[index]
	int matcher_val = failedMatchers[index]
	string actual_val = failedActuals[index]
	string expected_val = failedExpecteds[index]

	string cdtn
	if failedConditions[index] == true
		cdtn = "to"
	else
		cdtn = "not to"
	endif
	
	string matcher
	if matcher_val == beEqualTo
		matcher = "be equal to"
	elseif matcher_val == beLessThan
		matcher = "be less than"
	elseif matcher_val == beLessThanOrEqualTo
		matcher = "be less than or equal to"
	elseif matcher_val == beGreaterThan
		matcher = "be greater than"
	elseif matcher_val == beGreaterThanOrEqualTo
		matcher = "be greater than or equal to"
	elseif matcher_val == beTruthy
		matcher = "be truthy"
	elseif matcher_val == beFalsy
		matcher = "be falsy"
	elseif matcher_val == contain
		matcher = "contain"
	elseif matcher_val == beNone
		matcher = "be None"
	endif

	string msg

	if matcher_val == beTruthy || matcher_val == beFalsy || matcher_val == beNone
		msg = header + " " + actual_val + " " + cdtn + " " + matcher
	else
		msg = header + " " + actual_val + " " + cdtn + " " + matcher + " " + expected_val
	endif

	return msg
endFunction


; Unit Test Composition ===========================================================================

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

; Log level enum
int property INFO 					= 0 	autoReadOnly
int property WARN 					= 1 	autoReadOnly
int property ERROR 					= 2 	autoReadOnly

;/********f* Lilac/describe
* API VERSION ADDED
* 1
*
* DESCRIPTION
* Defines and executes a test suite.
*
* SYNTAX
*/;
function describe(string asTestSuiteName, bool abTestCases)
;/*
* PARAMETERS
* * asTestSuiteName: The name of the test suite.
* * abTestCases: A function that implements this suite's test cases.
*
* EXAMPLES
describe("A test suite", myTestSuite())
;*********/;
	current_test_suite = asTestSuiteName
	LogFailedTestSuites()
endFunction

;/********f* Lilac/it
* API VERSION ADDED
* 1
*
* DESCRIPTION
* Defines and executes a test case (spec).
*
* SYNTAX
*/;
function it(string asTestCaseName, bool abTestSteps)
;/*
* PARAMETERS
* * asTestCaseName: The name of the test case.
* * abTestSteps: A function that implements this suite's test steps.
*
* EXAMPLES
it("should do something", myTestCase())
;*********/;
	current_test_case = asTestCaseName
	LogFailedTestCases()

	string resultString
	float this_current_time = Game.GetRealHoursPassed()
	float deltaTimeSecs = (this_current_time - last_current_time) * 3600.0
	
	testsRun += 1
	if test_case_had_failures == false
		resultString = " SUCCESS"
		testsPassed	+= 1
	else
		resultString = " FAILED"
		testsFailed	+= 1
	endif

	if testsFailed > 0
		debug.trace(createLilacDebugMessage(INFO, "Executed " + testsRun + " (" + testsFailed + " FAILED)" + resultString + " (" + deltaTimeSecs + " secs)"))
	else
		debug.trace(createLilacDebugMessage(INFO, "Executed " + testsRun + resultString + " (" + deltaTimeSecs + " secs)"))
	endif
	last_current_time = this_current_time
	test_case_had_failures = false

	; Tear down this test and set up the next one.
	afterEach()
	beforeEach()
endFunction

;/********f* Lilac/beforeAll
* API VERSION ADDED
* 1
*
* DESCRIPTION
* Override this function to run a block of code before any test case runs (including before any beforeEach).
*
* SYNTAX
*/;
function beforeAll()
;/*
* PARAMETERS
* None
* 
* EXAMPLES
;Make sure the quest isn't running and is on stage 12 before every test.
function beforeAll()
	TheQuest.Stop()
	TheQuest.SetStage(12)
endFunction
;*********/;
endFunction

;/********f* Lilac/beforeAll
* API VERSION ADDED
* 1
*
* DESCRIPTION
* Override this function to run a block of code after all test cases run (including after any afterEach).
*
* SYNTAX
*/;
function afterAll()
;/*
* PARAMETERS
* None
* 
* EXAMPLES
;Make sure the quest isn't running and is on stage 12 after every test.
function afterAll()
	TheQuest.Stop()
	TheQuest.SetStage(12)
endFunction
;*********/;
endFunction

;/********f* Lilac/beforeEach
* API VERSION ADDED
* 1
*
* DESCRIPTION
* Override this function to run a block of code before each test case.
*
* SYNTAX
*/;
function beforeEach()
;/*
* PARAMETERS
* None
* 
* EXAMPLES
;Make sure the storm trooper is reset before every test.
function beforeEach()
	stormtrooper.Reset()
endFunction
;*********/;
endFunction

;/********f* Lilac/afterEach
* API VERSION ADDED
* 1
*
* DESCRIPTION
* Override this function to run a block of code after each test case.
*
* SYNTAX
*/;
function afterEach()
;/*
* PARAMETERS
* None
* 
* EXAMPLES
;Make sure the star destroyer is deleted after every test.
function afterEach()
	destroyer.Disable()
	destroyer.Delete()
endFunction
;*********/;
endFunction

function LogFailedTestSuites()
	int end_index = ArrayCountString(failedActuals) - 1
	if end_index == -1
		return
	endif
	int start_index = ArrayCountString(failedTestSuites)

	int i = start_index
	while i <= end_index
		failedTestSuites[i] = current_test_suite
		i += 1
	endWhile
endFunction

function LogFailedTestCases()
	int end_index = ArrayCountString(failedActuals) - 1
	if end_index == -1
		return
	endif
	int start_index = ArrayCountString(failedTestCases)

	int i = start_index
	while i <= end_index
		failedTestCases[i] = current_test_case
		i += 1
	endWhile
endFunction

;/********f* Lilac/expectForm
* API VERSION ADDED
* 1
*
* DESCRIPTION
* Defines a new expectation, comparing actual and expected Forms.
*
* SYNTAX
*/;
function expectForm(Form akActual, bool abCondition, int aiMatcher, Form akExpected = None)
;/*
* PARAMETERS
* * akActual: The form under test.
* * abCondition: The condition (to or notTo).
* * aiMatcher: The matcher. See Notes for a list of valid matchers for this expectation.
* * akExpected: The expected value.
* 
* EXAMPLES
expectForm(MyArmor, to, beEqualTo, PowerArmor)
* NOTES
* Valid matchers for this expectation:
* * beEqualTo
* * beTruthy
* * beFalsy
* * beNone
;*********/;
	bool result
	if abCondition == to
		if aiMatcher == beEqualTo
			result = akActual == (akExpected as Form)
		elseif aiMatcher == beTruthy
			result = (akActual as bool) == true
		elseif aiMatcher == beFalsy
			result = (akActual as bool) == false
		elseif aiMatcher == beNone
			result = akActual == None
		else
			RaiseException_InvalidMatcher(aiMatcher)
			result = false
		endif
	else ; notTo
		if aiMatcher == beEqualTo
			result = akActual != (akExpected as Form)
		elseif aiMatcher == beTruthy
			result = (akActual as bool) == false
		elseif aiMatcher == beFalsy
			result = (akActual as bool) == true
		elseif aiMatcher == beNone
			result = akActual != None
		else
			RaiseException_InvalidMatcher(aiMatcher)
			result = false
		endif
	endif
	RaiseResult(result, akActual as string, abCondition, aiMatcher, akExpected as string)
endFunction

;/********f* Lilac/expectRef
* API VERSION ADDED
* 1
*
* DESCRIPTION
* Defines a new expectation, comparing actual and expected ObjectReferences.
*
* SYNTAX
*/;
function expectRef(ObjectReference akActual, bool abCondition, int aiMatcher, ObjectReference akExpected = None)
;/*
* PARAMETERS
* * akActual: The reference under test.
* * abCondition: The condition (to or notTo).
* * aiMatcher: The matcher. See Notes for a list of valid matchers for this expectation.
* * akExpected: The expected value.
* 
* EXAMPLES
expectRef(FalmerRef, to, beEqualTo, BossFalmerRef)
* NOTES
* Valid matchers for this expectation:
* * beEqualTo
* * beTruthy
* * beFalsy
* * beNone
;*********/;
	bool result
	if abCondition == to
		if aiMatcher == beEqualTo
			result = akActual == (akExpected as ObjectReference)
		elseif aiMatcher == beTruthy
			result = (akActual as bool) == true
		elseif aiMatcher == beFalsy
			result = (akActual as bool) == false
		elseif aiMatcher == beNone
			result = akActual == None
		else
			RaiseException_InvalidMatcher(aiMatcher)
			result = false
		endif
	else ; notTo
		if aiMatcher == beEqualTo
			result = akActual != (akExpected as ObjectReference)
		elseif aiMatcher == beTruthy
			result = (akActual as bool) == false
		elseif aiMatcher == beFalsy
			result = (akActual as bool) == true
		elseif aiMatcher == beNone
			result = akActual != None
		else
			RaiseException_InvalidMatcher(aiMatcher)
			result = false
		endif
	endif
	RaiseResult(result, akActual as string, abCondition, aiMatcher, akExpected as string)
endFunction

;/********f* Lilac/expectInt
* API VERSION ADDED
* 1
*
* DESCRIPTION
* Defines a new expectation, comparing actual and expected integers.
*
* SYNTAX
*/;
function expectInt(int aiActual, bool abCondition, int aiMatcher, int aiExpected = -1)
;/*
* PARAMETERS
* * akActual: The integer under test.
* * abCondition: The condition (to or notTo).
* * aiMatcher: The matcher. See Notes for a list of valid matchers for this expectation.
* * akExpected: The expected value.
* 
* EXAMPLES
expectInt(counter, to, beLessThan, 40)
* NOTES
* Valid matchers for this expectation:
* * beEqualTo
* * beLessThan
* * beGreaterThan
* * beLessThanOrEqualTo
* * beGreaterThanOrEqualTo
* * beTruthy
* * beFalsy
;*********/;
	bool result
	if abCondition == to
		if aiMatcher == beEqualTo
			result = aiActual == aiExpected
		elseif aiMatcher == beLessThan
			result = aiActual < aiExpected
		elseif aiMatcher == beGreaterThan
			result = aiActual > aiExpected
		elseif aiMatcher == beLessThanOrEqualTo
			result = aiActual <= aiExpected
		elseif aiMatcher == beGreaterThanOrEqualTo
			result = aiActual >= aiExpected
		elseif aiMatcher == beTruthy
			result = (aiActual as bool) == true
		elseif aiMatcher == beFalsy
			result = (aiActual as bool) == false
		else
			RaiseException_InvalidMatcher(aiMatcher)
			result = false
		endif
	else ; notTo
		if aiMatcher == beEqualTo
			result = aiActual != aiExpected
		elseif aiMatcher == beLessThan
			result = aiActual >= aiExpected
		elseif aiMatcher == beGreaterThan
			result = aiActual <= aiExpected
		elseif aiMatcher == beLessThanOrEqualTo
			result = aiActual > aiExpected
		elseif aiMatcher == beGreaterThanOrEqualTo
			result = aiActual < aiExpected
		elseif aiMatcher == beTruthy
			result = (aiActual as bool) != true
		elseif aiMatcher == beFalsy
			result = (aiActual as bool) != false
		else
			RaiseException_InvalidMatcher(aiMatcher)
			result = false
		endif
	endif
	RaiseResult(result, aiActual as string, abCondition, aiMatcher, aiExpected as string)
endFunction

;/********f* Lilac/expectFloat
* API VERSION ADDED
* 1
*
* DESCRIPTION
* Defines a new expectation, comparing actual and expected floats.
*
* SYNTAX
*/;
function expectFloat(float afActual, bool abCondition, int aiMatcher, float afExpected = -1.0)
;/*
* PARAMETERS
* * akActual: The float under test.
* * abCondition: The condition (to or notTo).
* * aiMatcher: The matcher. See Notes for a list of valid matchers for this expectation.
* * akExpected: The expected value.
* 
* EXAMPLES
expectFloat(GameHour.GetValue(), to, beGreaterThan, 19.0)
* NOTES
* Valid matchers for this expectation:
* * beEqualTo
* * beLessThan
* * beGreaterThan
* * beLessThanOrEqualTo
* * beGreaterThanOrEqualTo
* * beTruthy
* * beFalsy
;*********/;
	bool result
	if abCondition == to
		if aiMatcher == beEqualTo
			result = afActual == afExpected
		elseif aiMatcher == beLessThan
			result = afActual < afExpected
		elseif aiMatcher == beGreaterThan
			result = afActual > afExpected
		elseif aiMatcher == beLessThanOrEqualTo
			result = afActual <= afExpected
		elseif aiMatcher == beGreaterThanOrEqualTo
			result = afActual >= afExpected
		elseif aiMatcher == beTruthy
			result = (afActual as bool) == true
		elseif aiMatcher == beFalsy
			result = (afActual as bool) == false
		else
			RaiseException_InvalidMatcher(aiMatcher)
			result = false
		endif
	else ; notTo
		if aiMatcher == beEqualTo
			result = afActual != afExpected
		elseif aiMatcher == beLessThan
			result = afActual >= afExpected
		elseif aiMatcher == beGreaterThan
			result = afActual <= afExpected
		elseif aiMatcher == beLessThanOrEqualTo
			result = afActual > afExpected
		elseif aiMatcher == beGreaterThanOrEqualTo
			result = afActual < afExpected
		elseif aiMatcher == beTruthy
			result = (afActual as bool) != true
		elseif aiMatcher == beFalsy
			result = (afActual as bool) != false
		else
			RaiseException_InvalidMatcher(aiMatcher)
			result = false
		endif
	endif
	RaiseResult(result, afActual as string, abCondition, aiMatcher, afExpected as string)
endFunction

;/********f* Lilac/expectBool
* API VERSION ADDED
* 1
*
* DESCRIPTION
* Defines a new expectation, comparing actual and expected booleans.
*
* SYNTAX
*/;
function expectBool(bool abActual, bool abCondition, int aiMatcher, bool abExpected = false)
;/*
* PARAMETERS
* * akActual: The boolean under test.
* * abCondition: The condition (to or notTo).
* * aiMatcher: The matcher. See Notes for a list of valid matchers for this expectation.
* * akExpected: The expected value.
* 
* EXAMPLES
expectBool(Follower.IsEssential(), to, beTruthy)
* NOTES
* Valid matchers for this expectation:
* * beEqualTo
* * beTruthy
* * beFalsy
;*********/;
	bool result
	if abCondition == to
		if aiMatcher == beEqualTo
			result = abActual == abExpected
		elseif aiMatcher == beTruthy
			result = abActual == true
		elseif aiMatcher == beFalsy
			result = abActual == false
		else
			RaiseException_InvalidMatcher(aiMatcher)
			result = false
		endif
	else ; notTo
		if aiMatcher == beEqualTo
			result = abActual != abExpected
		elseif aiMatcher == beTruthy
			result = abActual != true
		elseif aiMatcher == beFalsy
			result = abActual != false
		else
			RaiseException_InvalidMatcher(aiMatcher)
			result = false
		endif
	endif
	RaiseResult(result, abActual as string, abCondition, aiMatcher, abExpected as string)
endFunction

;/********f* Lilac/expectString
* API VERSION ADDED
* 1
*
* DESCRIPTION
* Defines a new expectation, comparing actual and expected booleans.
*
* SYNTAX
*/;
function expectString(string asActual, bool abCondition, int aiMatcher, string asExpected = "")
;/*
* PARAMETERS
* * akActual: The boolean under test.
* * abCondition: The condition (to or notTo).
* * aiMatcher: The matcher. See Notes for a list of valid matchers for this expectation.
* * akExpected: The expected value.
* 
* EXAMPLES
expectString("its a small world after all", to, contain, "world")
* NOTES
* Valid matchers for this expectation:
* * beEqualTo
* * beTruthy
* * beFalsy
* * contain
;*********/;
	bool result
	if abCondition == to
		if aiMatcher == beEqualTo
			result = asActual == asExpected
		elseif aiMatcher == beTruthy
			result = (asActual as bool) == true
		elseif aiMatcher == beFalsy
			result = (asActual as bool) == false
		elseif aiMatcher == contain
			result = StringUtil.Find(asActual, asExpected) != -1
		else
			RaiseException_InvalidMatcher(aiMatcher)
			result = false
		endif
	else ; notTo
		if aiMatcher == beEqualTo
			result = asActual != asExpected
		elseif aiMatcher == beTruthy
			result = (asActual as bool) != true
		elseif aiMatcher == beFalsy
			result = (asActual as bool) != false
		elseif aiMatcher == contain
			result = StringUtil.Find(asActual, asExpected) == -1
		else
			RaiseException_InvalidMatcher(aiMatcher)
			result = false
		endif
	endif
	RaiseResult(result, asActual, abCondition, aiMatcher, asExpected)
endFunction

function RaiseResult(bool abResult, string asActual, bool abCondition, int aiMatcher, string asExpected)
	if abResult == false
		test_case_had_failures = true
		int idx = ArrayAddString(failedActuals, asActual as string)
		if idx != -1
			failedConditions[idx] = abCondition
			failedMatchers[idx] = aiMatcher
			failedExpecteds[idx] = asExpected
		endif
	endif
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

	debug.trace(createLilacDebugMessage(ERROR, "Invalid matcher '" + matcher + "' used."))
endFunction

string function createLilacDebugMessage(int aiLogLevel, string asMessage)
	string level
	return "[" + SystemName + "] " + getLogLevel(aiLogLevel) + asMessage
endFunction

string function getLogLevel(int aiLogLevel)
	if aiLogLevel == 0
		return ""
	elseif aiLogLevel == 1
		return "WARN - "
	elseif aiLogLevel == 2
		return "ERROR - "
	endif
endFunction

int function ArrayAddString(string[] myArray, string myKey)
    ;Adds a form to the first available element in the array.
    ;       false       =       Error (array full)
    ;       true        =       Success

    int i = 0
    while i < myArray.Length
        if IsNone(myArray[i])
            myArray[i] = myKey
            return i
        else
            i += 1
        endif
    endWhile
    return -1
endFunction

int function ArrayCountString(String[] myArray)
;Counts the number of indices in this array that do not have a "none" type.
    ;       int myCount = number of indicies that are not "none"
 
    int i = 0
    int myCount = 0
    while i < myArray.Length
        if !(IsNone(myArray[i]))
            myCount += 1
            i += 1
        else
            i += 1
        endif
    endWhile
    return myCount
endFunction

bool function IsNone(string akString)
    if akString
        if akString == ""
            return true
        else
            return false
        endif
    else
        return true
    endif
endFunction
