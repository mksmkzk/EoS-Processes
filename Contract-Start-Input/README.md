# Contract and START Information Input

We used WINDING CREEKS II from DIV 1 for this particular example on the dev server. 
All of this is performed on the dev server and the production server was not touched.

## Purpose

Populate the contract information from the current contract with information regarding each plan and elevation.

## Process

Since the process is similar and the contract and start data are linked, I combined both of them into one.

### 1. Select the estimate to generate the contract information from or the STARTS form.

![First Step](./images/GenerateExcel.png)

Right click on an estimate and go to 'eCMS Integration'.
Select either:
- 'Generate Contract Input Form'
- 'Generate START Input Form'

### 2. Fill out the Excel.

Once the excel is generated it will be saved into the currrent folder.
Then we fill out the salmon colored cells.

We want the forms to populate into a specified directory. (16 Input Forms?).

## Issues with Contracts

### Grouping Error

![Grouping Error](./images/GroupingError.png)

The first error happens when the contract is generated.
It tries to group the items by footprint quantity.

![Grouping Error Location](./images/GroupingErrorLocation.png)

We managed to make it work by summing the footprint quantity and commenting out the footpring quantity grouping.

![Corrected Grouping](./images/CorrectedGrouping.png)

This gave us the correct? results.

![Correct Results](./images/CorrectResult.png)

### Pulling Wrong Data

#### Information

![Pulling Wrong Information](./images/PullingWrongInformation.png)

The Builder, Project, Company Number, Contract Name, Project Name, and Estimator are all either not pulling any data or pulling the wrong data.

The Job Number is pulling the Division Number.

#### START

![Wrong Contract Amount](./images/WrongContractAmount.png)

When we generate the START excel, it pulls from the wrong column.

![Pulling Wrong Data](./images/PullingWrongData.png)

It currently pulls the data from the pumping column.

![Contract Value Error](./images/ContractValueError.png)

We managed to get it working with the above information.

#### Contract

![RFA Error](./images/RFAError.png)

There seems to be an error with the RFA column.
It pulls information from the column below it and leads to wrong results.

![Sage Total Error](./images/SageTotalError.png)

When we sum these values, we get 27,371. 
The contract amount is 19,995.

When we take first value divided by second value, we get ~1.369.

We wanted to know the formula that is being used to generate the Sage Total.



