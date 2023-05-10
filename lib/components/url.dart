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
    "itemId": "27b73df2f3510c776179f8d303274dc3",
    "price": "1개월 간 거래 없음",
  },
  {
    "part": "모자",
    "index": "1trw7i",
    "name": "요리부장의 프릴 밴드[A타입]",
    "icon": "pr_acap/00315.png",
    "itemId": "e1c49fb08f5286cff607abf9af04057a",
    "price": "2000000",
  },
  {
    "part": "얼굴",
    "index": "6xiv7i",
    "name": "피어싱[A타입]",
    "icon": "pr_aface/00058.png",
    "itemId" : "897ab9238a527e96f069419bf74dde02",
    "price": "1050000",
  },
  {
    "part": "목가슴",
    "index": "fn2r7i",
    "name": "정열의 삼바 화려한 장식 날개[B타입]",
    "icon": "pr_aneck/00409.png",
    "itemId" : "a6033c44039a8eaf664af387a371913c",
    "price": "1330000",
  },
  {
    "part": "상의",
    "index": "sssr7i",
    "name": "스팀펑크 정장 상의[D타입]",
    "icon": "pr_acoat/00378.png",
    "itemId" : "39db625dca715274a103a731fde145f7",
    "price": "1개월 간 거래 없음",
  },
  {
    "part": "허리",
    "index": "whaw7i",
    "name": "해변의 로망 배꼽피어싱",
    "icon": "pr_abelt/00362.png",
    "itemId" : "941709693e3420b500d84db692dccebb",
    "price" : "3000000",
  },
  {
    "part": "하의",
    "index": "4d7r7i",
    "name": "아시아 여행 중국 전통의상 하의[A타입]",
    "icon": "pr_apants/00577.png",
    "itemId" : "11fe40a2cd189b807f12cf2dbcd41dc9",
    "price": "9999999",
  },
  {
    "part": "신발",
    "index": "teow7i",
    "name": "용투사의 세무 앵클 부츠[D타입]",
    "icon": "pr_ashoes/00382.png",
    "itemId" : "e7b4d9c2f952eebc1445639eb5590f3c",
    "price": "1개월 간 거래 없음",
  },
  {
    "part": "피부",
    "index": "0eyv7i",
    "name": "아시아 여행 몽골 프리스트 피부[B타입]",
    "icon": "pr_abody/00010.png",
    "itemId" : "7a39ae8d060a21d8c01478f3c1ecb117",
    "price": "1개월 간 거래 없음",
  },
  //{
  //  "part": "무기",
  //  "index": "3fuv7i",
  //  "name": "해군 제독의 전투도끼",
  //  "icon": "axe/00149.png",
  //},
];
