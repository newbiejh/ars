// Url 저장 파일

// 서버 url
String upload_url = "https://05cf-112-217-167-202.ngrok-free.app/upload";

// 아바타 url
String showroomtest_url =
    "https://avatarsync.df.nexon.com/wear/image/stand@2x.png?wearInfo=%7B%22job%22:%224%22,%22level%22:0,%22hair%22:%7B%22index%22:%22e0li%22,%20%22color%22:0%7D,%22cap%22:%7B%22index%22:%22wjww7i%22,%20%22color%22:0%7D,%22face%22:%7B%22index%22:%22hzai%22,%20%22color%22:0%7D,%22neck%22:%7B%22index%22:%22fn2r7i%22,%20%22color%22:0%7D,%22coat%22:%7B%22index%22:%22tssr7i%22,%20%22color%22:0%7D,%22belt%22:%7B%22index%22:%22whaw7i%22,%20%22color%22:0%7D,%22pants%22:%7B%22index%22:%22ox7r7i%22,%20%22color%22:0%7D,%22shoes%22:%7B%22index%22:%2242ow7i%22,%20%22color%22:0%7D,%22skin%22:%7B%22index%22:%2259yv7i%22,%20%22color%22:0%7D,%22weapon1%22:null,%22package%22:null,%22animation%22:%22Stand%22%7D";

// 부위별 아이템 아이콘 url
String item_icon_url =
    "https://bbscdn.df.nexon.com/data7/showroom/static/icon/";

// 경매장 아이템 가격 url
String price_url_front = "https://api.neople.co.kr/df/auction-sold?itemName=";
String price_url_end =
    "&wordType=<wordType>&wordShort=<wordShort>&limit=<limit>&apikey=KzbTKfwBlsuFjwOwn0SXGkoKwUK6O7Bn";

// json 테스트용
var testData = [
  {
    "part": "머리",
    "index": "569w7i",
    "name": "무림고수 묶음 머리[A타입]",
    "icon": "pr_ahair/00252.png",
  },
  {
    "part": "모자",
    "index": "1trw7i",
    "name": "요리부장의 프릴 밴드[A타입]",
    "icon": "pr_acap/00315.png",
  },
  {
    "part": "얼굴",
    "index": "6xiv7i",
    "name": "피어싱[A타입]",
    "icon": "pr_aface/00058.png",
  },
  {
    "part": "목가슴",
    "index": "fn2r7i",
    "name": "정열의 삼바 화려한 장식 날개[B타입]",
    "icon": "pr_aneck/00409.png",
  },
  {
    "part": "상의",
    "index": "sssr7i",
    "name": "스팀펑크 정장 상의[D타입]",
    "icon": "pr_acoat/00378.png",
  },
  {
    "part": "허리",
    "index": "whaw7i",
    "name": "해변의 로망 배꼽피어싱",
    "icon": "pr_abelt/00362.png",
  },
  {
    "part": "하의",
    "index": "4d7r7i",
    "name": "아시아 여행 중국 전통의상 하의[A타입]",
    "icon": "pr_apants/00577.png",
  },
  {
    "part": "신발",
    "index": "teow7i",
    "name": "용투사의 세무 앵클 부츠[D타입]",
    "icon": "pr_ashoes/00382.png",
  },
  {
    "part": "피부",
    "index": "0eyv7i",
    "name": "아시아 여행 몽골 프리스트 피부[B타입]",
    "icon": "pr_abody/00010.png",
  },
  //{
  //  "part": "무기",
  //  "index": "3fuv7i",
  //  "name": "해군 제독의 전투도끼",
  //  "icon": "axe/00149.png",
  //},
];
