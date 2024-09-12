#!/bin/bash

# 변수 설정
Crontab_file="/usr/bin/crontab"
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
  echo -e "지갑 주소와 비밀 키를 안전하게 저장하십시오."
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
echo && echo -e " ${Red_font_prefix}Dusk Network 자동 설치 스크립트${Font_color_suffix} by oooooyoung
此脚本完全免费开源，由推特用户 @ouyoung11 开发
 ———————————————————————
 ${Green_font_prefix} 1. 의존성 설치 및 풀 노드 설치 ${Font_color_suffix}
 ${Green_font_prefix} 2. 지갑 생성 ${Font_color_suffix}
 ${Green_font_prefix} 3. CAT 토큰 발행 ${Font_color_suffix}
 ${Green_font_prefix} 4. 노드 동기화 로그 확인 ${Font_color_suffix}
 ${Green_font_prefix} 5. 지갑 잔액 확인 ${Font_color_suffix}
 ———————————————————————" && echo

# 사용자 입력 대기
read -e -p " 위의 단계를 참고하여 숫자를 입력하세요: " num
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
    echo -e "${Error} 잘못된 입력입니다."
    ;;
esac
