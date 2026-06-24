# Aviv Group Case Study
Aviv Data Platform and Analytics Engineering Case


## Data Quality Issues

* **Missing (Null) Values:** The prices of some listings or the sources of some leads will come up as `None`/`NaN`.
* **Duplicated Records:** Identical duplicate rows with the exact same ID will be generated.
* **Negative/Invalid Prices:** The prices of some listings will take impossible values like `-100` or `0`.
* **Logical Date Violations:** Some update dates (`updated_at`) will be earlier than their creation dates (`created_at`), causing a chronological error.
* **Orphan Records (in the Leads table):** There will be lead rows containing a fake `listing_id` that does not exist at all in the main listings table (a Referential Integrity error).