scriptname LilacTestRunner extends Quest
{Base script for creating and running Lilac unit tests.}

int testsRun = 0
int testsPassed = 0
int testsFailed = 0
int testsSkipped = 0

function RunTests()
	ResetTestRunner()
	TestSuites()
endFunction

; Extend
function TestSuites()
endFunction

function ResetTestRunner()
	testsRun = 0
	testsPassed = 0
	testsFailed = 0
	testsSkipped = 0
endFunction