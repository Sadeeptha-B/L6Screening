# L6 Screening

Contains the files for task1, task2 and task3 respectively. The first two task files are written in JavaScript while the third file is an SQL script written for the SQLite DB Engine. Further details can be found under each file.

# Running the files

The JavaScript files can be run on Node.js LTS (v20.16.0) at the time of writing.

## Task 1

task1.js requires no dependencies to run.
Simply run the file with `node task1.js`

## Task 2

**task2.js makes use of Google API client libraries**. This is the recommended approach by Google for accessing Google Workspace APIs. Therefore, fetch the required dependencies with `npm install`

**To run task2.js, a `credentials.json` file containing the credentials for the Google Cloud Project must be provided at the root of the project.** You can setup your own Google Cloud Project to access Calendar APIs by following the instructions at

- https://developers.google.com/workspace/guides/get-started
- https://developers.google.com/calendar/api/quickstart/nodejs

**After installing the dependencies and providing `credentials.json`, simply run the file with `node task2.js`**

<blockquote>
The credentials.json file for my Google Cloud Project will be provided by email, you can use this instead. However, please note that my Google Cloud Project is listed in Production mode. This means that the Project must be verified by Google since the app requires accessing restricted scopes. Therefore, it is possible that Google would block the request since the app has not been verified. 

If the request is not blocked, You will be redirected to a warning page as follows when running the script.

![Auth Page](/images/auth.png "Auth warning.") 

You can complete your authentication by clicking "Go to FreeBusyBasic (unsafe)". However, if the request is blocked, you will have to setup your own Google Cloud Project following the instructions above. 
</blockquote>


## Task 3

Copy paste the script to the Online SQL compiler at https://www.programiz.com/sql/online-compiler/, which provides a SQLite DB backend without being reliant on WebSQL.

Though the instructions state that the file should be executable at https://www.w3schools.com/sql/trysql.asp?filename=trysql_select_columns/. This is no longer possible since the Try-SQL editor at w3Schools uses WebSQL which is no longer supported
on modern browsers. Further details can be found in the task3.sql script.

