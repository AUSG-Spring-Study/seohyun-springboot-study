# 7장 AWS에 데이터베이스 환경을 만들어보자 - AWS RDS

- RDS
  - 관계형 데이터베이스
  - 여러 종류가 있는데 그중에서 MariaDB를 사용해본다
  - 네트워크 - 퍼블릭 엑세스 허용
  - 추후 보안그룹에서 지정된 IP만 접근을 막도록 수정한다
  - 파라미터 그룹
    - 파라미터 그룹을 생성함
    - timezone: Asia/Seoul
    - character_xx_xx: utf8mb4
    - collation_xx: utf8mb4_general_ci
    - utf8mb4는 이모지를 저장할 수 있다
    - max_connections: 150
  - RDS 수정에서 방금 설정한 '파라미터 그룹'을 선택
- RDS 보안그룹에서 내 IP로 3306 인바운드 규칙 추가

- Database 연결
  - Host에 RDS의 엔드포인트 등록
  - 쿼리 실행 후 executed successfully 문구가 뜨면 성공
  - 파라미터 그룹에서 설정한 몇가지 항목들을 확인한다
    - show variables like 'c%';

- EC2, RDS 연동확인
  - MYSQL cli 설치
  - mysql -u seohyun -p -h 엔드포인트