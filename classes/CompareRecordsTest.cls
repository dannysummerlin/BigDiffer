@isTest
public class CompareRecordsTest {
  static void testComparison(Boolean isSame, sObject recordA, sObject recordB, String fieldsToExcludeList, String expectedResults) {
  	CompareRecords.comparisonData testInput = new CompareRecords.comparisonData();
	testInput.isSame = isSame;
	testInput.recordA = recordA;
	testInput.recordB = recordB;
	testInput.fieldsToExcludeList = fieldsToExcludeList;
	List<List<comparisonResult>> result = compareRecords.compare(new CompareRecords.comparisonData[]{testInput});
	System.debug(result);
	if(expectedResults != null && result[0][0].field != null)
		System.assert(result[0][0].field.equals(expectedResults));
	else if(expectedResults == null)
		System.assert(result[0][0].hasError);
  }

	static testMethod void diffTest() {
		testComparison(
			false,
			new Account(Name = 'Test Account One', Type = 'Customer'),
			new Account(Name = 'Test Account Two', Type = 'Customer'),
			null,
			'name'
		);
	}
	static testMethod void sameTest() {
		testComparison(
			true,
			new Account(Name = 'Test Account One', Type = 'Customer'),
			new Account(Name = 'Test Account Two', Type = 'Customer'),
			null,
			'type'
		);
	}
	static testMethod void errorTest() {
		testComparison(
			null,
			new Account(Name = 'Test Account One', Type = 'Customer'),
			new Contact(),
			null,
			null
		);
	}
}