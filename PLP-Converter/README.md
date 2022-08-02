# PLP Converter - Field Item Importer

We used WINDING CREEKS II from DIV 1 for this particular example.
It already had the contract and STARTS import performed on it.

## Purpose

Import the Warehouse orders into EoS in order to update the budget.

## Process

### 1. Select the estimate to import the orders into.

![First Step](./images/PLPimporterSteps.png)

We first select the estimate that we want to import the orders into.
We right click the estimate, go to 'Integration', then select 'Import Field Items'.

### 2. Select the file to import the orders from.

![Second Step](./images/FileSelectionStep.png)

We get a file selection dialog. We then select the file that we want to import the orders from.

### 3. The import process goes through and imports the orders.

![Third Step](./images/ImportStep.png)

After we selected the file, we go through the import process.
Once its done, we get a confirmation dialog.
If it fails, we get a dialog that tells us what went wrong.

## Issues

### Dev Environment

We has successfully imported the orders into the estimate on the dev server.
The only issue is that the item names are not correct. We need to fix this on the dev server.

### Production Environment

This process fails on the production server.
Need to document the error message.