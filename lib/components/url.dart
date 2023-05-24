// Url 저장 파일

// 서버 url
String upload_url = "https://05cf-112-217-167-202.ngrok-free.app/upload";
String history_check_url = "";
String avatar_save_url = "";

// 아바타 url
String showroom_url =
    "https://avatarsync.df.nexon.com/wear/image/stand@2x.png?wearInfo=%7B%22job%22:%224%22,%22level%22:0,%22hair%22:%7B%22index%22:%22h24w7i%22,%20%22color%22:0%7D,%22cap%22:%7B%22index%22:%22ygww7i%22,%20%22color%22:0%7D,%22face%22:%7B%22index%22:%223rjv7i%22,%20%22color%22:0%7D,%22neck%22:%7B%22index%22:%22fn2r7i%22,%20%22color%22:0%7D,%22coat%22:%7B%22index%22:%22i5ai%22,%20%22color%22:0%7D,%22belt%22:%7B%22index%22:%22kcmi%22,%20%22color%22:0%7D,%22pants%22:%7B%22index%22:%2292ai%22,%20%22color%22:0%7D,%22shoes%22:%7B%22index%22:%22x5mi%22,%20%22color%22:0%7D,%22skin%22:null,%22weapon1%22:null,%22package%22:null,%22animation%22:%22Stand%22%7D";

// 부위별 아이템 아이콘 url
String item_icon_url =
    "https://bbscdn.df.nexon.com/data7/showroom/static/icon/";

// 경매장 아이템 가격 url
String price_url_front = "https://api.neople.co.kr/df/auction-sold?itemName=";
String price_url_end =
    "&wordType=<wordType>&wordShort=<wordShort>&limit=<limit>&apikey=KzbTKfwBlsuFjwOwn0SXGkoKwUK6O7Bn";

// json 오프라인 자체 테스트용
var testData = [
  {
    "part": "머리",
    "index": "569w7i",
    "name": "진 퇴마사의 반곱슬 중단발 헤어[C타입]",
    "icon": "pr_ahair/00714.png",
    "itemId": "27b73df2f3510c776179f8d303274dc3",
    "price": "1개월 간 거래 없음",
  },
  {
    "part": "모자",
    "index": "1trw7i",
    "name": "둠스가디언의 데빌 후드[B타입]",
    "icon": "pr_acap/00382.png",
    "itemId": "e1c49fb08f5286cff607abf9af04057a",
    "price": "2000000",
  },
  {
    "part": "얼굴",
    "index": "6xiv7i",
    "name": "에테르나 란두스의 타락한 얼굴[D타입]",
    "icon": "pr_aface/00594.png",
    "itemId": "897ab9238a527e96f069419bf74dde02",
    "price": "1050000",
  },
  {
    "part": "목가슴",
    "index": "fn2r7i",
    "name": "정열의 삼바 화려한 장식 날개[B타입]",
    "icon": "pr_aneck/00409.png",
    "itemId": "a6033c44039a8eaf664af387a371913c",
    "price": "1330000",
  },
  {
    "part": "상의",
    "index": "sssr7i",
    "name": "인파이터 상갑[B타입]",
    "icon": "pr_acoat/00052.png",
    "itemId": "39db625dca715274a103a731fde145f7",
    "price": "1개월 간 거래 없음",
  },
  {
    "part": "허리",
    "index": "whaw7i",
    "name": "아라드 다방 옆트임 앞치마[A타입]",
    "icon": "pr_abelt/00153.png",
    "itemId": "941709693e3420b500d84db692dccebb",
    "price": "3000000",
  },
  {
    "part": "하의",
    "index": "4d7r7i",
    "name": "타이트팬츠[A타입]",
    "icon": "pr_apants/00017.png",
    "itemId": "11fe40a2cd189b807f12cf2dbcd41dc9",
    "price": "9999999",
  },
  {
    "part": "신발",
    "index": "teow7i",
    "name": "가죽워커[D타입]",
    "icon": "pr_ashoes/00160.png",
    "itemId": "e7b4d9c2f952eebc1445639eb5590f3c",
    "price": "1개월 간 거래 없음",
  },
];
