# Brightwheel lead sources

### Assumptions

- I matched the data fields provided to the requirements as best as I could. In reality, I would expect to work closely with the business stakeholder who'd ideally have more context.
- I assumed that all leads came from one of the source files that start with the text "source". I then assume that when a lead is added to Salesforce, it stays in the source file but also gets a row in salesforce_leads.

### Design details

- I loaded data provided as external sources into Bigquery dataset. Thus, any changes in the files will be reflected automatically and ready for each run of the job.
- I used dbt to build all models and dependencies.
- The final model that combines the sources and salesforce_leads is lead_sources. Several staging and intermediate files are built along the way.
- I created a macro (clean_input_fields) to standardize how to clean and format fields.
- I created a snapshot (lead_sources_snapshot) of the final model so it can be references to analyze changes over time.

#### Database datasets (aka "schemas" in other databases)

- dataset "raw" is intended to be the landing spot for all external data. This is where I loaded the files provided.
- dataset "prod_staging" is intended to be raw data with some data cleanup, and only the fields that need to be maintained.
  - staging models: source1, source2, salesforce_leads
- dataset "prod_intermediate" is intended to be for datasets that are unlikely to be needed by the business but may be useful for data qa. Not all models need this step.
  - itermediate models: lead_sources_int, salesforce_leads_int
- dataset "prod_mart" is intended to be clean, well-modeled data with business rules and easy to query and leverage in BI tools.
  - mart model: lead_sources
- dataset "prod_snapshot" holds snapshots. In this case, I only took a snapshot of the final mart model.
    - snapshot model: lead_sources_snapshot
- datasets starting with "dev_" are for work in development

### Notes

- I only materialized the final resulting dataset, `lead_sources`, the rest I left as views. But could be materialized depending on needs.
- For time constraints, I did not load source3, but it would follow the same pattern as source1 and source2.
- I built a couple basic tests on the field I created that I think should be unique.

### With more time and context

- I would have liked to more thoroughly understand where the data came from to think about how to best ingest it. For now I used external tables that feed directly from GSheets to Bigquery, but landing files in S3 or using third party ETL tools like Fivetran could be other alternatives.
- There is more data cleaning that could have been done and more data could have been extracted for more complete datasets.
- I would have done more stress testing of the code to make sure it was robust as more data is added to the source files.
- I would have loaded the 3rd file and shared queries that answer the sample questions.
- I would have created a dag and scheduled it with airflow.

### Long term considerations

- The data provided required a lot of cleaning and there was minimal standardization across sources. I would like to work with stakeholders to see if there are ways to standardize upstream.
- Changing schemas is always difficult to deal with in a traditional data pipeline since that's is usually a breaking change. If it's not feasible to improve data quality and consistency upstream, we could consider building a pipeline that leverages genAI to extract the desired information from each file in a standardized format, without requring the source schemas to remain constant.
- To significantly scale the number of sources, besides leveraging genAI to handle schema changes and some data cleanup, we'd also want to add more macros to the code. For example, instead of hardcoding union statements for each of the sources, we can use for loops to cycle through all of them.


### To run the code

- I can create a service account in my personal Bigquery project for you. Alternately, you can point to your own Bigquery database with the files provides as tables or views. You'll have to edit the \_staging_sources.yml file if your dataset/schema has a name other than "raw"
- Fork from this github repo
- Create a new project in your dbt account
- Connect dbt to your github fork
- Run the following command to install the necessary packages:
  dbt deps
- Run the following command to build lead_sources and all upstream dependencies:
  dbt build --select +lead_sources
- Run the following command to run the lead_sources_snapshot model:
  dbt snapshot
