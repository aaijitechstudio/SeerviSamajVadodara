import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi')
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Seervi Kshatriya Samaj'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @guestMode.
  ///
  /// In en, this message translates to:
  /// **'Guest Mode'**
  String get guestMode;

  /// No description provided for @limitedAccess.
  ///
  /// In en, this message translates to:
  /// **'Limited access. Login for full features.'**
  String get limitedAccess;

  /// No description provided for @becomeVerifiedMember.
  ///
  /// In en, this message translates to:
  /// **'Become a Verified Member'**
  String get becomeVerifiedMember;

  /// No description provided for @getFullAccess.
  ///
  /// In en, this message translates to:
  /// **'Get full access to member directory, contact details, and more features.'**
  String get getFullAccess;

  /// No description provided for @loginRegister.
  ///
  /// In en, this message translates to:
  /// **'Login / Register'**
  String get loginRegister;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @committee.
  ///
  /// In en, this message translates to:
  /// **'Committee'**
  String get committee;

  /// No description provided for @helpline.
  ///
  /// In en, this message translates to:
  /// **'Helpline'**
  String get helpline;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @memberDirectory.
  ///
  /// In en, this message translates to:
  /// **'Member Directory'**
  String get memberDirectory;

  /// No description provided for @newsAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get newsAnnouncements;

  /// No description provided for @committeeMembers.
  ///
  /// In en, this message translates to:
  /// **'Committee Members'**
  String get committeeMembers;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeUser(String name);

  /// No description provided for @samajTitle.
  ///
  /// In en, this message translates to:
  /// **'Shri Seervi Kshatriya Samaj'**
  String get samajTitle;

  /// No description provided for @samajVadodara.
  ///
  /// In en, this message translates to:
  /// **'Vadodara'**
  String get samajVadodara;

  /// No description provided for @aaiMataPrasad.
  ///
  /// In en, this message translates to:
  /// **'શ્રી ઐઈ માતા પ્રસાદતા:।।'**
  String get aaiMataPrasad;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @registerMembersOnly.
  ///
  /// In en, this message translates to:
  /// **'Register (Members Only)'**
  String get registerMembersOnly;

  /// No description provided for @guestUsersCanBrowse.
  ///
  /// In en, this message translates to:
  /// **'Guest users can browse limited data'**
  String get guestUsersCanBrowse;

  /// No description provided for @noMembersFound.
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get noMembersFound;

  /// No description provided for @loginToViewDirectory.
  ///
  /// In en, this message translates to:
  /// **'Login to view member directory'**
  String get loginToViewDirectory;

  /// No description provided for @searchByNameHouseId.
  ///
  /// In en, this message translates to:
  /// **'Search by name, house ID, area, profession...'**
  String get searchByNameHouseId;

  /// No description provided for @filterMembers.
  ///
  /// In en, this message translates to:
  /// **'Filter Members'**
  String get filterMembers;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @profession.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get profession;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @memberDetails.
  ///
  /// In en, this message translates to:
  /// **'Member Details'**
  String get memberDetails;

  /// No description provided for @houseId.
  ///
  /// In en, this message translates to:
  /// **'House ID'**
  String get houseId;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @familyMembers.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembers;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @noUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events'**
  String get noUpcomingEvents;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @noAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet'**
  String get noAnnouncements;

  /// No description provided for @pinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinned;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'By'**
  String get by;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @medicalEmergency.
  ///
  /// In en, this message translates to:
  /// **'Medical Emergency'**
  String get medicalEmergency;

  /// No description provided for @samajHelpline.
  ///
  /// In en, this message translates to:
  /// **'Samaj Helpline'**
  String get samajHelpline;

  /// No description provided for @samajOffice.
  ///
  /// In en, this message translates to:
  /// **'Samaj Office'**
  String get samajOffice;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMember;

  /// No description provided for @addAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Add Announcement'**
  String get addAnnouncement;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get addEvent;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL (optional)'**
  String get imageUrl;

  /// No description provided for @pinAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Pin Announcement'**
  String get pinAnnouncement;

  /// No description provided for @selectEventDate.
  ///
  /// In en, this message translates to:
  /// **'Select Event Date'**
  String get selectEventDate;

  /// No description provided for @selectEventTime.
  ///
  /// In en, this message translates to:
  /// **'Select Event Time'**
  String get selectEventTime;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @verifiedMember.
  ///
  /// In en, this message translates to:
  /// **'Verified Member'**
  String get verifiedMember;

  /// No description provided for @pleaseSelectEventDate.
  ///
  /// In en, this message translates to:
  /// **'Please select event date'**
  String get pleaseSelectEventDate;

  /// No description provided for @memberAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Member added successfully'**
  String get memberAddedSuccessfully;

  /// No description provided for @announcementAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Announcement added successfully'**
  String get announcementAddedSuccessfully;

  /// No description provided for @eventAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Event added successfully'**
  String get eventAddedSuccessfully;

  /// No description provided for @memberVerified.
  ///
  /// In en, this message translates to:
  /// **'Member verified'**
  String get memberVerified;

  /// No description provided for @memberDeleted.
  ///
  /// In en, this message translates to:
  /// **'Member deleted'**
  String get memberDeleted;

  /// No description provided for @deleteMember.
  ///
  /// In en, this message translates to:
  /// **'Delete Member'**
  String get deleteMember;

  /// No description provided for @areYouSureDeleteMember.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this member?'**
  String get areYouSureDeleteMember;

  /// No description provided for @noMembersFoundAdmin.
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get noMembersFoundAdmin;

  /// No description provided for @noAnnouncementsFound.
  ///
  /// In en, this message translates to:
  /// **'No announcements found'**
  String get noAnnouncementsFound;

  /// No description provided for @noEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No events found'**
  String get noEventsFound;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// No description provided for @adminPrivilegesRequired.
  ///
  /// In en, this message translates to:
  /// **'Admin privileges required.'**
  String get adminPrivilegesRequired;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @gujarati.
  ///
  /// In en, this message translates to:
  /// **'ગુજરાતી'**
  String get gujarati;

  /// Full app title with location
  ///
  /// In en, this message translates to:
  /// **'{samajTitle} - {samajVadodara}'**
  String appTitle(String samajTitle, String samajVadodara);

  /// No description provided for @directory.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get directory;

  /// No description provided for @limited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get limited;

  /// No description provided for @announcements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @panel.
  ///
  /// In en, this message translates to:
  /// **'Panel'**
  String get panel;

  /// No description provided for @createPost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

  /// No description provided for @addVideo.
  ///
  /// In en, this message translates to:
  /// **'Add Video'**
  String get addVideo;

  /// No description provided for @joinOurCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join Our Community'**
  String get joinOurCommunity;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account to get started'**
  String get createYourAccount;

  /// No description provided for @iAgreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms and Conditions'**
  String get iAgreeToTerms;

  /// No description provided for @goToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Go to Sign In →'**
  String get goToSignIn;

  /// No description provided for @pleaseAgreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms and Conditions'**
  String get pleaseAgreeToTerms;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterFullName;

  /// No description provided for @nameMustBeAtLeast2.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMustBeAtLeast2;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @pleaseEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhone;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMustBeAtLeast6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @trustRegistrationNo.
  ///
  /// In en, this message translates to:
  /// **'Trust Registration No.'**
  String get trustRegistrationNo;

  /// No description provided for @trustRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'A/3256, Vadodara'**
  String get trustRegistrationNumber;

  /// No description provided for @trustRegistrationDate.
  ///
  /// In en, this message translates to:
  /// **'Date: 8/12/2016'**
  String get trustRegistrationDate;

  /// No description provided for @established.
  ///
  /// In en, this message translates to:
  /// **'Established'**
  String get established;

  /// No description provided for @establishedYear.
  ///
  /// In en, this message translates to:
  /// **'2014'**
  String get establishedYear;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @trustInfo.
  ///
  /// In en, this message translates to:
  /// **'Trust Information'**
  String get trustInfo;

  /// No description provided for @aaiMataAarti.
  ///
  /// In en, this message translates to:
  /// **'Maa Shree Aai Mataji Ki Aarti'**
  String get aaiMataAarti;

  /// No description provided for @viewAarti.
  ///
  /// In en, this message translates to:
  /// **'View Aarti'**
  String get viewAarti;

  /// No description provided for @aarti.
  ///
  /// In en, this message translates to:
  /// **'Aarti'**
  String get aarti;

  /// No description provided for @devotionalInvocations.
  ///
  /// In en, this message translates to:
  /// **'Devotional Invocations'**
  String get devotionalInvocations;

  /// No description provided for @shriGaneshayaNamah.
  ///
  /// In en, this message translates to:
  /// **'।। श्री गणेशाय नमः ।।'**
  String get shriGaneshayaNamah;

  /// No description provided for @shriAaiMatajiNamah.
  ///
  /// In en, this message translates to:
  /// **'।। श्री आईमाताजी नमः ।।'**
  String get shriAaiMatajiNamah;

  /// No description provided for @shriKhetlajiNamah.
  ///
  /// In en, this message translates to:
  /// **'।। श्री खेतलाजी नमः ।।'**
  String get shriKhetlajiNamah;

  /// No description provided for @shriCharbhujaJiNamah.
  ///
  /// In en, this message translates to:
  /// **'।। श्री चारभुजा जी नमः ।।'**
  String get shriCharbhujaJiNamah;

  /// No description provided for @executiveCommittee.
  ///
  /// In en, this message translates to:
  /// **'Executive Committee'**
  String get executiveCommittee;

  /// No description provided for @executiveMembers.
  ///
  /// In en, this message translates to:
  /// **'Executive Members'**
  String get executiveMembers;

  /// No description provided for @president.
  ///
  /// In en, this message translates to:
  /// **'President'**
  String get president;

  /// No description provided for @vicePresident.
  ///
  /// In en, this message translates to:
  /// **'Vice President'**
  String get vicePresident;

  /// No description provided for @treasurer.
  ///
  /// In en, this message translates to:
  /// **'Treasurer'**
  String get treasurer;

  /// No description provided for @assistantTreasurer.
  ///
  /// In en, this message translates to:
  /// **'Assistant Treasurer'**
  String get assistantTreasurer;

  /// No description provided for @secretary.
  ///
  /// In en, this message translates to:
  /// **'Secretary'**
  String get secretary;

  /// No description provided for @assistantSecretary.
  ///
  /// In en, this message translates to:
  /// **'Assistant Secretary'**
  String get assistantSecretary;

  /// No description provided for @advisor.
  ///
  /// In en, this message translates to:
  /// **'Advisor'**
  String get advisor;

  /// No description provided for @assistantAdvisor.
  ///
  /// In en, this message translates to:
  /// **'Assistant Advisor'**
  String get assistantAdvisor;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @assistantManager.
  ///
  /// In en, this message translates to:
  /// **'Assistant Manager'**
  String get assistantManager;

  /// No description provided for @noCommitteeMembersYet.
  ///
  /// In en, this message translates to:
  /// **'No committee members added yet'**
  String get noCommitteeMembersYet;

  /// No description provided for @committeeError.
  ///
  /// In en, this message translates to:
  /// **'Error loading committee members'**
  String get committeeError;

  /// No description provided for @aartiVerse1.
  ///
  /// In en, this message translates to:
  /// **'जय आई श्री, जय आई श्री, जय आई श्री माता।\nअंबापुर में प्रगटी, नरलाई में रही।\nभैंसाणा में बैठी, बिलाड़ा में रही।\nमेवाड़ में रही, जोधपुर में रही।\nगुजरात में रही, जय आई श्री।'**
  String get aartiVerse1;

  /// No description provided for @aartiVerse2.
  ///
  /// In en, this message translates to:
  /// **'जय आई श्री, जय आई श्री, जय आई श्री माता।\nचमत्कार दिखाए, भक्तों को बचाया।\nदुःख दूर किए, सुख दिया सबको।\nकृपा की बरसात, जय आई श्री।'**
  String get aartiVerse2;

  /// No description provided for @aartiVerse3.
  ///
  /// In en, this message translates to:
  /// **'जय आई श्री, जय आई श्री, जय आई श्री माता।\nआई माता की जय, आई माता की जय।\nसबका कल्याण करो, सबका भला करो।\nआई माता की जय, जय आई श्री।'**
  String get aartiVerse3;

  /// No description provided for @communityRequest.
  ///
  /// In en, this message translates to:
  /// **'All brothers and sisters of the community are requested to take a holiday on Bhadvi Beej and to come in traditional attire.'**
  String get communityRequest;

  /// No description provided for @submittedBy.
  ///
  /// In en, this message translates to:
  /// **'Submitted by'**
  String get submittedBy;

  /// No description provided for @operatingOrganization.
  ///
  /// In en, this message translates to:
  /// **'Operating Organization'**
  String get operatingOrganization;

  /// No description provided for @shreeSeerviKshatriyaSamaj.
  ///
  /// In en, this message translates to:
  /// **'Shree Seervi Kshatriya Samaj'**
  String get shreeSeerviKshatriyaSamaj;

  /// No description provided for @vadodaraGujarat.
  ///
  /// In en, this message translates to:
  /// **'Vadodara, Gujarat'**
  String get vadodaraGujarat;

  /// No description provided for @todaysDate.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Date'**
  String get todaysDate;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @dailyInfoNote.
  ///
  /// In en, this message translates to:
  /// **'Daily information will be updated with Tithi and Chogadiya soon'**
  String get dailyInfoNote;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @samajHistory.
  ///
  /// In en, this message translates to:
  /// **'Samaj History'**
  String get samajHistory;

  /// No description provided for @historyContent.
  ///
  /// In en, this message translates to:
  /// **'The Seervi Kshatriya Samaj Vadodara was established with the vision of bringing together the Seervi Kshatriya community in Vadodara. Our organization has been working tirelessly to preserve our cultural heritage, support community members, and foster unity among all members.'**
  String get historyContent;

  /// No description provided for @keyMilestones.
  ///
  /// In en, this message translates to:
  /// **'Key Milestones'**
  String get keyMilestones;

  /// No description provided for @milestone1.
  ///
  /// In en, this message translates to:
  /// **'2014 - Establishment'**
  String get milestone1;

  /// No description provided for @milestone1Description.
  ///
  /// In en, this message translates to:
  /// **'The Samaj was officially established in Vadodara, Gujarat, marking the beginning of our organized community efforts.'**
  String get milestone1Description;

  /// No description provided for @milestone2.
  ///
  /// In en, this message translates to:
  /// **'2016 - Trust Registration'**
  String get milestone2;

  /// No description provided for @milestone2Description.
  ///
  /// In en, this message translates to:
  /// **'The organization was registered as a trust (Registration No. A/3256, Vadodara) on 8th December 2016, formalizing our commitment to community service.'**
  String get milestone2Description;

  /// No description provided for @milestone3.
  ///
  /// In en, this message translates to:
  /// **'Ongoing - Community Growth'**
  String get milestone3;

  /// No description provided for @milestone3Description.
  ///
  /// In en, this message translates to:
  /// **'We continue to grow and serve our community through various programs, events, and initiatives that strengthen our bonds and preserve our traditions.'**
  String get milestone3Description;

  /// No description provided for @getInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in Touch'**
  String get getInTouch;

  /// No description provided for @officeAddress.
  ///
  /// In en, this message translates to:
  /// **'Office Address'**
  String get officeAddress;

  /// No description provided for @officeAddressDetails.
  ///
  /// In en, this message translates to:
  /// **'Seervi Kshatriya Samaj Vadodara\nVadodara, Gujarat, India'**
  String get officeAddressDetails;

  /// No description provided for @phoneNumberDetails.
  ///
  /// In en, this message translates to:
  /// **'+91-XXXXXXXXXX'**
  String get phoneNumberDetails;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailAddressDetails.
  ///
  /// In en, this message translates to:
  /// **'info@seervisamajvadodara.org'**
  String get emailAddressDetails;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @websiteDetails.
  ///
  /// In en, this message translates to:
  /// **'www.seervisamajvadodara.org'**
  String get websiteDetails;

  /// No description provided for @aboutSamaj.
  ///
  /// In en, this message translates to:
  /// **'About Seervi Kshatriya Samaj'**
  String get aboutSamaj;

  /// No description provided for @aboutContent.
  ///
  /// In en, this message translates to:
  /// **'The Seervi Kshatriya Samaj Vadodara is a community organization dedicated to preserving and promoting the rich cultural heritage of the Seervi Kshatriya community. We strive to create a strong, united, and supportive community that honors our traditions while embracing modern values.'**
  String get aboutContent;

  /// No description provided for @ourMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get ourMission;

  /// No description provided for @missionContent.
  ///
  /// In en, this message translates to:
  /// **'To unite the Seervi Kshatriya community in Vadodara, preserve our cultural heritage, support community members in their personal and professional growth, and foster a sense of belonging and mutual respect among all members.'**
  String get missionContent;

  /// No description provided for @ourVision.
  ///
  /// In en, this message translates to:
  /// **'Our Vision'**
  String get ourVision;

  /// No description provided for @visionContent.
  ///
  /// In en, this message translates to:
  /// **'To be a leading community organization that serves as a bridge between tradition and modernity, creating opportunities for growth, learning, and cultural preservation while building a strong, supportive network of community members.'**
  String get visionContent;

  /// No description provided for @ourValues.
  ///
  /// In en, this message translates to:
  /// **'Our Values'**
  String get ourValues;

  /// No description provided for @valuesContent.
  ///
  /// In en, this message translates to:
  /// **'We are committed to unity, respect, cultural preservation, community service, mutual support, and the overall well-being of all Seervi Kshatriya community members in Vadodara and beyond.'**
  String get valuesContent;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToYourAccount;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureLogout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to access your account.'**
  String get logoutConfirmation;

  /// No description provided for @connectWithCommunity.
  ///
  /// In en, this message translates to:
  /// **'Connect with community members'**
  String get connectWithCommunity;

  /// No description provided for @stayUpdated.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with upcoming events'**
  String get stayUpdated;

  /// No description provided for @latestAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Get latest news and announcements'**
  String get latestAnnouncements;

  /// No description provided for @bySigningInYouAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our'**
  String get bySigningInYouAgreeTo;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @step1.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2'**
  String get step1;

  /// No description provided for @step2.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 2'**
  String get step2;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @additionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// No description provided for @gotra.
  ///
  /// In en, this message translates to:
  /// **'Gotra'**
  String get gotra;

  /// No description provided for @pleaseEnterGotra.
  ///
  /// In en, this message translates to:
  /// **'Please enter your gotra'**
  String get pleaseEnterGotra;

  /// No description provided for @vadodaraAddress.
  ///
  /// In en, this message translates to:
  /// **'Vadodara Address'**
  String get vadodaraAddress;

  /// No description provided for @pleaseEnterVadodaraAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Vadodara address'**
  String get pleaseEnterVadodaraAddress;

  /// No description provided for @nativeAddress.
  ///
  /// In en, this message translates to:
  /// **'Native Address'**
  String get nativeAddress;

  /// No description provided for @pleaseEnterNativeAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your native address (Rajasthan/MP)'**
  String get pleaseEnterNativeAddress;

  /// No description provided for @pratisthanName.
  ///
  /// In en, this message translates to:
  /// **'Pratisthan/Business Name'**
  String get pratisthanName;

  /// No description provided for @pleaseEnterPratisthanName.
  ///
  /// In en, this message translates to:
  /// **'Please enter pratisthan/business name'**
  String get pleaseEnterPratisthanName;

  /// No description provided for @profileImage.
  ///
  /// In en, this message translates to:
  /// **'Profile Image'**
  String get profileImage;

  /// No description provided for @selectProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Select Profile Image'**
  String get selectProfileImage;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove Image'**
  String get removeImage;

  /// No description provided for @signUpSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get signUpSuccess;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @notAssigned.
  ///
  /// In en, this message translates to:
  /// **'Not Assigned'**
  String get notAssigned;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @addressInformation.
  ///
  /// In en, this message translates to:
  /// **'Address Information'**
  String get addressInformation;

  /// No description provided for @businessInformation.
  ///
  /// In en, this message translates to:
  /// **'Business Information'**
  String get businessInformation;

  /// No description provided for @accountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get accountStatus;

  /// No description provided for @verificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Verification Status'**
  String get verificationStatus;

  /// No description provided for @pendingVerification.
  ///
  /// In en, this message translates to:
  /// **'Pending Verification'**
  String get pendingVerification;

  /// No description provided for @memberType.
  ///
  /// In en, this message translates to:
  /// **'Member Type'**
  String get memberType;

  /// No description provided for @viewIdCard.
  ///
  /// In en, this message translates to:
  /// **'View ID Card'**
  String get viewIdCard;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @socialSamajNews.
  ///
  /// In en, this message translates to:
  /// **'Social Samaj News'**
  String get socialSamajNews;

  /// No description provided for @vadodaraNews.
  ///
  /// In en, this message translates to:
  /// **'Vadodara News'**
  String get vadodaraNews;

  /// No description provided for @eNewspaper.
  ///
  /// In en, this message translates to:
  /// **'E-Newspaper'**
  String get eNewspaper;

  /// No description provided for @eNewspapers.
  ///
  /// In en, this message translates to:
  /// **'E-Newspapers'**
  String get eNewspapers;

  /// No description provided for @gujaratiNewspapers.
  ///
  /// In en, this message translates to:
  /// **'Gujarati Newspapers'**
  String get gujaratiNewspapers;

  /// No description provided for @rajasthanNewspapers.
  ///
  /// In en, this message translates to:
  /// **'Rajasthan Newspapers'**
  String get rajasthanNewspapers;

  /// No description provided for @englishNewspapers.
  ///
  /// In en, this message translates to:
  /// **'English Newspapers'**
  String get englishNewspapers;

  /// No description provided for @vadodaraNewspapers.
  ///
  /// In en, this message translates to:
  /// **'Vadodara E-Newspapers'**
  String get vadodaraNewspapers;

  /// No description provided for @noNewsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No news available'**
  String get noNewsAvailable;

  /// No description provided for @failedToLoadNews.
  ///
  /// In en, this message translates to:
  /// **'Failed to load news'**
  String get failedToLoadNews;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @publishedOn.
  ///
  /// In en, this message translates to:
  /// **'Published on'**
  String get publishedOn;

  /// No description provided for @apiKeyNotSet.
  ///
  /// In en, this message translates to:
  /// **'API key not configured. Please set your NewsData.io API key in vadodara_news_service.dart'**
  String get apiKeyNotSet;

  /// No description provided for @social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get social;

  /// No description provided for @socialNewsPaused.
  ///
  /// In en, this message translates to:
  /// **'Social News Temporarily Unavailable'**
  String get socialNewsPaused;

  /// No description provided for @socialNewsPausedDescription.
  ///
  /// In en, this message translates to:
  /// **'This section is currently being updated. Please check back soon or use the Vadodara News tab for the latest updates.'**
  String get socialNewsPausedDescription;

  /// No description provided for @businessNews.
  ///
  /// In en, this message translates to:
  /// **'Business News'**
  String get businessNews;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More Options'**
  String get moreOptions;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get changePasswordDescription;

  /// No description provided for @changePasswordFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Change password feature will be available soon.'**
  String get changePasswordFeatureComingSoon;

  /// No description provided for @themeModeFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Theme mode selection will be available soon.'**
  String get themeModeFeatureComingSoon;

  /// No description provided for @manageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Manage notification preferences'**
  String get manageNotifications;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @photoGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get photoGallery;

  /// No description provided for @noPhotosAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Photos Available'**
  String get noPhotosAvailable;

  /// No description provided for @photoGalleryEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Photos will be displayed here once they are added to the gallery.'**
  String get photoGalleryEmptyMessage;

  /// No description provided for @vadodaraPhotos.
  ///
  /// In en, this message translates to:
  /// **'Vadodara Photos'**
  String get vadodaraPhotos;

  /// No description provided for @aaijiDarshan.
  ///
  /// In en, this message translates to:
  /// **'Aaiji Darshan'**
  String get aaijiDarshan;

  /// No description provided for @noVadodaraPhotosAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Vadodara Photos Available'**
  String get noVadodaraPhotosAvailable;

  /// No description provided for @elevenNiyamTitle.
  ///
  /// In en, this message translates to:
  /// **'Shri Aimataji Bel Ke Gyarah Niyam'**
  String get elevenNiyamTitle;

  /// No description provided for @niyam1.
  ///
  /// In en, this message translates to:
  /// **'First, abandon falsehood, find happiness'**
  String get niyam1;

  /// No description provided for @niyam2.
  ///
  /// In en, this message translates to:
  /// **'Second, give up intoxication and meat'**
  String get niyam2;

  /// No description provided for @niyam3.
  ///
  /// In en, this message translates to:
  /// **'Third, do not take interest on money'**
  String get niyam3;

  /// No description provided for @niyam4.
  ///
  /// In en, this message translates to:
  /// **'Fourth, never gamble'**
  String get niyam4;

  /// No description provided for @niyam5.
  ///
  /// In en, this message translates to:
  /// **'Fifth, serve your parents'**
  String get niyam5;

  /// No description provided for @niyam6.
  ///
  /// In en, this message translates to:
  /// **'Sixth, be a god to guests'**
  String get niyam6;

  /// No description provided for @niyam7.
  ///
  /// In en, this message translates to:
  /// **'Seventh, obey the guru\'s command'**
  String get niyam7;

  /// No description provided for @niyam8.
  ///
  /// In en, this message translates to:
  /// **'Eighth, walk the path of welfare for others'**
  String get niyam8;

  /// No description provided for @niyam9.
  ///
  /// In en, this message translates to:
  /// **'Ninth, consider other women as mothers'**
  String get niyam9;

  /// No description provided for @niyam10.
  ///
  /// In en, this message translates to:
  /// **'Tenth, marry off daughters righteously'**
  String get niyam10;

  /// No description provided for @niyam11.
  ///
  /// In en, this message translates to:
  /// **'Eleventh, walk the path of righteousness with eleven knots'**
  String get niyam11;

  /// No description provided for @shree.
  ///
  /// In en, this message translates to:
  /// **'Shree'**
  String get shree;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get resetYourPassword;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordDescription;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email Sent!'**
  String get emailSent;

  /// No description provided for @emailSentDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to {email}. Please check your email and follow the instructions.'**
  String emailSentDescription(String email);

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent! Please check your inbox.'**
  String get passwordResetEmailSent;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @enablePushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Push Notifications'**
  String get enablePushNotifications;

  /// No description provided for @pushNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications on your device'**
  String get pushNotificationsDescription;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @enableEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Email Notifications'**
  String get enableEmailNotifications;

  /// No description provided for @emailNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications via email'**
  String get emailNotificationsDescription;

  /// No description provided for @notificationTypes.
  ///
  /// In en, this message translates to:
  /// **'Notification Types'**
  String get notificationTypes;

  /// No description provided for @eventsNotificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified about upcoming events'**
  String get eventsNotificationDescription;

  /// No description provided for @announcementsNotificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified about community announcements'**
  String get announcementsNotificationDescription;

  /// No description provided for @memberUpdates.
  ///
  /// In en, this message translates to:
  /// **'Member Updates'**
  String get memberUpdates;

  /// No description provided for @memberUpdatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified about new members and updates'**
  String get memberUpdatesDescription;

  /// No description provided for @newsUpdates.
  ///
  /// In en, this message translates to:
  /// **'News Updates'**
  String get newsUpdates;

  /// No description provided for @newsUpdatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified about community news'**
  String get newsUpdatesDescription;

  /// No description provided for @termsAndConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditionsTitle;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @acceptanceOfTerms.
  ///
  /// In en, this message translates to:
  /// **'1. Acceptance of Terms'**
  String get acceptanceOfTerms;

  /// No description provided for @acceptanceOfTermsContent.
  ///
  /// In en, this message translates to:
  /// **'By accessing and using the Seervi Kshatriya Samaj Vadodara mobile application, you accept and agree to be bound by the terms and provision of this agreement.'**
  String get acceptanceOfTermsContent;

  /// No description provided for @useLicense.
  ///
  /// In en, this message translates to:
  /// **'2. Use License'**
  String get useLicense;

  /// No description provided for @useLicenseContent.
  ///
  /// In en, this message translates to:
  /// **'Permission is granted to temporarily use the application for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.'**
  String get useLicenseContent;

  /// No description provided for @userAccount.
  ///
  /// In en, this message translates to:
  /// **'3. User Account'**
  String get userAccount;

  /// No description provided for @userAccountContent.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.'**
  String get userAccountContent;

  /// No description provided for @communityGuidelines.
  ///
  /// In en, this message translates to:
  /// **'4. Community Guidelines'**
  String get communityGuidelines;

  /// No description provided for @communityGuidelinesContent.
  ///
  /// In en, this message translates to:
  /// **'Users must respect all community members and follow community guidelines. Any violation may result in account suspension or termination.'**
  String get communityGuidelinesContent;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'5. Privacy'**
  String get privacy;

  /// No description provided for @privacyContent.
  ///
  /// In en, this message translates to:
  /// **'Your use of the application is also governed by our Privacy Policy. Please review our Privacy Policy to understand our practices.'**
  String get privacyContent;

  /// No description provided for @limitationOfLiability.
  ///
  /// In en, this message translates to:
  /// **'6. Limitation of Liability'**
  String get limitationOfLiability;

  /// No description provided for @limitationOfLiabilityContent.
  ///
  /// In en, this message translates to:
  /// **'The application and its content are provided \"as is\" without warranties of any kind. We shall not be liable for any damages arising from the use of the application.'**
  String get limitationOfLiabilityContent;

  /// No description provided for @changesToTerms.
  ///
  /// In en, this message translates to:
  /// **'7. Changes to Terms'**
  String get changesToTerms;

  /// No description provided for @changesToTermsContent.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify these terms at any time. Your continued use of the application after any changes constitutes acceptance of the new terms.'**
  String get changesToTermsContent;

  /// No description provided for @termsContactDescription.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about these Terms and Conditions, please contact us through the app\'s contact section.'**
  String get termsContactDescription;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @informationWeCollect.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get informationWeCollect;

  /// No description provided for @informationWeCollectContent.
  ///
  /// In en, this message translates to:
  /// **'We collect information that you provide directly to us, including:\n\n• Name, email address, and phone number\n• Profile information and photos\n• Community-related information\n• Device information and usage data'**
  String get informationWeCollectContent;

  /// No description provided for @howWeUseYourInformation.
  ///
  /// In en, this message translates to:
  /// **'2. How We Use Your Information'**
  String get howWeUseYourInformation;

  /// No description provided for @howWeUseYourInformationContent.
  ///
  /// In en, this message translates to:
  /// **'We use the information we collect to:\n\n• Provide and maintain the application\n• Send you notifications and updates\n• Improve our services\n• Communicate with you about community events'**
  String get howWeUseYourInformationContent;

  /// No description provided for @informationSharing.
  ///
  /// In en, this message translates to:
  /// **'3. Information Sharing'**
  String get informationSharing;

  /// No description provided for @informationSharingContent.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your personal information. We may share your information only:\n\n• With other community members (as per your privacy settings)\n• With service providers who assist us in operating the app\n• When required by law'**
  String get informationSharingContent;

  /// No description provided for @dataSecurity.
  ///
  /// In en, this message translates to:
  /// **'4. Data Security'**
  String get dataSecurity;

  /// No description provided for @dataSecurityContent.
  ///
  /// In en, this message translates to:
  /// **'We implement appropriate security measures to protect your personal information. However, no method of transmission over the internet is 100% secure.'**
  String get dataSecurityContent;

  /// No description provided for @yourRights.
  ///
  /// In en, this message translates to:
  /// **'5. Your Rights'**
  String get yourRights;

  /// No description provided for @yourRightsContent.
  ///
  /// In en, this message translates to:
  /// **'You have the right to:\n\n• Access your personal data\n• Correct inaccurate data\n• Request deletion of your data\n• Opt-out of certain communications'**
  String get yourRightsContent;

  /// No description provided for @childrensPrivacy.
  ///
  /// In en, this message translates to:
  /// **'6. Children\'s Privacy'**
  String get childrensPrivacy;

  /// No description provided for @childrensPrivacyContent.
  ///
  /// In en, this message translates to:
  /// **'Our application is not intended for children under 13 years of age. We do not knowingly collect personal information from children.'**
  String get childrensPrivacyContent;

  /// No description provided for @changesToThisPolicy.
  ///
  /// In en, this message translates to:
  /// **'7. Changes to This Policy'**
  String get changesToThisPolicy;

  /// No description provided for @changesToThisPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page.'**
  String get changesToThisPolicyContent;

  /// No description provided for @privacyContactDescription.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy, please contact us through the app\'s contact section.'**
  String get privacyContactDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'gu', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
