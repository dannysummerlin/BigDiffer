public class BigDiffer {
	public class BigDifferException extends Exception {}

	@InvocableMethod(label='Diff Records' description='Find the differing values between two records')
	public static List<sObject> diff(List<BigDiffer.comparisonData> inputs) {
		List<sObject> outputs = new List<sObject>();
		for(BigDiffer.comparisonData input : inputs) {
			List<FormulaRecalcResult> recalcResults = Formula.recalculateFormulas(new List<sObject>{input.source, input.compare});
			if(recalcResults[0].isSuccess() && recalcResults[1].isSuccess()) {
				List<String> excludeFieldsList = new List<String>();
				if(String.isNotBlank(input.excludeFields)) {
					excludeFieldsList = input.excludeFields.split('\\s*,\\s*');                
				}
				Schema.DescribeSObjectResult sObjectType = input.source.getSObjectType().getDescribe();
				String sObjectTypeName = sObjectType.getName();
				Map<String, Schema.SObjectField> fieldMap = sObjectType.fields.getMap();
				List<String> usedFields = new List<String>();
				for(String fieldName : fieldMap.keySet()) {
					if(!excludeFieldsList.contains(fieldName) && input.source.get(fieldName) != input.compare.get(fieldName)) {
						usedFields.add(fieldName);
					}
				}
				Map<String, Object> outputObject = new Map<String, Object>();
				for(String fieldName : usedFields) {
					try {
						outputObject.put(fieldName, input.compare.get(fieldName));
					} catch(Exception e) {
						System.debug(e);
					}
				}
				outputs.add((sObject)JSON.deserialize(JSON.serialize(outputObject), Type.forName(sObjectTypeName)));
			} else {
				System.debug('--------------------------------------------------------------------------');
				System.debug(recalcResults[0].getErrors());
				System.debug(recalcResults[1].getErrors());
				System.debug('--------------------------------------------------------------------------');
				throw newBigDifferException(recalcResults[0].getErrors() + '\\n' + recalcResults[1].getErrors());
			}
		}
		return outputs;
	}
	static BigDifferException newBigDifferException(String message) {
		BigDifferException err = new BigDifferException(message);
		err.setMessage(message);
		return err;
	}
	public class comparisonData {
		@AuraEnabled @InvocableVariable(label='Source Record' description='Source record' required=true)
		public sObject source;
		@AuraEnabled @InvocableVariable(label='Comparison Record' description='Record for comparison' required=true)
		public sObject compare;
		@AuraEnabled @InvocableVariable(label='Fields to Exclude' description='(optional) comma-separated list of fields to skip')
		public String excludeFields;

		public comparisonData() {}
		public comparisonData(sObject s, sObject c) {
			this.source = s;
			this.compare = c;
		}
		public comparisonData(sObject s, sObject c, String e) {
			this.source = s;
			this.compare = c;
			this.excludeFields = e;
		}

	}
}
