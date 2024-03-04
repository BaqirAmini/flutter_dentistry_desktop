final Map<String, Map<String, String>> translations = {
  'English': {
    'chooseLanguage': 'Choose Language',
    /*----- LOGIN PAGE  -----*/
    'TopLabel': 'Welcome!',
    'UserName': 'User Name',
    'Password': 'Password',
    'LoginButton': 'Login',
    'BlankUsernameMsg': 'Username cannot be empty.',
    'BlankPwdMsg': 'Password cannot be empty.',
    'ForgotPwd': 'Forgot Password?',
    'InvalidUP': 'Sorry, invalid User Name or Password!',
    /*-----/. LOGIN PAGE  -----*/
    /*----- DASHBOARD -----*/
    'TodayPatient': 'Today\'s Patients',
    'CurrentMonthExpenses': 'Current month expenses',
    'CurrentYearTaxes': 'This year\'s tax',
    'AllPatients': 'All Patients',
    'LastThreeMonthExpenses': 'Expenses of the last three months',
    'LastSixMonthPatients': 'Visits of patients in the last six months',
    'OpenDrawerMsg': 'Open left Menu',
    'Profit': 'Profits',
    'DDLDuration': 'Duration',
    'Earnings': 'Earnings',
    'Receivable': 'Receivable',
    /*-----/. DASHBOARD -----*/
    /*----- SIDEBAR -----*/
    'Dashboard': 'Dashboard',
    'Patients': 'Patients',
    'Staff': 'Staff',
    'Services': 'Services',
    'Expenses': 'Expenses',
    'Taxes': 'Taxes',
    'Settings': 'Settings',
    'Logout': 'Log out',
    'UpcomingAppt': 'Upcoming Appointments',
    /*-----/.SIDEBAR  -----*/
    /*----- UNITS -----*/
    'People': 'person',
    'Afn': 'AFN',
    /*-----/. UNITS -----*/
    /*----- LOGOUT POPUP -----*/
    'ConfirmMsg': 'Are you sure you want to exit?',
    'ConfirmBtn': 'Log Out',
    'CancelBtn': 'Cancel',
    /*----- /. LOGOUT POPUP -----*/
    /*----- PATIENTS -----*/
    'Search': 'Search...',
    'GenPresc': 'Prescription',
    'AddNewPatient': 'Add New Patient',
    'DeletePatientTitle': 'Delete',
    'ConfirmDelete': 'Are you sure you want to delete this patient?',
    'DeleteSuccess': 'The patient deleted.',
    'PatientReg': 'Patient Registration',
    'َPatientPersInfo': 'Patient Personal Info',
    'َDentalService': 'Dental services required',
    'َServiceFee': 'Fee',
    'Step1Msg': 'Please insert patient\'s info carefully in the boxes below.',
    'NextBtn': 'Next',
    'PrevBtn': 'Previous',
    'AddBtn': 'Register',
    'BloodGroup': 'Blood Group',
    'SelectAge': 'Please select age.',
    'NoAge': 'No age selected.',
    'RegDate': 'Registration Date',
    'Appointments': 'Appointments',
    'Histories': 'Patient Health History',
    'FeeInstallment': 'Fee / Installments',
    'Retreatment': 'Retreatments',
    'RetreatBtn': 'Retreatment',
    'PatRecords': 'Patient Records',
    'CreateRet4': 'Create Retreatment for ',
    'SelectDentist': 'Select Dentist',
    'RetDateTime': 'Retreatment Date and Time',
    'RetReason': 'Retreatment Reason',
    'RetFee': 'Retreatment Fee',
    'Ret4Free': 'For Free',
    'RetResult': 'Retreatment Results',
    'RetDetails': 'Description',
    'RetReasonRequired': 'The retreatment reason required.',
    'RetReasonLength':
        'The retreatment reason must be at leat 5 and at most 40 characters.',
    'RetFeeRequired': 'Please enter the retreatment fee.',
    'RetFeeLength': 'Fee cannot be lower than 50 AFN and more than 1000 AFN.',
    'OtherDDLDetail': 'Please explain about this case.',
    'OtherDDLLength':
        'Details cannot be less than 5 and more than 40 characters.',
    'RetSuccessMsg': 'Retreatment of this appointment inserted.',
    'RetFailMsg': 'Adding retreatment failed. Try again.',
    'DeleteAHeading': 'Delete appointment',
    'ConfirmDelAppt': 'Are you sure you want to delete this appointment?',
    'DeleteSuccessMsg': 'Deleted!',
    'FeeInst4': 'Fee and Installments Belong to: ',
    'Appt4': 'Appointments Belong to: ',
    'HealthHistory4': 'Health Histories Belong to: ',
    'Installments': 'Installments',
    'Installment': 'Installment',
    'WholeFP': 'Whole Fee Earned',
    'EarnedBy': 'Earned by: ',
    'Earn': 'Earn Payment',
    'ServiceDone': 'Services Done',
    'Procedure': 'Procedure Type',
    'Teeth': 'Teeth Selected',
    'Gum': 'Gum Selected',
    'BleachStep': 'Bleaching Steps',
    'Materials': 'Materials Used',
    'AffectArea': 'Affected Area',
    'Round': 'Round',
    'Dentist': 'Dentist',
    'FeeDialogHeading': 'Earn Patients\' Fee',
    'FormHintMsg':
        'Please enter the related values in the field below carefully.',
    'FeeDateRequired': 'Fee payment date required.',
    'PayDate': 'Payment Date',
    'PayInstallment': 'Payment Installment',
    'PayAmountRequired': 'Payment amount required.',
    'PayAmountValid': 'Payment amount must be less than receivable.',
    'LastInstallment': 'It is the last installment. Whole amount required.',
    'PayAmount': 'Payment Amount',
    'TotalFee': 'Total Fee',
    'ReceivableFee': 'Receivable Fee',
    'ValidPayDateMsg':
        'The date must be greater than or equal to previous payment date.',
    'FeeReceivedBy': 'Fee Earned By',
    'HealthHHeading': 'Edit Health History of ',
    'DiagResult': 'Diagnosis Results',
    'DiagDate': 'Diagnosis Date',
    'HistoryLevel': 'Severty',
    'HistoryDuration': 'Duration',
    'Positive': 'Positive',
    'Xray4': 'X-Rays Belong to: ',
    'UploadXray': 'Upload X-Ray / Teeth related Images',
    'XrayFileRequired': 'Please choose an X-Ray file or image.',
    'XrayDate': 'X-Ray Date',
    'XrayType': 'X-Ray Type:',
    'XrayDateRequired': 'Date is required.',
    'DupXrayMsg':
        'X-Ray with this name already exists in the system. So either rename this file or choose another file and upload it again.',
    'XraySizeMsg': 'The size of the X-Ray file must be less than 10 MB.',
    'XrayUploadBtn': 'Upload',
    'XrayPath':
        'The address of all X-Ray files that have been uploaded so far: ',
    'XrayNotFound': 'No X-Ray Image Found.',
    'UploadedAt': 'Uploaded At:',
    'PrevXray': 'Previous Image',
    'NextXray': 'Next Image',
    'XrayDetails': 'X-Ray Details',
    /*-----/. PATIENTS -----*/
    /*-------- STAFF ------- */
    'AllStaff': 'All Staff',
    'Photo': 'Photo',
    'Salary': 'Salary',
    'Tazkira': 'Tazkira NO',
    'Position': 'Position',
    'Address': 'Address',
    'Actions': 'Actions',
    'AddNewStaff': 'Add new staff',
    'StaffDetail': 'Details',
    'StaffUA': 'User Account',
    'StaffReg': 'New Staff Registration',
    'StaffRegMsg': 'Please insert staff\'s info carefully in the boxes below.',
    'FNRequired': 'First Name is required.',
    'FNLength': 'First Name must be between 3 and 10 characters.',
    'LNLength': 'Last Name must be between 3 and 10 characters.',
    'PhoneRequired': 'Phone is required.',
    'ValidPhone': 'Invalid phone number.',
    'Phone10': 'Phone must be 10 digits.',
    'Phone12': 'Phone must be 12 digits including country code.',
    'ValidSalary': 'Salary must be between 1000 AFN and 100,000 AFN.',
    'ValidTazkira': 'Tazkira NO must be have format xxxx-xxxx-xxxxx.',
    'StaffRegSuccess': 'The staff registered successfully.',
    'ChangeUAHeader': 'Change User Account',
    'ConfirmPassword': 'Confirm Password',
    'ChooseRole': 'Choose Role',
    'SaveUABtn': 'Done',
    'RequireUserName': 'User Name is required.',
    'UserNameLength': 'User Name must be at least 6 and at most 10 characters.',
    'RequirePassword': 'Password is required.',
    'RequirePwdConfirm': 'Re-typing Password is required.',
    'PasswordLength': 'Password must be at least 8 characters.',
    'ConfirmPwdMsg': 'The Password doesn\' match. Try again.',
    'UpdateUAMsg': 'The user account updated successfully.',
    'CreateUAHeader': 'Create User Account',
    'StaffEditMsg': 'The changes applied successfully.',
    'StaffEditErrMsg': 'Nothing has been edited.',
    'ConfirmStaffDelete': 'Are you sure you want to delete this staff?',
    'DeleteStaffMsg': 'The staff deleted successfully.',
    /*--------/. STAFF ------- */
    /*----- SHARED VALUES -----*/
    'FName': 'First Name',
    'LName': 'Last Name',
    'Age': 'Age',
    'Sex': 'Sex',
    'Marital': 'Marital Status',
    'Phone': 'Phone',
    'Details': 'Details',
    'Edit': 'Edit',
    'Delete': 'Delete',
    'GoToDashboard': 'Go To Dashboard',
    'RegBtn': 'Register',
    'GoBack': 'Go to previous page',
    'Year': 'year',
    'Single': 'Single',
    'Married': 'Married',
    'NotAvable': 'N/A',
    'Male': 'Male',
    'Female': 'Female',
    'AddrLength': 'Address must be at least 10 and at most 40 characters.',
    /*-----/. SHARED VALUES -----*/
    /*---- SETTINGS -----*/
    'PersonalInfo': 'Personal Info',
    'MyProfile': 'My Profile',
    'Security': 'Security',
    'ChangePwd': 'Change Password',
    'Sync': 'Sync',
    'Backup': 'Backup',
    'Restore': 'Restore',
    'SysRelated': 'Related to the System',
    'Theme': 'Themes',
    'Languages': 'Languages',
    'ChangeProfilePhoto': 'Change Profile Photo',
    /*----/. SETTINGS -----*/
    /*---------- USER PROFILE -----------*/
    'MyProfileHeading': 'Edit My Personal Info',
    'ChgMyPInfo': 'Edit Personal Info',
    'LblCurrNewPwd': 'Enter your current and new password carefully.',
    'CurrPwdRequired': 'Your current password required.',
    'NewPwdRequired': 'Enter your new password.',
    'Pwd6': 'Password must be at least 6 characters.',
    'NewPwdConfirm': 'Confirm your new password.',
    'NewPwdNotMatch': 'Your new password does not match.',
    'PwdHint': 'This value should be the same as the new password.',
    'InvalidCurrPwd': 'Your current password is invalid.',
    'CurrPwd': 'Current Password',
    'NewPwd': 'New Password',
    'ConfirmNewPwd': 'Confirm New Password',
    'ChangeBtn': 'Change Password',
    'PwdSuccessMsg': 'Password changed successfully.',
    'BackupCautMsg':
        'Caution! To protect your data from getting lost, please move the backup file into secure storages like:',
    'Storage1': 'Cloud Storages such as Google Drive or Microsoft OneDrive.',
    'Storage2': 'External Storages such as a Hard Disk Drive.',
    'CreateBackup': 'Create Backup File',
    'BackupCreatMsg': 'The Backup file has been created under: ',
    'RestoreBackup': 'Restore Backup File',
    'RestoreSuccessMsg': 'Restoration was done.',
    'RestoreMsg':
        'Attention! Before to restore, please make sure the Backup file is existing.',
    'WaitMsg': 'Please wait...',
    'BackupNotSelected': 'You have not selected any Backup file.',
    'RestoreNotNeeded':
        'Restoration not needed. These records are already existing in the system.',
    /*----------/. USER PROFILE -----------*/
  },
  'دری': {
    'chooseLanguage': 'انتخاب زبان',
    /*----- LOGIN PAGE  -----*/
    'TopLabel': 'خوش آمدید!',
    'UserName': 'نام یوزر',
    'Password': 'رمز عبور',
    'LoginButton': 'ورود',
    'BlankUsernameMsg': 'نام یوزر نمی تواند خالی باشد.',
    'BlankPwdMsg': 'رمز عبور نمی تواند خالی باشد.',
    'ForgotPwd': 'رمز فراموش تان گریده؟',
    'InvalidUP': 'متأسفم، نام یوزر یا رمز نا معتبر است!',
    /*-----/. LOGIN PAGE  -----*/
    /*----- DASHBOARD -----*/
    'TodayPatient': 'مریض های امروز',
    'CurrentMonthExpenses': 'مصارف ماه جاری',
    'CurrentYearTaxes': 'مالیات امسال',
    'AllPatients': 'همه مریض ها',
    'LastThreeMonthExpenses': 'مصارف سه ماه اخیر',
    'LastSixMonthPatients': 'مراجعه مریض ها در شش ماه اخیر',
    'OpenDrawerMsg': 'باز کردن مینو راست',
    'Profit': 'مفاد',
    'DDLDuration': 'مدت',
    'Earnings': 'عایدات',
    'Receivable': 'قابل دریافت (قرض)',
    /*-----/. DASHBOARD -----*/
    /*----- SIDEBAR -----*/
    'Dashboard': 'داشبورد',
    'Patients': 'مریض ها',
    'Staff': 'کارمندان',
    'Services': 'خدمات',
    'Expenses': 'مصارف',
    'Taxes': 'مالیات',
    'Settings': 'تنظیمات',
    'Logout': 'خروج',
    'UpcomingAppt': 'جلسات آینده',
    /*-----/. SIDEBAR -----*/
    /*----- UNITS -----*/
    'People': 'نفر',
    'Afn': 'افغانی',
    /*-----/. UNITS -----*/
    /*----- LOGOUT POPUP -----*/
    'ConfirmMsg': 'آیا میخواهید از سیستم خارج شوید؟',
    'ConfirmBtn': 'خروج',
    'CancelBtn': 'لغو',
    /*----- /. LOGOUT POPUP -----*/
    /*----- PATIENTS -----*/
    'Search': 'جستجو...',
    'GenPresc': 'تجویز نسخه',
    'AddNewPatient': 'افزودن مریض جدید',
    'DeletePatientTitle': 'حذف',
    'ConfirmDelete': 'آیا میخواهید این مریض را حذف کنید؟',
    'DeleteSuccess': 'مریض حذف شد.',
    'PatientReg': 'ثبت مریض',
    'َPatientPersInfo': 'معلومات شخصی مریض',
    'َDentalService': 'خدمات مورد نیاز',
    'َServiceFee': 'فیس',
    'Step1Msg': 'لطفاً معلومات شخصی مریض را با دقت در خانه های زیر درج کنید.',
    'NextBtn': 'ادامه',
    'PrevBtn': 'قبلی',
    'AddBtn': 'ثبت',
    'BloodGroup': 'گروپ خون',
    'SelectAge': 'لطفاً سن را انتخاب کنید.',
    'NoAge': 'هیچ سنی انتخاب نشده است.',
    'RegDate': 'تاریخ ثبت',
    'Appointments': 'جلسات',
    'Histories': 'تاریخچه صحی مریض',
    'FeeInstallment': 'فیس / اقساط',
    'Retreatment': 'درمان مجدد / عودی',
    'RetreatBtn': 'عودی (درمان مجدد)',
    'PatRecords': 'سوابق مریض',
    'CreateRet4': 'ایجاد عودی برای',
    'SelectDentist': 'انتخاب داکتر',
    'RetDateTime': 'تاریخ و زمان عودی',
    'RetReason': 'علت عودی',
    'RetFee': 'فیس عودی',
    'Ret4Free': 'بطور رایگان',
    'RetResult': 'نتایج عودی',
    'RetDetails': 'توضیحات',
    'RetReasonRequired': 'علت عودی را باید درج کنید.',
    'RetReasonLength': 'علت عودی باید حداقل 5 و حداکثر 40 حرف باشد.',
    'RetFeeRequired': 'لطفاً مقدار فیس را وارد کنید.',
    'RetFeeLength':
        'فیس نمی تواند کمتر از 50 افغانی و بیشتر از 1000 افغانی باشد.',
    'OtherDDLDetail': 'لطفاً راجع به این مورد شرح دهید.',
    'OtherDDLLength': 'توضیحات باید حداقل 5 و حداکثر 40 حرف باشد.',
    'RetSuccessMsg': 'عودی مربوط به این جلسه ثبت گردید.',
    'RetFailMsg': 'ثبت عودی ناکام شد. دوباره سعی کنید.',
    'DeleteAHeading': 'حذف جلسه',
    'ConfirmDelAppt': 'آیا از حذف این جلسه اطمینان دارید؟',
    'DeleteSuccessMsg': 'حذف گردید!',
    'FeeInst4': 'فیس و اقساط مربوط: ',
    'Appt4': 'جلسات مربوط به: ',
    'HealthHistory4': 'تاریخچه صحی مربوط به: ',
    'Installments': 'اقساط',
    'Installment': 'قسط',
    'WholeFP': 'همه فیس دریافت شد',
    'EarnedBy': 'دریافت کننده: ',
    'Earn': 'دریافت فیس',
    'ServiceDone': 'خدمات انجام شده',
    'Procedure': 'نوعیت کاری',
    'Teeth': 'دندانهای انتخاب شده',
    'Gum': 'لثه انتخاب شده',
    'BleachStep': 'مراحل سفید کردن',
    'Materials': 'مواد مورد استفاده',
    'AffectArea': 'ناحیه آسیب دیده',
    'Round': 'نوبت',
    'Dentist': 'داکتر معالج',
    'FeeDialogHeading': 'دریافت فیس مریض',
    'FormHintMsg': 'لطفاً خانه های ذیل را با قیمتهای مربوطه با دقت پرکنید.',
    'FeeDateRequired': 'تاریخ دریافت فیس الزامی است.',
    'PayDate': 'تاریخ دریافت فیس',
    'PayInstallment': 'قسط دریافت فیس',
    'PayAmountRequired': 'مبلغ دریافت فیس را وارد کنید.',
    'PayAmountValid':
        'مبلغ دریافت فیس باید کمتر یا مساوی به مقدار باقی مانده باشد.',
    'LastInstallment': 'آخرین قسط است. باید همه فیس باقی پرداخته شود.',
    'PayAmount': 'مبلغ دریافت',
    'TotalFee': 'مجموع فیس',
    'ReceivableFee': 'فیس باقی',
    'ValidPayDateMsg':
        'تاریخ دریافت باید بزرگتر یا مساوی به تاریخ پرداخت قبلی باشد.',
    'FeeReceivedBy': 'دریافت کننده فیس',
    'HealthHHeading': 'تغییر تاریخچه صحی ',
    'DiagResult': 'نتیجه معاینه',
    'DiagDate': 'تاریخ تشخیص / معاینه',
    'HistoryLevel': 'شدت / سطح',
    'HistoryDuration': 'سابقه / مدت',
    'Positive': 'نتیجه مثبت',
    'Xray4': 'اکسری مربوط به: ',
    'UploadXray': 'آپلود فایل اکسری / تصویر مرتبط به دندان',
    'XrayFileRequired': 'لطفاً فایل اکسری یا تصویر را انتخاب کنید.',
    'XrayDate': 'تاریخ اکسری',
    'XrayType': 'نوعیت اکسری:',
    'XrayDateRequired': 'تاریخ الزامی میباشد.',
    'DupXrayMsg':
        'اکسری با این نام قبلاً در سیستم وجود دارد. پس یا این فایل را تغییر نام داده و یا فایل دیگری را انتخاب نموده و دوباره آپلود کنید.',
    'XraySizeMsg': 'اندازه فایل اکسری باید کمتر از 10 میگابایت باشد.',
    'XrayUploadBtn': 'آپلود',
    'XrayPath': 'آدرس همه فایل های اکسری که تا حالا آپلود گریده اند: ',
    'XrayNotFound': 'هیچ عکس اکسری یافت نشد.',
    'UploadedAt': 'تاریخ آپلود:',
    'PrevXray': 'عکس قبلی',
    'NextXray': 'عکس بعدی',
    'XrayDetails': 'توضیحات اکسری',
    /*-----/. PATIENTS -----*/
    /*-------- STAFF ------- */
    'AllStaff': 'همه کارمندان',
    'Photo': 'عکس',
    'Salary': 'مقدار معاش',
    'Tazkira': 'نمبر تذکره',
    'Position': 'مقام',
    'Address': 'آدرس',
    'Actions': 'اقدامات',
    'AddNewStaff': 'افزودن کارمند جدید',
    'StaffDetail': 'جزییات',
    'StaffUA': 'حساب کاربری',
    'StaffReg': 'ثبت کارمندان جدید',
    'StaffRegMsg':
        'لطفاً معلومات کارمند جدید را با دقت در خانه هالی ذیل درج نمایید.',
    'FNRequired': 'نام الزامی است.',
    'FNLength': 'نام باید بین 3 و 10 حرف باشد.',
    'LNLength': 'تخلص باید بین 3 و 10 حرف باشد.',
    'PhoneRequired': 'نمبر تماس الزامی است.',
    'Phone10': 'نمبر تماس باید 10 رقم باشد.',
    'Phone12': 'نمبر تماس همراه با کود کشور باید 12 رقم باشد.',
    'ValidPhone': 'نمبر تماس نا معتبر است.',
    'ValidSalary': 'مقدار معاش باید بین 1000 افغانی و 100,000 افغانی باشد.',
    'ValidTazkira': 'نمبر تذکره باید دارای فورمت xxxx-xxxx-xxxxx باشد.',
    'StaffRegSuccess': 'کارمند موفقانه ثبت گردید.',
    'ChangeUAHeader': 'تغییر حساب یوزر',
    'ConfirmPassword': 'تایید رمز',
    'ChooseRole': 'تعیین صلاحیت',
    'SaveUABtn': 'انجام',
    'RequirePassword': 'رمز الزامی است.',
    'RequireUserName': 'نام یوزر الزامی میباشد.',
    'UserNameLength': 'نام یوزر باید حداقل 6 و حداکثر 10 حرف باشد.',
    'RequirePwdConfirm': 'تایید رمز الزامی است.',
    'PasswordLength': 'رمز باید حداقل 8 حرف باشد.',
    'ConfirmPwdMsg': 'رمز همخوانی ندارد. دوباره سعی کنید.',
    'UpdateUAMsg': 'حساب یوزر موفقانه تغییر کرد.',
    'CreateUAHeader': 'ایجاد حساب یوزر',
    'StaffEditMsg': 'تغییرات موفقانه انجام شد.',
    'StaffEditErrMsg': 'شما هیچ تغییراتی نیاورده اید.',
    'ConfirmStaffDelete': 'آیا میخواهید این کارمند را حذف کنید؟',
    'DeleteStaffMsg': 'کارمند موفقانه حذف شد.',
    /*--------/. STAFF ------- */
    /*----- SHARED VALUES -----*/
    'FName': 'اسم',
    'LName': 'تخلص',
    'Age': 'سن',
    'Sex': 'جنسیت',
    'Marital': 'حالت تاهل',
    'Phone': 'تماس',
    'Details': 'شرح',
    'Edit': 'تغییر',
    'Delete': 'حذف',
    'GoToDashboard': 'رفتن به داشبورد',
    'RegBtn': 'ثبت کردن',
    'GoBack': 'رفتن به صفحه قبل',
    'Year': 'سال',
    'Single': 'مجرد',
    'Married': 'متأهل',
    'NotAvable': 'نامشخص',
    'Male': 'مرد',
    'Female': 'زن',
    'AddrLength': 'آدرس باید حداقل 10 و حداکثر 40 حرف باشد.',
    /*-----/. SHARED VALUES -----*/
    /*---- SETTINGS -----*/
    'PersonalInfo': 'معلومات شخصی',
    'MyProfile': 'پروفایل من',
    'Security': 'امنیت',
    'ChangePwd': 'تغییر رمز',
    'Sync': 'همگام سازی',
    'Backup': 'پشتیبان گیری',
    'Restore': 'بازیابی',
    'SysRelated': 'مرتبط به سیستم',
    'Theme': 'نمایه ها',
    'Languages': 'زبان',
    'ChangeProfilePhoto': 'تغییر عکس پروفایل',
    /*----/. SETTINGS -----*/
    /*---------- USER PROFILE -----------*/
    'MyProfileHeading': 'تغییر معلومات شخصی من',
    'ChgMyPInfo': 'تغییر معلومات شخصی',
    'LblCurrNewPwd': 'لطفاً رمز فعلی و جدید تانرا با دقت وارد نمایید.',
    'CurrPwdRequired': 'رمز فعلی تان الزامی است.',
    'NewPwdRequired': 'رمز جدید تانرا وارد کنید.',
    'Pwd6': 'رمز باید حداقل 6 حرف باشد.',
    'NewPwdConfirm': 'لطفاً رمز جدید تانرا دوباره وارد کنید.',
    'NewPwdNotMatch': 'رمز جدید تان مطابقت نمیکند.',
    'PwdHint': 'این رمز باید با رمز جدید یکسان باشد.',
    'InvalidCurrPwd': 'رمز فعلی تان نادرست است.',
    'CurrPwd': 'رمز فعلی',
    'NewPwd': 'رمز جدید',
    'ConfirmNewPwd': 'تایید رمز جدید',
    'ChangeBtn': 'تغییر رمز',
    'PwdSuccessMsg': 'تغییر رمز موفقانه بود.',
    'BackupCautMsg':
        'احتیاط! برای جلوگیری از نابود شدن اطلاعات تان، لطفا فایل پشتیبانی را در یک جای محفوظ که قرار ذیل است ذخیره کنید:',
    'Storage1':
        'حافظه کلود (ابری ) مثل Google Drive و یا Microsoft OneDrive است.',
    'Storage2': 'حافظه بیرونی مثل هارددیسک است.',
    'CreateBackup': 'ایجاد فایل پشتیبانی',
    'BackupCreatMsg': 'فایل پشتیبانی ایجاد شد در: ',
    'RestoreBackup': 'بازیابی فایل پشتیبان',
    'RestoreSuccessMsg': 'بازیابی انجام شد.',
    'RestoreMsg':
        'توجه! قبل از انجام بازیابی، از موجودیت فایل پشتیبان اطمینان حاصل کنید.',
    'WaitMsg': 'لطفاً صبر...',
    'BackupNotSelected': 'شما هیچ فایل پشتیبانی را انتخاب نکرده اید.',
    'RestoreNotNeeded':
        'نیازی به بازیابی نیست. این ریکاردها در سیستم وجود دارند.',
    /*----------/. USER PROFILE -----------*/
    // Add other Dari translations here
  },
  'پښتو': {
    'chooseLanguage': 'د ژبې انتخاب',
    /*----- LOGIN PAGE  -----*/
    'TopLabel': 'ښه راغلاست!',
    'UserName': 'د کارن نیم',
    'Password': 'پټنوم',
    'LoginButton': 'ننوتل',
    'BlankUsernameMsg': 'د کارن نوم خالي نشي.',
    'BlankPwdMsg': 'پټنوم خالي نشي.',
    'ForgotPwd': 'خپل پټنوم درڅخه هیر دی؟',
    'InvalidUP': 'بخښنه غواړئ، ناسم کارن نوم یا پټنوم!',
    /*-----/. LOGIN PAGE  -----*/
    /*----- DASHBOARD -----*/
    'TodayPatient': 'د نن ورځې ناروغان',
    'CurrentMonthExpenses': 'د روانې میاشتې لګښتونه',
    'CurrentYearTaxes': 'د سږ کال مالیه',
    'AllPatients': 'ټول ناروغان',
    'LastThreeMonthExpenses': 'د تیرو دریو میاشتو لګښتونه',
    'LastSixMonthPatients': 'په تیرو شپږو میاشتو کې د ناروغانو لیدنه',
    'OpenDrawerMsg': 'سم مینو خلاص کړی',
    'Profit': 'ګټه',
    'DDLDuration': 'دوره',
    'Earnings': 'عایدات',
    'Receivable': 'د ترلاسه کولو وړ (پور)',
    /*-----/. DASHBOARD -----*/
    /*----- SIDEBAR -----*/
    'Dashboard': 'ډشبورډ',
    'Patients': 'ناروغان',
    'Staff': 'کارکوونکي',
    'Services': 'خدمتونه',
    'Expenses': 'لګښتونه',
    'Taxes': 'مالیات',
    'Settings': 'ترتیبات',
    'Logout': 'وتل',
    'UpcomingAppt': 'راتلونکې ګمارنې',
    /*-----/. SIDEBAR -----*/
    /*----- UNITS -----*/
    'People': 'کسان',
    'Afn': 'افغانۍ',
    /*-----/. UNITS -----*/
    /*----- LOGOUT POPUP -----*/
    'ConfirmMsg': 'ایا تاسو غواړئ له سیستم څخه وتلئ؟',
    'ConfirmBtn': 'وتون',
    'CancelBtn': 'لغوه کول',
    /*---- /. LOGOUT POPUP -----*/
    /*----- PATIENTS -----*/
    'Search': 'لټون...',
    'GenPresc': 'نسخه ورکول',
    'AddNewPatient': 'نوی ناروغ اضافه کړئ',
    'DeletePatientTitle': 'لرې کړئ',
    'ConfirmDelete': 'ایا تاسو غواړئ دا ناروغ حذف کړئ؟',
    'DeleteSuccess': 'ناروغ لرې شو.',
    'PatientReg': 'د ناروغانو ثبتول',
    'َPatientPersInfo': 'د ناروغ شخصي معلومات',
    'َDentalService': 'اړین خدمتونه',
    'َServiceFee': 'فیس',
    'Step1Msg':
        'مهرباني وکړئ د ناروغ شخصي معلومات په احتیاط سره په لاندې برخو کې دننه کړئ.',
    'NextBtn': 'دوام',
    'PrevBtn': 'مخکینی',
    'AddBtn': 'راجستر',
    'BloodGroup': 'د وینې ګروپ',
    'SelectAge': 'مهرباني وکړئ عمر وټاکئ.',
    'NoAge': 'هیڅ عمر نه دی ټاکل شوی.',
    'RegDate': 'د ثبت نیټه',
    'Appointments': 'ګمارنې',
    'Histories': 'د ناروغ روغتیا تاریخ',
    'FeeInstallment': 'فیس / قسطونه',
    'Retreatment': 'شاته تګ',
    'RetreatBtn': 'شاته تګ',
    'PatRecords': 'د ناروغانو ریکارډونه',
    'CreateRet4': 'شاته تګ جوړ کړئ لپاره ',
    'SelectDentist': 'دندان ساز غوره کړئ',
    'RetDateTime': 'شاته تګ نېټه او وخت',
    'RetReason': 'د شاته تګ سبب',
    'RetFee': 'د شاته تګ تادیه',
    'Ret4Free': 'بیاړه',
    'RetResult': 'د شاته تګ پایلې',
    'RetDetails': 'تفصیل',
    'RetReasonRequired': 'د شاته تګ سبب اړین دی.',
    'RetReasonLength':
        'د شاته تګ سبب باید لږ تر لږه 5 او زیاترلږه 40 حرفونه ولري.',
    'RetFeeRequired': 'مهرباني وکړئ د شاته تګ تادیه دننه کړئ.',
    'RetFeeLength': 'تادیه نشی کښی 50 افغانی لږ او 1000 افغانی ډیر نه وی',
    'OtherDDLDetail': 'مهرباني وکړئ د دې پایلې په اړه وضاحت وکړئ.',
    'OtherDDLLength': 'تشریحات باید لږترلږه 5 او زیاترلږه 40 حرفونه ولري.',
    'RetSuccessMsg': 'د دې ملاقات شاته تګ ورکړ شو.',
    'RetFailMsg': 'شاته تګ اضافه کول ناکام شو. بیا هڅه وکړئ.',
    'DeleteAHeading': 'د ملاقات ړنګول',
    'ConfirmDelAppt': 'ایا تاسو ډاډه یاست چې تاسو دا ملاقات حذف کول غواړئ؟',
    'DeleteSuccessMsg': 'ړنګ شوی!',
    'FeeInst4': 'فیس او قسطونه پورې اړه لري: ',
    'Appt4': 'ګمارنې پورې اړه لري: ',
    'HealthHistory4': 'اړونده روغتیا تاریخ: ',
    'Installments': 'قسطونه',
    'Installment': 'قسط',
    'WholeFP': 'ټول فیس ترلاسه شوی',
    'EarnedBy': 'اخیستونکی: ',
    'Earn': 'فیس ترلاسه کړئ',
    'ServiceDone': 'خدمتونه ترسره شول',
    'Procedure': 'د کار طریقه',
    'Teeth': 'ټاکل شوي غاښونه',
    'Gum': 'ټاکل شوی ګوم',
    'BleachStep': 'د بلیچ کولو ګامونه',
    'Materials': 'کارول شوي توکي',
    'AffectArea': 'تخریب شوې سیمه',
    'Round': 'ګرځول',
    'Dentist': 'ډاکټر درملنه',
    'FeeDialogHeading': 'د ناروغ فیس ترلاسه کول',
    'FormHintMsg':
        'مهرباني وکړئ په لاندې ساحه کې اړوند ارزښتونه په احتیاط سره دننه کړئ.',
    'FeeDateRequired': 'د فیس تادیه نیټه اړینه ده.',
    'PayDate': 'د تادیاتو نیټه',
    'PayInstallment': 'د تادیاتو قسط',
    'PayAmountRequired': 'د تادیاتو مقدار اړین دی.',
    'PayAmountValid': 'ترلاسه شوی فیس باید د پاتې فیس څخه کم یا مساوي وي.',
    'LastInstallment': 'دا وروستی قسط دی. ټول مقدار ته اړتیا ده.',
    'PayAmount': 'ترلاسه شوي مقدار',
    'TotalFee': 'ټول فیس',
    'ReceivableFee': 'پاتې فیس',
    'ValidPayDateMsg': 'نیټه باید د تیر تادیې نیټې څخه زیاته یا مساوي وي.',
    'FeeReceivedBy': 'فیس اخیستونکی',
    'HealthHHeading': 'د روغتیا تاریخ بدلول ',
    'DiagResult': 'د معایناتو پایله',
    'DiagDate': 'د تشخیص / معایناتو نیټه',
    'HistoryLevel': 'شدت/ کچه',
    'HistoryDuration': 'موده',
    'Positive': 'مثبته پایله',
    'Xray4': 'اړونده اکسری: ',
    'UploadXray': 'د اکسری / غاښونو اړوند انځورونه پورته کول',
    'XrayFileRequired': 'مهرباني وکړئ د اکسری فایل یا عکس غوره کړئ.',
    'XrayDate': 'د اکسری نیټه',
    'XrayType': 'د اکسری ډول:',
    'XrayDateRequired': 'نیټه اړینه ده.',
    'DupXrayMsg':
        'د دې نوم سره اکسری لا دمخه په سیسټم کې شتون لري. نو یا د دې فایل نوم بدل کړئ یا بل فایل غوره کړئ او بیا یې اپلوډ کړئ.',
    'XraySizeMsg': 'د اکسری فایل اندازه باید د 10 MB څخه کم وي.',
    'XrayUploadBtn': 'پورته کول',
    'XrayPath': 'د ټولو اکسری فایلونو پته چې تر دې دمه اپلوډ شوي دي: ',
    'XrayNotFound': 'هیڅ اکسری ونه موندل شو.',
    'UploadedAt': 'د پورته کولو نیټه:',
    'PrevXray': 'مخکینی انځور',
    'NextXray': 'بل انځور',
    'XrayDetails': 'د اکسری توضیحات',
    /*-----/. PATIENTS -----*/
    /*-------- STAFF ------- */
    'AllStaff': 'ټول کارکوونکي',
    'Photo': 'انځور',
    'Salary': 'د معاش اندازه',
    'Tazkira': 'تذکره نمبر',
    'Position': 'موقف',
    'Address': 'پته',
    'Actions': 'کړنې',
    'AddNewStaff': 'نوي کارکوونکي اضافه کړئ',
    'StaffDetail': 'جزییات',
    'StaffUA': 'د کارن حساب',
    'StaffReg': 'د نویو کارکوونکو ثبتول',
    'StaffRegMsg':
        'مهرباني وکړئ په لاندې برخو کې د نوي کارمند معلومات په احتیاط سره دننه کړئ.',
    'FNRequired': 'نوم اړین دی.',
    'RequireUserName': 'د کارن نوم اړین دی.',
    'FNLength': 'نوم باید د 3 او 10 حروفو ترمنځ وي.',
    'LNLength': 'تخلص باید د 3 او 10 حروفو ترمنځ وي.',
    'PhoneRequired': 'د تماس شمیره اړینه ده.',
    'Phone10': 'د اړیکې شمیره باید 10 عدده وي.',
    'Phone12': 'د اړیکو شمیره د هیواد کوډ سره باید 12 عدده وي.',
    'ValidPhone': 'د تماس شمیره ناسمه ده.',
    'ValidSalary': 'د معاش اندازه باید د 1000 څخه تر 100000 پورې وي.',
    'ValidTazkira': 'تذکره نمبر باید د xxxx-xxxx-xxxx بڼه ولري.',
    'StaffRegSuccess': 'کارمند په بریالیتوب سره ثبت شو.',
    'ChangeUAHeader': 'د کارونکي حساب بدل کړئ',
    'ConfirmPassword': 'پټنوم تایید کړه',
    'ChooseRole': 'وړتوبونه',
    'SaveUABtn': 'ترسره شوی',
    'RequirePassword': 'پټنوم اړین دی',
    'UserNameLength': 'د کارن نوم باید لږترلږ 6 او اعظمي 10 حروف وي.',
    'RequirePwdConfirm': 'د پټنوم تایید ته اړتیا ده.',
    'PasswordLength': 'پټنوم باید لږترلږه 8 حروف اوږد وي.',
    'ConfirmPwdMsg': 'پټنوم سره سمون نه خوري. بیا هڅه وکړه.',
    'UpdateUAMsg': 'د کارن حساب په بریالیتوب سره بدل شوی.',
    'CreateUAHeader': 'د کارن حساب جوړ کړئ',
    'StaffEditMsg': 'بدلونونه په بریالیتوب سره ترسره شول.',
    'StaffEditErrMsg': 'تاسو هیڅ بدلون نه دی کړی.',
    'ConfirmStaffDelete': 'ایا تاسو غواړئ دا کارمند حذف کړئ؟',
    'DeleteStaffMsg': 'کارمند په بریالیتوب سره ړنګ شو.',
    /*--------/. STAFF ------- */
    /*----- SHARED VALUES -----*/
    'FName': 'نوم',
    'LName': 'تخلص',
    'Age': 'عمر',
    'Sex': 'جندر',
    'Marital': 'مدني حالت',
    'Phone': 'د تماس شمېره',
    'Details': 'تفصیل',
    'Edit': 'سم کول',
    'Delete': 'ړنګول',
    'GoToDashboard': 'ډشبورډ ته لاړ شئ',
    'RegBtn': 'راجستر',
    'GoBack': 'پخوانۍ پاڼې ته لاړ شئ',
    'Year': 'کال',
    'Single': 'مجرد',
    'Married': 'واده شوی',
    'NotAvable': 'نامعلوم',
    'Male': 'نارینه',
    'Female': 'ښځه',
    'AddrLength': 'پته باید لږترلږه 5 او تر 40 حروفو پورې وي.',
    /*-----/. SHARED VALUES -----*/
    /*---- SETTINGS -----*/
    'PersonalInfo': 'شخصي معلمات',
    'MyProfile': 'زما پروفایل',
    'Security': 'امنیت',
    'ChangePwd': 'پټ نوم بدل کړی',
    'Sync': 'همغږي',
    'Backup': 'بیک اپ',
    'Restore': 'بیا رغونه',
    'SysRelated': 'د سیسټم سره تړاو لري',
    'Theme': 'موضوعات',
    'Languages': 'ژبه',
    'ChangeProfilePhoto': 'د پروفایل انځور بدل کړئ',
    /*----/. SETTINGS -----*/
    /*---------- USER PROFILE -----------*/
    'MyProfileHeading': 'زما شخصي معلومات سم کړئ',
    'ChgMyPInfo': 'د شخصي معلومات سم کړئ',
    'LblCurrNewPwd': 'خپل اوسنی او نوی پټنوم په ا حتیاط سره دننه کړئ.',
    'CurrPwdRequired': 'ستاسو اوسنی پټنوم اړتیا ده.',
    'Pwd6': 'پټنوم باید به وروستي 6 حروف کی وي.',
    'NewPwdRequired': 'خپل نوی پټنوم دننه کړئ',
    'NewPwdConfirm': 'خپل نوی پټنوم تایید کړئ',
    'NewPwdNotMatch': 'ستاسو نوی پټنوم سره سمون ته خوري.',
    'PwdHint': 'دا پټنوم باید د نوی پټنوم په څیر وي.',
    'InvalidCurrPwd': 'ستاسو اوسنی پټنوم ناسمه ده.',
    'CurrPwd': 'اوسنی پټنوم',
    'NewPwd': 'نوی پټنوم',
    'ConfirmNewPwd': 'نوی پټنوم تایید',
    'ChangeBtn': 'پټنوم بدلول',
    'PwdSuccessMsg': 'د پټنوم بدلول بریالي وو.',
    'BackupCautMsg':
        'احتیاط! د دې لپاره چې ستاسو د کلینیک ټول معلومات له منځه نه یوسي، مهرباني وکړئ د ملاتړ فایل په یو خوندي ځای کې په لاندې ډول وي خوندي کړئ:',
    'Storage1': 'د بادل حافظه لکه Google Drive یا Microsoft OneDrive.',
    'Storage2': 'بهرنۍ حافظه لکه هارډډیسک.',
    'CreateBackup': 'د بیک اپ فایل جوړول',
    'BackupCreatMsg': 'بیک اپ فایل جوړ شوی په: ',
    'RestoreBackup': 'د بیک اپ فایل بیا رغونه',
    'RestoreSuccessMsg': 'بیا رغونه ترسره شوه.',
    'RestoreMsg':
        'پاملرنه! ډاډ ترلاسه کړئ چې د بیا رغونې کولو دمخه د بیک اپ فایل شتون لري.',
    'WaitMsg': 'انتظار وکړئ...',
    'BackupNotSelected': 'تاسو هیڅ بیک اپ فایل نه دی غوره کړی.',
    'RestoreNotNeeded': 'بیا رغونه ته اړتیا نشته. دا ریکارډونه په سیسټم کې دي.',
    /*----------/. USER PROFILE -----------*/

    // Add other Pashto translations here
  },
  // Add other languages here
};
