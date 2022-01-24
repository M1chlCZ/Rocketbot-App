library konjungate.globals;

bool isLoggedIn = false;
const String SERVER_URL = 'http://51.195.102.171:3000';
const String USERNAME = "username";
const String ID = "idUser";
const String ADR = "adr";
const String NICKNAME = "nickname";
const String LOCALE = "locale";
const String LEVEL = "level";
const String UDID = "udid";
const String TOKEN = "jwt";
const String PIN = "PIN";
const String ADMINPRIV = "admin";
const String FIRETOKEN = "firetoken";
const String LOGIN = "login";
const String PASS = "pass";
const String AUTH_TYPE = "AUTH_TYPE";
const String COUNTDOWN = "countdownTime";
const String LOCALE_APP = 'locale_app';

const String DB_NAME = "databazia";

const String APP_NOT = 'showMessages';

const List<String> LANGUAGES = ['English','Finnish','Czech'];
const List<String> LANGUAGES_CODES = ['en', 'fi_FI', 'cs_CZ'];

// ['English', 'Bosnian', 'Croatian', 'Czech', 'Finnish', 'German', 'Hindi', 'Japanese', 'Russian', 'Serbian Latin', 'Serbian Цyриллиц', 'Spanish', 'Panjabi'];
// ['en', 'bs_BA', 'hr_HR', 'cs_CZ', 'fi_FI', 'de_DE', 'hi_IN', 'ja_JP', 'ru_RU', 'sr_Latn_RS', 'sr_Cyrl_RS', 'es_ES' 'pa_IN'];
bool reloadData = false;