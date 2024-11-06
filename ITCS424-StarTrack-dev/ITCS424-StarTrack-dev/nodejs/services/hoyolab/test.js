const { Hoyolab } = require('./hoyolab-api')
const Language = require('./lang/lang')
const { langEnum } = require('./lang/lang-interface')

var cookie = '_MHYUUID=1f8e5683-b1e6-44ae-800e-ce2f90ec25be; HYV_LOGIN_PLATFORM_OPTIONAL_AGREEMENT={%22content%22:[]}; DEVICEFP_SEED_ID=feaa2023c12cae56; DEVICEFP_SEED_TIME=1694144039602; G_ENABLED_IDPS=google; _ga_Y5SZ86WZQH=GS1.1.1695625727.4.0.1695625727.0.0.0; _ga_SBYZMHZRMJ=GS1.1.1695625728.4.0.1695625728.0.0.0; hoyolab_color_scheme=system; _ga=GA1.2.1138124864.1694416698; _ga_JTLS2F53NR=GS1.1.1705024522.1.1.1705024527.0.0.0; _ga_GFC5HN79FG=GS1.1.1705024522.1.1.1705024527.0.0.0; mi18nLang=en-us; HYV_LOGIN_PLATFORM_TRACKING_MAP={%22sourceValue%22:%22491%22}; DEVICEFP=38d7f0d395564; cookie_token_v2=v2_CAQSDGNpZWJod3pwcnBxOBokMWY4ZTU2ODMtYjFlNi00NGFlLTgwMGUtY2UyZjkwZWMyNWJlINmchq8GKJmhheMHMNnbrCxCDGhrcnBnX2dsb2JhbA; account_mid_v2=1gojv4kl3b_hy; account_id_v2=93007321; ltoken_v2=v2_CAISDGNpZWJod3pwcnBxOBokMWY4ZTU2ODMtYjFlNi00NGFlLTgwMGUtY2UyZjkwZWMyNWJlINmchq8GKKSpu_wFMNnbrCxCDGhrcnBnX2dsb2JhbA; ltmid_v2=1gojv4kl3b_hy; ltuid_v2=93007321; HYV_LOGIN_PLATFORM_LOAD_TIMEOUT={}; HYV_LOGIN_PLATFORM_LIFECYCLE_ID={%22value%22:%229c54ef24-89c4-48a0-ba99-ed5e4da1eb00%22}'
const hoyo = new Hoyolab({
    cookie: {
        cookie: cookie
    },
    //ang: 'en-us'
})

async function main() {
    const test = await hoyo.gameRecordCard()
console.log(test)
}

main()
