# Medical Test Management System

## Description
This script is a Medical Test Management System implemented in Shell scripting. It allows users to add, search, update, delete, and retrieve medical test records. The system stores medical test data in a file and provides various functionalities, such as filtering tests based on patient ID, test status, test name, abnormal values, and more.

### Functionalities:
1. Add a New Medical Test Record: Adds new medical test records after validating their format.
2. Search for a Test by Patient ID: Retrieves all test records associated with a specific patient ID.
3. Search for Abnormal Tests by Patient ID: Searches and displays abnormal test records based on predefined ranges.
4. Search for Tests in a Specific Period: Filters tests conducted within a specific date range.
5. Search by Test Status: Retrieves tests filtered by a specific status (e.g., pending, completed).
6. Search for Tests by Test Name: Allows searching for tests based on the test name.
7. Update an Existing Test Result: Updates an existing test record.
8. Delete a Test: Deletes a medical test record.
9. Exit the Program: Exits the program.


## Key Features:
- ID Validation: The system ensures that each medical record has a valid, unique patient ID, following the proper format
- Date Validation: The system validates the date format (YYYY-MM).
- Unit Validation: The test records are validated for valid units, including `mg/dL`, `mm Hg`, and `g/dL`.
- Test Status Validation: The status of tests is validated to ensure it's either `pending`, `completed`, or another valid status.
- Abnormal Test Range Check: Specific test results like `LDL`, `Hgb`, `BGT`, etc., are checked against abnormal value ranges and flagged accordingly.
  

## Project Files:
- script.sh: Contains the source code.
- medicalRecord.txt: Stores all medical test records.
- medicalTest.txt: Contains the list of valid medical tests.
- linuxReport: Contains tests cases for validating functionality and performance.


## Conclusion:
This shell script is a comprehensive tool for managing medical test records, with validation and error handling to ensure data integrity. The built-in test cases ensure that all features work correctly, and users can effectively manage medical test data.
