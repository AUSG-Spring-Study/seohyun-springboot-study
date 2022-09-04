# 1장 인텔리제이로 스프링부트 시작하기

- IntelliJ Community Version
- 프로젝트 생성
  - GroupId: 프로젝트 식별자
  - ArtifactId: 프로젝트 이름
- 그레이들 프로젝트를 스프링부트 프로젝트로 변경하기
  - `build.gradle`에 스프링부트에 필요한 내용 추가
    - `ext`: 전역 변수 설정
    - 스프링 부트 의존성 관리 플러그인 추가
    - `repositories`: 라이브러리를 받을 원격 저장소 설정 
      - `mavenCentral()`
      - `jcenter()`은 deprecated 되었다고해서 추가하지 않음
    - `dependencies`: 프로젝트 개발에 필요한 의존성 선언
      - `${springBootVersion}` 맨 위에 작성한 버전을 따라가도록 설정하기
      - Gradle 7.1버전을 사용 중이므로 일부 deprecated 메소드명 변경하기 `compile` -> `implementation`, `testCompile` -> `testImplementation`
- Git에 올리기
  - `.ignore` 플러그인을 설치하여 `.gitignore` 설정하기