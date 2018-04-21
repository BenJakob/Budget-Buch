//
//  Constants.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 26.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import Foundation

// MARK: - Seque
let SW_REAR = "sw_rear"
let SW_FRONT = "sw_front"
let TO_ADD_INCOME = "add_income"
let TO_ADD_EXPENSE = "add_expense"
let TO_EDIT_EXPENSE = "edit_expense"
let TO_EDIT_INCOME = "edit_income"
let TO_CONFIG_CATEGORIES = "configCategories"
let TO_CONFIG_STATISTICS = "configStatistics"
let TO_CONFIG_REPEATING_EXPENSES = "configRepeatingExpenses"
let TO_CONFIG_REPEATING_INCOMES = "configRepeatingIncomes"
let TO_ADD_REAPEATING_EXPENSE = "add_repeatingExpense"
let TO_ADD_REAPEATING_INCOME = "add_repeatingIncome"
let TO_EDIT_REAPEATING_EXPENSE = "edit_repeatingExpense"
let TO_EDIT_REAPEATING_INCOME = "edit_repeatingIncome"
let TO_CATEGORY_DETAIL = "categoryDetails"

// MARK: - Cell IDs
let CELL_ID = "cell_id"
let NO_DATA_CELL_ID = "noDataCellId"
let DIAGRAM_CELL_ID = "diagrammCell"
let BALANCE_CELL_ID = "balance_cell"
let BALANCE_RESULT_CELL_ID = "balance_result_cell"
let ICON_CELL_ID = "iconCell"
let COLOR_CELL_ID = "colorCell"
let INTERVALL_CELL_ID = "intervalCellId"

// MARK: - Core Data Entities
let CONTAINER_NAME = "Budget_Buch"
let ENTRY = "Entry"
let INCOME = "Income"
let EXPENSE = "Expense"
let REPEATING_ENTRY = "RepeatingEntry"
let REPEATING_INCOME = "RepeatingIncome"
let REPEATING_EXPENSE = "RepeatingExpense"
let EXPENSE_CATEGORY = "ExpenseCategory"
let INCOME_CATEGORY = "IncomeCategory"

// MARK: - AD IDs
let APP_AD_ID = "ca-app-pub-2120545226663778~2616688276"
let EXPENSES_AD = "ca-app-pub-2120545226663778/3238880085"
let INCOMES_AD = "ca-app-pub-2120545226663778/7761467079"
let NEW_EXPENSE_AD = "ca-app-pub-2120545226663778/6227402861"
let NEW_INCOME_AD = "ca-app-pub-2120545226663778/2252267326"
let DIAGRAMS_AD = "ca-app-pub-2120545226663778/2012470463"

// Images
let BURGER_MENU = "BurgerMenu"

// MARK: - Localized Strings
// NavigationBar Titles
let EXPENSES_TITLE = NSLocalizedString("Expenses", comment: "Title for the Expense ViewController")
let INCOME_TITLE = NSLocalizedString("Income", comment: "Title for the Income ViewController")
let CATEGORY_TITLE = NSLocalizedString("Category", comment: "Title for the Category ViewController")
let INTERVAL_TITLE = NSLocalizedString("Interval", comment: "Title for the Interval ViewController")
let STATISTICS_TITLE = NSLocalizedString("Statistics", comment: "Title for the Statistics ViewController")
let NEW_EXPENSE_ENTRY = NSLocalizedString("New Expense", comment: "Title for the New-Expense-View-Controller")
let EDIT_EXPENSE_ENTRY = NSLocalizedString("Edit Expense", comment: "Title for the New-Expense-View-Controller")
let NEW_INCOME_ENTRY = NSLocalizedString("New Income", comment: "Title for the New-Income-View-Controller")
let EDIT_INCOME_ENTRY = NSLocalizedString("Edit Income", comment: "Title for the New-Income-View-Controller")
let FIX_INCOMES_TITLE = NSLocalizedString("Fixed Incomes", comment: "Title for Fixed Income View Controller")
let FIX_EXPENSES_TITLE = NSLocalizedString("Fixed Expenses", comment: "Title for Fixed Expenses View Controller")
let NEW_FIX_INCOME_TITLE = NSLocalizedString("New Fixed Income", comment: "Title for new Fixed Income View Controller")
let NEW_FIX_EXPENSE_TITLE = NSLocalizedString("New Fixed Expense", comment: "Title for new Fixed Expense View Controller")
let NEW_CATEGORY_TITLE = NSLocalizedString("New Category", comment: "Title for new Fix Expenses View Controller")

