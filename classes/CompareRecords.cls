global class CompareRecords {
	@InvocableMethod(label='Compare Records' description='returns the fields with a difference in value between two records. Toggle the "Same" option to find matching values.')
	public static List<List<comparisonResult>> compare(comparisonData[] inputs) {
		List<List<comparisonResult>> outList = new List<List<comparisonResult>>{};
		List<comparisonResult> wrapper = new List<comparisonResult>{};
		for(Integer count = 0; count < inputs.size(); count++) {
			comparisonData current = inputs[count];
			comparisonResult output = new comparisonResult();
			try {
				if(current.recordA.getSObjectType() != current.recordB.getSObjectType()) {
					SObjectException e = new SObjectException();
					e.setMessage('Comparison records must be the same type in order to compare');
					throw e;
				}
				DescribeSObjectResult objDef = current.recordA.getSObjectType().getDescribe();
				Type classType = Type.forName(objDef.getName());
				Map<String, SObjectField> fields = objDef.fields.getMap();

				Set<String> fieldsToExclude = new Set<String>{ 'Id' };
				if(current.fieldsToExcludeList != null)
					fieldsToExclude = new Set<String>(current.fieldsToExcludeList.replaceAll('\\s','').split(','));
				for(String field : fields.keySet()) {
					if (!fieldsToExclude.contains(field)) {
						if(
							(!current.isSame && current.recordA.get(field) != current.recordB.get(field))
							|| (current.isSame && current.recordA.get(field) == current.recordB.get(field) && current.recordA.get(field) != null)
						) {
							output.field = field;
							output.fieldType = objDef.fields.getMap().get(field).getDescribe().getType().name();
							output.aValue = ((String) current.recordA.get(field));
							output.bValue = ((String) current.recordB.get(field));
                            wrapper.add(output);
						}
					}
				}
			} catch (Exception e) {
				output.hasError = true;
				output.errorMessage = e.getMessage();
                wrapper.add(output);
				System.debug('An exception occurred: ' + e.getMessage());
			}
			outList.add(wrapper);
		}
		return outList;
	}
	global class comparisonData {
		@AuraEnabled @InvocableVariable(label='Record A' description='First record for comparison' required=true) public sObject recordA;
		@AuraEnabled @InvocableVariable(label='Record B' description='Second record for comparison' required=true) public sObject recordB;
		@AuraEnabled @InvocableVariable(label='Find Same Values?' description='by default the differences are returned, check this to find matching values instead' required=false) public Boolean isSame = false;
		@AuraEnabled @InvocableVariable(label='Fields to Exclude' description='(optional) comma-separated list of fields to skip' required=false) public String fieldsToExcludeList;
	}
}