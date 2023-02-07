@isTest
private class BigDifferTest {
	@isTest static void SimpleTest() {
		Account source = new Account();
		source.Name = 'First Account';
		Account compare = source.clone();
		compare.Name = 'Updated Name';
		BigDiffer.comparisonData testData = new BigDiffer.comparisonData();
		testData.source = source;
		testData.compare = compare;
		List<sObject> results = BigDiffer.diff(new List<BigDiffer.comparisonData>{testData});
	}
	@isTest static void ExclusionTest() {
		Account source = new Account();
		source.Name = 'First Account';
		source.Phone = '3218675309';
		Account compare = source.clone();
		compare.Phone = '';
		compare.Name = 'Updated Name';
		BigDiffer.comparisonData testData = new BigDiffer.comparisonData(source, compare, 'Phone');
		List<sObject> results = BigDiffer.diff(new List<BigDiffer.comparisonData>{testData});
	}
	@isTest static void ExceptionTest() {
		Boolean exceptionOccurred = false;
		try {
			Account source = new Account();
			source.Name = 'First Account';
			Account compare = source.clone();
			compare.Name = 'Updated Name';
			compare.Id = 'Bad Id';
			BigDiffer.comparisonData testData = new BigDiffer.comparisonData(source, compare);
			List<sObject> results = BigDiffer.diff(new List<BigDiffer.comparisonData>{testData});
		} catch(Exception e) {
			BigDiffer.BigDifferException testException = new BigDiffer.BigDifferException(e.getMessage());
			exceptionOccurred = true;
		}
		System.assert(exceptionOccurred, 'An Exception was not thrown');
	}
}