// Buttons
let SAVE = NSLocalizedString("Save", comment: "Title for Save-New-Income/Expense Button")
let EXPORT = NSLocalizedString("Export", comment: "Title for Export Data Button")
let OK = NSLocalizedString("OK", comment: "Confirm button title")
let DELETE = NSLocalizedString("Delete", comment: "Confirm delete button title")
let DELETE_ALL_ENTRIES = NSLocalizedString("Delete associated Entries", comment: "Confirm delete button title")
let DELETE_FIX_ENTRY = NSLocalizedString("Delete recurring payment", comment: "Confirm delete button title")
let CANCEL = NSLocalizedString("Cancel", comment: "cancel button title")
let BALANCE_LABEL = NSLocalizedString("Balance", comment: "Title for Segmented Controller in diagrams view controller")
let AUTOFILL_YES = NSLocalizedString("Autofill entries", comment: "AlertView AutoFill Reaction")
let AUTOFILL_NO = NSLocalizedString("Do not fill entries", comment: "AlertView AutoFill Reaction")

// Labels
let DATE = NSLocalizedString("DATE", comment: "Date Label")
let START = NSLocalizedString("Start", comment: "Start")
let END = NSLocalizedString("End", comment: "End")
let END_NOT_SET = NSLocalizedString("End: Not Set", comment: "End: Not Set")
let START_DATE = NSLocalizedString("START", comment: "Start Date Label")
let END_DATE = NSLocalizedString("END", comment: "End Date Label")
let INTERVAL = NSLocalizedString("INTERVAL", comment: "Interval Label")
let CATEGORY = NSLocalizedString("CATEGORY", comment: "Category Label")
let AMOUNT = NSLocalizedString("AMOUNT", comment: "Amount Label")
let NO_DATA_DIAGRAM_LABEL = NSLocalizedString("No Data", comment: "No Data Label, inside of the pie diagram")
let TOTAL = NSLocalizedString("Total", comment: "Label for total amount of a month")
let TITLE = NSLocalizedString("Title", comment: "Label for category title textfield")
let TITLE_PLACEHOLDER = NSLocalizedString("Name your Category", comment: "Placeholder for category title textfield")
let SELECT_ICON = NSLocalizedString("Select an Icon", comment: "Label for category icon selector")
let SELECT_COLOR = NSLocalizedString("Select a Color", comment: "Label for category color textfield")
let CONFIG_STAT_INTERVAL_LABEL = NSLocalizedString("The pie charts are displayed at the interval you select here:", comment: "label for interval picker in configureStatisticsVC")
let CONFIG_STAT_FILEFORMAT_LABEL = NSLocalizedString("You can export data in the following file formats:", comment: "label for fileformat picker in configureStatisticsVC")

// Intervals
let NONE = NSLocalizedString("None", comment: "Category Name")
let WEEKLY = NSLocalizedString("Weekly", comment: "Category Name")
let MONTHLY = NSLocalizedString("Monthly", comment: "Category Name")
let YEARLY = NSLocalizedString("Yearly", comment: "Category Name")

// Placeholder
let SELECTCATEGORY = NSLocalizedString("Select Category", comment: "Placeholder in Category-TextField")
let OPTIONAL = NSLocalizedString("Optional", comment: "Placeholder for optional input")

// Messages
let ERROR_TITLE = NSLocalizedString("Error", comment: "AlertView Error-Title")
let DELETE_TITLE = NSLocalizedString("Delete", comment: "AlertView Delete-Title")
let AUTOFILL_TITLE = NSLocalizedString("Autofill", comment: "AlertView AutoFill-Title")
let AUTOFILL_MESSAGE = NSLocalizedString("The start date is in the past. Should the past entries also be generated?", comment: "AlertView AutoFill-Message")
let DELETE_CATEGORY_MESSAGE = NSLocalizedString("The category has existing entries. The entries will be changed to the category 'Other'. Are you sure, you want to delete the category?", comment: "Confirmation message for category delete")
let DELETE_REPEATING_ENTRY_MESSAGE = NSLocalizedString("The recurring payment has entries associated with it. Should the entries also be deleted?", comment: "Confirmation message for repeating entry delete")
let INCOME_EXISTS_MESSAGE = NSLocalizedString("The fixed income already exists. Please select an other category or create a new category.", comment: "Income Exists Message")
let EXPENSE_EXISTS_MESSAGE = NSLocalizedString("The fixed expense already exists. Please select an other category or create a new category.", comment: "Expense Exists Message")
let CATEGORY_EXISTS_MESSAGE = NSLocalizedString("The category already exists. Please choose an other name for the category.", comment: "Category exists Message")
let EMPTY_FIELD_MESSAGE = NSLocalizedString("Please complete all required fields", comment: "Message for missing Userinput")
let MISSING_TITLE_MESSAGE = NSLocalizedString("Please choose a title for your Category", comment: "Message for missing Userinput")
let MISSING_COLOR_MESSAGE = NSLocalizedString("Please choose a color for your Category", comment: "Message for missing Userinput")
let MISSING_ICON_MESSAGE = NSLocalizedString("Please choose an icon for your Category", comment: "Message for missing Userinput")
let NO_DATA_FOUND = NSLocalizedString("Add new Entries with the + Button", comment: "Message in TableView, if no income or expense is found")

