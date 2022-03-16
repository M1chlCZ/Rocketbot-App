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
const String SORT_TYPE = 'sortby';

const String DB_NAME = "databazia";

const String APP_NOT = 'showMessages';

const List<String> LANGUAGES = ['English','Finnish','Czech'];
const List<String> LANGUAGES_CODES = ['en', 'fi_FI', 'cs_CZ'];

const String TABLE_STAKE = "tableStake";
const String TS_ID = "id";
const String TS_PWG = "pwg";
const String TS_FINISHED = "txFinish";
const String TS_COINID = "idCoin";
const String TS_ADDR = "depAddr";
const String TS_AMOUNT = "amount";

const String TABLE_COIN = "tableCoin";
const String TC_ID = "id";
const String TC_RANK = "rank";
const String TC_NAME = "name";
const String TC_TICKER = "ticker";
const String TC_CRYPTO_ID = "cryptoId";
const String TC_IS_TOKEN = "isToken";
const String TC_CONTRACT_ADDR = "contractAddress";
const String TC_FEE_PERCENT = "feePercent";
const String TC_BLOCKCHAIN = "blockchain";
const String TC_MIN_WITHDRAW = "minWithdraw";
const String TC_IMAGE_BIG = "imageBig";
const String TC_IMAGE_SMALL = "imageSmall";
const String TC_IS_ACTIVE = "isActive";
const String TC_EXPLORER_URL = "explorerUrl";
const String TC_REQUIRED_CONF = "requiredConfirmations";
const String TC_FULL_NAME = "fullName";
const String TC_TOKEN_STANDARD = "tokenStandart";
const String TC_ALLOW_WITH = "allowWithdraws";
const String TC_ALLOW_DEP = "allowDeposits";



// ['English', 'Bosnian', 'Croatian', 'Czech', 'Finnish', 'German', 'Hindi', 'Japanese', 'Russian', 'Serbian Latin', 'Serbian Цyриллиц', 'Spanish', 'Panjabi'];
// ['en', 'bs_BA', 'hr_HR', 'cs_CZ', 'fi_FI', 'de_DE', 'hi_IN', 'ja_JP', 'ru_RU', 'sr_Latn_RS', 'sr_Cyrl_RS', 'es_ES' 'pa_IN'];
bool reloadData = false;