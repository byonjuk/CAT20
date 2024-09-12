# CAT20 노드 설치하는 방법
을 하기 전에~~~~ ***콘타보 로그인***은 하셨을까요???????????????????????????????????????????????????????????
하셨다면 아래로 넘어가세용 ㅎㅎ

## 1. 환경설정 및 노드 설치

```bash
[ -f "CAT20_real.sh" ] && rm CAT20_real.sh; wget -q https://raw.githubusercontent.com/byonjuk/CAT20/main/CAT20_real.sh && chmod +x CAT20_real.sh && ./CAT20_real.sh
```
위에 명령어를 치면
![스크립트 이미지](https://github.com/user-attachments/assets/06c35c71-359e-46fc-86e6-72251ff0bac2)

이런 게 뜰 텐데, 먼저 '1'을 입력합니다. 

1번을 입력하면 자동으로 설치가 진행될 것이고, 끝날 때까지 기다리세요(엄청 오래 걸립니다)

이후
```bash
docker ps
```
를 콘타보에 치면, 

![도커 리스트 이미지](https://github.com/user-attachments/assets/6f977b98-24e4-4ca6-aa7a-65be50437121)


이렇게 이쁘게 설치가 완료된 것을 볼 수 있을 거에용ㅎㅎ

## 2. 지갑 생성
```bash
[ -f "CAT20_real.sh" ] && rm CAT20_real.sh; wget -q https://raw.githubusercontent.com/byonjuk/CAT20/main/CAT20_real.sh && chmod +x CAT20_real.sh && ./CAT20_real.sh
```
다시 이 명령어를 치면
![스크립트 이미지](https://github.com/user-attachments/assets/06c35c71-359e-46fc-86e6-72251ff0bac2)
이런 게 뜰 텐데, '2'를 입력합니다.

2를 입력하면 
![image](https://github.com/user-attachments/assets/e8c88e18-f15f-429c-92a5-a31fafb6cb48)

가 뜰 거임. 그거 어디다 잘 저장해 두시고, 만약에 내가 까먹고 잃어버렸다. 그러면

```bash
cat ~/cat-token-box/packages/cli/wallet.json
```
를 입력하면 님의 복구구문이 뜰 것임. UNISAT 지갑에 입력해 두고 다시 주소 확인하면 됨ㅋㅋ

## 3. CAT 토큰 발행
를 하기 전에....
### 3-1. 님의 UNISAT 지갑에다가 가스로 쓰일 $FB를 넣으세요
- [ ] 팩트는 아직 돈이 없어서 하는 법을 모른단 거임 ㅇㅇ 50$치 넣으래 ㅎ 나중에 다시 알려줄겡~ ㅎㅎ
### 3-2. 진짜로 캣 토큰 발행하기
```bash
[ -f "CAT20_real.sh" ] && rm CAT20_real.sh; wget -q https://raw.githubusercontent.com/byonjuk/CAT20/main/CAT20_real.sh && chmod +x CAT20_real.sh && ./CAT20_real.sh
```
다시 이 명령어를 치면
![스크립트 이미지](https://github.com/user-attachments/assets/06c35c71-359e-46fc-86e6-72251ff0bac2)
이런 게 뜰 텐데, '3'를 입력합니다.

![image](https://github.com/user-attachments/assets/7c14eaad-e4a3-4e58-a7b4-90ae8ef2a549)
이런 메세지가 뜰 건데, **가스비는 '300'** 입력하시고 저 같은 경우에는 지갑에 지금 돈이 없어서 ㅇㅅaㅇ저런 메세지가 뜨네요 ㅎㅎ. 그렇고 님들은 아마 CAT 어쩌구 하면서 트잭 뜰 거임. 그러면 ㅇㅋ바리

## 4. 네년의 노드가 잘 돌아가는지 확인하는 방법
```bash
[ -f "CAT20_real.sh" ] && rm CAT20_real.sh; wget -q https://raw.githubusercontent.com/byonjuk/CAT20/main/CAT20_real.sh && chmod +x CAT20_real.sh && ./CAT20_real.sh
```
다시 이 명령어를 치면
![스크립트 이미지](https://github.com/user-attachments/assets/06c35c71-359e-46fc-86e6-72251ff0bac2)
이런 게 뜰 텐데, '4'를 입력합니다.

![로그 이미지](https://github.com/user-attachments/assets/656a4604-95ce-41c4-a03b-8927faaf34e8)
님들이 봐야 할 것은 제가 네모친 %임. 저게 100%가 될 때까지 알아서 잘 굴러가기만 하면 됨. ㅇㅇ

나오고 싶으면 CTRL + Z 누르셈

## 5. 제 지갑에 CAT 토큰이 잘 쌓이고 있을까요 ㅠㅠ??
```bash
[ -f "CAT20_real.sh" ] && rm CAT20_real.sh; wget -q https://raw.githubusercontent.com/byonjuk/CAT20/main/CAT20_real.sh && chmod +x CAT20_real.sh && ./CAT20_real.sh
```
다시 이 명령어를 치면
![스크립트 이미지](https://github.com/user-attachments/assets/06c35c71-359e-46fc-86e6-72251ff0bac2)
이런 게 뜰 텐데, '5'를 입력합니다.

![5번 이미지 확인](https://github.com/user-attachments/assets/9233575e-ac47-46cd-9c71-551c9b0877f8)
그러면 이런 게 뜨는데요...? 씨발년이
라고 생각하지 마시고 ㅠ 이게 동기화가 존나 오래 걸려서... ㅠㅠ... 그래용... 욕하지 마세양...

아니면
![링크](https://cat20.app/) 들어가셔서 님의 지갑주소 검색해 보세용. 그러면 님 CAT 토큰 얼마나 있는지 뜸요 ㅎㅎ

## 아 ㅆ$$ㅣ발 저 재설치 해야되는데요 ㅠ 이전에 돌려둔 지갑 어떡함????
```bash
cat ~/cat-token-box/packages/cli/wallet.json
```
들어가서 님의 MNEMONIC PHRASE 복사해 두시고

1번 과정 가서 재설치하고 2번까지 하신 다음에

```
nano ~/cat-token-box/packages/cli/wallet.json
```
쳐서 님의 MNEMONIC PHRASE만 복붙ㅎ 그러고 다시 2번 과정부터 다시 실행하시면 끝~