// Categories
// Expenses
let health = NSLocalizedString("Health", comment: "category name")
let gifts = NSLocalizedString("Gifts", comment: "category name")
let shopping = NSLocalizedString("Shopping", comment: "category name")
let bars = NSLocalizedString("Bars", comment: "category name")
let groceries = NSLocalizedString("Groceries", comment: "category name")
let restaurant = NSLocalizedString("Restaurant", comment: "category name")
let transport = NSLocalizedString("Transport", comment: "category name")
let education = NSLocalizedString("Education", comment: "category name")
let job = NSLocalizedString("Job", comment: "category name")
let houseHold = NSLocalizedString("Household", comment: "category name")
let supscriptions = NSLocalizedString("Supscriptions", comment: "category name")
let media = NSLocalizedString("Media", comment: "category name")
let electronics = NSLocalizedString("Electronics", comment: "category name")
let holidays = NSLocalizedString("Holidays", comment: "category name")
let savings = NSLocalizedString("Savings", comment: "category name")
let taxes = NSLocalizedString("Taxes", comment: "category name")
let insurance = NSLocalizedString("Insurance", comment: "category name")

// Incomes
let salery = NSLocalizedString("Salery", comment: "category name")
let tip = NSLocalizedString("Tip", comment: "category name")
let other = NSLocalizedString("Other", comment: "category name")

// Constant Data
let colors = [#colorLiteral(red: 0.1063642874, green: 0.7366505265, blue: 0.6106948256, alpha: 1), #colorLiteral(red: 0.08874874562, green: 0.6263432503, blue: 0.5207551122, alpha: 1), #colorLiteral(red: 0.1806617379, green: 0.8020917773, blue: 0.4414062202, alpha: 1), #colorLiteral(red: 0.1522265673, green: 0.6836117506, blue: 0.3726581931, alpha: 1), #colorLiteral(red: 0.2021752596, green: 0.5949850678, blue: 0.8609786034, alpha: 1), #colorLiteral(red: 0.1622865796, green: 0.5016841888, blue: 0.7261353731, alpha: 1), #colorLiteral(red: 0.6078112721, green: 0.3486402035, blue: 0.7139593363, alpha: 1), #colorLiteral(red: 0.5569592118, green: 0.2662727833, blue: 0.6791390181, alpha: 1), #colorLiteral(red: 0.2048440576, green: 0.2848570645, blue: 0.3680415452, alpha: 1), #colorLiteral(red: 0.173940599, green: 0.2419398427, blue: 0.3126519918, alpha: 1), #colorLiteral(red: 0.9459478259, green: 0.7699176669, blue: 0.05561546981, alpha: 1), #colorLiteral(red: 0.9523624778, green: 0.6107442379, blue: 0.07204849273, alpha: 1), #colorLiteral(red: 0.9019959569, green: 0.491275847, blue: 0.1372225881, alpha: 1), #colorLiteral(red: 0.8279563785, green: 0.3280953765, blue: 0, alpha: 1), #colorLiteral(red: 0.9074795842, green: 0.2969527543, blue: 0.2355833948, alpha: 1), #colorLiteral(red: 0.7531306148, green: 0.2227272987, blue: 0.1705473661, alpha: 1)]
let intervalData = [NONE, WEEKLY, MONTHLY, YEARLY]
let icons = ["icon00","icon01","icon02","icon03","icon04","icon05","icon06","icon07","icon08","icon09",
             "icon10","icon11","icon12","icon13","icon14","icon15","icon16","icon17","icon18","icon19",
             "icon20","icon21","icon22","icon23","icon24","icon25","icon26","icon27","icon28","icon29",
             "icon30","icon31","icon32","icon33","icon34","icon35","icon36","icon37","icon38","icon39",
             "icon40","icon41","icon42","icon43","icon44","icon45","icon46","icon47","icon48","icon49",
             "icon50","icon51","icon52","icon53","icon54","icon55","icon56","icon57","icon58","icon59",
             "icon60","icon61","icon62","icon63","icon64","icon65","icon66","icon67","icon68","icon69",
             "icon70","icon71","icon72","icon73","icon74","icon75","icon76","icon77","icon78","icon79",
             "icon80","icon81","icon82","icon83","icon84","icon85","icon86","icon87","icon88","icon89",
             "icon90","icon91","icon92","icon93","icon94","icon95","icon96","icon97","icon98","icon99",
             "icon100","icon101","icon102","icon103","icon104","icon105","icon106","icon107","icon108","icon109",
             "icon110","icon111","icon112","icon113","icon114"]















