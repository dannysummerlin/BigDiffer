public class comparisonResult {
    // probably really need to make a splitter Apex since it is otherwise just impossible
//		@AuraEnabled @InvocableVariable(label='Result Count' description='number of results' required=false) public Integer resultCount = 0;
    @AuraEnabled @InvocableVariable(label='Field Name' description='list of fields from comparison' required=false) public String field = '';
    @AuraEnabled @InvocableVariable(label='Field Type' description='list of field types from comparison' required=false) public String fieldType = '';
    @AuraEnabled @InvocableVariable(label='Value from A' description='' required=false) public String aValue = '';
    @AuraEnabled @InvocableVariable(label='Value from B' description='' required=false) public String bValue = '';
    @AuraEnabled @InvocableVariable(label='Has Error' description='' required=false) public Boolean hasError = false;
    @AuraEnabled @InvocableVariable(label='Error Message' description='' required=false) public String errorMessage = '';
}