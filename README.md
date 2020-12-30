# apex-compareResults

<a href="https://githubsfdeploy.herokuapp.com?owner=dannysummerlin&repo=apex-compareResults&ref=main" style="float:left">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

This class allows you to create a comparison action in a Lightning Flow by providing two of the same type of Record, and it returns a collection of results you can loop through that include the field name, field type, and values of each Record. By default the comparison finds the differences between Records, but there is an option to return values that are the same. You can also exclude fields from the comparison by entering a comma-separated list of field API names.

![Screenshot of the Apex Action](https://i.imgur.com/ab0FlEl.png)
