#!/bin/bash

# 변수 설정
Crontab_file="/usr/bin/crontab"
Blue_font_prefix="\033[34m"
Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"
Info="[${Green_font_prefix}정보${Font_color_suffix}]"
Error="[${Red_font_prefix}오류${Font_color_suffix}]"
Tip="[${Green_font_prefix}주의${Font_color_suffix}]"

# root 권한 확인
check_root() {
    if [[ $EUID != 0 ]]; then
        echo -e "${Error} 현재 ROOT 권한이 없습니다. ROOT 권한으로 실행하거나 ${Green_background_prefix}sudo su${Font_color_suffix} 명령어를 사용하십시오."
        exit 1
    fi
}

# 환경 설치 및 풀 노드 설정
install_env_and_full_node() {
    check_root
    sudo apt update && sudo apt upgrade -y
    sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu unzip zip docker.io -y

    # 최신 Docker Compose 설치
    VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')
    DESTINATION=/usr/local/bin/docker-compose
    sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
    sudo chmod 755 $DESTINATION

    # npm 설치 및 설정
    sudo apt-get install npm -y
    sudo npm install n -g
    sudo n stable
    sudo npm i -g yarn

    # Git에서 CAT 토큰 박스 클론
    git clone https://github.com/CATProtocol/cat-token-box
    cd cat-token-box
    sudo yarn install
    sudo yarn build

    # Docker 설정 및 실행
    cd ./packages/tracker/
    sudo chmod 777 docker/data
    sudo chmod 777 docker/pgdata
    sudo docker-compose up -d

    # Docker 빌드 및 실행
    cd ../../
    sudo docker build -t tracker:latest .
    sudo docker run -d \
        --name tracker \
        --add-host="host.docker.internal:host-gateway" \
        -e DATABASE_HOST="host.docker.internal" \
        -e RPC_HOST="host.docker.internal" \
        -p 3000:3000 \
        tracker:latest

    # config.json 파일 작성
    echo '{
      "network": "fractal-mainnet",
      "tracker": "http://127.0.0.1:3000",
      "dataDir": ".",
      "maxFeeRate": 30,
      "rpc": {
          "url": "http://127.0.0.1:8332",
          "username": "bitcoin",
          "password": "opcatAwesome"
      }
    }' > ~/cat-token-box/packages/cli/config.json

    # mint_script.sh 작성
    echo '#!/bin/bash

    command="sudo yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5"

    while true; do
        $command

        if [ $? -ne 0 ]; then
            echo "명령 실행 실패, 반복문 종료"
            exit 1
        fi

        sleep 1
    done' > ~/cat-token-box/packages/cli/mint_script.sh

    chmod +x ~/cat-token-box/packages/cli/mint_script.sh
}

# 지갑 생성
create_wallet() {
  echo -e "\n"
  cd ~/cat-token-box/packages/cli
  sudo yarn cli wallet create
  echo -e "\n"
  sudo yarn cli wallet address
  echo -e "이 지갑 주소랑 프라이빗키랑 다 어디 저장해 주세요. 잃어버려도 확인 안 해줄 거임."
}

# CAT 토큰 발행 시작
start_mint_cat() {
  read -p "발행할 Gas 값을 입력하세요: " newMaxFeeRate
  sed -i "s/\"maxFeeRate\": [0-9]*/\"maxFeeRate\": $newMaxFeeRate/" ~/cat-token-box/packages/cli/config.json
  cd ~/cat-token-box/packages/cli
  bash ~/cat-token-box/packages/cli/mint_script.sh
}

# 노드 로그 확인
check_node_log() {
  docker logs -f --tail 100 tracker
}

# 지갑 잔액 확인
check_wallet_balance() {
  cd ~/cat-token-box/packages/cli
  sudo yarn cli wallet balances
}

# 메인 메뉴
echo && echo -e " ${Red_font_prefix}Dusk network 자동 설치 스크립트${Font_color_suffix} by oooooyoung
이 스크립트는 오픈소스이고 @ouyoung11이라는 유저가 개발한 것을 한국어로 옮겨 쓴 겁니다.
${Blue_font_prefix} 전지전능하고 위대한 중국인에게 감사를 드립시다. ${Font_color_suffix}
 ———————————————————————
 ${Green_font_prefix} 1. 기본파일 설치 및 CAT20 노드 설치. ${Font_color_suffix}
 ${Green_font_prefix} 2. 노드 운용에 쓰일 지갑을 생성하고 싶어요. ${Font_color_suffix}
 ${Green_font_prefix} 3. CAT 토큰을 발행하고 싶어요. ${Font_color_suffix}
 ${Green_font_prefix} 4. 노드 잘 돌아가는지 체크하고 싶어요. ${Font_color_suffix}
 ${Green_font_prefix} 5. 지갑에 잔액이 얼마나 있는지 확인하고 싶어요. ${Font_color_suffix}
 ———————————————————————" && echo

# 사용자 입력 대기
read -e -p " 어떤 과정을 하고 싶으신가요? 위 항목을 참고해 숫자를 입력해 주세요: " num
case "$num" in
1)
    install_env_and_full_node
    ;;
2)
    create_wallet
    ;;
3)
    start_mint_cat
    ;;
4)
    check_node_log
    ;;
5)
    check_wallet_balance
    ;;
*)
    echo -e "${Red_font_prefix}숫자 못 읽음? 진짜 병신이니 눈깔 삐엇니? 죽어 그냥 자살해 시발 1~5 하나 제대로 입력 못하는 주제에 무슨 노드를 쳐 돌리고~ 에드작을 한다 그러고~ 시발 서당개도 3년이면 풍월을 읊는다는데 만물의 영장이라는 게 시발 에드작을 반년 가까이 하고도 시발 숫자 하나 입력하는 법을 모르고 개 씨발 병신 좆버러지 같은 년 에휴 왜 사니? 여긴 왜 들어왔니? 코인이 하고 싶긴 하니? 너 평소에 하라는 에드작은 다 열심히 하고 있니? 안일하게 살지마 세상에 돈 벌기 쉬운 게 어딨어 다들 피땀흘려서 열심히 돈 버는데 지는 이거 하기 싫다고 편하게 딸깍이나 하러 와서는 숫자 하나 제대로 입력 못하고 내 복창이 터진다 씨발 에휴 병신 금수련아 짐승련아 대체 왜 그러고 사니 존재 자체가 인류의 공해야 너는 그냥 에휴 긴말 안 할게 죽어라 걍 에휴 ㅄ;;;;;;;;${Font_color_suffix}"
    ;;
esac
