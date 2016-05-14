scriptname mockLilac extends Lilac
{Test-specific subclass of Lilac.}

Event OnInit()
	; pass
endEvent

string property mockLastLilacDebugMessage = "" auto
string function createLilacDebugMessage(int aiLogLevel, string asMessage)
	mockLastLilacDebugMessage = parent.createLilacDebugMessage(aiLogLevel, asMessage)
	return "mockLilac createLilacDebugMessage: " + mockLastLilacDebugMessage
endFunction

bool property mockLastRaisedResultResult = true auto
function RaiseResult(bool abResult, string asActual, bool abCondition, int aiMatcher, string asExpected)
	mockLastRaisedResultResult = abResult
endFunction

int property mockItCallCount = 0 auto
function it(string asTestCaseName, bool abTestSteps)
	mockItCallCount += 1
	parent.it(asTestCaseName, abTestSteps)
endFunction

int property mockBeforeEachCallCount = 0 auto
function beforeEach()
	mockBeforeEachCallCount += 1
endFunction

int property mockAfterEachCallCount = 0 auto
function afterEach()
	mockAfterEachCallCount += 1
endFunction


function TestSuites()
	describe("Testing Suite", LilacTesting_TestSuite())
endFunction

function LilacTesting_TestSuite()
	it("should run a test case", LilacTesting_TestCase1())
	it("should run another test case", LilacTesting_TestCase2())
endFunction

function LilacTesting_TestCase1()
	debug.trace(createLilacDebugMessage(INFO, "Ran test case 1"))
	expectBool(true, to, beTruthy)
endFunction

function LilacTesting_TestCase2()
	debug.trace(createLilacDebugMessage(INFO, "Ran test case 2"))
	expectBool(false, to, beFalsy)
endFunction